"""
From project source directory:

python3 -m unittest test/test_parser.py
"""

import unittest
from baserror import BasError
from baserror import WarningLevel as WL
from basparse import LocBasParser
from baslex import LocBasLexer
from baspp import CodeLine
from symbols import SymType
import astlib as AST
import json

class TestParser(unittest.TestCase):

    def parse_code(self, code: str):
        # let's add an extra EOL at the end so one single lines work
        code = code + '\n'
        lx = LocBasLexer(code)
        tokens = list(lx.tokens())
        codelines = [CodeLine("TEST.BAS", i, c) for i,c in enumerate(code.split('\n'))]
        return LocBasParser(codelines, tokens, warning_level=WL.NONE).parse_program()

# ---------- Statement and Expression parsing

    def test_expression_basic(self):
        code = "10 R = 11 MOD 2"
        ast, _ = self.parse_code(code)
        node = ast.lines[0].statements[0]
        self.assertIsInstance(node, AST.Assignment)
        self.assertEqual(node.target.name, "R")
        self.assertIsInstance(node.source, AST.BinaryOp)
        self.assertEqual(node.source.op, "MOD")
        
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
        code = """
10 X = 0
20 E = (X + 5) / 2.2
30 E$ = "STRING1" + "STRING2"
40 E! = (1 MOD 2.2) * 2
50 E% = 5.2 \\ 2.2
60 E = "STRING1" >= "STRING"
70 E = (1 AND 1.2) OR 1.5        
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].source.etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[2].statements[0].source.etype, AST.ExpType.String)
        self.assertEqual(ast.lines[3].statements[0].source.etype, AST.ExpType.Real)
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
        self.assertEqual(len(ast.lines), 9)
        # X is a local variable inside FNADD context
        # so 4 symbols + 9 labels (line numbers)
        self.assertEqual(len(symt.syms), 4+9)

# ------------------ Commands and Functions

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
        self.assertEqual(ast.lines[0].statements[0].args[1].args[0].value, 200)
        code = "10 AFTER 12,1+1+1 GOSUB 200"
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[0].statements[0].args[1], AST.BinaryOp)
        codes = ['10 AFTER "A" GOSUB 200', '10 AFTER 2,"B" GOSUB 200', "10 AFTER 2, GOSUB 200"]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_array_params_basic(self):
        code = """
10 DIM A(10)
20 SUB PRINTARRAY(vec[10])
30    FOR I=0 TO 10: PRINT vec(i): NEXT
40 END SUB
50 CALL PRINTARRAY(A[])
"""
        # check that it doesn't fail
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
        codes = ['10 a!=ATN(30)', '10 a!=ATN(30/3)', '10 a!=ATN(50.5)']
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
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "AUTO")

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
        codes = ['10 BORDER "2"', '10 BORDER 2,3,4']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_call_basic(self):
        # Regular call using an integer address
        codes = ['10 CALL 0', '10 CALL 2,2*2/4.5', '10 CALL &1000,"STRING",@NUM']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(ast.lines[0].statements[0].name, "CALL")
            self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Void)
        # ASM call using string labels
        code = '10 CALL "__my_asm_func",2,10'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "CALL")
        self.assertEqual(ast.lines[0].statements[0].etype, AST.ExpType.Void)
        # calling SUB rutine
        code = """
10 SUB mysub(A,B)
20    print A+B
30 END SUB
40 CALL mysub(2,10)
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[3].statements[0].name, "SUBmysub")
        self.assertEqual(ast.lines[3].statements[0].etype, AST.ExpType.Void)
        # calling FUNCTION rutine
        code = """
10 FUNCTION myfun(A,B)
20    myfun=A*B
30 END FUNCTION
40 R = myfun(2,10)
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[3].statements[0].source.name, "FUNmyfun")
        self.assertEqual(ast.lines[3].statements[0].source.etype, AST.ExpType.Integer)

    def test_chain_basic(self):
        codes = ['10 CHAIN "myfile.bas"', '10 CHAIN MERGE "myfile.bas"']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines[0].statements), 1)
            self.assertIsInstance(ast.lines[0].statements[0].args[0], AST.String)

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

    def test_clear_input_basic(self):
        code = """
10 CLS
20 PRINT "Type in letters now!"
30 FOR t=1 TO 3000
40 NEXT
50 CLEAR INPUT
"""
        ast, _ = self.parse_code(code)
        # FOR + NEXT form a single line/block
        self.assertEqual(ast.lines[4].statements[0].name, "CLEAR INPUT")
 
    def test_clg_basic(self):
        codes = ["10 CLG 1", "10 CLG 1+1", "10 CLG"]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            cmd = ast.lines[0].statements[0]
            self.assertIsInstance(cmd, AST.Command)
            self.assertEqual(cmd.name, "CLG")
        codes = ["10 CLG $I", "10 CLG #10"]
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


    def test_basic_const_example(self):
        code="""
