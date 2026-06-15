"""
Emitter structural tests: verify ASM output patterns, data sections, runtime imports.

From project source directory:

python3 -m unittest test/test_emitter_struct.py
"""

import unittest
from baspp import LocBasPreprocessor
from baslex import LocBasLexer
from basparse import LocBasParser
from baserror import WarningLevel as WL
from emitters.cpcemitter import CPCEmitter
from typing import Tuple

def compile_to_asm(code: str) -> Tuple[str, list, object]:
    """
    Compile BASIC code to ASM, returning (asm_code, codelines, emitter).
    This runs through preprocess -> lex -> parse -> emit pipeline.
    """
    # Preprocess to get codelines
    pp = LocBasPreprocessor()
    codelines, processed = pp.preprocess("TEST.BAS", code, 10)

    # Lex
    lx = LocBasLexer(processed)
    tokens = list(lx.tokens())

    # Parse
    parser = LocBasParser(codelines, tokens, warning_level=WL.ALL)
    ast, symtable = parser.parse_program()

    # Emit
    emitter = CPCEmitter(codelines, ast, symtable)
    emitter.cfgset_wlevel(WL.ALL)
    emitter.cfgset_verbose(False)
    asm_code, heapused = emitter.emit_program()

    return asm_code, codelines, emitter


class TestEmitterASM(unittest.TestCase):

    def test_minimal_program(self):
        """ A minimal program should produce valid ASM with startup and end labels. """
        asm, _, _ = compile_to_asm("10 END")
        self.assertIn("_startup_:", asm)
        self.assertIn("_code_end_:", asm)

    def test_for_loop_labels(self):
        """ FOR...NEXT should generate forloop labels. """
        code = "10 FOR I = 1 TO 10\n20 PRINT I\n30 NEXT"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("__forloop_start", asm)
        self.assertIn("__forloop_end", asm)

    def test_while_loop_labels(self):
        """ WHILE...WEND should generate whileloop labels. """
        code = "10 WHILE I < 10\n20 I = I + 1\n30 WEND"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("__whileloop_start", asm)
        self.assertIn("__whileloop_end_", asm)

    def test_if_else_labels(self):
        """ IF...ELSE...END IF should generate if labels. """
        code = "10 A% = 5\n20 IF A% > 3 THEN\n30 PRINT A%\n40 ELSE\n50 PRINT 0\n60 END IF"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("__if_else_", asm)
        self.assertIn("__if_end", asm)

    def test_variable_declaration(self):
        """ Variables should be declared in the data section with correct sizes. """
        code = "10 A% = 5\n20 B$ = \"HELLO\"\n30 C! = 3.14"
        asm, _, _ = compile_to_asm(code)
        # Integer: 2 bytes, String: 255 bytes, Real: 5 bytes
        self.assertIn("defs 2", asm)
        self.assertIn("defs 255", asm)
        self.assertIn("defs 5", asm)

    def test_array_declaration(self):
        """ Arrays should be declared with correct total size. """
        code = "10 DIM A(4)\n20 A(0) = 1"
        asm, _, _ = compile_to_asm(code)
        # Array A(4) of integers: 5 elements * 2 bytes = 10
        self.assertIn("defs 10", asm)

    def test_array_multidim(self):
        """ Multidimensional arrays: DIM A(2,3) = 3*4 = 12 elements * 2 = 24 bytes. """
        code = "10 DIM A(2,3)\n20 A(0,0) = 1"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("defs 24", asm)

    def test_string_constant_in_data(self):
        """ String literals should appear in the data section. """
        code = '10 PRINT "HELLO"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("HELLO", asm)

    def test_label_generation_format(self):
        """ Variable labels should follow the G_VAR_X pattern. """
        code = "10 MYVAR = 5"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("G_VAR_MYVAR", asm)

    def test_for_loop_variable_in_data(self):
        """ FOR loop variables should have labels in data section. """
        code = "10 FOR I = 1 TO 10\n20 NEXT"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("G_VAR_I", asm)


