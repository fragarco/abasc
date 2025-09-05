"""
From project source directory:

python3 -m unittest test/test_parser.py
"""

import unittest
from baserror import BasError
from basparse import LocBasParser
from baslex import LocBasLexer
from baspp import CodeLine
import astlib as AST

class TestParser(unittest.TestCase):

    def parse_code(self, code: str):
        # let's add an extra EOL at the end so one single lines work
        code = code + '\n'
        lx = LocBasLexer(code)
        tokens = list(lx.tokens())
        codelines = [CodeLine("TEST.BAS", i, c) for i,c in enumerate(code.split('\n'))]
        return LocBasParser(codelines, tokens, warning_level=0).parse_program()

    def test_no_case(self):
        code ="""
10 cls
20 for i=1 TO 2
30 Print i
40 NEXT I
"""
        ast, _ = self.parse_code(code)
        # CLS + FOR block
        self.assertEqual(len(ast.lines), 2)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Command)
        self.assertEqual(ast.lines[0].statements[0].name, "CLS")
        self.assertIsInstance(ast.lines[1].statements[0], AST.ForLoop)
        self.assertIsInstance(ast.lines[1].statements[0].body[0], AST.Print)
        
    def test_multiple_statements_same_line(self):
        code = "10 LET X=5 : LET Y=10 : PRINT X,Y"
        ast, _ = self.parse_code(code)
        line = ast.lines[0]
        self.assertEqual(len(line.statements), 3)
        self.assertIsInstance(line.statements[0], AST.Assignment)
        self.assertIsInstance(line.statements[1], AST.Assignment)
        self.assertIsInstance(line.statements[2], AST.Print)

    def test_multiple_statements_with_comments(self):
        code = "10 LET A=1 : REM THIS IS A COMMENT : PRINT A"
        ast, _ = self.parse_code(code)
        line = ast.lines[0]
        # The final PRINT A should be considerer part of the comment
        self.assertEqual(len(line.statements), 2)
        self.assertIsInstance(line.statements[1], AST.Comment)

    def test_expression_basic(self):
        code = "10 R = 11 MOD 2"
        ast, _ = self.parse_code(code)
        node = ast.lines[0].statements[0]
        self.assertIsInstance(node, AST.Assignment)
        self.assertEqual(node.target.name, "R")
        self.assertIsInstance(node.source, AST.BinaryOp)
        self.assertEqual(node.source.op, "MOD")

    def test_unexpected_token(self):
        code = "10 X = "
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_invalid_statement(self):
        code = "10 UNKNOWNCMD"
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_invalid_expression(self):
        code = "10 X = (5 + )"
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_valid_expression_types(self):
        code = """10 X = 0
20 E = (X + 5) / 2.2
30 E$ = "STRING1" + "STRING2"
40 E! = (1 MOD 2.2) * 2
50 E% = 5.2 \\ 2.2
60 E = "STRING1" >= "STRING"
70 E = (1 AND 1.2) OR 1.5        
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].source.etype, AST.ExpType.Real)
        self.assertEqual(ast.lines[2].statements[0].source.etype, AST.ExpType.String)
        self.assertEqual(ast.lines[3].statements[0].source.etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[4].statements[0].source.etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[5].statements[0].source.etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[6].statements[0].source.etype, AST.ExpType.Integer)

    def test_expression_type_mismatch(self):
        codes = [
            '10 E = (X + 5) / "S"',
            '20 E = "STRING1" - "STRING2"',
            '30 E = (1 MOD 2.2) * "A"',
            '40 E = "B" \\ 2',
            '50 E = "STRING1" >= 6',
            '60 E = (1 AND "C") OR 1.5'
        ]        
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_symtable_access(self):
        code = """
