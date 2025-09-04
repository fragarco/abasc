"""
From project source directory:

python3 -m unittest test/test_lexer.py
"""

import unittest
from baslex import TokenType, Token, LocBasLexer

class TestLexer(unittest.TestCase):

    def _lexemes(self, code):
        """ Returns a list of tuples (type, lexeme, value) without EOL or EOF."""
        lx = LocBasLexer(code)
        return [(t.type, t.lexeme, t.value) for t in lx.tokens()
                if t.type not in (TokenType.EOL, TokenType.EOF)]

    def test_line_numbers_and_keywords(self):
        code = "10 PRINT \"HELLO\""
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "10", 10), toks[0])
        self.assertEqual((TokenType.KEYWORD, "PRINT", None), toks[1])
        self.assertEqual((TokenType.STRING, "\"HELLO\"", "HELLO"), toks[2])

    def test_variables_with_type_suffixes(self):
        code = "LET a% = 1: b! = 2.5: c$ = \"text\""
        toks = self._lexemes(code)
        self.assertEqual((TokenType.KEYWORD, "LET", None), toks[0])
        self.assertEqual((TokenType.IDENT, "a%", "A%"), toks[1])
        self.assertEqual((TokenType.COMP, "=", None), toks[2])
        self.assertEqual((TokenType.INT, "1", 1), toks[3])
        self.assertEqual((TokenType.COLON, ":", None), toks[4])
        self.assertEqual((TokenType.IDENT, "b!", "B!"), toks[5])
        self.assertEqual((TokenType.COMP, "=", None), toks[6])
        self.assertEqual((TokenType.REAL, "2.5", 2.5), toks[7])
        self.assertEqual((TokenType.COLON, ":", None), toks[8])
        self.assertEqual((TokenType.IDENT, "c$", "C$"), toks[9])
        self.assertEqual((TokenType.COMP, "=", None), toks[10])
        self.assertEqual((TokenType.STRING, "\"text\"", "text"), toks[11])

    def test_operators_and_comparators(self):
        code = "IF A<=10 THEN B=B+1"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.KEYWORD, "IF", None), toks[0])
        self.assertEqual((TokenType.IDENT, "A", "A"), toks[1])
        self.assertEqual((TokenType.COMP, "<=", None), toks[2])
        self.assertEqual((TokenType.INT, "10", 10), toks[3])
        self.assertEqual((TokenType.KEYWORD, "THEN", None), toks[4])
        self.assertEqual((TokenType.IDENT, "B", "B"), toks[5])
        self.assertEqual((TokenType.COMP, "=", None), toks[6])
        self.assertEqual((TokenType.IDENT, "B", "B"), toks[7])
        self.assertEqual((TokenType.OP, "+", None), toks[8])
        self.assertEqual((TokenType.INT, "1", 1), toks[9])

    def test_hex_and_binary_numbers(self):
        code = "&2A &X1010 &H2A"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.INT, "&H2A", 42), toks[0])
        self.assertEqual((TokenType.INT, "&X1010", 10), toks[1])
        self.assertEqual((TokenType.INT, "&H2A", 42), toks[2])

    def test_reals(self):
        code = "10 1.23 4E2 .5"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "10", 10), toks[0])
        self.assertEqual((TokenType.REAL, "1.23", 1.23), toks[1])
        self.assertEqual((TokenType.REAL, "4E2", 400), toks[2])
        self.assertEqual((TokenType.REAL, ".5", 0.5), toks[3])

    def test_comments(self):
        code = "10 REM this is a comment\n20 ' another comment"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "10", 10), toks[0])
        self.assertEqual((TokenType.COMMENT, " this is a comment", None), toks[1])
        self.assertEqual((TokenType.LINE_NUMBER, "20", 20), toks[2])
        self.assertEqual((TokenType.COMMENT, " another comment", None), toks[3])

    def test_rsx_command(self):
        code = "15 |dir,\"*.BAS\""
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "15", 15), toks[0])
        self.assertEqual((TokenType.RSX, "|DIR", "DIR"), toks[1])
        self.assertEqual((TokenType.COMMA, ",", None), toks[2])
        self.assertEqual((TokenType.STRING, "\"*.BAS\"", "*.BAS"), toks[3])

    def test_multiple_statements(self):
        code = "30 A=1:PRINT A"
        toks = self._lexemes(code)
        self.assertEqual(len(toks), 7)
        self.assertEqual((TokenType.COLON, ":", None), toks[4])

    def test_identifier_length_limit(self):
        code = "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ = 5"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.IDENT, "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ", "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ"), toks[0])
        self.assertEqual(len(toks[0][1]), 40)

    def test_compound_keyword_on_error_goto(self):
        code = "100 ON ERROR GOTO 300"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "100", 100), toks[0])
        self.assertEqual((TokenType.KEYWORD, "ON ERROR GOTO", None), toks[1])
        self.assertEqual((TokenType.INT, "300", 300), toks[2])

    def test_compound_keyword_symbol_after(self):
        code = "500 SYMBOL   AFTER 240"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "500", 500), toks[0])
        self.assertEqual((TokenType.KEYWORD, "SYMBOL AFTER", None), toks[1])
        self.assertEqual((TokenType.INT, "240", 240), toks[2])

    def test_compound_keyword_line_input(self):
        code = "9999 LINE INPUT #1,A$"
        toks = self._lexemes(code)
        self.assertEqual((TokenType.LINE_NUMBER, "9999", 9999), toks[0])
        self.assertEqual((TokenType.KEYWORD, "LINE INPUT", None), toks[1])
        self.assertEqual((TokenType.HASH, '#', None), toks[2])
        self.assertEqual((TokenType.INT, '1', 1), toks[3])
        self.assertEqual((TokenType.COMMA, ',', None), toks[4])
        self.assertEqual((TokenType.IDENT, 'A$', "A$"), toks[5])

if __name__ == "__main__":
    unittest.main()