class TestRuntimeImports(unittest.TestCase):
    """ Test that runtime functions are correctly imported when needed. """

    def test_sqr_imports_math(self):
        """ Using SQR() should import math runtime. """
        code = "10 R! = SQR(4)"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_math_call", asm)

    def test_string_operation_imports_malloc(self):
        """ String concatenation should import malloc runtime. """
        code = '10 S$ = "A" + "B"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_malloc", asm)

    def test_sin_imports_math(self):
        """ SIN() should import math runtime. """
        code = "10 R! = SIN(0)"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_math_call", asm)

    def test_cos_imports_math(self):
        code = "10 R! = COS(0)"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_math_call", asm)

    def test_atn_imports_math(self):
        code = "10 R! = ATN(1)"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_math_call", asm)


class TestEmitterEdgeCases(unittest.TestCase):

    def test_empty_program(self):
        """ A program with just END should not crash. """
        asm, _, _ = compile_to_asm("10 END")
        self.assertIsInstance(asm, str)
        self.assertGreater(len(asm), 0)

    def test_unused_sub_not_emitted(self):
        """ SUB that is never called should not generate code. """
        code = """
10 SUB UNUSED
20    PRINT "NEVER"
30 END SUB
40 END
"""
        asm, _, _ = compile_to_asm(code)
        # The SUB should not be emitted since it's never called
        self.assertNotIn("SUBUNUSED", asm)

    def test_called_sub_is_emitted(self):
        """ SUB that IS called should generate code. """
        code = """
10 SUB DOIT
20    PRINT "HELLO"
30 END SUB
40 CALL DOIT()
"""
        asm, _, _ = compile_to_asm(code)
        self.assertIn("SUBDOIT", asm)

    def test_unused_function_not_emitted(self):
        """ FUNCTION that is never called should not generate code. """
        code = """
10 FUNCTION UNUSED
20    UNUSED = 0
30 END FUNCTION
40 END
"""
        asm, _, _ = compile_to_asm(code)
        self.assertNotIn("FNUNUSED", asm)

    def test_events_generate_timer_code(self):
        """ Programs with events should include timer runtime. """
        code = "10 AFTER 10 GOSUB 20\n20 PRINT \"TICK\""
        asm, _, _ = compile_to_asm(code)
        self.assertIn("rt_timer", asm)

    def test_real_constant_serialization(self):
        """ Real constants should be serialized as 5-byte data. """
        code = "10 R! = 3.14"
        asm, _, _ = compile_to_asm(code)
        # The emitter generates __const_real labels for real constants
        self.assertIn("__const_real", asm)

    def test_print_separator_comma(self):
        """ PRINT with comma separator should work. """
        code = '10 PRINT "A", "B"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("A", asm)
        self.assertIn("B", asm)

    def test_print_separator_semicolon(self):
        """ PRINT with semicolon separator should work. """
        code = '10 PRINT "A"; "B"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("A", asm)
        self.assertIn("B", asm)


class TestEmitterDataSection(unittest.TestCase):

    def test_data_section_has_label(self):
        """ The data section should have a _data_ label. """
        code = '10 PRINT "TEST"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("_data_:", asm)

    def test_data_addresses_respected(self):
        """ Data should be placed at the configured address. """
        code = "10 END"
        asm, _, _ = compile_to_asm(code)
        # Data section should reference the data address
        self.assertIn("&4000", asm)


class TestEmitterSymbolTable(unittest.TestCase):

    def test_variable_size_integer(self):
        """ Integer variables should use defs 2. """
        code = "10 A% = 5"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("G_VAR_A_I:", asm)
        self.assertIn("defs 2", asm)

    def test_variable_size_string(self):
        """ String variables should use defs 255. """
        code = '10 A$ = "HELLO"'
        asm, _, _ = compile_to_asm(code)
        self.assertIn("G_VAR_A_S:", asm)
        self.assertIn("defs 255", asm)

    def test_variable_size_real(self):
        """ Real variables should use defs 5. """
        code = "10 A! = 3.14"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("G_VAR_A_R:", asm)
        self.assertIn("defs 5", asm)

    def test_array_string_size(self):
        """ String arrays: DIM A$(4) = 5 elements * 255 bytes. """
        code = "10 DIM A$(4)\n20 A$(0) = \"X\""
        asm, _, _ = compile_to_asm(code)
        self.assertIn("defs 1275", asm)

    def test_label_after_line_number(self):
        """ GOTO targets should create labels. """
        code = "10 GOTO 20\n20 END"
        asm, _, _ = compile_to_asm(code)
        self.assertIn("__label_20", asm)


if __name__ == "__main__":
    unittest.main()