10 CLS
20 DIM I(2)
30 FOR J=0 TO 2
40   I(J) = J
50 NEXT
60 F = 0
70 F = F + 1
80 DEF FNadd(X) = X+I(0)
90 PRINT FNadd(F)
"""
        ast, symt = self.parse_code(code)
        # 40 and 50 get inside the ForLoop block
        self.assertEqual(len(ast.lines), 7)
        # X is a local variable inside FNADD context
        # so 4 symbols + 7 labels (line numbers)
        self.assertEqual(len(symt.syms), 4+7)

    def test_for_inline(self):
        codes = [
            "10 FOR I=1 TO 5: PRINT I: NEXT: END",
            "10 FOR I%=1 TO 5: PRINT I%: NEXT: END",
            "10 FOR I=1 TO 5: PRINT I: NEXT I: END",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT: NEXT: END",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT J: NEXT I: END"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            self.assertEqual(len(ast.lines[0].statements), 2)
            self.assertEqual(ast.lines[0].statements[0].id, "ForLoop")
            self.assertEqual(ast.lines[0].statements[1].name, "END")

    def test_for_inline_error(self):
        codes = [
            "10 FOR I=1 TO 5: PRINT I: END",
            "10 FOR I$=1 TO 5: PRINT I: NEXT: END",
            "10 FOR I!=1 TO 5: PRINT I: NEXT: END",
            "10 FOR I%=1 TO 5: PRINT I: NEXT I: END",
            "10 FOR I$=1 TO 5: PRINT I$: NEXT: END",
            "10 FOR I=1 TO 5: PRINT I: NEXT J: END",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT: END",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT I: NEXT J: END"
        ]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)
            
    def test_for_nested_loops(self):
        code = """10 FOR I=1 TO 2
20 FOR J=1 TO 2
30 PRINT I,J
40 NEXT J
50 NEXT I
"""
        ast, _ = self.parse_code(code)
        outer_for = ast.lines[0].statements[0]
        self.assertIsInstance(outer_for, AST.ForLoop)
        self.assertIsInstance(outer_for.body[0], AST.ForLoop)
        inner_for = outer_for.body[0]
        self.assertIsInstance(inner_for.body[0], AST.Print)

    def test_for_mixed_fails(self):
        codes = [
            "10 FOR I=1 TO 2: PRINT I\n20 NEXT",
            "10 FOR I=1 TO 2\n20 PRINT I: NEXT: PRINT I",
            "10 FOR I=1 TO 2\n20 PRINT I: NEXT: FOR J=1 TO 5: NEXT"
        ]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)


    def test_while_inline(self):
        codes = [
            '10 I=10: WHILE I>0: I=I-1: PRINT I: WEND: END',
            '10 I$="HELLOX": WHILE I$>"HELLO": PRINT I$: WEND: END',
            '10 I=10: WHILE I>0: I=I-1: J=10: WHILE J>0: J=J-1: WEND: WEND: END',
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            self.assertEqual(len(ast.lines[0].statements), 3)
            self.assertEqual(ast.lines[0].statements[0].id, "Assignment")
            self.assertEqual(ast.lines[0].statements[1].id, "WhileLoop")
            self.assertEqual(ast.lines[0].statements[2].name, "END")

    def test_while_nested_loops(self):
        code = """10 I=10
20 WHILE I>0
30 PRINT I: I=I-1
40 J=10
50 WHILE J>0
60 J=J-1
70 WEND
80 WEND
"""
        ast, _ = self.parse_code(code)
        outer_while = ast.lines[1].statements[0]
        self.assertIsInstance(outer_while, AST.WhileLoop)
        self.assertIsInstance(outer_while.body[3], AST.WhileLoop)
        inner_while = outer_while.body[3]
        self.assertIsInstance(inner_while.body[0], AST.Assignment)

    def test_while_mixed_fails(self):
        codes = [
            '10 I$="HELLO": WHILE I$>0: PRINT I$: WEND',
            "10 I=10: WHILE I>0: PRINT I\n20 I=I-1: WEND",
            "10 I=10: WHILE I>0\n 20 PRINT I\n30 I=I-1: WEND: END",
            "10 I=10: WHILE I>0\n 20 PRINT I: WEND: WHILE I>0: WEND",
        ]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_if_else_basic(self):
        codes = [
            "10 I=5: IF I=10 THEN 10 ELSE 10",
            "10 I=10: IF I=10 THEN GOTO 10 ELSE GOTO 10"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            ifnode = ast.lines[0].statements[1]
            self.assertIsInstance(ifnode, AST.If)
            # GOTO + ELSE
            self.assertEqual(len(ifnode.then_block), 2)
            self.assertEqual(ifnode.then_block[0].args[0].value, 10)
            # GOTO + IFEND
            self.assertEqual(len(ifnode.else_block), 2)
            self.assertEqual(ifnode.else_block[0].args[0].value, 10)

    def test_if_then_basic(self):
        codes = [
            "10 I=0: IF I=10 THEN 10",
            "10 I=10: IF I=10 THEN GOTO 10"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            ifnode = ast.lines[0].statements[1]
            self.assertIsInstance(ifnode, AST.If)
            # GOTO + IFEND
            self.assertEqual(len(ifnode.then_block), 2)
            self.assertEqual(ifnode.then_block[0].args[0].value, 10)
            self.assertIsInstance(ifnode.then_block[1], AST.BlockEnd)

    def test_if_else_inline(self):
        code = """10 I=0: IF I=10 THEN PRINT "A": J=1 ELSE PRINT "B": J=0"""
        ast, _ = self.parse_code(code)
        ifnode = ast.lines[0].statements[1]
        self.assertIsInstance(ifnode, AST.If)
        # PRINT + J + ELSE
        self.assertEqual(len(ifnode.then_block), 3)
        # PRINT + J + IFEND
        self.assertEqual(len(ifnode.else_block), 3)

    def test_if_else_block(self):
        code = """10 X=0 