10 CONST a = 5
20 PRINT a + 5
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "CONST")
        self.assertIsInstance(ast.lines[0].statements[0].args[0], AST.Variable)

    def test_const_error_example(self):
        code="""
10 CONST a = 5
20 a = 6
"""
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_copychrss_example(self):
        code = """
10 CLS
20 PRINT "top corner"
30 LOCATE 1,1
40 a$=COPYCHR$(#0)
50 LOCATE 1,20
60 PRINT a$
"""
        ast, _ = self.parse_code(code)
        cpcmd = ast.lines[3].statements[0].source
        self.assertEqual(cpcmd.name, "COPYCHR$")
        self.assertEqual(len(cpcmd.args), 1)
        self.assertEqual(cpcmd.args[0].value, 0)

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

    def test_cursor_example(self):
        code = """
10 CURSOR 1
20 PRINT "question?";
30 a$=INKEY$:IF a$="" THEN 30
40 PRINT a$
50 CURSOR 0
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "CURSOR")
        self.assertEqual(len(cmd.args), 1)
        self.assertEqual(cmd.args[0].value, 1)

    def test_data_basic(self):
        code = '10 DATA 1,2,3,HELLO,"HELLO",&HFF,1.5'
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Data)
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
        code = "10 DELETE &100-&200"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "DELETE")

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

    def test_draw_basic(self):
        code = "10 I=5: DRAW 10,10: DRAW 100,200,I: END"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].name, "DRAW")
        self.assertEqual(ast.lines[0].statements[2].args[0].value, 100)
        self.assertEqual(ast.lines[0].statements[2].args[1].value, 200)
        codes = ['10 DRAW 100', '10 DRAW 100,100,"A"']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)
    
    def test_drawr_basic(self):
        code = "10 I=5: DRAWR 10,10: DRAWR 100,200,I: END"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].name, "DRAWR")
        self.assertEqual(ast.lines[0].statements[2].args[0].value, 100)
        self.assertEqual(ast.lines[0].statements[2].args[1].value, 200)
        codes = ['10 DRAWR 100', '10 DRAWR 100,100,"A"']
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_edit_basic(self):
        code = "10 EDIT 100"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "EDIT")

    def test_ei_basic(self):
        code = "10 EI: END"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "EI")

    def test_ent_basic(self):
        code = "10 ENT 1,10,-50,10,10,50,10"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "ENT")
        self.assertEqual(len(ast.lines[0].statements[0].args), 7)
        self.assertEqual(ast.lines[0].statements[0].args[5].value, 50)
        
    def test_env_basic(self):
        code = "10 ENV 1,100,2,20"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "ENV")
        self.assertEqual(len(ast.lines[0].statements[0].args), 4)
        self.assertEqual(ast.lines[0].statements[0].args[3].value, 20)

    def test_eof_basic(self):
        code = '10 WHILE NOT EOF: PRINT "PRINT READING": WEND'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].condition.op, "NOT")
        self.assertEqual(ast.lines[0].statements[0].condition.etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[0].statements[0].condition.operand.name, "EOF")

    def test_erase_basic(self):
        code = '10 DIM a(100), b$(100): ERASE a,b$'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].name, "ERASE")
        self.assertEqual(len(ast.lines[0].statements[1].args), 2)

    def test_error_basic(self):
        code = '10 IF ERR=17 THEN 10 ELSE ERROR 17\n20 PRINT ERR,ERL'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].id, "If")
        self.assertEqual(ast.lines[0].statements[0].inline_else[0].name, "ERROR")
        self.assertEqual(len(ast.lines[0].statements[0].inline_else[0].args), 1)

    def test_every_basic(self):
        code = """
