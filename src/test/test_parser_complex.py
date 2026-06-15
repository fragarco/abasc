"""
Parser tests for complex structures (SELECT CASE, RECORD, events, SHARED, pointers, streams).

From project source directory:

python3 -m unittest test/test_parser_complex.py
"""

import unittest
from baserror import BasError
from test.fixtures import compile_program
import astlib as AST


class TestSelectCase(unittest.TestCase):

    def test_select_case_basic(self):
        code = """
10 SELECT CASE X
20 CASE 1
30    PRINT "ONE"
40 CASE 2
50    PRINT "TWO"
60 END SELECT
"""
        ast, _ = compile_program(code)
        select = ast.lines[0].statements[0]
        self.assertIsInstance(select, AST.SelectCase)
        self.assertEqual(select.options, 2)

    def test_select_case_with_default(self):
        code = """
10 SELECT CASE X
20 CASE 1
30    PRINT "ONE"
40 CASE DEFAULT
50    PRINT "OTHER"
60 END SELECT
"""
        ast, _ = compile_program(code)
        select = ast.lines[0].statements[0]
        self.assertIsInstance(select, AST.SelectCase)
        self.assertTrue(select.defaultcase)

    def test_select_case_missing_end(self):
        code = """
10 SELECT CASE X
20 CASE 1
30    PRINT "ONE"
"""
        with self.assertRaises(BasError):
            compile_program(code)

    def test_select_case_nested(self):
        """ Nested SELECT CASE should parse without error. """
        code = """
10 SELECT CASE A
20 CASE 1
30    SELECT CASE B
40    CASE 2
50       PRINT "A=1,B=2"
60    END SELECT
70 END SELECT
"""
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.SelectCase)

    def test_select_case_unexpected_end(self):
        code = "10 END SELECT"
        with self.assertRaises(BasError):
            compile_program(code)


class TestRecord(unittest.TestCase):

    def test_record_definition(self):
        """RECORD IDENT; IDENT[,IDENT]* - semicolon after record name."""
        code = "10 RECORD MYREC; FIELD1%, FIELD2$"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertIsInstance(cmd, AST.Command)
        self.assertEqual(cmd.name, "RECORD")

    def test_record_multiple_fields(self):
        code = "10 RECORD MYREC; A%, B$, C!"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "RECORD")
        # args[0] is the record name, rest are field declarations
        self.assertEqual(len(cmd.args), 4)


class TestEventsAndTimers(unittest.TestCase):

    def test_after_gosub(self):
        code = "10 AFTER 10 GOSUB 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "AFTER")
        self.assertEqual(len(cmd.args), 2)

    def test_after_gosub_with_timer(self):
        code = "10 AFTER 10,1 GOSUB 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "AFTER")
        self.assertEqual(len(cmd.args), 3)

    def test_every_gosub(self):
        code = "10 EVERY 50,1 GOSUB 30"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "EVERY")

    def test_on_break_gosub(self):
        code = "10 ON BREAK GOSUB 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ON BREAK GOSUB")

    def test_on_error_goto(self):
        code = "10 ON ERROR GOTO 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ON ERROR GOTO")

    def test_after_sets_hasevents(self):
        code = "10 AFTER 10 GOSUB 200"
        ast, _ = compile_program(code)
        self.assertTrue(ast.hasevents)


class TestSharedVariables(unittest.TestCase):

    def test_shared_in_sub(self):
        code = """
10 A = 5
20 SUB DOIT
30    SHARED A
40    A = A + 1
50 END SUB
60 CALL DOIT()
"""
        ast, _ = compile_program(code)
        # Should parse without error
        self.assertEqual(len(ast.lines), 6)

    def test_shared_multiple_vars(self):
        code = """
10 A = 5
20 B = 10
30 SUB DOIT
40    SHARED A, B
50    A = A + 1
60 END SUB
"""
        ast, _ = compile_program(code)
        self.assertEqual(len(ast.lines), 6)

    def test_shared_array(self):
        code = """
10 DIM ARR(10)
20 SUB DOIT
30    SHARED ARR[]
40    ARR(0) = 99
50 END SUB
"""
        ast, _ = compile_program(code)
        self.assertEqual(len(ast.lines), 5)


