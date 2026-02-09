r"""
Lexycal scanner for Amstrad locomotive BASIC code.

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

from lexer import LocBasLexer

program = '''
10 REM Demo
20 a%=3: b!=&H2A: c$="HELLO"
30 IF a%<=10 THEN PRINT b! \ 2, c$
40 ' the other way to comment a line
50 PRINT "END"
60 END
'''

lx = LocBasLexer(program)
for t in lx.tokens():
    print(f"{t.line:02d}:{t.col:02d}  {t.type.name:10s}  {t.lexeme!r}  {t.value}")

"""

from __future__ import annotations
from dataclasses import dataclass, is_dataclass
from enum import Enum, auto
from typing import Union, Any, Optional, Tuple, Iterator
import re
import json

# -------------------------------
# Token types
# -------------------------------

class TokenType(Enum):
    LINE_NUMBER = auto()
    EOL = auto()
    EOF = auto()
    COLON = auto()          # :
    COMMA = auto()          # ,
    SEMICOLON = auto()      # ;
    LPAREN = auto()         # (
    RPAREN = auto()         # )
    LBRACK = auto()         # [
    RBRACK = auto()         # ]
    HASH = auto()           # #  (streams)
    AT = auto()             # @  (pointers)

    IDENT = auto()          # user defined names (variables, FN*, etc.)
    RSX = auto()            # |COMMAND
    INT = auto()            # numeric literals (decimal, &H/&hex, &Xbin)
    REAL= auto()            # numeric literals (float)
    STRING = auto()         # "..."
    KEYWORD = auto()        # reserved words (PRINT, IF, THEN, ELSE, etc.)
    OP = auto()             # operators (+ - * / ^ \ AND OR XOR NOT MOD etc.)
    COMP = auto()           # logic comparations (=, <, >, <=, =>, <>, etc.)
    COMMENT = auto()        # REM ...  or  ' ...

@dataclass
class Token:
    type: TokenType
    lexeme: str
    line: int
    col: int
    value: Optional[int | float | str] = None
    text: str = "" # how lexeme really appeared in the text (original case)

class TokenEncoder(json.JSONEncoder):
    def default(self, o: Any) -> Any:
        if is_dataclass(o):
            return {
                "type": str(o.type).split('.')[1],
                "lexeme": o.lexeme,
                "line": o.line,
                "col": o.col,
                "value": o.value,
                "text": o.text
            }
        return super().default(o)

# -------------------------------
# Reserved words and operators
# -------------------------------

# List of Locomotive BASIC reserved words (commands and functions)
_KEYWORDS = {
    # Commands
    "AFTER","ASM", "AUTO","BORDER","CALL","CASE","CASE DEFAULT","CAT","CHAIN",
    "CHAIN MERGE","CLEAR","CLEAR INPUT","CLG","CLOSEIN","CLOSEOUT","CLS","CONST",
    "CONT","COPYCHR$","CURSOR","DATA","DECLARE","DEF","DEF FN","DEFAULT", "DEFINT",
    "DEFREAL","DEFSTR","DEG","DELETE","DERR","DI","DIM","DRAW","DRAWR","EDIT","EI",
    "ELSE","END","END IF","END SUB","END FUNCTION","END SELECT","ENT","ENV","ERASE",
    "ERL","ERROR","EVERY","EXIT","EXIT FOR","EXIT WHILE","FILL","FIXED","FN","FOR",
    "FRAME","FUNCTION","GOSUB","GOTO","GRAPHICS","GRAPHICS PAPER","GRAPHICS PEN","IF",
    "INK","INPUT","KEY","KEY DEF","LABEL","LET","LINE","LINE INPUT","LIST","LOAD",
    "LOCATE","MASK","MEMORY","MERGE","MID$","MODE","MOVE","MOVER","NEW","NEXT","ON",
    "ON BREAK","ON ERROR GOTO","ON SQ","OPENIN","OPENOUT","ORIGIN","OUT","PAPER",
    "PEN","PLOT","PLOTR","POKE","PRINT","RAD","RANDOMIZE","READ","RECORD","RELEASE",
    "REM","RENUM","RESTORE","RESUME","RETURN","RUN","SAVE","SELECT", "SELECT CASE",
    "SOUND","SPC","SPEED","SPEED KEY","SPEED INK","SPEED WRITE","STEP","STOP","SHARED",
    "SUB","SWAP","SYMBOL","SYMBOL AFTER","TAB","TAG","TAGOFF","TO","TROFF","TRON","THEN",
    "USING","WAIT","WEND","WHILE","WIDTH","WINDOW","WINDOW SWAP","WRITE","ZONE",
    # Functions
    "ABS","ASC","ATN","BIN$","CHR$","CINT","COS","CREAL","DEC$","EOF","ERR",
    "EXP","FIX","FRE","HEX$","HIMEM","INKEY","INKEY$","INP","INT","INSTR",
    "JOY","LEFT$","LEN","LOG","LOG10","LOWER$","MAX","MIN","PEEK","PI","POS",
    "REMAIN","RIGHT$","RND","ROUND","SGN","SIN","SPACE$","SQ","SQR","STR$",
    "STRING$","TAN","TEST","TESTR","TIME","UNT","UPPER$","VAL","VPOS","XPOS","YPOS"
}