10 EVERY 50,1 GOSUB 30
20 GOTO 20
30 PRINT "."
40 RETURN
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "EVERY")
        self.assertEqual(len(ast.lines[0].statements[0].args), 3)
        self.assertEqual(ast.lines[0].statements[0].args[2].name, "GOSUB")

    def test_exp_basic(self):
        code = '10 PRINT EXP(6.876)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "EXP")
        self.assertEqual(ast.lines[0].statements[0].items[0].args[0].value, 6.876)

    def test_fix_basic(self):
        code = '10 PRINT FIX(9.999)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "FIX")
        self.assertEqual(ast.lines[0].statements[0].items[0].args[0].value, 9.999)

    def test_for_inline(self):
        codes = [
            "10 FOR I=1 TO 5: PRINT I: NEXT: END",
            "10 FOR I%=1 TO 5: PRINT I%: NEXT: END",
            "10 FOR I=1 TO 5: PRINT I: NEXT I: END",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT: NEXT",
            "10 FOR I=1 TO 5: FOR J=1 TO 10: NEXT J: NEXT I"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            self.assertEqual(len(ast.lines[0].statements), 4)
            self.assertEqual(ast.lines[0].statements[0].id, "ForLoop")

    def test_for_errors(self):
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
            with self.assertRaises(BasError, msg=code):
                self.parse_code(code)
            
    def test_for_nested_loops(self):
        code = """      
10 FOR I=1 TO 2
20 FOR J=1 TO 2
30 PRINT I,J
40 NEXT J
50 NEXT I
"""
        ast, _ = self.parse_code(code)
        outer_for = ast.lines[0].statements[0]
        self.assertIsInstance(ast.lines[0].statements[0], AST.ForLoop)
        self.assertIsInstance(ast.lines[1].statements[0], AST.ForLoop)
        self.assertIsInstance(ast.lines[2].statements[0], AST.Print)

    def test_for_no_case(self):
        code ="""
10 cls
20 for i=1 TO 2
30 Print i
40 NEXT I
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(len(ast.lines), 4)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Command)
        self.assertEqual(ast.lines[0].statements[0].name, "CLS")
        self.assertIsInstance(ast.lines[1].statements[0], AST.ForLoop)
        self.assertIsInstance(ast.lines[2].statements[0], AST.Print)

    def test_fre_basic(self):
        code = '10 PRINT FRE(0),FRE("")'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "FRE")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[0].statements[0].items[0].args[0].etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[0].statements[0].items[2].args[0].etype, AST.ExpType.String)

    def test_hexss_basic(self):
        code = '10 PRINT HEX$(255,4)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "HEX$")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.String)
        self.assertEqual(ast.lines[0].statements[0].items[0].args[0].etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[0].statements[0].items[0].args[1].etype, AST.ExpType.Integer)

    def test_if_else_basic(self):
        codes = [
            "10 I=5: IF I=10 THEN 10 ELSE 10",
            "10 I=10: IF I=10 THEN GOTO 10 ELSE GOTO 10"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            ifnode = ast.lines[0].statements[1]
            self.assertIsInstance(ifnode, AST.If)
            self.assertEqual(len(ifnode.inline_then), 1)
            self.assertEqual(ifnode.inline_then[0].args[0].value, 10)
            self.assertEqual(len(ifnode.inline_then), 1)
            self.assertEqual(ifnode.inline_then[0].args[0].value, 10)

    def test_if_then_basic(self):
        codes = [
            "10 I=0: IF I=10 THEN 10",
            "10 I=10: IF I=10 THEN GOTO 10"
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            ifnode = ast.lines[0].statements[1]
            self.assertIsInstance(ifnode, AST.If)
            self.assertEqual(ifnode.inline_then[0].args[0].value, 10)
            self.assertEqual(len(ifnode.inline_then), 1)

    def test_if_else_inline(self):
        code = """10 I=0: IF I=10 THEN PRINT "A": J=1 ELSE PRINT "B": J=0"""
        ast, _ = self.parse_code(code)
        ifnode = ast.lines[0].statements[1]
        self.assertIsInstance(ifnode, AST.If)
        self.assertEqual(len(ifnode.inline_then), 2)
        self.assertEqual(len(ifnode.inline_else), 2)

    def test_if_then_else_block(self):
        code = """
10 X=0 
20 IF X=1 THEN
30 PRINT "YES": J=1
40 ELSE
50 PRINT "NO": J=1
60 END IF
"""
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[1].statements[0], AST.If)
        self.assertEqual(ast.lines[3].statements[0].name, "ELSE")
        self.assertEqual(ast.lines[5].statements[0].name, "END IF")

    def test_if_else_while_nested(self):
        code = "10 I=10: IF I=10 THEN WHILE I>0: I=I-1: PRINT I: WEND ELSE J=I MOD 2: PRINT I"
        ast, _ = self.parse_code(code)
        ifnode = ast.lines[0].statements[1]
        self.assertIsInstance(ifnode, AST.If)
        self.assertEqual(len(ifnode.inline_then), 4)
        self.assertIsInstance(ifnode.inline_then[0], AST.WhileLoop)
        self.assertEqual(len(ifnode.inline_else), 2)
        self.assertIsInstance(ifnode.inline_else[0], AST.Assignment)
        self.assertIsInstance(ifnode.inline_else[1], AST.Print)

    def test_if_missing_end(self):
        code = """
10 IF X>0 THEN
20 PRINT X
"""
        with self.assertRaises(BasError):
            self.parse_code(code)

    def test_ink_basic(self):
        code = """
10 FOR p=0 TO 1
20 FOR I=0 TO 28
30 INK p,i
40 PRINT "INK:";P;";";i
50 NEXT I
60 NEXT P
70 INK 1,2,16
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[6].statements[0].name, "INK")
        self.assertEqual(ast.lines[6].statements[0].args[0].value, 1)
        self.assertEqual(ast.lines[6].statements[0].args[1].value, 2)
        self.assertEqual(ast.lines[6].statements[0].args[2].value, 16)

    def test_inkey_basic(self):
        code = '10 IF INKEY(55)=32 THEN PRINT "V+SHIFT PRESSED"'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].condition.left.name, "INKEY")
        self.assertEqual(ast.lines[0].statements[0].condition.left.args[0].value, 55)

    def test_inkeyss_basic(self):
        code = '10 a$=INKEY$: WHILE a$="": a$=INKEY$: WEND'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].source.name, "INKEY$")
        self.assertEqual(ast.lines[0].statements[0].source.etype, AST.ExpType.String)

    def test_inp_basic(self):
        code = '10 PRINT INP(&FF77)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "INP")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.Integer)
        self.assertEqual(ast.lines[0].statements[0].items[0].args[0].value, 65399)


    def test_while_inline(self):
        codes = [
            '10 I=10: WHILE I>0: I=I-1: PRINT I: WEND: END',
            '10 I$="HELLOX": WHILE I$>"HELLO": PRINT I$: WEND: END',
            '10 I=10: WHILE I>0: I=I-1: J=10: WHILE J>0: J=J-1: WEND: WEND: END',
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertEqual(len(ast.lines), 1)
            statements = len(code.split(":"))
            self.assertEqual(len(ast.lines[0].statements), statements)
            self.assertEqual(ast.lines[0].statements[0].id, "Assignment")
            self.assertEqual(ast.lines[0].statements[1].id, "WhileLoop")
            self.assertEqual(ast.lines[0].statements[statements-1].name, "END")

    def test_while_nested_loops(self):
        code = """
10 I=10
20 WHILE I>0
30 PRINT I: I=I-1
40 J=10
50 WHILE J>0
60 J=J-1
70 WEND
80 WEND
"""
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[1].statements[0], AST.WhileLoop)
        self.assertIsInstance(ast.lines[4].statements[0], AST.WhileLoop)
        self.assertIsInstance(ast.lines[5].statements[0], AST.Assignment)

    def test_while_fails(self):
        code = '10 I$="HELLO": WHILE I$>0: PRINT I$: WEND'
        with self.assertRaises(BasError, msg=code):
            self.parse_code(code)

    def test_input_full(self):
        code = '10 INPUT #0,"ENTER YOUR NAME:";n$'
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertIsInstance(cmd, AST.Input)
        self.assertEqual(cmd.stream.value, 0)
        self.assertEqual(cmd.prompt, "ENTER YOUR NAME:")
        self.assertTrue(cmd.question)
        self.assertEqual(cmd.vars[0].name, "n$")

    def test_input_options(self):
        codes = [
            '10 INPUT "QUESTION",n$',
            '10 INPUT "QUESTION";n$,a$,b$',
            "10 INPUT a",
            "10 INPUT ;b$,c$",
            "10 INPUT #1,num",
            '10 INPUT "",a,b'
            ""
        ]
        for code in codes:
            ast, _ = self.parse_code(code)
            cmd = ast.lines[0].statements[0]
            self.assertIsInstance(cmd, AST.Input)

    def test_input_errors(self):
        codes = [
            "10 INPUT 'QUESTION',n$",
            '10 INPUT 12,"QUESTION";n$',
            '10 INPUT a,12,"a"',
            "10 INPUT ;b$;c$",
            '10 INPUT #1+"a";num',
            '10 INPUT "",a;b'
            ""
        ]
        for code in codes:
            with self.assertRaises(BasError):
                self.parse_code(code)

    def test_input_createvars(self):
        code = '10 INPUT n$: a$="ASNWER: "+n$'
        ast,symt = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertIsInstance(cmd, AST.Input)
        self.assertTrue(symt.find(ident="n$", stype=SymType.Variable, context="") is not None)

    def test_input_if_example(self):
        code = """
10 CLS 
20 INPUT "Give me two numbers, separated by a comma ";A,B 
30 IF A=B THEN PRINT "The two numbers are the same" 
40 IF A>B THEN PRINT A "is greater than" B  
50 IF A<B THEN PRINT A "is less than" B  
60 CLEAR:GOTO 20
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[1].statements[0]
        self.assertIsInstance(cmd, AST.Input)


    def test_instr_basic(self):
        code = '10 PRINT INSTR(2,"BANANA","AN")'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "INSTR")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.Integer)

    def test_int_basic(self):
        code = '10 PRINT INT(-1.995)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "INT")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.Integer)

    def test_joy_basic(self):
        code = '10 IF JOY(0) AND 8 THEN GOTO 100'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].condition.left.name, "JOY")
        self.assertEqual(ast.lines[0].statements[0].condition.left.etype, AST.ExpType.Integer)
    
    def test_key_basic(self):
        code = '10 KEY 140,"RUN"+CHR$(13)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "KEY")
        self.assertEqual(len(ast.lines[0].statements[0].args), 2)
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 140)

    def test_graphics_paper_mask_example(self):
        code = """