20IF X=1 THEN
30 PRINT "YES": J=1
40 ELSE
50 PRINT "NO": J=1
60 IFEND"""
        ast, _ = self.parse_code(code)
        stmt = ast.lines[1].statements[0]
        self.assertIsInstance(stmt, AST.If)
        # PRINT + Assignement + ELSE
        self.assertEqual(len(stmt.then_block), 3)
        # PRINT + Assignement + IFEND
        self.assertEqual(len(stmt.else_block), 3)

    def test_if_then_inline_else_block(self):
        code = """10 X=0: IF X=1 THEN PRINT "YES": J=1 ELSE
30 PRINT "NO": J=1
40 IFEND"""
        ast, _ = self.parse_code(code)
        stmt = ast.lines[0].statements[1]
        self.assertIsInstance(stmt, AST.If)
        # PRINT + Assignement + ELSE
        self.assertEqual(len(stmt.then_block), 3)
        # PRINT + Assignement + IFEND
        self.assertEqual(len(stmt.else_block), 3)

    def test_if_then_block_else_inline(self):
        code = """10 x=0: IF X=1 THEN
20 PRINT "YES"
30 J=1
40 ELSE PRINT "NO": J=1
"""
        ast, _ = self.parse_code(code)
        stmt = ast.lines[0].statements[1]
        self.assertIsInstance(stmt, AST.If)
        # PRINT + Assignement + ELSE
        self.assertEqual(len(stmt.then_block), 3)
        # PRINT + Assignement + IFEND
        self.assertEqual(len(stmt.else_block), 3)

    def test_if_else_while_nested(self):
        code = "10 I=10: IF I=10 THEN WHILE I>0: I=I-1: PRINT I: WEND ELSE J=I MOD 2: PRINT I"
        ast, _ = self.parse_code(code)
        ifnode = ast.lines[0].statements[1]
        self.assertIsInstance(ifnode, AST.If)
        # WHILE + ELSE
        self.assertEqual(len(ifnode.then_block), 2)
        self.assertIsInstance(ifnode.then_block[0], AST.WhileLoop)
        self.assertEqual(ifnode.then_block[1].name, "ELSE")
        # Assignement + Print + IFEND
        self.assertEqual(len(ifnode.else_block), 3)
        self.assertIsInstance(ifnode.else_block[0], AST.Assignment)
        self.assertIsInstance(ifnode.else_block[1], AST.Print)
        self.assertEqual(ifnode.else_block[2].name, "IFEND")

    def test_missing_end_if(self):
        code = """10 IF X>0 THEN