# Operators and comparators that will share the type TokenType.OP
_OPERATORS = {
    "AND","OR","XOR","NOT","MOD"
}

# Logic comparators
_COMPARATORS = {
    "=","<",">","<>","<=","=<",">=","=>"
}

_SINGLE_CHARS = {
    ":": TokenType.COLON, ",": TokenType.COMMA, ";": TokenType.SEMICOLON,
    "(": TokenType.LPAREN, ")": TokenType.RPAREN, "[": TokenType.LBRACK,
    "]": TokenType.RBRACK, "#": TokenType.HASH, "@": TokenType.AT
}

# -------------------------------
# Lexer
# -------------------------------

class LocBasLexer:
    def __init__(self, text: str, enforce_varlen: bool = True) -> None:
        # Windows/Amstrad line end to \n
        self.text = text.replace("\r\n", "\n").replace("\r", "\n")
        self.pos = 0
        self.line = 1
        self.col = 1
        self.enforce_varlen = enforce_varlen

    def _peek(self, n=0) -> str:
        nextch = self.pos + n
        return self.text[nextch] if nextch < len(self.text) else ""

    def _next_ch(self) -> str:
        if self.pos + 1 < len(self.text):
            return self.text[self.pos + 1]
        return ''

    def _advance(self) -> str:
        ch = self._peek()
        if not ch:
            return ""
        self.pos += 1
        if ch == "\n":
            self.line += 1
            self.col = 1
        else:
            self.col += 1
        return ch

    def _match(self, s: str) -> bool:
        if self.text.startswith(s, self.pos):
            for _ in s:
                self._advance()
            return True
        return False

    def _match_nocase(self, s: str) -> bool:
        text = self.text[self.pos:self.pos + len(s)].upper()
        if text == s:
            for _ in s:
                self._advance()
            return True
        return False

    def _skip_spaces(self) -> None:
        while self._peek() in (" ", "\t"):
            self._advance()

    def _consume_until_eol(self) -> str:
        out = ""
        while self._peek() and self._peek() != "\n":
            out += self._advance()
        return out

    def _consume_rsx(self) -> str:
        # |NAME search for EOL, ':' or arguments
        out = self._advance()  # '|' symbol
        while True:
            ch = self._peek()
            if ch == "" or ch == "\n":
                break
            if ch in " ,:":
                break
            out += self._advance()
        return out.upper()

    def _consume_string(self) -> str:
        out = self._advance()  # " symbol
        while True:
            ch = self._peek()
            if ch == "":
                # string without end-quotes
                # lets return what we have and leave the
                # parser to provide an error
                break
            c = self._advance()
            # Some letters have different code in Amstrad as it uses a non-standar
            # charset
            if c == "Ñ": c = chr(161)
            elif c == "ñ": c = chr(171)
            elif c == "¿": c = chr(174)
            elif c == "¡": c = chr(175)
            out += c
            if c == '"':
                break
        return out

    def _consume_digits(self, base_re: re.Pattern) -> str:
        out = ""
        while True:
            ch = self._peek()
            if ch and base_re.match(ch):
                out += self._advance()
            else:
                break
        return out

    def _consume_integer(self) -> str:
        return self._consume_digits(re.compile(r"[0-9]"))

    def _consume_identifier_with_suffix(self) -> str:
        out = ""
        while True:
            ch = self._peek()
            if not ch:
                break
            # Locomotive BASIC in the CPC allows '.' as part
            # of identifier names
            # 10 a.b=5
            # above line is valid.
            # Also, locomotive BASIC 2 plus uses . to apply records to
            # string identifiers so A$.person.name$ is valid too.
            if ch.isalnum() or ch == '.' or (ch == '$' and self._next_ch() == '.'):
                out += self._advance()
            else:
                break
        # Optional sufixes
        if self._peek() in "%!$":
            out += self._advance()
        return out

    def _consume_cmp_sequence(self) -> str:
        # =, <, >, <>, <=, =<, >=, =>, etc.
        out = self._advance()
        # Amstrad CPC parser allows spaces in between operators like '>  ='
        # which will be converted to >=
        self._skip_spaces()
        if out == '<' and self._peek() in "=>":
            out += self._advance()
        elif out == '>' and self._peek() in "=":
            out += self._advance()
        elif out == '=' and self._peek() in "><":
            out += self._advance()
        return out

    def _try_number(self) -> Optional[Tuple[str, Union[int | float | str], "TokenType"]]:
        start_i = self.pos
        ch = self._peek()
        # Check for Hex/Bin with &-prefix (&Hxxxx or &xxxx for hex, &Xbbbb for bin)
        if ch == "&":
            self._advance()
            nxt = self._peek().upper()
            if nxt == "H" or nxt=="h":
                self._advance()
                digits = self._consume_digits(re.compile(r"[0-9A-Fa-f]"))
                if digits:
                    lex = "&H" + digits.upper()
                    return lex, int(digits, 16), TokenType.INT
            elif nxt == "X" or nxt == "x":
                self._advance()
                digits = self._consume_digits(re.compile(r"[01]"))
                if digits:
                    lex = "&X" + digits
                    return lex, int(digits, 2), TokenType.INT
            else:
                # direct hex number after symbol &
                digits = self._consume_digits(re.compile(r"[0-9A-Fa-f]"))
                if digits:
                    lex = "&H" + digits.upper()
                    return lex, int(digits, 16), TokenType.INT
            # Not a &-formated number
            self.pos = start_i
            return None

        # Decimal / real:  [digits][.digits][E[+-]?digits]?
        num_re = re.compile(r"""
            (?:
                (?:\d+\.\d*|\.\d+|\d+)
                (?:[Ee][\+\-]?\d+)?   # exponente opcional
            )
        """, re.VERBOSE)
        m = num_re.match(self.text[start_i:])
        if m:
            lex = m.group(0)
            # float or int depending on '.' or 'E/e' symbols
            if ('.' in lex or 'E' in lex.upper()):
                val = float(lex)
                ttype = TokenType.REAL
            else:
                val = int(lex, 10)
                ttype = TokenType.INT
            # consume all read digits
            for _ in lex:
                self._advance()
            return lex, val, ttype
        return None

    def _try_word(self, word: str) -> bool:
        pos = self.pos
        # espaces
        self._skip_spaces()
        if self.text.startswith(word, self.pos):
            for _ in word:
                self._advance()
            return True
        # no: restaurar
        self.pos = pos
        return False

    def _try_compound_keyword(self, head_upper: str) -> Tuple[str, bool]:
        """
        checks for multi-word reserved words like
        ON ERROR GOTO, SYMBOL AFTER, LINE INPUT, etc.
        """
        save_i, save_line, save_col = self.pos, self.line, self.col
        compound = {
            "CASE": ["DEFAULT"],
            "CHAIN": ["MERGE"],
            "CLEAR": ["INPUT"],
            "DEF": ["FN"],
            "END": ["IF", "SUB", "FUNCTION", "SELECT"],
            "EXIT": ["FOR", "WHILE"],
            "GRAPHICS": ["PAPER", "PEN"],
            "KEY": ["DEF"],
            "LINE": ["INPUT"],
            "ON": ["BREAK", "ERROR GOTO", "SQ"],
            "SELECT": ["CASE"],
            "SPEED": ["KEY", "INK", "WRITE"],
            "SYMBOL": ["AFTER"],
            "WINDOW": ["SWAP"],
        }
        if head_upper in compound:
            for tail in compound[head_upper]:
                pos_before = (self.pos, self.line, self.col)
                # At least there is a space before the tail word
                if self._peek() != " ":
                    continue
                self._skip_spaces()
                if self._match_nocase(tail):
                    lex = head_upper + " " + tail
                    return lex, True
                # restore before test another tail
                self.pos, self.line, self.col = pos_before

        # not a compounded word
        self.pos, self.line, self.col = save_i, save_line, save_col
        return head_upper, False

    def _next_token(self) -> Token:
        self._skip_spaces()
        start_line, start_col = self.line, self.col
        ch = self._peek()

        if ch == "":
            return Token(TokenType.EOF, "", self.line, self.col)

        if ch == "\n":
            self._advance()
            return Token(TokenType.EOL, "\\n", start_line, start_col, text="\\n")

        if ch in _SINGLE_CHARS:
            self._advance()
            t = _SINGLE_CHARS[ch]
            return Token(t, ch, start_line, start_col, text=ch)

        if ch == "'":
            comment = self._consume_until_eol()
            return Token(TokenType.COMMENT, comment[1:], start_line, start_col, text=comment)

        if ch == "|":
            rsx = self._consume_rsx()
            return Token(TokenType.RSX, rsx, start_line, start_col, rsx[1:], text=rsx)

        if ch == '"':
            s = self._consume_string()
            return Token(TokenType.STRING, s, start_line, start_col, s.replace('"',''), text=s)

        # Starting line number
        if start_col == 1 and ch.isdigit():
            num = self._consume_integer()
            try:
                val = int(num, 10)
            except ValueError:
                val = None
            return Token(TokenType.LINE_NUMBER, num, start_line, start_col, val, text=num)

        # Numbers including &H / & / &X and reals, even reals starting by .
        # like .5
        if ch.isdigit() or ch in "&." or ch == '-':
            numtok = self._try_number() # (lex, val, type)
            if numtok:
                return Token(numtok[2], numtok[0], start_line, start_col, numtok[1], text=numtok[0])

        # Identifiers / reserved words including FN... and sufixes %,!,$
        # record access can start witg '.' if we are parsing an Array Item
        if ch.isalpha() or ch == '.':
            ident = self._consume_identifier_with_suffix()
            uident = ident.upper()
            # compounded reserved words (e.g. "ON ERROR GOTO")
            extended, advanced = self._try_compound_keyword(uident)
            if advanced:
                ident = extended
                uident = extended.upper()

            if uident in _OPERATORS:
                return Token(TokenType.OP, uident, start_line, start_col, text=ident)

            if uident == "REM":
                rest = self._consume_until_eol()
                return Token(TokenType.COMMENT, rest, start_line, start_col, text=rest)

            if uident in _KEYWORDS:
                return Token(TokenType.KEYWORD, uident, start_line, start_col, text=ident)

            # User Identifier (variable, FN..., etc.)
            if self.enforce_varlen and len(ident.rstrip("%!$&")) > 40:
                ident = ident[:40]
            return Token(TokenType.IDENT, ident, start_line, start_col, ident.upper(), text=ident)

        # Pure one-character arithmetic operators
        if ch in "+-*/^\\":
            self._advance()
            return Token(TokenType.OP, ch, start_line, start_col, text=ch)

        # Comparative operators < y >
        if ch in "=<>":
            # =, <=, =<, >=, =>, <>...
            lex = self._consume_cmp_sequence()
            return Token(TokenType.COMP, lex, start_line, start_col, text=lex)

        # Uknown character, lets add it as a one-char ident
        self._advance()
        return Token(TokenType.IDENT, ch, start_line, start_col, text=ch)

    def tokens(self) -> Iterator[Token]:
        while True:
            tok = self._next_token()
            yield tok
            if tok.type == TokenType.EOF:
                break

    def tokens_json(self) -> tuple[str, list[Token]]:
        print("Parsing source files...")
        tokens = list(self.tokens())
        return json.dumps(tokens, indent=4, cls=TokenEncoder), tokens