10 MODE 0
20 MASK 15
30 GRAPHICS PAPER 3
40 DRAW 200,200
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].name, "MASK")
        self.assertEqual(ast.lines[1].statements[0].args[0].value, 15)
        self.assertEqual(ast.lines[2].statements[0].name, "GRAPHICS PAPER")
        self.assertEqual(ast.lines[2].statements[0].args[0].value, 3)

    def test_graphics_pen_move_example(self):
        code = """
10 MODE 0
20 GRAPHICS PEN 15
30 MOVE 200,0
40 DRAW 200,400
50 MOVE 639,0
60 FILL 15
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[2].statements[0].name, "MOVE")
        self.assertEqual(ast.lines[2].statements[0].args[0].value, 200)
        self.assertEqual(ast.lines[2].statements[0].args[1].value, 0)
        self.assertEqual(ast.lines[1].statements[0].name, "GRAPHICS PEN")
        self.assertEqual(ast.lines[1].statements[0].args[0].value, 15)

    def test_key_def_basic(self):
        code = '10 KEY DEF 46,1,110'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "KEY DEF")
        self.assertEqual(len(ast.lines[0].statements[0].args), 3)

    def test_leftss_example(self):
        code = """
10 CLS 
20 A$ = "AMSTRAD" 
30 B$ = LEFT$(A$,3) 
40 PRINT B$ 
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[2].statements[0].source
        self.assertEqual(cmd.name, "LEFT$")
        self.assertEqual(cmd.etype, AST.ExpType.String)
        self.assertEqual(len(cmd.args), 2)

    def test_len_basic(self):
        code = '10 A$="AMSTRAD":PRINT LEN(A$)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].items[0].name, "LEN")
        self.assertEqual(len(ast.lines[0].statements[1].items[0].args), 1)

    def test_line_input_basic(self):
        codes = ['10 LINE INPUT ;A$', '10 LINE INPUT "NAME"; N$', '10 LINE INPUT #0,;A$', '10 LINE INPUT #0,A$']
        for code in codes:
            ast, _ = self.parse_code(code)
            self.assertIsInstance(ast.lines[0].statements[0], AST.LineInput)

    def test_load_basic(self):
        code = '10 LOAD "TITLE.SCN",&C000'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "LOAD")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, "TITLE.SCN")
        self.assertEqual(ast.lines[0].statements[0].args[1].value, 49152)

    def test_log_log10_basic(self):
        codes = ['10 LOG(9999)', '10 LOG10(9999)']
        for code in codes:
            ast, _ = self.parse_code(code)
            # as the parameters are integers, the real argument will the CREAL function
            # that converts from INT to REAL
            self.assertIsInstance(ast.lines[0].statements[0].args[0], AST.Function)

    def test_lowerss_basic(self):
        code = '10 A$="AMSTRAD":PRINT LOWER$(A$)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].items[0].name, "LOWER$")
        self.assertEqual(len(ast.lines[0].statements[1].items[0].args), 1)

    def test_mask_example(self):
        code="""
10 CLS:TAG
20 MASK 1:MOVE 0,250:DRAWR 240,0
30 PRINT "(binary 00000001 in mask)"
40 MASK 3:MOVE 0,200:DRAWR 240,0
50 PRINT "(binary 00000011 in mask)"
60 MASK 7:MOVE 0,150:DRAWR 240,0
70 PRINT "(binary 00000111 in mask)"
80 MASK 15:MOVE 0,100:DRAWR 240,0
90 PRINT "(binary 00001111 in mask)"
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].name, "MASK")
        self.assertEqual(ast.lines[1].statements[0].args[0].value, 1)

    def test_max_example(self):
        code="""
