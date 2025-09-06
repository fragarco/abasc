"""
Syntactic analyzer of Amstrad locomotive BASIC code. It supports some
enhancements like having a body for THEN clausules.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation in its version 3.

This program is distributed in the hope that it will be useful
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA

Use example:

program = "
10 FOR I = 1 TO 5
20   PRINT I
30 NEXT I
40 WHILE I < 10
50   I = I + 1
60 WEND
70 IF I > 5 THEN
80   PRINT "OK"
90 ELSE
100  PRINT "FAIL"
110 END IF
"

parser = LocBasParser(program)
ast = parser.parse_program()

for line in ast.lines:
    print(f"LINE {line.number}:")
    for stmt in line.statements:
        print(f"  {stmt}")

"""

from __future__ import annotations
from typing import List, Optional, cast
from dataclasses import dataclass
from enum import Enum, auto
from baserror import BasError
from baspp import CodeLine
from baslex import LocBasLexer, TokenType, Token
from symbols import SymTable, SymEntry, SymType
import astlib as AST

class BlockType(Enum):
    IF = auto()
    FOR = auto()
    WHILE = auto()
 
@dataclass
class CodeBlock:
    type: BlockType
    until_keywords: tuple
    alive: bool = True

class LocBasParser:
    def __init__(self, code: list[CodeLine], tokens: list[Token], warning_level=-1):
        self.tokens = tokens
        self.lines = code
        self.pos = 0
        self.codeblocks: list[CodeBlock] = []
        self.warning_level = warning_level
        self.symtable = SymTable()
        self.context = ""

    # ----------------- Error management -----------------

    def _raise_error(self, codenum: int, info: str = "", line: int = -1, col: int = -1):
        current = self._current()
        # tokens start line counting in 1
        codeline = self.lines[current.line - 1]
        raise BasError(
            codenum,
            codeline.source,
            codeline.code,
            codeline.line if line == -1 else line,
            current.col if col == -1 else col,
            info
        ) 

    def _raise_warning(self, level: int, msg: str):
        if self.warning_level<0 or self.warning_level>=level:
            current = self._current()
            # tokens start line counting in 1
            codeline = self.lines[current.line - 1]
            print(f"[WARNING] {codeline.source}:{codeline.line}:{current.col}: {msg} in {codeline.code}")

    # ----------------- Token management -----------------

    def _current(self) -> Token:
        return self.tokens[self.pos]

    def _advance(self) -> Token:
        tok = self.tokens[self.pos]
        self.pos += 1
        return tok

    def _rewind(self) -> Token:
        tok = self.tokens[self.pos]
        self.pos -= 1
        return tok

    def _match(self, type: TokenType, lex: Optional[str] = None) -> Optional[Token]:
        if self._current_is(type, lex):
            return self._advance()
        return None

    def _expect(self, type: TokenType, lex: Optional[str] = None) -> Token:
        if not self._current_is(type, lex):
            self._raise_error(2)
        return self._advance()

    def _current_is(self, type: TokenType, lexeme: Optional[str] = None) -> bool:
        tk = self.tokens[self.pos]
        if tk.type != type: return False
        if lexeme != None:
            return lexeme == tk.lexeme
        return True

    def _current_in(self, types: tuple, lexemes: Optional[tuple] = None) -> bool:
        tk = self.tokens[self.pos]
        if tk.type not in types: return False
        if lexemes is not None:
            return tk.lexeme in lexemes
        return True

    def _next_is(self, type: TokenType, lexeme: Optional[str] = None) -> bool:
        nexttk = self.tokens[self.pos + 1]
        if nexttk.type != type: return False
        if lexeme != None and lexeme != nexttk.lexeme: return False
        return True

    # ----------------- Statements -----------------

    def _parse_ABS(self) -> AST.Function:
        """ <ABS> := ABS(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ABS", etype=AST.ExpType.Integer, args=args)

    def _parse_AFTER(self) -> AST.Command:
        """ <AFTER> ::= AFTER <int_expression>[,<int_expression>] GOSUB INT """
        self._advance()
        delay = self._parse_expression()
        if not AST.exptype_isint(delay.etype):
            self._raise_error(13)
        args = [delay]
        if self._current_is(TokenType.COMMA):
            self._advance()
            timer = self._parse_expression()
            if not AST.exptype_isint(timer.etype):
                self._raise_error(13)
            args.append(timer)
        self._expect(TokenType.KEYWORD, "GOSUB")
        num = self._expect(TokenType.INT)
        args.append(AST.Integer(value = cast(int, num.value)))
        return AST.Command(name="AFTER", args=args)
    
    def _parse_ASC(self) -> AST.Function:
        """ <ASC> ::= ASC(<str_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isstr(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ASC", etype=AST.ExpType.Integer, args=args)

    def _parse_ATN(self) -> AST.Function:
        """ <ATN> ::= ATN(<num_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ATN", etype=AST.ExpType.Real, args=args)

    def _parse_AUTO(self) -> AST.Command:
        """ <AUTO> ::= AUTO <int_expression>[,<int_expression>] """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="AUTO")
    
    def _parse_BINSS(self) -> AST.Function:
        """ <BINSS> ::= BIN$(<int_expression>[,<int_expression>])"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isint(args[0].etype):
            self._raise_error(13)
        if self._current_is(TokenType.COMMA):
            self._advance()
            width = self._parse_expression()
            if not AST.exptype_isint(width.etype):
                self._raise_error(13)
            args.append(width)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="BIN$", etype=AST.ExpType.String, args=args)

    def _parse_BORDER(self) -> AST.Command:
        """ <BORDER> ::= BORDER <int_expression>[,<int_expression>] """
        self._advance()
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isint(args[0].etype):
            self._raise_error(13)
        if self._current_is(TokenType.COMMA):
            self._advance()
            color2 = self._parse_expression()
            if not AST.exptype_isint(color2.etype):
                self._raise_error(13)
            args.append(color2)
        return AST.Command(name="BORDER", args=args)

    def _parse_CALL(self) -> AST.Command:
        """ <CALL> ::= CALL <int_expression>[,<expression>]* """
        self._advance()
        dir = self._parse_expression()
        if not AST.exptype_isint(dir.etype):
            self._raise_error(13)
        args = [dir]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        return AST.Command(name="CALL", args=args)

    def _parse_CAT(self) -> AST.Command:
        """ <CAT> ::= CAT """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="CAT")

    def _parse_CHAIN(self) -> AST.Command:
        """ <CHAIN> ::= CHAIN <str_expression>[,<int_expression>] """
        # This command appends a new Basic program form a loaded
        # file, so it doesn't make sense for a compiler
        # INCBAS additional command suplies this at compile time
        self._advance()
        self._raise_error(2, info="Command not supported, use INCBAS instead")
        return AST.Command(name="CHAIN")

    def _parse_CHAIN_MERGE(self) -> AST.Command:
        """ <CHAIN_MERGE> ::= CHAIN MERGE <str_expression>[,<int_expression>][,DELETE <int_expression>] """
        # This command appends a new Basic program form a loaded
        # file, so it doesn't make sense for a compiler
        # INCBAS additional command suplies this at compile time
        self._advance()
        self._raise_error(2, info="Command not supported, use INCBAS instead")
        return AST.Command(name="CHAIN_MERGE")

    def _parse_CHRSS(self) -> AST.Function:
        """ <CHRSS> ::= CHR$(<int_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isint(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CHR$", etype=AST.ExpType.String, args=args)

    def _parse_CINT(self) -> AST.Function:
        """ <CINT> ::= CINT(<real_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CINT", etype=AST.ExpType.Integer, args=args)

    def _parse_CLEAR(self) -> AST.Command:
        """ <CLEAR> ::= CLEAR """
        # This command resets several areas of the BASIC interpreter
        # and doesn't seem to be very useful for a compiled program
        self._advance()
        self._raise_error(2, info="Command not supported")
        return AST.Command(name="CLEAR")

    def _parse_CLG(self) -> AST.Command:
        """ <CLG> ::= CLG [<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            args = [self._parse_expression()]
            if not AST.exptype_isint(args[0].etype):
                self._raise_error(13)
        return AST.Command(name="CLG", args=args)

    def _parse_CLOSEIN(self) -> AST.Command:
        """ <CLOSEIN> ::= CLOSEIN """
        self._advance()
        return AST.Command(name="CLOSEIN")

    def _parse_CLOSEOUT(self) -> AST.Command:
        """ <CLOSEOUT> ::= CLOSEOUT """
        self._advance()
        return AST.Command(name="CLOSEOUT")

    def _parse_CLS(self) -> AST.Command:
        """ <CLS> := CLS [#<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_expression()]
            if not AST.exptype_isint(args[0].etype):
                self._raise_error(13)
        return AST.Command(name="CLS", args=args)

    def _parse_CONT(self) -> AST.Command:
        """ <CONT> ::= CONT """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="CONT")

    def _parse_COS(self) -> AST.Function:
        """ <COS> ::= COS(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="COS", etype=AST.ExpType.Real, args=args)
    
    def _parse_CREAL(self) -> AST.Function:
        """ <CREAL> ::= CREAL(<num_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CREAL", etype=AST.ExpType.Real, args=args)

    def _parse_DATA(self) -> AST.Command:
        """ <DATA> ::= DATA <primary>[,<primary>]*"""
        self._advance()
        args: list[AST.Statement] = [self._parse_constant()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_constant())
        return AST.Command(name="DATA", args=args)

    def _parse_DECSS(self) -> AST.Function:
        """ <DECSS> ::= DEC$(<num_expression>, STRING) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(13)
        self._expect(TokenType.COMMA)
        tk = self._expect(TokenType.STRING)
        args.append(AST.String(value=tk.lexeme))
        self._expect(TokenType.RPAREN)
        return AST.Function(name="DEC$", args=args, etype=AST.ExpType.String)

    def _parse_DEF_FN(self) -> AST.DefFN:
        """ <DEF_FN> ::== DEF FNIDENT[(IDENT[,IDENT]*)]=<num_expression>"""
        self._advance()
        if self.context != "":
            # is not possible to define functions inside a function
            self._raise_error(2)
        tk = self._expect(TokenType.IDENT)
        fname = "FN" + tk.lexeme
        fargs: list[AST.Variable] = []
        self.context = fname.upper()
        # initial entry so we can create any local context entries
        # it will be updated at the end
        info = SymEntry(
            symtype=SymType.Function,
            exptype=AST.ExpType.Integer,
            locals=SymTable(),
            )
        if self.symtable.add(ident=fname, info=info, context="") is None:
            self._raise_error(2)
        if self._match(TokenType.LPAREN):
            tk = self._expect(TokenType.IDENT)
            vartype = AST.exptype_fromname(tk.lexeme)
            fargs.append(AST.Variable(name=tk.lexeme, etype=vartype))
            info.exptype = vartype
            info.symtype = SymType.Variable
            info.locals = SymTable()
            self.symtable.add(ident=tk.lexeme, info=info, context=self.context)
            while self._current_is(TokenType.COMMA):
                self._advance()
                tk = self._expect(TokenType.IDENT)
                vartype = AST.exptype_fromname(tk.lexeme)
                fargs.append(AST.Variable(name=tk.lexeme, etype=vartype))
                info.exptype = vartype
                self.symtable.add(ident=tk.lexeme, info=info, context=self.context)
            self._expect(TokenType.RPAREN)
        self._expect(TokenType.COMP, "=")
        fbody = self._parse_expression()
        if not AST.exptype_isnum(fbody.etype):
            self._raise_error(13)
        self.context = ""
        # Lets update our entry for the function with
        # the last calculated parameters
        info = self.symtable.find(ident=fname) # type: ignore[assignment]
        if info is None:
            self._raise_error(2)
        info.exptype = fbody.etype
        info.nargs = len(fargs)
        return AST.DefFN(name=fname, args=fargs, body=fbody)

    def _parse_DEFINT(self) -> AST.Command:
        """ <DEFINT> ::= DEFINT <str_range> """
        self._raise_warning(level=3, msg="DEFINT is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFINT", args=args)

    def _parse_DEFREAL(self) -> AST.Command:
        """ <DEFREAL> ::= DEFREAL <str_range> """
        self._raise_warning(level=3, msg="DEFREAL is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFREAL", args=args)

    def _parse_DEFSTR(self) -> AST.Command:
        """ <DEFSTR> ::= DEFSTR <str_range> """
        self._raise_warning(level=3, msg="DEFSTR is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFSTR", args=args)

    def _parse_DEG(self) -> AST.Command:
        """ <DEG> ::= DEG """
        self._advance()
        return AST.Command(name="DEG")

    def _parse_DELETE(self) -> AST.Command:
        """ <DELETE> ::= DELETE <int_range> """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="DELETE")

    def _parse_DI(self) -> AST.Command:
        """ <DI> ::= DI """
        self._advance()
        return AST.Command(name="DI")

    def _parse_DIM(self) -> AST.Command:
        """ <DIM> ::= DIM <array_declaration>[,<array_declaration>]*"""
        # El numero dado como "size" es el maximo indice que se puede
        # usar, de esta forma es valido 10 DIM I(0): I(0) = 5
        self._advance()
        args = [self._parse_array_declaration()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_array_declaration())
        for var in args:
            info = SymEntry(
                symtype=SymType.Array,
                exptype=var.etype,
                locals=SymTable(),
                nargs=len(var.sizes)    #type: ignore[attr-defined]
            )
            if not self.symtable.add(ident=var.name, info=info, context=self.context): #type: ignore[attr-defined]
                self._raise_error(2)
        return AST.Command(name="DIM", args=args)

    def _parse_array_declaration(self) -> AST.Statement:
        """ <array_declaration> ::= IDENT([INT[,INT]]) """
        var = self._expect(TokenType.IDENT).lexeme
        vartype = AST.exptype_fromname(var)
        sizes = [10]
        self._expect(TokenType.LPAREN)
        if not self._current_is(TokenType.RPAREN):
            sizes = [cast(int, self._expect(TokenType.INT).value)]
            if sizes[-1] < 0: self._raise_error(9)
            while self._current_is(TokenType.COMMA):
                self._advance()
                sizes.append(cast(int, self._expect(TokenType.INT).value))
                if sizes[-1] < 0: self._raise_error(9)
        self._expect(TokenType.RPAREN)
        return AST.Array(name=var, etype=vartype, sizes=sizes)

    def _parse_DRAW(self) -> AST.Command:
        """ <DRAW> ::= DRAW <int_expression>,<int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        for a in args:
            if not AST.exptype_isint(a.etype):
                self._raise_error(5)
        return AST.Command(name="DRAW", args=args)

    def _parse_DRAWR(self) -> AST.Command:
        """ <DRAWR> ::= DRAWR <int_expression>,<int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        for a in args:
            if not AST.exptype_isint(a.etype):
                self._raise_error(5)
        return AST.Command(name="DRAWR", args=args)

    def _parse_EDIT(self) -> AST.Command:
        """ <EDIT> ::= EDIT INT """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="EDIT")

    def _parse_EI(self) -> AST.Command:
        """ <EI> ::= EI """
        self._advance()
        return AST.Command(name="EI")

    def _parse_ELSE(self) -> AST.BlockEnd:
        """ <ELSE> ::== ELSE """
        self._advance()
        if len(self.codeblocks) == 0 or "ELSE" not in self.codeblocks[-1].until_keywords:
            self._raise_error(2, "Unexpected ELSE keyword")
        if not self.codeblocks[-1].alive:
             self._raise_error(2, "Unexpected ELSE keyword")
        self.codeblocks[-1].alive = False
        self.codeblocks.pop()
        return AST.BlockEnd(name="ELSE")

    def _parse_END(self) -> AST.Command:
        """ <END> ::= END """
        self._advance()
        return AST.Command(name="END")

    def _parse_ENT(self) -> AST.Command:
        """ <ENT> ::= ENT <int_expression>[,<ent_section>][,<ent_section>][,<ent_section>][,<ent_section>][,<ent_section>] """
        """ <ent_section> ::= <int_expression>,<int_expression>,<int_expression> | <int_expression>,<int_expression> """
        # NOTE: Sections will be integers of 3 bytes: byte, byte, byte or 2-bytes, byte.
        self._advance()
        args: list[AST.Statement] = [self._parse_expression()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        for a in args:
            if not AST.exptype_isint(a.etype):
                self._raise_error(5)
        if len(args) > 5*3:
            self._raise_error(5)
        return AST.Command(name="ENT", args=args)

    def _parse_ENV(self) -> AST.Command:
        """ <ENV> ::= ENV <int_expression>[,<env_section>][,<env_section>][,<env_section>][,<env_section>][,<env_section>] """
        """ <env_section> ::= <int_expression>,<int_expression>,<int_expression> | <int_expression>,<int_expression> """
        # NOTE: Sections will be integers of 3 bytes: byte, byte, byte or byte, 2-bytes.
        self._advance()
        args: list[AST.Statement] = [self._parse_expression()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        for a in args:
            if not AST.exptype_isint(a.etype):
                self._raise_error(5)
        if len(args) > 5*3:
            self._raise_error(5)
        return AST.Command(name="ENV", args=args)

    def _parse_EOF(self) -> AST.Function:
        """ <EOF> ::= EOF """
        self._advance()
        return AST.Function(name="EOF", etype=AST.ExpType.Integer)    

    def _parse_ERASE(self) -> AST.Command:
        """ <ERASE> ::= ERASE IDENT[,IDENT]* """
        self._advance()
        args: list[AST.Statement] = []
        tk = self._expect(TokenType.IDENT)
        entry = self.symtable.find(tk.lexeme, context=self.context)
        if entry is None or entry.symtype != SymType.Array:
            self._raise_error(2)
        else:
            args.append(AST.Variable(name=tk.lexeme, etype=entry.exptype))
        while self._current_is(TokenType.COMMA):
            self._advance()
            tk = self._expect(TokenType.IDENT)
            entry = self.symtable.find(tk.lexeme, context=self.context)
            if entry is None or entry.symtype != SymType.Array:
                self._raise_error(2)
            else:
                args.append(AST.Variable(name=tk.lexeme, etype=entry.exptype))
        return AST.Command(name="ERASE", args=args)

    def _parse_ERL(self) -> AST.Function:
        """ <ERL> ::= ERL """
        # Will return the line number where the last ERROR command was executed 
        self._advance()
        return AST.Function(name="ERL", etype=AST.ExpType.Integer)

    def _parse_ERR(self) -> AST.Function:
        """ <ERR> ::= ERR """
        # Will return the error code number used in the last executed ERROR command
        self._advance()
        return AST.Function(name="ERR", etype=AST.ExpType.Integer)

    def _parse_ERROR(self) -> AST.Command:
        """ <ERROR> ::= ERROR <int_expression> """
        # Sets the values for ERR and ERL
        self._advance()
        args = [self._parse_expression()]
        if not AST.exptype_isint(args[0].etype):
            self._raise_error(5)
        return AST.Command(name="ERROR", args=args)

    def _parse_EVERY(self) -> AST.Command:
        """ <EVERY> ::= EVERY <int_expression>[,<int_expression>] <GOSUB> """
        self._advance()
        args = [self._parse_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        for a in args:
            if not AST.exptype_isint(a.etype):
                self._raise_error(5)
        if not self._current_is(TokenType.KEYWORD, lexeme="GOSUB"):
            self._raise_error(2)
        args.append(self._parse_GOSUB())
        return AST.Command(name="EVERY", args=args)

    def _parse_EXP(self) -> AST.Function:
        """ <EXP> ::= EXP(<expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(5)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="EXP", etype=AST.ExpType.Real, args=args)

    def _parse_FIX(self) -> AST.Command:
        """ <FIX> ::= FIX(<expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_expression()]
        if not AST.exptype_isnum(args[0].etype):
            self._raise_error(5)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="FIX", etype=AST.ExpType.Integer, args=args)
    
    def _parse_FN(self) -> AST.Command:
        # DEF parses FN so if we arrive here is a syntax error
        self._advance()
        self._raise_error(2)
        return AST.Command(name="FN")

    def _parse_FOR(self) -> AST.ForLoop:
        """ <FOR> ::= FOR IDENT = <expression> TO <expression> [STEP <expression>] <for_body> """
        """ <for_body> ::= : <for_inline> | EOL <for_block> """
        self._advance()
        var = self._expect(TokenType.IDENT).lexeme.upper()
        vartype = AST.exptype_fromname(var)
        if not AST.exptype_isint(vartype):
            self._raise_error(13)
        self._expect(TokenType.COMP, "=")
        info = self.symtable.find(ident=var, context=self.context)
        if info is None:
            # Lets add the FOR variable to the symtable as it persists
            # in Locomotive BASIC after the loop ends
            self.symtable.add(
                ident=var,
                info=SymEntry(symtype=SymType.Variable, exptype=vartype, locals=SymTable()),
                context=self.context
            )
        start = self._parse_expression()
        if not AST.exptype_isint(start.etype):
            self._raise_error(13)
        self._expect(TokenType.KEYWORD, "TO")
        end = self._parse_expression()
        if not AST.exptype_isint(end.etype):
            self._raise_error(13)
        step = None
        if self._match(TokenType.KEYWORD, "STEP"):
            step = self._parse_expression()
            if not AST.exptype_isint(step.etype):
                self._raise_error(13)
        self.codeblocks.append(CodeBlock(type=BlockType.FOR, until_keywords=("NEXT",)))
        if self._current_is(TokenType.COLON):
            body = self._parse_for_inline()
        else:
            self._expect(TokenType.EOL)
            body = self._parse_code_block()
        # Last statement of the block is the NEXT otherwise
        # we won't be here
        next_var = body[-1].var.upper() # type: ignore[attr-defined]
        if next_var != "" and next_var != var:
            self._raise_error(5)            
        index = AST.Variable(name=var, etype=vartype)
        return AST.ForLoop(var=index, start=start, end=end, step=step, body=body)
    
    def _parse_for_inline(self) -> list[AST.Statement]:
        """ <for_inline> ::= :<statement><for_inline> | :<NEXT>"""
        self._advance()
        last_stmt = self._parse_statement() 
        body = [last_stmt]
        while not isinstance(last_stmt, AST.BlockEnd):
            self._expect(TokenType.COLON)
            last_stmt = self._parse_statement()
            body.append(last_stmt)
        return body

    def _parse_GOSUB(self) -> AST.Command:
        """ <GOSUB> ::= GOSUB INT """
        self._advance()
        num = self._expect(TokenType.INT)
        args: list[AST.Statement] = [AST.Integer(value = cast(int, num.value))]
        return AST.Command(name="GOSUB", args=args)

    def _parse_GOTO(self) -> AST.Command:
        """ <GOTO> ::= GOTO INT """
        self._advance()
        num = self._expect(TokenType.INT)
        args: list[AST.Statement] = [AST.Integer(value = cast(int, num.value))]
        return AST.Command(name="GOTO", args=args)

    def _parse_IF(self) -> AST.If:
        """ <IF> ::= IF <expression> THEN <then_block> [ELSE <else_block>] """
        self._advance()
        condition = self._parse_expression()
        self._expect(TokenType.KEYWORD, "THEN")
        then_block = self._parse_then_block()
        else_block: list[AST.Statement] = []
        if isinstance(then_block[-1], AST.BlockEnd) and then_block[-1].name == "ELSE":
            else_block = self._parse_else_block()
        return AST.If(condition=condition, then_block=then_block, else_block=else_block)

    def _parse_then_block(self) -> list[AST.Statement]:
        """ <then_block> :== (INT | <statements>) | EOL <code_block>"""
        then_block: list[AST.Statement] = []
        if not self._current_is(TokenType.EOL):
            if self._current_is(TokenType.INT):
                tk = self._advance()
                if self.symtable.find(str(cast(int, tk.value))) is None:
                    self._raise_error(8)
                then_block = [AST.Command(name="GOTO", args=[AST.Integer(value = cast(int, tk.value))])]
            else:
                then_block.append(self._parse_statement())
                while self._current_is(TokenType.COLON):
                    self._advance()
                    then_block.append(self._parse_statement())
            if self._current_is(TokenType.KEYWORD, "ELSE"):
                self._advance()
                then_block.append(AST.BlockEnd(name="ELSE"))
            else:
                then_block.append(AST.BlockEnd(name="IFEND"))
        else:
            self._advance()
            self.codeblocks.append(CodeBlock(type=BlockType.IF, until_keywords=("ELSE","IFEND")))
            statements = self._parse_code_block()
            then_block = then_block + statements
        return then_block                    
        
    def _parse_else_block(self) -> list[AST.Statement]:
        """ <then_else> :== (INT | <statements> ) | EOL <code_block>"""
        else_block: list[AST.Statement] = []
        if not self._current_is(TokenType.EOL):
            if self._current_is(TokenType.INT):
                tk = self._advance()
                if self.symtable.find(str(cast(int, tk.value))) is None:
                    self._raise_error(8)
                else_block = [AST.Command(name="GOTO", args=[AST.Integer(value = cast(int, tk.value))])]
            else:
                else_block.append(self._parse_statement())
                while self._current_is(TokenType.COLON):
                    self._advance()
                    else_block.append(self._parse_statement())
            else_block.append(AST.BlockEnd(name="IFEND"))
        else:
            self._advance()
            self.codeblocks.append(CodeBlock(type=BlockType.IF, until_keywords=("IFEND",)))
            statements = self._parse_code_block()
            else_block = else_block + statements
        return else_block                    
        
    def _parse_IFEND(self) -> AST.BlockEnd:
        self._advance()
        if len(self.codeblocks) == 0 or "IFEND" not in self.codeblocks[-1].until_keywords:
            self._raise_error(2, "Unexpected IFEND")
        if not self.codeblocks[-1].alive:
            self._raise_error(2, "Unexpected IFEND")
        self.codeblocks[-1].alive = False
        self.codeblocks.pop()
        return AST.BlockEnd(name="IFEND")

    def _parse_INPUT(self) -> AST.Input:
        self._advance()
        vars = []
        while True:
            tok = self._expect(TokenType.IDENT)
            vars.append(tok.lexeme)
            if not self._match(TokenType.COMMA):
                break
        return AST.Input(vars=vars)

    def _parse_LET(self) -> AST.Assignment:
        self._advance()
        return self._parse_assignment()

    def _parse_NEXT(self) -> AST.BlockEnd:
        """ <NEXT> ::= NEXT [IDENT]"""
        self._advance()
        if len(self.codeblocks) == 0 or "NEXT" not in self.codeblocks[-1].until_keywords:
            self._raise_error(1)
        self.codeblocks[-1].alive = False
        self.codeblocks.pop()
        next_var = ""
        if self._current_is(TokenType.IDENT):
            next_var = self._advance().lexeme
            vartype = AST.exptype_fromname(next_var)
            if not AST.exptype_isint(vartype):
                self._raise_error(13)
        return AST.BlockEnd(name="NEXT", var=next_var)

    def _parse_PRINT(self) -> AST.Print:
        self._advance()
        items: list[AST.Statement] = []
        while not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            if self._current_in((TokenType.COMMA, TokenType.SEMICOLON)):
                self._advance()
                continue
            items.append(self._parse_expression())
        return AST.Print(items=items)

    def _parse_RETURN(self) -> AST.Command:
        self._advance()
        return AST.Command(name="RETURN")

    def _parse_THEN(self):
        """ This is always an error """
        self._advance()
        self._raise_error(2, "Unexpected THEN keyword")

    def _parse_WEND(self) -> AST.BlockEnd:
        """ <WEND> ::= WEND """
        self._advance()
        if len(self.codeblocks) == 0 or "WEND" not in self.codeblocks[-1].until_keywords:
            self._raise_error(2, "Unexpected WEND keyword")
        self.codeblocks[-1].alive = False
        self.codeblocks.pop()
        return AST.BlockEnd(name="WEND")
    
    def _parse_WHILE(self) -> AST.WhileLoop:
        """ <WHILE> ::= WHILE <expression> <while_body> """
        """ <while_body> ::= : <while_inline> | EOL <code_block> """
        self._advance()
        cond = self._parse_expression()
        self.codeblocks.append(CodeBlock(type=BlockType.WHILE, until_keywords=("WEND",)))
        if self._current_is(TokenType.COLON):
            self._advance()
            body = self._parse_while_inline()
        else:
            self._expect(TokenType.EOL)
            body = self._parse_code_block()
        return AST.WhileLoop(condition=cond, body=body)
    
    def _parse_while_inline(self) -> list[AST.Statement]:
        """ <while_inline> ::= :<statement><while_inline> | :<WEND>"""
        last_stmt = self._parse_statement() 
        body = [last_stmt]
        while not isinstance(last_stmt, AST.BlockEnd):
            self._expect(TokenType.COLON)
            last_stmt = self._parse_statement()
            body.append(last_stmt)
        return body

    # ------------- Keyword placeholders -----------

    def _parse_JOY(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="JOY")

    def _parse_RENUM(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RENUM")

    def _parse_MIN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MIN")

    def _parse_RND(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RND")

    def _parse_XPOS(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="XPOS")

    def _parse_POKE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="POKE")

    def _parse_WAIT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="WAIT")

    def _parse_INP(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INP")

    def _parse_RANDOMIZE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RANDOMIZE")

    def _parse_USING(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="USING")

    def _parse_UNT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="UNT")

    def _parse_LOCATE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LOCATE")

    def _parse_MASK(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MASK")

    def _parse_NEW(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="NEW")

    def _parse_SWAP(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SWAP")

    def _parse_OPENIN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="OPENIN")

    def _parse_FRE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="FRE")

    def _parse_PI(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PI")

    def _parse_VPOS(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="VPOS")

    def _parse_LOG10(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LOG10")

    def _parse_TRON(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TRON")

    def _parse_STOP(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="STOP")

    def _parse_RIGHT_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RIGHT_S")

    def _parse_INSTR(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INSTR")

    def _parse_RESTORE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RESTORE")

    def _parse_ON_BREAK(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ON_BREAK")

    def _parse_PAPER(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PAPER")

    def _parse_ON_SQ(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ON_SQ")

    def _parse_LOG(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LOG")

    def _parse_RESUME(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RESUME")

    def _parse_READ(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="READ")

    def _parse_LOAD(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LOAD")

    def _parse_WINDOW(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="WINDOW")

    def _parse_HIMEM(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="HIMEM")

    def _parse_MEMORY(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MEMORY")

    def _parse_GRAPHICS(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="GRAPHICS")

    def _parse_RAD(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RAD")

    def _parse_SYMBOL_AFTER(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SYMBOL_AFTER")

    def _parse_POS(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="POS")

    def _parse_KEY(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="KEY")

    def _parse_RELEASE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RELEASE")

    def _parse_MERGE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MERGE")

    def _parse_TIME(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TIME")

    def _parse_MODE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MODE")

    def _parse_STRING_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="STRING_S")

    def _parse_DEF(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="DEF")

    def _parse_INK(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INK")

    def _parse_TAG(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TAG")

    def _parse_TAGOFF(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TAGOFF")

    def _parse_PEEK(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PEEK")

    def _parse_REMAIN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="REMAIN")

    def _parse_ON(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ON")

    def _parse_UPPER_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="UPPER_S")

    def _parse_CURSOR(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="CURSOR")

    def _parse_SQR(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SQR")

    def _parse_REM(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="REM")

    def _parse_OPENOUT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="OPENOUT")

    def _parse_LINE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LINE")

    def _parse_ON_ERROR_GOTO(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ON_ERROR_GOTO")

    def _parse_SAVE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SAVE")

    def _parse_RUN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="RUN")

    def _parse_YPOS(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="YPOS")

    def _parse_HEX_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="HEX_S")

    def _parse_SPC(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SPC")

    def _parse_FRAME(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="FRAME")

    def _parse_TROFF(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TROFF")

    def _parse_INKEY(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INKEY")

    def _parse_LEFT_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LEFT_S")

    def _parse_LOWER_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LOWER_S")

    def _parse_PLOTR(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PLOTR")

    def _parse_MOVER(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MOVER")

    def _parse_TEST(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TEST")

    def _parse_SIN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SIN")

    def _parse_MAX(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MAX")

    def _parse_SPEED(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SPEED")

    def _parse_LIST(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LIST")

    def _parse_SOUND(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SOUND")

    def _parse_SQ(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SQ")

    def _parse_STR_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="STR_S")

    def _parse_ORIGIN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ORIGIN")

    def _parse_ZONE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ZONE")

    def _parse_LINE_INPUT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LINE_INPUT")

    def _parse_FILL(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="FILL")

    def _parse_WRITE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="WRITE")

    def _parse_TESTR(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TESTR")

    def _parse_OUT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="OUT")

    def _parse_SYMBOL(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SYMBOL")

    def _parse_MID_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MID_S")

    def _parse_TAB(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TAB")

    def _parse_INT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INT")

    def _parse_LEN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="LEN")

    def _parse_SGN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SGN")

    def _parse_VAL(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="VAL")

    def _parse_INKEY_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="INKEY_S")

    def _parse_WIDTH(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="WIDTH")

    def _parse_SPACE_S(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="SPACE_S")



    def _parse_MOVE(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="MOVE")

    def _parse_PEN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PEN")

    def _parse_PLOT(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="PLOT")

    def _parse_TAN(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="TAN")

    def _parse_ROUND(self) -> AST.Command:
        # AUTOGEN PLACEHOLDER
        self._advance()
        return AST.Command(name="ROUND")

    # ----------------- Expresions -----------------

    r"""
        Numeric operators precedence:
        EXP     ^
        SIGN    -
        MULT    *
        DIV     /  (Real)
        DIV     \  (Int)
        MOD     MOD
        ADD     +
        SUB     -

        Logic operators precedence:
        NOT
        AND
        OR
        XOR
    """

    def _parse_expression(self) -> AST.Statement:
        """ <expression> ::= <logic_or> """
        return self._parse_logic_xor()

    def _parse_logic_xor(self) -> AST.Statement:
        """ <logic_xor> ::= <logic_or> [OR <logic_or>] """
        node = self._parse_logic_or()
        while self._current_is(TokenType.OP, "XOR"):
            op = self._advance()
            right = self._parse_logic_and()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype) or not AST.exptype_isnum(etype):
                self._raise_error(13, line=op.line, col=op.col)
            # AND, OR and XOR produce integer results, they round real numbers before
            # performing the operation
            node = AST.BinaryOp(op="XOR", left=node, right=right, etype=AST.ExpType.Integer)
        return node

    def _parse_logic_or(self) -> AST.Statement:
        """ <logic_or> ::= <logic_and> [OR <logic_and>] """
        node = self._parse_logic_and()
        while self._current_is(TokenType.OP, "OR"):
            op = self._advance()
            right = self._parse_logic_and()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype) or not AST.exptype_isnum(etype):
                self._raise_error(13, line=op.line, col=op.col)
            # AND, OR and XOR produce integer results, they round real numbers before
            # performing the operation
            node = AST.BinaryOp(op="OR", left=node, right=right, etype=AST.ExpType.Integer)
        return node

    def _parse_logic_and(self) -> AST.Statement:
        """ <logic_and> ::= <comparison> [AND <comparison>] """
        node = self._parse_comparison()
        while self._current_is(TokenType.OP, "AND"):
            op = self._advance()
            right = self._parse_comparison()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype) or not AST.exptype_isnum(etype):
                self._raise_error(13, line=op.line, col=op.col)
            # AND, OR and XOR produce integer results, they round real numbers before
            # performing the operation
            node = AST.BinaryOp(op="AND", left=node, right=right, etype=AST.ExpType.Integer)
        return node

    def _parse_comparison(self) -> AST.Statement:
        """ <comparison> ::= <mod> [(= | < | > | <= | =< | >= | => | <>) <mod>] """
        node = self._parse_mod()
        while self._current_is(TokenType.COMP):
            op = self._advance()
            right = self._parse_mod()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype):
                self._raise_error(13, line=op.line, col=op.col)
            # Logic OP always produces an integer result (0=FALSE, -1=TRUE)
            # but can operate with strings, for example "STRING1" >= "STRING"
            # which returns -1 (TRUE)    
            node = AST.BinaryOp(op=op.lexeme, left=node, right=right, etype=AST.ExpType.Integer)
        return node

    def _parse_mod(self) -> AST.Statement:
        """ <MOD> ::= <term> [MOD <term>] """
        node = self._parse_term()
        while self._current_is(TokenType.OP, "MOD"):
            op = self._advance()
            right = self._parse_term()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype) or not AST.exptype_isnum(etype):
                self._raise_error(13, line=op.line, col=op.col)
            # MOD always produces an integer result
            node = AST.BinaryOp(op="MOD", left=node, right=right, etype=AST.ExpType.Integer)
        return node

    def _parse_term(self) -> AST.Statement:
        """ <term> ::= <factor> [( + | - ) <factor>] """
        node = self._parse_factor()
        while self._current_in((TokenType.OP,),  ('+', '-')):
            op = self._advance()
            right = self._parse_factor()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isvalid(etype):
                self._raise_error(13, line=op.line, col=op.col)
            if etype == AST.ExpType.String and op.lexeme == "-":
                """ Strings only work with + (concatenate) """
                self._raise_error(13, line=op.line, col=op.col)
            node = AST.BinaryOp(op=op.lexeme, left=node, right=right, etype=etype)
        return node

    def _parse_factor(self) -> AST.Statement:
        r""" <factor> ::= <unary> [( * | / | \ ) <unary>] """
        node = self._parse_unary()
        while self._current_in((TokenType.OP,), ('*', '/', '\\')):
            op = self._advance()
            right = self._parse_unary()
            etype = AST.exptype_derive(node, right)
            if not AST.exptype_isnum(etype):
                self._raise_error(13, line=op.line, col=op.col)
            elif op.lexeme == '\\':
                etype = AST.ExpType.Integer
            node = AST.BinaryOp(op=op.lexeme, left=node, right=right, etype=etype)
        return node

    def _parse_unary(self) -> AST.Statement:
        """ <unary> ::= ( - | NOT ) <primary> | <primary> """
        if self._current_in((TokenType.OP,), ('-', 'NOT')):
            op = self._advance()
            operand = self._parse_primary()
            if not AST.exptype_isnum(operand.etype):
                # NOT and - only work with INT and REAL
                self._raise_error(13, line=op.line, col=op.col) 
            return AST.UnaryOp(op=op.lexeme, operand=operand, etype=operand.etype)
        return self._parse_primary()

    def _parse_primary(self) -> AST.Statement:
        """
        <primary> ::= POINTER | INT | REAL | STRING | (<expression>)
        <primary> ::= IDENT | IDENT(INT[,INT]) | <fun_keyword> | <fun_user>
        """
        tok = self._current()
        if tok.type == TokenType.AT:
            return self._parse_pointer()
        if tok.type == TokenType.INT:
            self._advance()
            return AST.Integer(value=cast(int, tok.value))
        if tok.type == TokenType.REAL:
            self._advance()
            return AST.Real(value=cast(float, tok.value))
        if tok.type == TokenType.STRING:
            self._advance()
            return AST.String(value=tok.lexeme.strip('"'))
        if tok.type == TokenType.IDENT:
            return self._parse_primary_ident()
        if tok.type == TokenType.KEYWORD:   
            return self._parse_keyword()
        if self._match(TokenType.LPAREN):
            expr = self._parse_expression()
            self._expect(TokenType.RPAREN)
            return expr
        self._raise_error(2, f"Unexpected symbol {tok.lexeme} in expression")
        return AST.Nop()
    
    def _parse_primary_ident(self, checksym: bool = True) -> AST.Statement:
        """ <primary_ident> ::= IDENT | IDENT(<int_expression>[,<int_expression>]) | <user_fun> """
        if self._current().lexeme[:2].upper() == "FN":
            # this is a user function defined by DEF FN as FN are reserved
            # and cannot be used in Locomotive Basic as the starting chars
            # for variables
            return self._parse_user_fun()
        tk = self._expect(TokenType.IDENT)
        if self._current_is(TokenType.LPAREN):
            # Array item
            self._advance()
            indexes = [self._parse_expression()]
            if not AST.exptype_isint(indexes[0].etype):
                self._raise_error(13)
            while self._current_is(TokenType.COMMA):
                self._advance()
                indexes.append(self._parse_expression())
                if not AST.exptype_isint(indexes[-1].etype):
                    self._raise_error(13)
            self._expect(TokenType.RPAREN)
            entry = self.symtable.find(tk.lexeme, self.context)
            if entry is None or entry.symtype != SymType.Array:
                self._raise_error(2)
            if entry.nargs != len(indexes): # type: ignore[union-attr]
                self._raise_error(2)
            return AST.ArrayItem(name=tk.lexeme, etype=entry.exptype, args=indexes) # type: ignore[union-attr]
        # regular variable
        etype = AST.exptype_fromname(tk.lexeme)
        entry = self.symtable.find(tk.lexeme, context=self.context)
        if entry is None and checksym:
            self._raise_error(2)
        if entry is not None: etype = entry.exptype
        return AST.Variable(name=tk.lexeme, etype=etype)

    def _parse_user_fun(self) -> AST.Statement:
        """ <user_fun> ::= FNIDENT([<expression>[,<expression>]])"""
        tk = self._expect(TokenType.IDENT)
        # functions are always declared in the global context
        entry = self.symtable.find(ident=tk.lexeme, context="")
        if entry is None:
            self._raise_error(18)
        args: list[AST.Statement] = []
        self._expect(TokenType.LPAREN)
        if not self._current_is(TokenType.RPAREN):
            args = [self._parse_expression()]
            while self._current_is(TokenType.COMMA):
                self._advance()
                args.append(self._parse_expression()) 
        self._expect(TokenType.RPAREN)
        if entry.nargs != len(args): # type: ignore[union-attr]
            self._raise_error(5)
        return AST.UserFun(name=tk.lexeme, etype=entry.exptype, args=args) # type: ignore[union-attr]

    def _parse_constant(self) -> AST.Statement:
        """ <constant> ::= INT | REAL | "STRING" | STRING """
        tok = self._current()
        if tok.type == TokenType.INT:
            self._advance()
            return AST.Integer(value=cast(int, tok.value))
        if tok.type == TokenType.REAL:
            self._advance()
            return AST.Real(value=cast(float, tok.value))
        if tok.type == TokenType.STRING:
            self._advance()
            return AST.String(value=tok.lexeme.strip('"'))
        if tok.type == TokenType.IDENT:
            name = self._advance().lexeme
            return AST.String(value=name)
        self._raise_error(2)
        return AST.Nop()

    def _parse_pointer(self) -> AST.Pointer:
        """ <pointer> ::= @IDENT """
        self._advance()
        tk = self._expect(TokenType.IDENT)
        vartype = AST.exptype_fromname(tk.lexeme)
        var = AST.Variable(name=tk.lexeme, etype=vartype)
        return AST.Pointer(var=var)

    def _parse_range(self) -> AST.Statement:
        """ <range> ::= CHAR[-CHAR] | INT[-INT]"""
        if self._current_is(TokenType.IDENT):
            low = self._expect(TokenType.IDENT).lexeme.upper()
            high = low
            if self._current_is(TokenType.OP, lexeme="-"):
                self._advance()
                high = self._expect(TokenType.IDENT).lexeme.upper()
            if len(low) > 1 or len(high) > 1:
                self._raise_error(2)
            etype = AST.ExpType.String
        else:
            high = low = self._expect(TokenType.INT).value # type: ignore[assignment]
            if self._current_is(TokenType.OP, lexeme="-"):
                self._advance()
                high = self._expect(TokenType.INT).value  # type: ignore[assignment]
            etype = AST.ExpType.Integer
        if low > high:
            self._raise_error(2)
        return AST.Range(etype=etype, low=low, high=high)

    # ----------------- AST Generation -----------------

    def _parse_assignment(self) -> AST.Assignment:
        """ <assignment> ::= <primary_ident> = <expression>"""
        # The asignement is the way to declare variables so
        # we do not check in the sym table for left variable
        target = self._parse_primary_ident(checksym=False)
        self._expect(TokenType.COMP, "=")
        source = self._parse_expression()
        etype = AST.exptype_derive(target, source)
        if not AST.exptype_isvalid(etype):
            self._raise_error(13)
        # assignament type is always the one from the target variable
        if isinstance(target, AST.Variable):
            # Simple variables are declared through assinements so we
            # have to add them to the symtable now
            self.symtable.add(
                ident=target.name,
                info=SymEntry(SymType.Variable, exptype=target.etype, locals=SymTable()),
                context=self.context
            )
        return AST.Assignment(target=target, source=source, etype=target.etype)

    def _parse_code_block(self) -> list[AST.Statement]:
        """ <code_block> ::= <line><parse_block> | (NEXT | WEND | ELSE | IFEND) """
        codeblock = self.codeblocks[-1]
        self._expect(TokenType.LINE_NUMBER)
        stmts: list[AST.Statement] = self._parse_statement_list()
        while codeblock.alive:
            self._expect(TokenType.EOL)
            self._expect(TokenType.LINE_NUMBER)
            stmts += self._parse_statement_list()
        if not isinstance(stmts[-1], AST.BlockEnd):
            # The line continued after the BlockEnd keyword
            # which is an error for us
            self._rewind()
            self._raise_error(2, "Extra statements aren't allowed after a codeblock end")
        return stmts

    def _parse_keyword(self) -> AST.Statement:
        """ <keyword> ::= <FUNCTION> | <COMMAND> """
        keyword = self._current().lexeme
        funcname = "_parse_" + keyword.replace('$','SS').replace(' ', '_')
        parse_keyword = getattr(self, funcname , None)
        if parse_keyword is None:
            self._raise_error(2, f"Unknown keyword {keyword}")
        return parse_keyword() # type: ignore[misc]

    def _parse_statement(self) -> AST.Statement:
        """ <statement> ::= <keyword> | COMMENT | RSX | <assignement> """
        tok = self._current()
        if tok.type == TokenType.KEYWORD:
            return self._parse_keyword()     
        if tok.type == TokenType.COMMENT:
            return AST.Comment(text=self._advance().lexeme)
        if tok.type == TokenType.RSX:
            return AST.RSX(command=self._advance().lexeme)
        if tok.type == TokenType.IDENT and tok.lexeme[:2].upper() == "FN":
            # User call to a function defined with DEF FN
            return self._parse_user_fun()
        if tok.type == TokenType.IDENT:
            # Assignment without LET
            return self._parse_assignment()
        self._raise_error(2, f"Unknown statement '{tok.lexeme}'")
        return AST.Nop()

    def _parse_statement_list(self) -> list[AST.Statement]:
        """<statement_list> ::= <statements> [:<statement>]"""
        stmts = [self._parse_statement()]
        while self._match(TokenType.COLON):
            stmts.append(self._parse_statement())
        return stmts

    def _parse_line(self) -> AST.Line:
        """<line> ::= LINE_NUMBER <statement_list> EOL"""
        tk = self._expect(TokenType.LINE_NUMBER)
        line_number = cast(int, tk.value)
        inserted = self.symtable.add(
            ident=str(line_number),
            info=SymEntry(symtype=SymType.Label, exptype=AST.ExpType.Integer, locals=SymTable()),
            context=""
        )
        if not inserted:
            self._raise_error(34)
        statements = self._parse_statement_list()
        self._expect(TokenType.EOL)
        return AST.Line(number=line_number, statements=statements)

    def parse_program(self) -> tuple[AST.Program, SymTable]:
        """ <program> ::= <line><program> | EOL<program> | EOF"""
        lines = []
        while not self._current_is(TokenType.EOF):
            if self._current_is(TokenType.EOL):
                self._advance()
                continue
            lines.append(self._parse_line())
        return AST.Program(lines=lines), self.symtable

if __name__ == "__main__":
    program = r"""
5  LET A = 0
10 FOR I = 1 TO 5
20   PRINT I
30 NEXT I
40 WHILE I < 10
50   I = I + 1
60 WEND
70 IF I > 5 THEN
80   PRINT "OK"
90 ELSE
100  PRINT "FAIL"
110 IFEND
120 END
"""
    try:
        lx = LocBasLexer(program)
        tokens = list(lx.tokens())
        code = [CodeLine("example.bas", i, line) for i,line in enumerate(program.split('\n'))]
        parser = LocBasParser(code, tokens)
        ast, _ = parser.parse_program()
        print(ast.to_json())
    except BasError as e:
        print(e)