20 PRINT X"""
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_abs_basic(self):
        code = "10 I=0: res = ABS(-10 * 2 + I)"
        ast, _ = self.parse_code(code)
        self.assertEqual(len(ast.lines), 1)
        cmd = ast.lines[0].statements[1]
        self.assertIsInstance(cmd, AST.Assignment)
        self.assertIsInstance(cmd.source, AST.Function)
        self.assertEqual(cmd.source.name, "ABS")
        self.assertIsInstance(cmd.source.args[0], AST.BinaryOp)
        codes = ["10 ABS -10", "10 ABS(ABS)", '10 ABS("H")', "10 ABS(1*2-10"]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)
        
    def test_after_basic(self):
        code = "10 AFTER 12 GOSUB 200"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "AFTER")
        self.assertEqual(len(ast.lines[0].statements[0].args), 2)
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 12)
        self.assertEqual(ast.lines[0].statements[0].args[1].value, 200)
        code = "10 AFTER 12,1+1+1 GOSUB 200"
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[0].statements[0].args[1], AST.BinaryOp)
        codes = ["10 AFTER 2.5 GOSUB 200", "10 AFTER 2,3.4 GOSUB 200", "10 AFTER 2, GOSUB 200"]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_asc_basic(self):
        codes = ['10 ASC("H")', '10 ASC("HELLO")', '10 ASC("H"+"E")']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "ASC")
            self.assertEqual(len(ast.lines[0].statements[0].args), 1)
            self.assertEqual(ast.lines[0].statements[0].args[0].etype, AST.ExpType.String)
        codes = ['10 ASC(12)', '10 ASC("H"+1)', '10 ASC(CLS)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_atn_basic(self):
        codes = ['10 a=ATN(30)', '10 a=ATN(30/3)', '10 a=ATN(50.5)']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].source.name, "ATN")
            self.assertEqual(len(ast.lines[0].statements[0].source.args), 1)
            self.assertEqual(ast.lines[0].statements[0].source.etype, AST.ExpType.Real)
        codes = ['10 a=ATN("H")', '10 a=ATN(ATN 5)', '10 a=ATN("A"+"B")']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_auto_basic(self):
        codes = ['10 AUTO 10,20', '10 AUTO 10', '10 AUTO']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_binss_basic(self):
        codes = ['10 a$=BIN$(2)', '10 a$=BIN$(2,4)']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].source.name, "BIN$")
            self.assertEqual(ast.lines[0].statements[0].source.etype, AST.ExpType.String)
        codes = ['10 a=BIN$(2)', '10 a$=BIN$(2,"A")', '10 a$=BIN$(1,2,3)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_border_basic(self):
        codes = ['10 BORDER 2', '10 BORDER 2,2*2/4']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "BORDER")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Void)
            self.assertEqual(ast.lines[0].statements[0].args[0].value, 2)
        codes = ['10 BORDER "2"', '10 BORDER 2,3,4', '10 BORDER 2/2.5,1']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_call_basic(self):
        codes = ['10 CALL 0', '10 CALL 2,2*2/4.5', '10 CALL &1000,"STRING",@NUM']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "CALL")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Void)
        codes = ['10 CALL "2"', '10 CALL 2,@"3"', '10 CALL 2,"H",@2']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_cat_basic(self):
        codes = ['10 CAT', '10 I=10: CAT']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_chain_basic(self):
        codes = ['10 CHAIN "myfile.bas"', '10 CHAIN MERGE "myfile.bas"']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_chrss_basic(self):
        codes = ['10 CHR$(34)', '10 CHR$(&F0)', '10 CHR$(10+&HA0)']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "CHR$")
            self.assertEqual(len(ast.lines[0].statements[0].args), 1)
            self.assertEqual(ast.lines[0].statements[0].args[0].etype, AST.ExpType.Integer)
        codes = ['10 I=10 + CHR$(34)', '10 CHR$("H"+1)', '10 CHR$(CLS)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_cint_basic(self):
        codes = ['10 CINT(2.5)', '10 CINT(2+2*1.5)', '10 CINT(&HA0)']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "CINT")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Integer)
            self.assertEqual(len(ast.lines[0].statements[0].args), 1)
            self.assertTrue(AST.exptype_isnum(ast.lines[0].statements[0].args[0].etype))
        codes = ['10 I=CINT(A$)', '10 CINT("H"+1.0)', '10 I=CINT(CLS)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)
 
    def test_clg_basic(self):
        codes = ["10 CLG 1", "10 CLG 1+1", "10 CLG"]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            cmd = ast.lines[0].statements[0]
            self.assertIsInstance(cmd, AST.Command)
            self.assertEqual(cmd.name, "CLG")
        codes = ["10 CLG $I", "10 CLG #10","10 CLG 2.5"]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_closein_basic(self):
        code = "10 CLOSEIN"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertIsInstance(cmd, AST.Command)
        self.assertEqual(cmd.name, "CLOSEIN")

    def test_closeout_basic(self):
        code = "10 CLOSEOUT"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertIsInstance(cmd, AST.Command)
        self.assertEqual(cmd.name, "CLOSEOUT")

    def test_cls_basic(self):
        codes = ["10 CLS", "10 CLS #1", "10 CLS #1+1"]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            cmd = ast.lines[0].statements[0]
            self.assertIsInstance(cmd, AST.Command)
            self.assertEqual(cmd.name, "CLS")
        codes = ['10 CLS #"A"', "10 CLS CLG 0", '10 CLS #I$', '10 CLS 0.5']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_cos_basic(self):
        codes = ['10 COS(2.5)', '10 COS(2+2*5)', '10 COS(&HA0)']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "COS")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Real)
            self.assertEqual(len(ast.lines[0].statements[0].args), 1)
            self.assertTrue(AST.exptype_isnum(ast.lines[0].statements[0].args[0].etype))
        codes = ['10 I!=COS(A$)', '10 COS("H"+1.0)', '10 I=COS(CLS #1)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_creal_basic(self):
        codes = ['10 CREAL(2)', '10 CREAL(ABS(-1))', '10 CREAL(&HA0 * COS(30))']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "CREAL")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Real)
            self.assertEqual(len(ast.lines[0].statements[0].args), 1)
            self.assertTrue(AST.exptype_isnum(ast.lines[0].statements[0].args[0].etype))
        codes = ['10 I=CREAL(A$)', '10 I!=CREAL("H"+1.0)', '10 I!=CREAL(CLS #0)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_data_basic(self):
        code = '10 DATA 1,2,3,HELLO,"HELLO",&HFF,1.5'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "DATA")
        self.assertEqual(len(ast.lines[0].statements[0].args), 7)
        self.assertTrue(AST.exptype_isstr(ast.lines[0].statements[0].args[3].etype))
        codes = ['10 DATA CREAL(5)', '10 DATA 1+1', '10 DATA #0', '10 DATA @I$']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_decss_basic(self):
        code = '10 I$=DEC$(1.5,"##.##")'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].source.name, "DEC$")
        self.assertEqual(len(ast.lines[0].statements[0].source.args), 2)
        self.assertTrue(AST.exptype_isstr(ast.lines[0].statements[0].source.args[1].etype))
        codes = ['10 I=DEC$(1.5,"#.#")', '10 I$=DEC$(10)', '10 I$=DEC$("H","##.##")']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_def_fn_basic(self):
        code = '10 DEF FNpow(X) = X*X'
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.DefFN)
        self.assertEqual(ast.lines[0].statements[0].name, "FNpow")
        self.assertEqual(len(ast.lines[0].statements[0].args), 1)
        self.assertIsInstance(ast.lines[0].statements[0].body, AST.BinaryOp)

    def test_def_fn_call(self):
        code = '10 DEF FNpow(X) = X*X\n20 FNpow(2)'
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.DefFN)
        self.assertIsInstance(ast.lines[1].statements[0], AST.UserFun)
        
    def test_deg_basic(self):
        code = "10 DEG: END"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "DEG")

    def test_delete_basic(self):
        code = "10 DELETE 100-200"
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_di_basic(self):
        code = "10 DI: END"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "DI")

    def test_dim_basic(self):
        codes = ["10 DIM I()", "10 DIM I(5),A$(8)", "10 DIM A$(2,3,4), I()"]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "DIM")
            for arg in ast.lines[0].statements[0].args:
                self.assertIsInstance(arg, AST.Array)
        codes = ['10 DIM I("A")', '10 DIM I$(1.5)', '10 DIM I$(3*3)']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

if __name__ == "__main__":
    unittest.main()