10 n=66 
20 PRINT MAX(1,n,3,6,4,3)
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].items[0].name, "MAX")
        self.assertEqual(ast.lines[1].statements[0].items[0].etype, AST.ExpType.Integer)

    def test_min_example(self):
        code="""
10 n=66 
20 PRINT MIN(1,n,3.0,6,4,3)
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].items[0].name, "MIN")
        self.assertEqual(ast.lines[1].statements[0].items[0].etype, AST.ExpType.Real)

    def test_memory_basic(self):
        code = '10 MEMORY &20AA'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "MEMORY")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 8362)

    def test_merge_basic(self):
        code = '10 MERGE "PLAN"'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "MERGE")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, "PLAN")
    
    def test_midss_basic(self):
        code = '10 A$="AMSTRAD":PRINT MID$(A$,2,4)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].items[0].name, "MID$")
        self.assertEqual(len(ast.lines[0].statements[1].items[0].args), 3)

    def test_on_GOSUB_basic(self):
        code = "10 DAY=1: ON DAY GOSUB 100,200,300,400,500"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].name, "ON GOSUB")
        self.assertEqual(len(ast.lines[0].statements[1].args), 6)
        self.assertEqual(ast.lines[0].statements[1].args[1].value, 100)

    def test_on_GOTO_basic(self):
        code = r"10 RATE%=0: ON RATE% GOTO 1000,2000,3000,4000"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[1].name, "ON GOTO")
        self.assertEqual(len(ast.lines[0].statements[1].args), 5)
        self.assertEqual(ast.lines[0].statements[1].args[1].value, 1000)

    def test_on_break_example(self):
        code = """
10 ON BREAK GOSUB 40
20 PRINT "program running"
30 GOTO 20
40 CLS
50 PRINT "pressing [ESC] twice calls GOSUB routine"
60 FOR t=1 TO 2000:NEXT
65 ON BREAK STOP
70 RETURN
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "ON BREAK GOSUB")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 40)
        self.assertEqual(ast.lines[6].statements[0].name, "ON BREAK STOP")

    def test_on_error_example(self):
        code = """
10 ON ERROR GOTO 80  
20 CLS 
30 PRINT"if there is an error, I would"  
40 PRINT"like the program listed, so that"  
50 PRINT"I can see where I went wrong"  
60 FOR t=1 TO 4000:NEXT   
70 GOTO 100 
80 CLS:PRINT"THERE IS AN ERROR IN LINE";ERL:PRINT   
90 LIST
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "ON ERROR GOTO")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 80)

    def test_on_sq_example(self):
        code = "10 ON SQ(2) GOSUB 2000"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "ON SQ")
        self.assertEqual(len(ast.lines[0].statements[0].args), 2)
        self.assertEqual(ast.lines[0].statements[0].args[1].value, 2000)

    def test_openin_openout_basic(self):
        code = '10 OPENIN "DATA.TXT": OPENOUT "DATA.TXT"'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "OPENIN")
        self.assertEqual(ast.lines[0].statements[1].name, "OPENOUT")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, "DATA.TXT")

    def test_origin_example(self):
        code = """