class TestPointers(unittest.TestCase):

    def test_integer_pointer(self):
        """@IDENT creates a pointer to a variable (always integer type)."""
        code = "10 P% = @A%"
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)
        src = ast.lines[0].statements[0].source
        self.assertEqual(src.id, "Pointer")

    def test_pointer_to_string_var(self):
        """Pointer to string variable is still integer address."""
        code = "10 P% = @S$"
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)
        src = ast.lines[0].statements[0].source
        self.assertEqual(src.id, "Pointer")

    def test_label_pointer(self):
        """@LABEL(IDENT) creates a pointer to a label."""
        code = "10 P% = @LABEL(MYLABEL)"
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)
        src = ast.lines[0].statements[0].source
        self.assertEqual(src.id, "Pointer")

    def test_data_pointer(self):
        """@DATA creates a pointer to DATA."""
        code = "10 P% = @DATA"
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)
        src = ast.lines[0].statements[0].source
        self.assertEqual(src.id, "Pointer")


class TestStreams(unittest.TestCase):

    def test_openin(self):
        """OPENIN <str_expression> - no # prefix."""
        code = '10 OPENIN "FILE.TXT"'
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "OPENIN")
        self.assertEqual(cmd.args[0].value, "FILE.TXT")

    def test_openout(self):
        code = '10 OPENOUT "OUT.TXT"'
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "OPENOUT")

    def test_print_stream(self):
        """PRINT #N, expr - stream output."""
        code = '10 PRINT #1, "HELLO"'
        ast, _ = compile_program(code)
        stmt = ast.lines[0].statements[0]
        self.assertIsInstance(stmt, AST.Print)

    def test_line_input_stream(self):
        """LINE INPUT #N, ident - stream input."""
        code = '10 LINE INPUT #1, A$'
        ast, _ = compile_program(code)
        stmt = ast.lines[0].statements[0]
        self.assertIsInstance(stmt, AST.LineInput)
        self.assertEqual(stmt.stream.value, 1)

    def test_input_stream(self):
        """INPUT #N, ident - stream input."""
        code = '10 INPUT #1, A$'
        ast, _ = compile_program(code)
        stmt = ast.lines[0].statements[0]
        self.assertIsInstance(stmt, AST.Input)
        self.assertEqual(stmt.stream.value, 1)

    def test_readin(self):
        """READIN ident[,ident]* - reads from DATA statements."""
        code = '10 READIN A'
        ast, _ = compile_program(code)
        stmt = ast.lines[0].statements[0]
        self.assertIsInstance(stmt, AST.ReadIn)


class TestControlFlow(unittest.TestCase):

    def test_exit_for(self):
        code = """
10 FOR I = 1 TO 100
20    IF I > 10 THEN EXIT FOR
30 NEXT
"""
        ast, _ = compile_program(code)
        cmd = ast.lines[1].statements[0].inline_then[0]
        self.assertEqual(cmd.name, "EXIT FOR")

    def test_exit_while(self):
        code = """
10 WHILE I < 100
20    IF I > 10 THEN EXIT WHILE
30 WEND
"""
        ast, _ = compile_program(code)
        cmd = ast.lines[1].statements[0].inline_then[0]
        self.assertEqual(cmd.name, "EXIT WHILE")

    def test_gosub_return(self):
        code = """
10 GOSUB 200
20 PRINT "DONE"
200 PRINT "SUB"
210 RETURN
"""
        ast, _ = compile_program(code)
        self.assertEqual(ast.lines[0].statements[0].name, "GOSUB")
        self.assertEqual(ast.lines[3].statements[0].name, "RETURN")

    def test_goto(self):
        code = "10 GOTO 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "GOTO")
        self.assertEqual(cmd.args[0].value, 200)

    def test_on_goto(self):
        code = "10 ON X GOTO 100,200,300"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ON GOTO")

    def test_on_gosub(self):
        code = "10 ON X GOSUB 100,200,300"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ON GOSUB")


class TestDefFun(unittest.TestCase):

    def test_def_fun_block(self):
        code = """
10 FUNCTION MYFUNC(A,B)
20    MYFUNC = A * B
30 END FUNCTION
40 R = MYFUNC(3, 4)
"""
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.DefFUN)
        self.assertEqual(ast.lines[0].statements[0].name, "FUNMYFUNC")

    def test_def_sub_block(self):
        code = """
10 SUB MYSUB(A,B)
20    PRINT A + B
30 END SUB
40 CALL MYSUB(1, 2)
"""
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.DefSUB)
        self.assertEqual(ast.lines[0].statements[0].name, "SUBMYSUB")

    def test_def_fn_inline(self):
        """DEF FN IDENT(X) = expr - space between FN and identifier."""
        code = "10 DEF FN square(X) = X * X"
        ast, _ = compile_program(code)
        fn = ast.lines[0].statements[0]
        self.assertIsInstance(fn, AST.DefFN)
        self.assertEqual(fn.name, "FNsquare")

    def test_call_def_fun(self):
        code = """
10 FUNCTION MYFUNC(A)
20    MYFUNC = A * 2
30 END FUNCTION
40 R = MYFUNC(5)
"""
        ast, _ = compile_program(code)
        call = ast.lines[3].statements[0].source
        self.assertIsInstance(call, AST.UserFun)
        self.assertEqual(call.name, "FUNMYFUNC")


