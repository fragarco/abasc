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
from typing import Any, Callable, Optional, cast
from dataclasses import dataclass
from enum import Enum, auto
from functools import wraps
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
    start_node: AST.Statement

class LocBasParser:
    def __init__(self, code: list[CodeLine], tokens: list[Token], warning_level=-1):
        self.tokens = tokens
        self.lines = code
        self.pos = 0
        self.codeblocks: list[CodeBlock] = []
        self.warning_level = warning_level
        self.symtable = SymTable()
        self.context = ""

    @staticmethod
    def astnode(func: Callable[[LocBasParser], AST.ASTNode]):
        """ Decorator to store token line and col in the required AST nodes """
        @wraps(func)
        def inner(inst, *args, **kwargs):
            tk = inst._current()
            node = func(inst, *args, **kwargs)
            node.line = tk.line
            node.col = tk.col
            return node
        return inner

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

    def _next_in(self, types: tuple, lexemes: Optional[tuple] = None) -> bool:
        tk = self.tokens[self.pos + 1]
        if tk.type not in types: return False
        if lexemes is not None:
            return tk.lexeme in lexemes
        return True

    # ----------------- Statements -----------------

    @astnode
    def _parse_ABS(self) -> AST.Function:
        """ <ABS> := ABS(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ABS", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_AFTER(self) -> AST.Command:
        """ <AFTER> ::= AFTER <int_expression>[,<int_expression>] <GOSUB> """
        self._advance()
        delay = self._parse_int_expression()
        args = [delay]
        if self._current_is(TokenType.COMMA):
            self._advance()
            timer = self._parse_int_expression()
            args.append(timer)
        args.append(self._parse_GOSUB())
        return AST.Command(name="AFTER", args=args)
    
    @astnode
    def _parse_ASC(self) -> AST.Function:
        """ <ASC> ::= ASC(<str_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_str_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ASC", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_ATN(self) -> AST.Function:
        """ <ATN> ::= ATN(<num_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ATN", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_AUTO(self) -> AST.Command:
        """ <AUTO> ::= AUTO <int_expression>[,<int_expression>] """   
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.INT):
            num = self._advance()
            args.append(AST.Integer(value=cast(int, num.value)))
            self._match(TokenType.COMMA)
            if self._current_is(TokenType.INT):
                num = self._advance()
                args.append(AST.Integer(value=cast(int, num.value)))
        return AST.Command(name="AUTO", args=args)
    
    @astnode
    def _parse_BINSS(self) -> AST.Function:
        """ <BINSS> ::= BIN$(<int_expression>[,<int_expression>])"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            width = self._parse_int_expression()
            args.append(width)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="BIN$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_BORDER(self) -> AST.Command:
        """ <BORDER> ::= BORDER <int_expression>[,<int_expression>] """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            color2 = self._parse_int_expression()
            args.append(color2)
        return AST.Command(name="BORDER", args=args)

    @astnode
    def _parse_CALL(self) -> AST.Command:
        """ <CALL> ::= CALL <int_expression>[,<expression>]* """
        self._advance()
        dir = self._parse_int_expression()
        args = [dir]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_expression())
        return AST.Command(name="CALL", args=args)

    @astnode
    def _parse_CAT(self) -> AST.Command:
        """ <CAT> ::= CAT """
        # A direct command that is not allowed in compiled programs
        # but let's the emiter fail 
        self._advance()
        return AST.Command(name="CAT")

    @astnode
    def _parse_CHAIN(self) -> AST.Command:
        """ <CHAIN> ::= CHAIN <str_expression>[,<int_expression>] """
        # This command appends a new Basic program form a loaded
        # file, so it doesn't make sense for a compiler
        # INCBAS additional command suplies this at compile time
        self._advance()
        self._raise_error(2, info="Command not supported, use INCBAS instead")
        return AST.Command(name="CHAIN")

    @astnode
    def _parse_CHAIN_MERGE(self) -> AST.Command:
        """ <CHAIN_MERGE> ::= CHAIN MERGE <str_expression>[,<int_expression>][,DELETE <int_expression>] """
        # This command appends a new Basic program form a loaded
        # file, so it doesn't make sense for a compiler
        # INCBAS additional command suplies this at compile time
        self._advance()
        self._raise_error(2, info="Command not supported, use INCBAS instead")
        return AST.Command(name="CHAIN_MERGE")

    @astnode
    def _parse_CHRSS(self) -> AST.Function:
        """ <CHRSS> ::= CHR$(<int_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CHR$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_CINT(self) -> AST.Function:
        """ <CINT> ::= CINT(<real_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CINT", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_CLEAR(self) -> AST.Command:
        """ <CLEAR> ::= CLEAR """
        # This command resets several areas of the BASIC interpreter
        # and doesn't seem to be very useful for a compiled program
        # but let's decide that to the code emiter as we can reuse CLEAR
        # to free some other generated structures
        self._advance()
        return AST.Command(name="CLEAR")

    def _parse_CLEAR_INPUT(self) -> AST.Command:
        """ <CLEAR_INPUT> ::= CLEAR INPUT"""
        # BASIC 1.1
        self._advance()
        return AST.Command(name="CLEAR INPUT")

    @astnode
    def _parse_CLG(self) -> AST.Command:
        """ <CLG> ::= CLG [<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            args = [self._parse_int_expression()]
        return AST.Command(name="CLG", args=args)

    @astnode
    def _parse_CLOSEIN(self) -> AST.Command:
        """ <CLOSEIN> ::= CLOSEIN """
        self._advance()
        return AST.Command(name="CLOSEIN")

    @astnode
    def _parse_CLOSEOUT(self) -> AST.Command:
        """ <CLOSEOUT> ::= CLOSEOUT """
        self._advance()
        return AST.Command(name="CLOSEOUT")

    @astnode
    def _parse_CLS(self) -> AST.Command:
        """ <CLS> := CLS [#<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
        return AST.Command(name="CLS", args=args)

    @astnode
    def _parse_CONT(self) -> AST.Command:
        """ <CONT> ::= CONT """
        # A direct command that is not allowed in compiled programs
        # but let's the emiter fail
        self._advance()
        return AST.Command(name="CONT")

    @astnode
    def _parse_COPYCHRSS(self) -> AST.Function:
        """ <COPYCHRSS> ::= COPYCHR$(#<int_expression>) """
        # BASIC 1.1
        self._advance()
        self._expect(TokenType.LPAREN)
        self._expect(TokenType.HASH)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="COPYCHR$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_COS(self) -> AST.Function:
        """ <COS> ::= COS(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="COS", etype=AST.ExpType.Real, args=args)
   
    @astnode 
    def _parse_CREAL(self) -> AST.Function:
        """ <CREAL> ::= CREAL(<num_expression>)"""
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="CREAL", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_CURSOR(self) -> AST.Command:
        """ <CURSOR> ::= CURSOR <int_expression>[,<int_expression>] """
        # BASIC 1.1
        self._advance()
        args = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="CURSOR", args=args)

    @astnode
    def _parse_DATA(self) -> AST.Command:
        """ <DATA> ::= DATA <primary>[,<primary>]*"""
        self._advance()
        args: list[AST.Statement] = [self._parse_constant()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_constant())
        return AST.Command(name="DATA", args=args)

    @astnode
    def _parse_DECSS(self) -> AST.Function:
        """ <DECSS> ::= DEC$(<num_expression>, STRING) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.COMMA)
        tk = self._expect(TokenType.STRING)
        args.append(AST.String(value=tk.lexeme))
        self._expect(TokenType.RPAREN)
        return AST.Function(name="DEC$", args=args, etype=AST.ExpType.String)

    @astnode
    def _parse_DEF(self) -> AST.Command:
        # We decode DEF FN and not only DEF so if we find this
        # is an error
        self._advance()
        self._raise_error(2)
        return AST.Command(name="DEF")

    @astnode
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
        fbody = self._parse_num_expression()
        self.context = ""
        # Lets update our entry for the function with
        # the last calculated parameters
        info = self.symtable.find(ident=fname) # type: ignore[assignment]
        if info is None:
            self._raise_error(38)
        info.exptype = fbody.etype
        info.nargs = len(fargs)
        return AST.DefFN(name=fname, args=fargs, body=fbody)

    @astnode
    def _parse_DEFINT(self) -> AST.Command:
        """ <DEFINT> ::= DEFINT <str_range> """
        self._raise_warning(level=3, msg="DEFINT is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFINT", args=args)

    @astnode
    def _parse_DEFREAL(self) -> AST.Command:
        """ <DEFREAL> ::= DEFREAL <str_range> """
        self._raise_warning(level=3, msg="DEFREAL is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFREAL", args=args)

    @astnode
    def _parse_DEFSTR(self) -> AST.Command:
        """ <DEFSTR> ::= DEFSTR <str_range> """
        self._raise_warning(level=3, msg="DEFSTR is ignored")
        self._advance()
        args = [self._parse_range()]
        return AST.Command(name="DEFSTR", args=args)

    @astnode
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

    @astnode
    def _parse_DERR(self) -> AST.Function:
        """ <DERR> ::= DERR """
        self._advance()
        return AST.Function(name="DERR", etype=AST.ExpType.Integer)

    @astnode
    def _parse_DI(self) -> AST.Command:
        """ <DI> ::= DI """
        self._advance()
        return AST.Command(name="DI")

    @astnode
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

    @astnode
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

    @astnode
    def _parse_DRAW(self) -> AST.Command:
        """ <DRAW> ::= DRAW <int_expression>,<int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="DRAW", args=args)

    @astnode
    def _parse_DRAWR(self) -> AST.Command:
        """ <DRAWR> ::= DRAWR <int_expression>,<int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="DRAWR", args=args)

    @astnode
    def _parse_EDIT(self) -> AST.Command:
        """ <EDIT> ::= EDIT INT """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="EDIT")

    @astnode
    def _parse_EI(self) -> AST.Command:
        """ <EI> ::= EI """
        self._advance()
        return AST.Command(name="EI")

    @astnode
    def _parse_ELSE(self) -> AST.BlockEnd:
        """ <ELSE> ::== ELSE """
        self._advance()
        if len(self.codeblocks) == 0 or "ELSE" not in self.codeblocks[-1].until_keywords:
            self._raise_error(37)
        codeblock = self.codeblocks[-1]
        if isinstance(codeblock.start_node, AST.If):
            codeblock.start_node.has_else = True
            codeblock.until_keywords = ("IFEND",)
        else:
            self._raise_error(2)
        return AST.BlockEnd(name="ELSE")

    @astnode
    def _parse_END(self) -> AST.Command:
        """ <END> ::= END """
        self._advance()
        return AST.Command(name="END")

    @astnode
    def _parse_ENT(self) -> AST.Command:
        """ <ENT> ::= ENT <int_expression>[,<ent_section>][,<ent_section>][,<ent_section>][,<ent_section>][,<ent_section>] """
        """ <ent_section> ::= <int_expression>,<int_expression>,<int_expression> | <int_expression>,<int_expression> """
        # NOTE: Sections will be integers of 3 bytes: byte, byte, byte or 2-bytes, byte.
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        if len(args) > 5*3:
            self._raise_error(5)
        return AST.Command(name="ENT", args=args)

    @astnode
    def _parse_ENV(self) -> AST.Command:
        """ <ENV> ::= ENV <int_expression>[,<env_section>][,<env_section>][,<env_section>][,<env_section>][,<env_section>] """
        """ <env_section> ::= <int_expression>,<int_expression>,<int_expression> | <int_expression>,<int_expression> """
        # NOTE: Sections will be integers of 3 bytes: byte, byte, byte or byte, 2-bytes.
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        if len(args) > 5*3:
            self._raise_error(5)
        return AST.Command(name="ENV", args=args)

    @astnode
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

    @astnode
    def _parse_ERL(self) -> AST.Function:
        """ <ERL> ::= ERL """
        # Will return the line number where the last ERROR command was executed 
        self._advance()
        return AST.Function(name="ERL", etype=AST.ExpType.Integer)

    @astnode
    def _parse_ERR(self) -> AST.Function:
        """ <ERR> ::= ERR """
        # Will return the error code number used in the last executed ERROR command
        self._advance()
        return AST.Function(name="ERR", etype=AST.ExpType.Integer)

    def _parse_ERROR(self) -> AST.Command:
        """ <ERROR> ::= ERROR <int_expression> """
        # Sets the values for ERR and ERL
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="ERROR", args=args)

    @astnode
    def _parse_EVERY(self) -> AST.Command:
        """ <EVERY> ::= EVERY <int_expression>[,<int_expression>] <GOSUB> """
        self._advance()
        args = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        if not self._current_is(TokenType.KEYWORD, lexeme="GOSUB"):
            self._raise_error(2)
        args.append(self._parse_GOSUB())
        return AST.Command(name="EVERY", args=args)

    @astnode
    def _parse_EXP(self) -> AST.Function:
        """ <EXP> ::= EXP(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="EXP", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_FILL(self) -> AST.Command:
        """ <FILL> ::= FILL <int_expression> """
        # BASIC 1.1
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="FILL", args=args)

    @astnode
    def _parse_FIX(self) -> AST.Function:
        """ <FIX> ::= FIX(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="FIX", etype=AST.ExpType.Integer, args=args)
   
    @astnode 
    def _parse_FN(self) -> AST.Command:
        # DEF parses FN so if we arrive here is a syntax error
        self._advance()
        self._raise_error(2)
        return AST.Command(name="FN")

    @astnode
    def _parse_FOR(self) -> AST.ForLoop:
        """ <FOR> ::= FOR IDENT = <int_expression> TO <int_expression> [STEP <int_expression>] """
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
        start = self._parse_int_expression()
        self._expect(TokenType.KEYWORD, "TO")
        end = self._parse_int_expression()
        step = None
        if self._match(TokenType.KEYWORD, "STEP"):
            step = self._parse_int_expression()
        index = AST.Variable(name=var, etype=vartype)
        node = AST.ForLoop(var=index, start=start, end=end, step=step)
        self.codeblocks.append(CodeBlock(
            type=BlockType.FOR,
            until_keywords=("NEXT",),
            start_node=node
        ))
        return node

    @astnode
    def _parse_FRAME(self) -> AST.Command:
        """ <FRAME> ::= FRAME """
        # BASIC 1.1
        self._advance()
        return AST.Command(name="FRAME")

    @astnode
    def _parse_FRE(self) -> AST.Function:
        """ <FRE> ::= FRE(0) | FRE("") """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="FRE", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_GOSUB(self) -> AST.Command:
        """ <GOSUB> ::= GOSUB (INT | IDENT) """
        # some compound commands call here so let's check that GOSUB
        # is really the current keyword
        self._expect(TokenType.KEYWORD, lex="GOSUB")
        args: list[AST.Statement] = []
        if self._current_is(TokenType.INT):
            num = self._advance()
            args = [AST.Integer(value = cast(int, num.value))]
        elif self._current_is(TokenType.IDENT):
            label = self._advance()
            args = [AST.Label(value = label.lexeme)]
        else:
            self._raise_error(2)
        return AST.Command(name="GOSUB", args=args)

    @astnode
    def _parse_GOTO(self) -> AST.Command:
        """ <GOTO> ::= GOTO (INT | IDENT) """
        # THEN and ELSE can arrive here parsing just a number/label so we use 
        # match and not advance
        self._match(TokenType.KEYWORD, "GOTO")
        args: list[AST.Statement] = []
        if self._current_is(TokenType.INT):
            num = self._advance()
            args = [AST.Integer(value = cast(int, num.value))]
        elif self._current_is(TokenType.IDENT):
            label = self._advance()
            args = [AST.Label(value = label.lexeme)]
        else:
            self._raise_error(2)
        return AST.Command(name="GOTO", args=args)

    @astnode
    def _parse_GRAPHICS_PAPER(self) -> AST.Command:
        """ <GRAPHICS_PAPER> ::= GRAPHICS PAPER <int_expression> """
        # BASIC 1.1
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="GRAPHICS PAPER", args=args)
 
    @astnode   
    def _parse_GRAPHICS_PEN(self) -> AST.Command:
        """ <GRAPHICS_PEN> ::= GRAPHICS PEN <int_expression> """
        # BASIC 1.1
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="GRAPHICS PEN", args=args)

    @astnode
    def _parse_HEXSS(self) -> AST.Function:
        """ <HEXSS> ::= HEX$(<int_expression>[,<int_expression>]) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="HEX$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_HIMEM(self) -> AST.Function:
        """ <HIMEN> ::= HIMEN """
        self._advance()
        return AST.Function(name="HIMEM", etype=AST.ExpType.Integer)
 
    @astnode   
    def _parse_IF(self) -> AST.If:
        """ <IF> ::= IF <int_expression> (THEN | GOTO) [<inline_then>[ELSE >inline_else>]] """
        self._advance()
        condition = self._parse_int_expression()
        if not self._current().lexeme in ("THEN", "GOTO"):
            self._raise_error(2, "THEN missing")
        self._advance()
        if not self._current_is(TokenType.EOL):
            then_body = self._parse_inline_then()
            else_body: list[AST.Statement] = []
            if self._current_is(TokenType.KEYWORD, "ELSE"):
                self._advance()
                else_body = self._parse_inline_else()
            return AST.If(condition=condition, inline_then=then_body, inline_else=else_body)
        node = AST.If(condition=condition)
        self.codeblocks.append(CodeBlock(
            type=BlockType.IF,
            until_keywords=("ELSE","IFEND"),
            start_node=node
        ))
        return node 

    def _parse_inline_then(self) -> list[AST.Statement]:
        """ <inline_then> ::= <statement>[:<statement>]* """
        if self._current_is(TokenType.INT):
                return [self._parse_GOTO()]
        then_body: list[AST.Statement] = []
        while not self._current_in((TokenType.EOL, TokenType.EOF)):
            stmt = self._parse_statement()
            then_body.append(stmt)
            if self._current_is(TokenType.COLON):
                self._advance()
            if self._current_is(TokenType.KEYWORD, "ELSE"):
                return then_body
        if len(then_body) == 0:
            self._raise_error(2)
        return then_body

    def _parse_inline_else(self) -> list[AST.Statement]:
        """ <inline_else> ::= <statement>[:<statement>]* """
        if self._current_is(TokenType.INT):
                return [self._parse_GOTO()]
        else_body: list[AST.Statement] = []
        while not self._current_in((TokenType.EOL, TokenType.EOF)):
            stmt = self._parse_statement()
            else_body.append(stmt)
            if self._current_is(TokenType.COLON):
                self._advance()
        if len(else_body) == 0:
            self._raise_error(2)
        return else_body

    @astnode
    def _parse_IFEND(self) -> AST.BlockEnd:
        self._advance()
        if len(self.codeblocks) == 0 or "IFEND" not in self.codeblocks[-1].until_keywords:
            self._raise_error(36)
        self.codeblocks.pop()
        return AST.BlockEnd(name="IFEND")

    @astnode
    def _parse_INK(self) -> AST.Command:
        """ <INK> ::= INK <int_expression()>,<int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="INK", args=args)

    @astnode
    def _parse_INKEY(self) -> AST.Function:
        """ <INKEY> ::= INKEY(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="INKEY", etype=AST.ExpType.Integer, args=args)
 
    @astnode   
    def _parse_INKEYSS(self) -> AST.Function:
        """ <INKEYSS> ::= INKEY$ """
        self._advance()
        return AST.Function(name="INKEY$", etype=AST.ExpType.String)

    @astnode
    def _parse_INP(self) -> AST.Function:
        """ <INP> ::= INP(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="INP", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_INPUT(self) -> AST.Input:
        """ <INPUT> := INPUT [#<int_expression>][STRING(;|,)] IDENT [,IDENT] """
        self._advance()
        stream: Optional[AST.Statement] = None; 
        prompt: str = ""
        vars: list[AST.Variable] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            stream = self._parse_int_expression()
            self._match(TokenType.COMMA)
        if self._current_is(TokenType.STRING):
            prompt = self._advance().lexeme.strip('"')
        if stream is not None or prompt != "":
            if not self._current_in((TokenType.COMMA, TokenType.SEMICOLON)):
                self._raise_error(2)
        question: bool = True if self._match(TokenType.SEMICOLON) else False
        self._match(TokenType.COMMA)
        while True:
            var = self._expect(TokenType.IDENT)
            vartype = AST.exptype_fromname(var.lexeme)
            vars.append(AST.Variable(name=var.lexeme, etype=vartype))
            vars[-1].line = var.line
            vars[-1].col = var.col
            if not self._match(TokenType.COMMA):
                break
        # Input can declare variables so we need to add any new ones to the symtable
        for v in vars:
            if self.symtable.find(ident=v.name, context=self.context) is None:
                self.symtable.add(
                    ident=v.name,
                    info=SymEntry(symtype=SymType.Variable, exptype=v.etype, locals=SymTable()),
                    context=self.context
                )
        return AST.Input(stream=stream, prompt=prompt, question=question, vars=vars)

    @astnode
    def _parse_INSTR(self) -> AST.Function:
        """ <INSTR> ::= INSTR([<int_expression>,]<str_expression(),<str_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_expression()]
        remain = 2 if args[0].etype == AST.ExpType.Integer else 1
        while remain:
            self._match(TokenType.COMMA)
            args.append(self._parse_str_expression())
            remain -= 1
        self._expect(TokenType.RPAREN)
        return AST.Function(name="INSTR", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_INT(self) -> AST.Function:
        """ <INT> ::= INT(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="INT", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_JOY(self) -> AST.Function:
        """ <JOY> ::= JOY(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="JOY", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_KEY(self) -> AST.Command:
        """ <KEY> ::= KEY <int_expression>,<str_expression> """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_str_expression())
        return AST.Command(name="KEY", args=args)

    @astnode
    def _parse_KEY_DEF(self) -> AST.Command:
        """
        <KEY> ::= KEY DEF <int_expression>,<int_expression>[,<keydefoptions>]
        <keydefoptions> ::== <int_expression>[,<int_expression>[,<int_expression>]]
        """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="KEY DEF", args=args)
  
    @astnode  
    def _parse_LABEL(self) -> AST.Label:
        """ <LABEL> ::== LABEL IDENT """
        self._advance()
        label = self._expect(TokenType.IDENT)
        inserted = self.symtable.add(
            ident=label.lexeme,
            info=SymEntry(symtype=SymType.Label, exptype=AST.ExpType.Void, locals=SymTable()),
            context=""
        )
        if not inserted:
            self._raise_error(39)
        return AST.Label(value=label.lexeme)

    @astnode  
    def _parse_LEFTSS(self) -> AST.Function:
        """ <LEFTSS> ::== LEFT$(<st_expression>,<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_str_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="LEFT$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_LEN(self) -> AST.Function:
        """ <LEN> ::= LEN(<str_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_str_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="LEN", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_LET(self) -> AST.Assignment:
        """ <LET> ::= LET <assignment> """
        self._advance()
        return self._parse_assignment()

    @astnode
    def _parse_LINE_INPUT(self) -> AST.LineInput:
        """ <LINE_INPUT>::= LINE INPUT [#<int_expression>,][STRING(;|,)]<IDENT> """
        self._advance()
        stream: Optional[AST.Statement] = None; 
        prompt: str = ""
        if self._current_is(TokenType.HASH):
            self._advance()
            stream = self._parse_int_expression()
            self._match(TokenType.COMMA)
        if self._current_is(TokenType.STRING):
            prompt = self._advance().lexeme.strip('"')
        if stream is not None or prompt != "":
            if not self._current_in((TokenType.COMMA, TokenType.SEMICOLON)):
                self._raise_error(2)
        carriage: bool = False if self._match(TokenType.SEMICOLON) else True
        self._match(TokenType.COMMA)
        varname = self._expect(TokenType.IDENT).lexeme
        vartype = AST.exptype_fromname(varname)
        var = AST.Variable(name=varname, etype=vartype)
        # LINE INPUT can declare a new variable so we need to add it
        if self.symtable.find(ident=varname, context=self.context) is None:
            self.symtable.add(
                ident=varname,
                info=SymEntry(symtype=SymType.Variable, exptype=vartype, locals=SymTable()),
                context=self.context
            )
        return AST.LineInput(stream=stream, prompt=prompt, carriage=carriage, var=var)
 
    @astnode
    def _parse_LIST(self) -> AST.Command:
        """ <LIST> ::= LIST """
        # This command doesn't make sense in a compiled program but
        # leave the emiter fail
        self._advance()
        return AST.Command(name="LIST")

    @astnode
    def _parse_LOAD(self) -> AST.Command:
        """ <LOAD> ::= LOAD <str_expression>[,<int_expression>]"""
        self._advance()
        args = [self._parse_str_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="LOAD", args=args)

    @astnode
    def _parse_LOCATE(self) -> AST.Command:
        """ <LOCATE> ::= LOCATE [#<int_expression>,]<int_expression>,<int_expression> """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args.append(self._parse_int_expression())
            self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="LOCATE", args=args)

    @astnode
    def _parse_LOG(self) -> AST.Function:
        """ <LOG> ::= LOG(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="LOG", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_LOG10(self) -> AST.Function:
        """ <LOG10> ::= LOG10(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="LOG10", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_LOWERSS(self) -> AST.Function:
        """ <LOWERSS> ::= LOWER$(<str_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_str_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="LOWER$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_MASK(self) -> AST.Command:
        """ <MASK> ::= MASK <int_expression>[,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="MASK", args=args)

    @astnode
    def _parse_MAX(self) -> AST.Function:
        """ <MAX> ::= MAX(<num_expression>[,<num_expression>]*) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        etype = args[-1].etype
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_num_expression())
            etype = etype if args[-1].etype == etype else AST.ExpType.Real
        self._expect(TokenType.RPAREN)
        if len(args) < 2:
            self._raise_error(2)
        return AST.Function(name="MAX", etype=etype, args=args)

    @astnode
    def _parse_MEMORY(self) -> AST.Command:
        """ <MEMORY> ::= MEMORY <int_expression>"""
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="MEMORY", args=args)

    @astnode
    def _parse_MERGE(self) -> AST.Command:
        """ <MERGE> ::= MERGE <str_expression> """
        self._advance()
        args = [self._parse_str_expression()]
        return AST.Command(name="MERGE", args=args)

    @astnode
    def _parse_MIDSS(self) -> AST.Function:
        """ <MIDSS> ::= MID$(<str_expression>,<int_expression>[,<int_expression>]) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_str_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="MID$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_MIN(self) -> AST.Function:
        """ <MIN> ::= MIN(<num_expression>[,<num_expression>]*) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        etype = args[-1].etype
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_num_expression())
            etype = etype if args[-1].etype == etype else AST.ExpType.Real
        self._expect(TokenType.RPAREN)
        if len(args) < 2:
            self._raise_error(2)
        return AST.Function(name="MIN", etype=etype, args=args)

    @astnode
    def _parse_MODE(self) -> AST.Command:
        """ <MODEA> ::= MODE <int_expression>"""
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="MODE", args=args)

    @astnode
    def _parse_MOVE(self) -> AST.Command:
        """ <MOVE> ::= MOVE <int_expression>,<int_expression>[,<int_expression>[,<int_expression>]] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        while self._current_is(TokenType.COMMA):
            args.append(self._parse_int_expression())
        return AST.Command(name="MOVE", args=args)

    @astnode
    def _parse_MOVER(self) -> AST.Command:
        """ <MOVER> ::= MOVER <int_expression>,<int_expression>[,<int_expression>[,<int_expression>]] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        while self._current_is(TokenType.COMMA):
            args.append(self._parse_int_expression())
        return AST.Command(name="MOVER", args=args)
 
    @astnode   
    def _parse_NEW(self) -> AST.Command:
        """ <NEW> ::= NEW """
        # A direct command that is not allowed in compiled programs    
        self._advance()
        self._raise_error(21)
        return AST.Command(name="NEW")

    @astnode
    def _parse_NEXT(self) -> AST.BlockEnd:
        """ <NEXT> ::= NEXT [IDENT]"""
        self._advance()
        if len(self.codeblocks) == 0 or "NEXT" not in self.codeblocks[-1].until_keywords:
            self._raise_error(1)
        next_var = ""
        if self._current_is(TokenType.IDENT):
            next_var = self._advance().lexeme
            vartype = AST.exptype_fromname(next_var)
            if not AST.exptype_isint(vartype):
                self._raise_error(13)
            node = self.codeblocks[-1].start_node
            if isinstance(node, AST.ForLoop):
                orgvar = node.var.name.upper()
                if orgvar != next_var.upper():
                    self._raise_error(1)
            else:
                self._raise_error(2)
        self.codeblocks.pop()
        return AST.BlockEnd(name="NEXT", var=next_var)

    @astnode
    def _parse_ON(self) -> AST.Command:
        """ 
        <ON> ::= ON <int_expression> <on_body> 
        <on_body> ::= (GOTO | GOSUB) INT[,INT]*
        """
        self._advance()
        args = [self._parse_int_expression()]
        if not self._current_in((TokenType.KEYWORD,), ("GOTO","GOSUB")):
            self._raise_error(2)
        cmd = "ON " + self._advance().lexeme
        while True:
            num = self._expect(TokenType.INT)
            args.append(AST.Integer(value = cast(int, num.value)))
            if not self._current_is(TokenType.COMMA):
                break
            self._advance()
        return AST.Command(name=cmd, args=args)

    @astnode
    def _parse_ON_BREAK(self) -> AST.Command:
        """ 
        <ON_BREAK> ::= ON BREAK <on_break_body>
        <on_break_body> ::= COUNT | STOP |GOSUB INT
        """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.KEYWORD, "COUNT"):
            self._advance()
            cmd = "ON BREAK COUNT"
        elif self._current_is(TokenType.KEYWORD, "STOP"):
            self._advance()
            cmd = "ON BREAK STOP"
        elif self._current_is(TokenType.KEYWORD, "GOSUB"):
            self._advance()
            cmd = "ON BREAK GOSUB"
            num = self._expect(TokenType.INT)
            args.append(AST.Integer(value = cast(int, num.value)))
        else:
            self._raise_error(2)
        return AST.Command(name=cmd, args=args)
 
    @astnode   
    def _parse_ON_ERROR_GOTO(self) -> AST.Command:
        """ <ON_ERROR_GOTO> ::= ON ERROR GOTO INT"""
        self._advance()
        num = self._expect(TokenType.INT)
        args: list[AST.Statement] = [AST.Integer(value = cast(int, num.value))]
        return AST.Command(name="ON ERROR GOTO", args=args)

    @astnode
    def _parse_ON_SQ(self) -> AST.Command:
        """ <ON_SQ> ::= ON SQ(<int_expression>) GOSUB INT """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        self._expect(TokenType.KEYWORD, "GOSUB")
        num = self._expect(TokenType.INT)
        args.append(AST.Integer(value = cast(int, num.value)))
        return AST.Command(name="ON SQ", args=args)

    @astnode
    def _parse_OPENIN(self) -> AST.Command:
        """ <OPENIN> ::= OPENIN <str_expression> """
        self._advance()
        args = [self._parse_str_expression()]
        return AST.Command(name="OPENIN", args=args)
  
    @astnode  
    def _parse_OPENOUT(self) -> AST.Command:
        """ <OPENOUT> ::= OPENOUT <str_expression> """
        self._advance()
        args = [self._parse_str_expression()]
        return AST.Command(name="OPENOUT", args=args)

    @astnode
    def _parse_ORIGIN(self) -> AST.Command:
        """
        <ORIGIN> ::= ORIGIN <int_expression>,<int_expression>[<origin_wnd>]
        <origin_wnd> ::= ,<int_expression>,<int_expression>,<int_expression>,<int_expression>
        """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            for _ in range(4):
                self._expect(TokenType.COMMA)
                args.append(self._parse_int_expression())
        return AST.Command(name="ORIGIN", args=args)

    @astnode
    def _parse_OUT(self) -> AST.Command:
        """ <OUT> ::= OUT <int_expression>,<int_expression> """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="OUT", args=args)

    @astnode
    def _parse_PAPER(self) -> AST.Command:
        """ <PAPER> ::= PAPER [#<int_expression>,]<int_expression> """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
            self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="PAPER", args=args)

    @astnode
    def _parse_PEEK(self) -> AST.Function:
        """ <PEEK> ::= PEEK(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="PEEK", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_PEN(self) -> AST.Command:
        """ <PEN> ::= PEN [#<int_expression>,]<int_expression> """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
            self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="PEN", args=args)

    @astnode
    def _parse_PI(self) -> AST.Function:
        """ <PI> ::= PI """
        self._advance()
        return AST.Function(name="PI", etype=AST.ExpType.Real)

    @astnode
    def _parse_PLOT(self) -> AST.Command:
        """ <PLOT> ::= PLOT <int_expression>,<int_expression>[,<int_expression>][,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="PLOT", args=args)

    @astnode
    def _parse_PLOTR(self) -> AST.Command:
        """ <PLOTR> ::= PLOTR <int_expression>,<int_expression>[,<int_expression>][,<int_expression>] """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        while self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="PLOTR", args=args)

    @astnode
    def _parse_POKE(self) -> AST.Command:
        """ <POKE> ::= POKE <int_expression>,<int_expression> """
        self._advance()
        args = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="POKE", args=args)

    @astnode
    def _parse_POS(self) -> AST.Function:
        """ <POS> ::= POS(#<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        self._expect(TokenType.HASH)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="POS", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_PRINT(self) -> AST.Print:
        """
        <PRINT> ::= PRINT [#<int_expression>,][<print_items>][print_using][print_separator]
        <print_items> ::= <expression>[;|,]<print_items> | <expression>
        <print_using> ::= USING <str_expression>,<expression>[]
        <print_separator> ::= ; | , 
        """
        self._advance()
        stream: Optional[AST.Statement] = None
        items: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            stream = self._parse_int_expression()
            self._expect(TokenType.COMMA)
        while not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            if self._current_in((TokenType.COMMA, TokenType.SEMICOLON)):
                sym = self._advance()
                sep = AST.Separator(symbol=sym.lexeme)
                sep.line = sym.line
                sep.col = sym.col
                items.append(sep)
            elif self._current_in((TokenType.KEYWORD,), ("USING",)):
                self._advance()
                args = [self._parse_str_expression()]
                self._expect(TokenType.SEMICOLON)
                args.append(self._parse_expression())
                etype = args[-1].etype
                while self._current_in((TokenType.COMMA,TokenType.SEMICOLON)):
                    if self._next_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
                        break
                    self._advance()
                    args.append(self._parse_expression())
                    if not AST.exptype_compatible(etype, args[-1].etype):
                        self._raise_error(13)
                items.append(AST.Function(name="USING", etype=AST.ExpType.String, args=args))
                if self._current_in((TokenType.COMMA,TokenType.SEMICOLON)):
                    sym = self._advance()
                    sep = AST.Separator(symbol=sym.lexeme)
                    sep.line = sym.line
                    sep.col = sym.col
                    items.append(sep)
                    items.append(sep)
                break
            else:
                items.append(self._parse_expression())
        return AST.Print(stream=stream, items=items)      

    @astnode
    def _parse_RAD(self) -> AST.Command:
        """ <RAD> ::= RAD """
        self._advance()
        return AST.Command(name="RAD")
  
    @astnode  
    def _parse_RANDOMIZE(self) -> AST.Command:
        """ <RANDOMIZE> ::= RANDOMIZE [<num_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            args = [self._parse_num_expression()]
        return AST.Command(name="RANDOMIZE", args=args)

    @astnode
    def _parse_READ(self) -> AST.Command:
        """ <READ> ::= READ IDENT[,IDENT]* """
        self._advance()
        vars: list[AST.Statement] = []
        while True:
            varname = self._expect(TokenType.IDENT).lexeme
            vartype = AST.exptype_fromname(varname)
            vars.append(AST.Variable(name=varname, etype=vartype))
            # READ can declare new variables so we need to add any new ones to the symtable
            if self.symtable.find(ident=varname, context=self.context) is None:
                self.symtable.add(
                    ident=varname,
                    info=SymEntry(symtype=SymType.Variable, exptype=vartype, locals=SymTable()),
                    context=self.context
                )
            if not self._current_is(TokenType.COMMA):
                break
            self._advance()
        return AST.Command(name="READ", args=vars)

    @astnode
    def _parse_RELEASE(self) -> AST.Command:
        """ <RELEASE> ::= RELEASE <int_expression> """
        self._advance()
        args = [self._parse_int_expression()]
        return AST.Command(name="RELEASE", args=args)

    @astnode
    def _parse_REMAIN(self) -> AST.Function:
        """ <REMAIN> ::= REMAIN(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="REMAIN", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_RENUM(self) -> AST.Command:
        """ <RENUM> ::= RENUM [<int_expression>[,<int_expression>[,<int_expression>]]] """
        self._advance()
        # This command doesn't make sense in a compiled program
        self._raise_error(21)
        return AST.Command(name="RENUM")

    @astnode
    def _parse_RESTORE(self) -> AST.Command:
        """ <RESTORE> ::= RESTORE [<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            args = [self._parse_int_expression()]
        return AST.Command(name="RESTORE", args=args)

    @astnode
    def _parse_RESUME(self) -> AST.Command:
        """ <RESUME> ::= RESUME [<int_expression> | NEXT] """
        self._advance()
        # Probably this doesn't make sense in a compiled program
        # but leave the emiter to fail if needed
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            if self._current_is(TokenType.KEYWORD, "NEXT"):
                self._advance()
                return AST.Command(name="RESUME", args=[AST.Command(name="NEXT")])
            args = [self._parse_int_expression()]
        return AST.Command(name="RESUME", args=args)

    @astnode
    def _parse_RETURN(self) -> AST.Command:
        """ <RETURN> ::= RETURN """
        self._advance()
        return AST.Command(name="RETURN")

    @astnode
    def _parse_RIGHTSS(self) -> AST.Function:
        """ <RIGHTSS> ::== RIGHT$(<str_expression>,<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_str_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="RIGHT$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_RND(self) -> AST.Function:
        """ <RND> ::= RND [(<num_expression>)] """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.LPAREN):
            self._advance()
            args = [self._parse_num_expression()]
            self._expect(TokenType.RPAREN)
        return AST.Function(name="RND", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_ROUND(self) -> AST.Function:
        """ <ROUND> ::= ROUND(<num_expression>[,<int_expression>]) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="ROUND", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_RUN(self) -> AST.Command:
        """ <RUN> ::= RUN <str_expression> """
        self._advance()
        args: list[AST.Statement] = []
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            args = [self._parse_str_expression()]  
        return AST.Command(name="RUN", args=args)

    @astnode
    def _parse_SAVE(self) -> AST.Command:
        """ <SAVE> ::= SAVE STRING[,CHAR][,<int_expression>[,<int_expression>[,<int_expression]]] """
        self._advance()
        lex = self._expect(TokenType.STRING).lexeme
        args: list[AST.Statement] = [AST.String(value=lex)]
        if not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
            self._expect(TokenType.COMMA)
            lex = self._expect(TokenType.IDENT).lexeme.upper()
            if lex not in ('A','B','P'):
                self._raise_error(5)
            args.append(AST.String(value=lex))
            while not self._current_in((TokenType.EOL, TokenType.EOF, TokenType.COLON)):
                self._expect(TokenType.COMMA)
                args.append(self._parse_int_expression())
        return AST.Command(name="SAVE", args=args)

    @astnode
    def _parse_SGN(self) -> AST.Function:
        """ <SGN> ::= SGN(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SGN", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_SIN(self) -> AST.Function:
        """ <SIN> ::= SIN(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SIN", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_SOUND(self) -> AST.Command:
        """ <SOUND> ::= SOUND <int_expression>,<int_expression>[,<int_expression>]* """
        # the extra int parameters are:
        # duration, volume, volume envelope, tone envelope, noise period 
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        for _ in range(5):
            if not self._current_is(TokenType.COMMA):
                break
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="SOUND", args=args)

    @astnode
    def _parse_SPACESS(self) -> AST.Function:
        """ <SPACESS> ::= SPACE$(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SPACE$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_SPC(self) -> AST.Function:
        """ <SPC> ::= SPC(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SPC", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_SPEED_INK(self) -> AST.Command:
        """ <SPEED_INK> ::= SPEED INK <int_expression>,<int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="SPEED INK", args=args)

    @astnode
    def _parse_SPEED_KEY(self) -> AST.Command:
        """ <SPEED_KEY> ::= SPEED KEY <int_expression>,<int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        return AST.Command(name="SPEED KEY", args=args)

    @astnode
    def _parse_SPEED_WRITE(self) -> AST.Command:
        """ <SPEED_WRITE> ::= SPEED WRITE <int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        return AST.Command(name="SPEED WRITE", args=args)

    @astnode
    def _parse_SQ(self) -> AST.Function:
        """ <SQ> ::= SQ(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SQ", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_SQR(self) -> AST.Function:
        """ <SQR> ::= SQR(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="SQR", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_STOP(self) -> AST.Command:
        """ <STOP> ::= STOP """
        self._advance()
        return AST.Command(name="STOP")

    @astnode
    def _parse_STRSS(self) -> AST.Function:
        """ <STRSS> ::= STR$(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="STR$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_STRINGSS(self) -> AST.Function:
        """ <STRINGSS> ::= STRING$(<int_expression>,(<str_expression>|<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        # char o ASCII code number
        args.append(self._parse_expression())
        if args[-1].etype not in (AST.ExpType.Integer, AST.ExpType.String):
            self._raise_error(5)
        self._expect(TokenType.RPAREN)
        return AST.Function(name="STRING$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_SYMBOL(self) -> AST.Command:
        """ <SYMBOL> ::= SYMBOL <int_expression>(,<int_expression>)* """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        for _ in range(8):
            self._expect(TokenType.COMMA)
            args.append(self._parse_int_expression())
        return AST.Command(name="SYMBOL", args=args)

    @astnode
    def _parse_SYMBOL_AFTER(self) -> AST.Command:
        """ <SYMBOL AFTER> ::= SYMBOL AFTER <int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        return AST.Command(name="SYMBOL_AFTER", args=args)

    @astnode
    def _parse_TAB(self) -> AST.Function:
        """ <TAB> ::= TAB(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="TAB", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_TAG(self) -> AST.Command:
        """ <TAG> ::= TAG [#<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
        return AST.Command(name="TAG", args=args)

    @astnode
    def _parse_TAGOFF(self) -> AST.Command:
        """ <TAGOFF> ::= TAGOFF [#<int_expression>] """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
        return AST.Command(name="TAGOFF", args=args)

    @astnode
    def _parse_TAN(self) -> AST.Function:
        """ <TAN> ::= TAN(<num_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="TAN", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_TEST(self) -> AST.Function:
        """ <TEST> ::= TEST(<int_expression>,<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="TEST", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_TESTR(self) -> AST.Function:
        """ <TESTR> ::= TESTR(<int_expression>,<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_num_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        self._expect(TokenType.RPAREN)
        return AST.Function(name="TESTR", etype=AST.ExpType.Integer, args=args)

    def _parse_THEN(self):
        """ This is always an error """
        self._advance()
        self._raise_error(2, "unexpected THEN keyword")

    @astnode
    def _parse_TIME(self) -> AST.Function:
        """ <TIME> ::= TIME """
        self._advance()
        return AST.Function(name="TIME", etype=AST.ExpType.Real)

    @astnode
    def _parse_TRON(self) -> AST.Command:
        """ <TRON> ::= TRON """
        self._advance()
        return AST.Command(name="TRON")
 
    @astnode   
    def _parse_TROFF(self) -> AST.Command:
        """ <TROFF> ::= TROFF """
        self._advance()
        return AST.Command(name="TROFF")

    @astnode
    def _parse_UNT(self) -> AST.Function:
        """ <UNT> ::= UNT(<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="UNT", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_UPPERSS(self) -> AST.Function:
        """ <UPPERSS> ::= UPPER$(<str_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_str_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="UPPER$", etype=AST.ExpType.String, args=args)

    @astnode
    def _parse_VAL(self) -> AST.Function:
        """ <VAL> ::= VAL(<str_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        args: list[AST.Statement] = [self._parse_str_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="UNT", etype=AST.ExpType.Real, args=args)

    @astnode
    def _parse_VPOS(self) -> AST.Function:
        """ <VPOS> ::= VPOS(#<int_expression>) """
        self._advance()
        self._expect(TokenType.LPAREN)
        self._expect(TokenType.HASH)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.RPAREN)
        return AST.Function(name="VPOS", etype=AST.ExpType.Integer, args=args)

    @astnode
    def _parse_WAIT(self) -> AST.Command:
        """ <WAIT> ::= WAIT <int_expression>,<int_expression>[,<int_expression>]"""
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        args.append(self._parse_int_expression())
        if self._current_is(TokenType.COMMA):
            self._advance()
            args.append(self._parse_int_expression())
        return AST.Command(name="WAIT", args=args)

    @astnode
    def _parse_WEND(self) -> AST.BlockEnd:
        """ <WEND> ::= WEND """
        self._advance()
        if len(self.codeblocks) == 0 or "WEND" not in self.codeblocks[-1].until_keywords:
            self._raise_error(30)
        self.codeblocks.pop()
        return AST.BlockEnd(name="WEND")
  
    @astnode  
    def _parse_WHILE(self) -> AST.WhileLoop:
        """ <WHILE> ::= WHILE <int_expression> """
        self._advance()
        cond = self._parse_int_expression()
        node = AST.WhileLoop(condition=cond)
        self.codeblocks.append(CodeBlock(
            type=BlockType.WHILE,
            until_keywords=("WEND",),
            start_node=node
        ))
        return node

    @astnode
    def _parse_WIDTH(self) -> AST.Command:
        """ <WIDTH> ::= WIDTH <int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        return AST.Command(name="WIDTH", args=args)

    @astnode
    def _parse_WINDOW(self) -> AST.Command:
        """ 
        <WINDOW> ::= WINDOW [#<int_expression>,]<wnd_rect>
        <wnd_rect> ::= <int_expression>,<int_expression>,<int_expression>,<int_expression>
        """
        self._advance()
        args: list[AST.Statement] = []
        if self._current_is(TokenType.HASH):
            self._advance()
            args = [self._parse_int_expression()]
            self._expect(TokenType.COMMA)
        for _ in range(4):
            self._match(TokenType.COMMA)
            args.append(self._parse_int_expression())
        return AST.Command(name="WINDOW", args=args)

    @astnode
    def _parse_WINDOW_SWAP(self) -> AST.Command:
        """ <WINDOWS_SWAP> ::= WINDOWS SWAP [#]<int_expression>,[#]<int_expression> """
        self._advance()
        self._match(TokenType.HASH)
        args: list[AST.Statement] = [self._parse_int_expression()]
        self._expect(TokenType.COMMA)
        self._match(TokenType.HASH)
        args.append(self._parse_int_expression())
        return AST.Command(name="WINDOW SWAP", args=args)
    
    @astnode
    def _parse_WRITE(self) -> AST.Write:
        """ <WRITE> ::= [#<int_expression>,]<expression>* """
        self._advance()
        stream: Optional[AST.Statement] = None
        if self._current_is(TokenType.HASH):
            self._advance()
            stream = self._parse_int_expression()
            self._expect(TokenType.COMMA)
        items: list[AST.Statement] = [self._parse_expression()]
        while self._current_is(TokenType.COMMA):
            self._advance()
            items.append(self._parse_expression())
        return AST.Write(stream=stream, items=items)

    @astnode
    def _parse_XPOS(self) -> AST.Function:
        """ <XPOS> ::= XPOS """
        self._advance()
        return AST.Function(name="XPOS", etype=AST.ExpType.Integer)
    
    @astnode
    def _parse_YPOS(self) -> AST.Function:
        """ <YPOS> ::= YPOS """
        self._advance()
        return AST.Function(name="YPOS", etype=AST.ExpType.Integer)

    @astnode
    def _parse_ZONE(self) -> AST.Command:
        """ <ZONE> ::= ZONE <int_expression> """
        self._advance()
        args: list[AST.Statement] = [self._parse_int_expression()]
        return AST.Command(name="ZONE", args=args)

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

    def _parse_int_expression(self) -> AST.Statement:
        """ <int_expression> ::= <expression>.type=INT """
        stat = self._parse_logic_xor()
        if not AST.exptype_isint(stat.etype):
            self._raise_error(13)
        return stat

    def _parse_num_expression(self) -> AST.Statement:
        """ <int_expression> ::= <expression>.type=(INT|REAL) """
        stat = self._parse_logic_xor()
        if not AST.exptype_isnum(stat.etype):
            self._raise_error(13)
        return stat

    def _parse_str_expression(self) -> AST.Statement:
        """ <int_expression> ::= <expression>.type=STRING """
        stat = self._parse_logic_xor()
        if not AST.exptype_isstr(stat.etype):
            self._raise_error(13)
        return stat

    def _parse_expression(self) -> AST.Statement:
        """ <expression> ::= <logic_or> """
        return self._parse_logic_xor()

    @astnode
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

    @astnode
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

    @astnode
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

    @astnode
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
            opname = op.lexeme.replace('=>','>=').replace('=<','<=') # one operation one symbol
            node = AST.BinaryOp(op=opname, left=node, right=right, etype=AST.ExpType.Integer)
        return node

    @astnode
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

    @astnode
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

    @astnode
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

    @astnode
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

    @astnode
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
        self._raise_error(2, f"unexpected symbol {tok.lexeme}")
        return AST.Nop()
    
    @astnode
    def _parse_primary_ident(self) -> AST.Statement:
        """ <primary_ident> ::= IDENT | IDENT(<int_expression>[,<int_expression>]) | <user_fun> """
        if self._current().lexeme[:2].upper() == "FN":
            # this is a user function defined by DEF FN as FN are reserved
            # and cannot be used in Locomotive Basic as the starting chars
            # for variables
            return self._parse_user_fun()
        # This is the first pass and some variables can be defined later
        # in the code so we cannot fail if an undefined variable arrives here
        # emiter will do
        tk = self._expect(TokenType.IDENT)
        etype = AST.exptype_fromname(tk.lexeme)
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
            return AST.ArrayItem(name=tk.lexeme, etype=etype, args=indexes) # type: ignore[union-attr]
        # regular variable
        return AST.Variable(name=tk.lexeme, etype=etype)

    @astnode
    def _parse_user_fun(self) -> AST.Statement:
        """ <user_fun> ::= FNIDENT([<expression>[,<expression>]])"""
        tk = self._expect(TokenType.IDENT)
        # functions are always declared in the global context
        entry = self.symtable.find(ident=tk.lexeme, context="")
        if entry is None:
            self._raise_error(18, col=tk.col)
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

    @astnode
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
            # It only allows single words without spaces
            # which is different from what is supported in Locomotive Basic
            name = self._advance().lexeme
            return AST.String(value=name)
        self._raise_error(2)
        return AST.Nop()

    @astnode
    def _parse_pointer(self) -> AST.Pointer:
        """ <pointer> ::= @IDENT """
        self._advance()
        tk = self._expect(TokenType.IDENT)
        vartype = AST.exptype_fromname(tk.lexeme)
        var = AST.Variable(name=tk.lexeme, etype=vartype)
        return AST.Pointer(var=var)

    @astnode
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
    
    @astnode
    def _parse_assignment(self) -> AST.Assignment:
        """ <assignment> ::= <primary_ident> = <expression>"""
        # The asignement is the way to declare variables so
        # we do not check in the sym table for left variable
        target = self._parse_primary_ident()
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

    def _parse_keyword(self) -> AST.Statement:
        """ <keyword> ::= <FUNCTION> | <COMMAND> """
        keyword = self._current().lexeme
        funcname = "_parse_" + keyword.replace('$','SS').replace(' ', '_')
        parse_keyword = getattr(self, funcname , None)
        if parse_keyword is None:
            self._raise_error(2, f", unknown keyword {keyword}")
        return parse_keyword() # type: ignore[misc]

    @astnode
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
            # it's possible to end a line with just : and EOL
            if self._current_is(TokenType.EOL):
                break
            stmts.append(self._parse_statement())
        return stmts

    @astnode
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
        print("Checking syntax...")
        lines = []
        while not self._current_is(TokenType.EOF):
            if self._current_is(TokenType.EOL):
                self._advance()
                continue
            lines.append(self._parse_line())
        if len(self.codeblocks) > 0:
            if "NEXT" in self.codeblocks[-1].until_keywords:
                self._raise_error(26)
            elif "WEND" in self.codeblocks[-1].until_keywords:
                self._raise_error(29)
            elif "IFEND" in self.codeblocks[-1].until_keywords:
                self._raise_error(35)
            else:
                self._raise_error(24)
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