10 CLS:BORDER 13 
20 ORIGIN 0,0,50,590,350,50  
30 DRAW 540,350 
40 GOTO 20
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].name, "ORIGIN")
        self.assertEqual(len(ast.lines[1].statements[0].args), 6)
        self.assertEqual(ast.lines[1].statements[0].args[3].value, 590)

    def test_out_example(self):
        code = "10 OUT &7F00,10:OUT &7F00,&4B"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "OUT")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 32512)
        self.assertEqual(ast.lines[0].statements[1].args[1].value, 75)

    def test_paper_pen_example(self):
        code = """
10 MODE 0 
20 FOR p=0 TO 15 
30 PAPER p:CLS 
40 PEN 15-p 
50 LOCATE 6,12:PRINT "PAPER"p  
60 FOR t=1 TO 500: NEXT t  
70 NEXT p  
"""         
        ast, _ = self.parse_code(code)
        cmd = ast.lines[2].statements[0]
        self.assertEqual(cmd.name, "PAPER")
        self.assertIsInstance(cmd.args[0], AST.Variable)

    def test_peek_example(self):
        code = """
10 MODE 2 
20 INK 1,0: INK 0,12: BORDER 12 
30 INPUT "Start address for examination";first  
40 INPUT "End address for examination";last  
50 FOR n= first TO last  
60 VALUE$=HEX$(PEEK(n),2)  
70 PRINT VALUE$; 
80 PRINT" at ";HEX$(n,4),  
90 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[5].statements[0].source.args[0]
        self.assertEqual(cmd.name, "PEEK")
        self.assertEqual(cmd.etype, AST.ExpType.Integer)
        self.assertIsInstance(cmd.args[0], AST.Variable)

    def test_pi_example(self):
        code = """
10 REM Perspective drawing  
20 MODE 2 
30 RAD 
40 INK 1,0 
50 INK 0,12 
60 BORDER 9 
70 FOR N= 1 TO 200 
80 ORIGIN 420,0 
90 DRAW 0,200 
100 REM draw angles from vanishing point  
110 DRAW CINT(30*N*SIN(N*PI/4)),CINT(SIN(PI/2)*N*SIN(N)) 
120 NEXT 
130 MOVE 0,200 
140 DRAWR 0,50 
150 DRAWR 40,0 
160 WINDOW 1,40,1,10  
170 PRINT"Now you can finish the Hangman program!"
"""
        ast, _ = self.parse_code(code)
        # We simply check that PI is recognized as a function
        self.assertIsInstance(ast.lines[10].statements[0], AST.Command)

    def test_plot_example(self):
        code = """
10 MODE 2:PRINT "Enter 4 numbers, separated by commas":PRINT  
20 PRINT "Enter X origin (0-639), Y origin (O-399), radius and angle to to step":INPUT x,y,r,s
30 ORIGIN x,y
40 FOR angle = 1 to 360 STEP s
50 XPOINT = cint(r*COS(angle))
60 YPOINT = cint(r*SIN(angle))
70 PLOT XPOINT,YPOINT
74 REM MOVE 0,0
75 REM DRAW XPOINT,YPOINT
80 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[6].statements[0]
        self.assertEqual(cmd.name, "PLOT")
        self.assertIsInstance(cmd.args[0], AST.Variable)
        self.assertIsInstance(cmd.args[1], AST.Variable)

    def test_poke_pos_example(self):
        code = """
10 V=POS(#0)
20 POKE &00FF,V
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[1].statements[0].name, "POKE")
        self.assertEqual(ast.lines[1].statements[0].args[0].value, 255)
        self.assertIsInstance(ast.lines[1].statements[0].args[1], AST.Variable)

    def test_print_example(self):
        code = """
10 a$="small"
20 b$="this is a larger string"
30 PRINT a$;a$
40 PRINT a$;b$;"which end here"
50 FOR x=6 TO 15
60 PRINT SPC(5)"a";SPC(x)"b"
70 PRINT TAB(5)"a";TAB(x)"b"
80 NEXT
90 a$="££######,.##"
100 b$="!"
110 PRINT USING a$;12345.6789
120 PRINT USING b$;"pence"
"""
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[2].statements[0], AST.Print)
        self.assertIsInstance(ast.lines[3].statements[0], AST.Print)
        self.assertIsInstance(ast.lines[5].statements[0], AST.Print)
        self.assertIsInstance(ast.lines[6].statements[0], AST.Print)
        self.assertIsInstance(ast.lines[10].statements[0], AST.Print)
        self.assertIsInstance(ast.lines[11].statements[0], AST.Print)

    def test_read_example(self):
        code = """