class TestUsingFormat(unittest.TestCase):

    def test_using_print(self):
        """USING is parsed inside PRINT statement, not standalone."""
        code = '10 PRINT USING "##.##"; 3.14159'
        ast, _ = compile_program(code)
        print_stmt = ast.lines[0].statements[0]
        self.assertIsInstance(print_stmt, AST.Print)
        # The USING command should be in the print items
        using_cmd = print_stmt.items[0]
        self.assertEqual(using_cmd.name, "USING")

    def test_dec_format(self):
        code = '10 S$ = DEC$(3.14, "##.##")'
        ast, _ = compile_program(code)
        fn = ast.lines[0].statements[0].source
        self.assertEqual(fn.name, "DEC$")
        self.assertEqual(len(fn.args), 2)
        self.assertTrue(AST.exptype_isstr(fn.args[1].etype))


class TestSound(unittest.TestCase):

    def test_sound_basic(self):
        code = "10 SOUND 1, 10, 100, 7"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "SOUND")
        # Parser adds defaults for missing optional params (total 7)
        self.assertEqual(len(cmd.args), 7)

    def test_sound_full_args(self):
        code = "10 SOUND 1, 10, 100, 7, 50, 10"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "SOUND")
        self.assertEqual(len(cmd.args), 7)

    def test_ent(self):
        code = "10 ENT 1, 10, -50, 10, 10, 50, 10"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ENT")
        self.assertEqual(len(cmd.args), 7)

    def test_env(self):
        code = "10 ENV 1, 100, 2, 20"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "ENV")
        self.assertEqual(len(cmd.args), 4)


class TestGraphics(unittest.TestCase):

    def test_plot(self):
        code = "10 PLOT 0, 100, 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "PLOT")

    def test_move(self):
        code = "10 MOVE 100, 200"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "MOVE")

    def test_draw(self):
        code = "10 DRAW 50, 50"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "DRAW")

    def test_fill(self):
        """FILL takes only one integer argument."""
        code = "10 FILL 100"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "FILL")
        self.assertEqual(len(cmd.args), 1)

    def test_frame(self):
        """FRAME takes no arguments."""
        code = "10 FRAME"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "FRAME")
        self.assertEqual(len(cmd.args), 0)


class TestDataReadWrite(unittest.TestCase):

    def test_data_read(self):
        code = """
10 DATA 1, 2, 3, "HELLO"
20 READ A
30 READ B
"""
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Data)
        self.assertEqual(ast.lines[1].statements[0].name, "READ")
        self.assertEqual(ast.lines[2].statements[0].name, "READ")

    def test_restore(self):
        code = "10 RESTORE 10"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "RESTORE")

    def test_write(self):
        code = '10 WRITE A$, A'
        ast, _ = compile_program(code)
        stmt = ast.lines[0].statements[0]
        self.assertIsInstance(stmt, AST.Write)


class TestMemory(unittest.TestCase):

    def test_poke(self):
        code = "10 POKE &4000, 255"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "POKE")

    def test_peek(self):
        code = "10 R = PEEK(&4000)"
        ast, _ = compile_program(code)
        fn = ast.lines[0].statements[0].source
        self.assertEqual(fn.name, "PEEK")

    def test_memory(self):
        code = "10 MEMORY &7000"
        ast, _ = compile_program(code)
        cmd = ast.lines[0].statements[0]
        self.assertEqual(cmd.name, "MEMORY")


class TestPointerAST(unittest.TestCase):
    """ Test the Pointer AST node type. """

    def test_pointer_expression(self):
        code = "10 A% = @B%"
        ast, _ = compile_program(code)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)
        src = ast.lines[0].statements[0].source
        self.assertEqual(src.id, "Pointer")


if __name__ == "__main__":
    unittest.main()