10 FOR n=1 TO 8
20 READ a$,c
30 PRINT a$;" ";c;:NEXT
40 DATA "AMSTRAD",1,"CPC",2,"464",3,"6128",5
50 DATA "128",8
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[1].statements[0]
        self.assertEqual(cmd.name, "READ")
        self.assertEqual(len(cmd.args), 2)

    def test_release_example(self):
        code = "10 RELEASE &X111"
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "RELEASE")
        self.assertEqual(ast.lines[0].statements[0].args[0].value, 7)

    def test_remain_example(self):
        code = """
10 AFTER 500,1 GOSUB 40
20 AFTER 100,2 GOSUB 50
30 PRINT "Program running":GOTO 30
40 REM this routine won't be called because line 80 blocks that
50 PRINT:PRINT "The timer 1 will be ";
60 PRINT "disabeld by REMAIN command"
70 PRINT "Remaining time:";
80 PRINT REMAIN(1)
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[7].statements[0].items[0].name, "REMAIN")
        self.assertEqual(ast.lines[7].statements[0].items[0].args[0].value, 1)

    def test_restore_example(self):
        code = """
10 READ a$:PRINT a$;" ";
20 RESTORE 50
30 FOR t=1 TO 500: NEXT
35 GOTO 10
40 DATA "restore data pointer to read data"
50 DATA "again and again"
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[1].statements[0]
        self.assertEqual(cmd.name, "RESTORE")
        self.assertEqual(cmd.args[0].value, 50)

    def test_rightss_example(self):
        code = """
10 MODE 0:a$="Computer CPC464" 
20 FOR n=1 TO LEN(a$)
25 LOCATE 21-n,n
30 PRINT RIGHT$(a$,n)
40 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[3].statements[0].items[0]
        self.assertEqual(cmd.name, "RIGHT$")
        self.assertEqual(cmd.etype, AST.ExpType.String)
        self.assertEqual(len(cmd.args), 2)

    def test_rnd_basic(self):
        code = '10 PRINT RND(1), RND(0), RND(-1)'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].name, "RND")
        self.assertEqual(ast.lines[0].statements[0].items[0].etype, AST.ExpType.Real)
        # item 1 is a Separator
        self.assertEqual(ast.lines[0].statements[0].items[2].name, "RND")
        self.assertEqual(len(ast.lines[0].statements[0].items), 5)

    def test_round_example(self):
        code = """
10 x!=0.123456789 
20 FOR r=9 TO 0 STEP -1:PRINT r,ROUND(x!,r):NEXT   
25 x!=123456789 
30 FOR r=0 TO -9 STEP -1
40 PRINT r,ROUND (x!,r)  
50 NEXT 
"""
        ast, _ = self.parse_code(code)
        # items = var(r), sep(,) and ROUND
        cmd = ast.lines[4].statements[0].items[2]
        self.assertEqual(cmd.name, "ROUND")
        self.assertEqual(cmd.etype, AST.ExpType.Real)
        self.assertEqual(len(cmd.args), 2)

    def test_save_basic(self):
        code = '10 SAVE "myfile.xyz",B,&4000,&4000,&4001'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "SAVE")
        self.assertEqual(len(ast.lines[0].statements[0].args), 5)

    def test_select_example(self):
        code ="""
10 INPUT "ENTER YOUR NUMBER:"; N
20 SELECT CASE N
30    CASE 1: PRINT "YOUR NUMBER IS 1"
40    CASE 2: PRINT "YOUR NUMBER IS 2"
50    CASE DEFAULT: PRINT "YOUR NUMBER IS DIFFERENT FROM 1 AND 2"
60 END SELECT
"""
        # Probamos que este codigo no falla
        self.parse_code(code)


    def test_shared_example(self):
        code ="""
10 DIM A$(10)
20 SUB PRINTA
30    SHARED A$[]
40    FOR i=0 To 10: PRINT a$(i): NEXT
50 END SUB
60 CALL PRINTA()
"""
        # Probamos que este codigo no falla
        self.parse_code(code)

    def test_sgn_example(self):
        code ="""
10 FOR n=200 TO -200 STEP -20
20 PRINT "SGN outputs";
30 PRINT SGN(n);"when the number is";n
40 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[2].statements[0].items[0]
        self.assertEqual(cmd.name, "SGN")
        self.assertEqual(len(cmd.args), 1)
        
    def test_sound_example(self):
        code ="""
10 FOR z=0 TO 4095
20 SOUND 1,z,1,12
30 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[1].statements[0]
        self.assertEqual(cmd.name, "SOUND")
        self.assertEqual(len(cmd.args), 7)

    def test_spacess_basic(self):
        code = '10 PRINT SPACE$(8);"HELLO"'
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0].items[0]
        self.assertEqual(cmd.name, "SPACE$")
        self.assertEqual(cmd.etype, AST.ExpType.String)
        self.assertEqual(cmd.args[0].value, 8)

    def test_speed_ink_example(self):
        code="""
10 INK 0,9,12:INK 1,0,26  
20 BORDER 12,9 
30 SPEED INK 50,20 
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[2].statements[0]
        self.assertEqual(cmd.name, "SPEED INK")
        self.assertEqual(cmd.args[0].value, 50)
        self.assertEqual(cmd.args[1].value, 20)

    def test_speed_key(self):
        code="10 SPEED KEY 20,3"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "SPEED KEY")
        self.assertEqual(cmd.args[0].value, 20)
        self.assertEqual(cmd.args[1].value, 3)

    def test_speed_write_basic(self):
        code="10 SPEED WRITE 1"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "SPEED WRITE")
        self.assertEqual(cmd.args[0].value, 1)

    def test_sq_example(self):
        code="""
10 MODE 1 
20 FOR n=20 TO 0 STEP -1 
30 PRINT n; 
40 SOUND 1,10+n,100,7  
50 WHILE SQ(1)>127:WEND  
60 NEXT
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[4].statements[0].condition.left
        self.assertEqual(cmd.name, "SQ")
        self.assertEqual(cmd.etype, AST.ExpType.Integer)
        self.assertEqual(cmd.args[0].value, 1)

    def test_sqr_basic(self):
        code="10 I!=SQR(3) + SQR(9)"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0].source
        self.assertEqual(cmd.left.name, "SQR")
    
    def test_strss_basic(self):
        code="10 PRINT STR$(&766)"
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0].items[0]
        self.assertEqual(cmd.name, "STR$")
        self.assertEqual(cmd.args[0].value, 1894)

    def test_stringss_basic(self):
        code='10 PRINT STRING$(&16,"*")'
        ast, _ = self.parse_code(code)
        cmd = ast.lines[0].statements[0].items[0]
        self.assertEqual(cmd.name, "STRING$")
        self.assertEqual(cmd.args[0].value, 22)

    def test_symbol_example(self):
        code="""
5 MODE 2 
10 SYMBOL AFTER 90 
20 SYMBOL 93,&80,&40,&20,&10,&8,&4,&2,&1   
30 FOR n=1 TO 2000 
40 PRINT CHR$(93); 
50 NEXT 
60 GOTO 60 
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[2].statements[0]
        self.assertEqual(cmd.name, "SYMBOL")
        self.assertEqual(cmd.args[0].value, 93)
        self.assertEqual(cmd.args[1].value, 128)

    def test_tag_example(self):
        code="""
10 MODE 2
11 BORDER 9
14 INK 0,12
15 INK 1,0
20 FOR n=1 TO 100
30 MOVE 200+n,320+n
40 TAG
50 IF n<70 THEN 60 ELSE 70
60 PRINT"Hello";:GOTO 80
70 PRINT" Farewell";
80 NEXT
90 GOTO 20
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[6].statements[0]
        self.assertEqual(cmd.name, "TAG")

    def test_time_example(self):
        code="""
10 DATUM = INT(TIME/300)  
20 TICKER!=((TIME/300)-DATUM) 
30 PRINT TICKER!; 
40 GOTO 20
"""
        ast, _ = self.parse_code(code)
        cmd = ast.lines[1].statements[0].source.left.left
        self.assertEqual(cmd.name, "TIME")

    def test_wait_basic(self):
        code='10 WAIT &FF34,20,25: WAIT &F500,&X00000001'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "WAIT")
        self.assertEqual(ast.lines[0].statements[0].args[1].value, 20)
        self.assertEqual(ast.lines[0].statements[1].name, "WAIT")
        self.assertEqual(ast.lines[0].statements[1].args[1].value, 1)

    def test_window_example(self):
        code="""
10 MODE 1  
20 BORDER 6 
30 WINDOW 10,30,7,18  
40 PAPER 2:PEN 3 
50 CLS 
60 PRINT CHR$(143);CHR$(242);"THIS IS LOCATION"  
70 PRINT "1,1 IN TEXT WINDOW"   
80 GOTO 80
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[2].statements[0].name, "WINDOW")
        self.assertEqual(len(ast.lines[2].statements[0].args), 4)
        self.assertEqual(ast.lines[2].statements[0].args[1].value, 30)
        self.assertEqual(ast.lines[2].statements[0].args[3].value, 18)
    
    def test_window_swap_basic(self):
        code='10 WINDOW SWAP 0,1: WINDOW SWAP #0,#1'
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[0].statements[0].name, "WINDOW SWAP")
        self.assertEqual(ast.lines[0].statements[0].args[1].value, 1)
        self.assertEqual(ast.lines[0].statements[1].name, "WINDOW SWAP")
        self.assertEqual(ast.lines[0].statements[1].args[1].value, 1)

    def test_write_example(self):
        code="""
10 OPENOUT "DUMMY"
20 INPUT A$,A
30 WRITE #9,A$,A
40 CLOSEOUT
"""
        ast, _ = self.parse_code(code)
        self.assertIsInstance(ast.lines[2].statements[0], AST.Write)
        self.assertEqual(ast.lines[2].statements[0].stream.value, 9)
        self.assertEqual(len(ast.lines[2].statements[0].items), 2)

    def test_xpos_ypos_example(self):
        code="""
10 MODE 1:DRAW 320,200
20 PRINT "graphics cursor X,Y position = ";
30 PRINT XPOS,YPOS
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[2].statements[0].items[0].name, "XPOS")
        self.assertEqual(ast.lines[2].statements[0].items[2].name, "YPOS")

    def test_zone_example(self):
        code="""
10 MODE 2
20 PRINT"normal zone (13)"
30 PRINT 1,2,3,4
40 PRINT"now with different zone(5)"
50 ZONE 5
60 PRINT 1,2,3,4
"""
        ast, _ = self.parse_code(code)
        self.assertEqual(ast.lines[4].statements[0].name, "ZONE")
        self.assertEqual(ast.lines[4].statements[0].args[0].value, 5)


if __name__ == "__main__":
    unittest.main()
