"""
AST-level optimizer tests.

From project source directory:

python -m unittest test/test_ast_opt.py
"""

import unittest
from test.fixtures import compile_program, compile_and_optimize
import astlib as AST


class TestConstantFolding(unittest.TestCase):
    """ Test that binary operations with literal operands are folded to constants.
    We use PRINT statements so the DCE pass does not remove single-write assignments.
    """

    def test_integer_add(self):
        code = "10 PRINT 5 + 3"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Integer)
        self.assertEqual(result.value, 8)

    def test_integer_sub(self):
        code = "10 PRINT 10 - 3"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 7)

    def test_integer_mul(self):
        code = "10 PRINT 4 * 3"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 12)

    def test_integer_div_backslash(self):
        code = "10 PRINT 10 \\ 3"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 3)

    def test_mod(self):
        code = "10 PRINT 10 MOD 3"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 1)

    def test_pow(self):
        code = "10 PRINT 2 ^ 5"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 32)

    def test_pow_zero_exponent(self):
        code = "10 PRINT 5 ^ 0"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 1)

    def test_pow_zero_base(self):
        code = "10 PRINT 0 ^ 5"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 0)

    def test_and_bitwise(self):
        code = "10 PRINT 5 AND 3"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 1)

    def test_and_false(self):
        code = "10 PRINT 1 AND 0"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 0)

    def test_or_bitwise(self):
        code = "10 PRINT 5 OR 2"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 7)

    def test_real_add(self):
        code = "10 PRINT 2.5 + 1.5"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Real)
        self.assertAlmostEqual(result.value, 4.0)

    def test_real_div(self):
        code = "10 PRINT 5.0 / 2.0"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Real)
        self.assertAlmostEqual(result.value, 2.5)

    def test_string_concat(self):
        code = '10 PRINT "A" + "B" + "C"'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.String)
        self.assertEqual(result.value, "ABC")

    def test_mixed_int_real(self):
        code = "10 PRINT 5 + 2.5"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Real)
        self.assertAlmostEqual(result.value, 7.5)

    def test_nested_folding(self):
        """ (5 + 3) * 2 should fold to 16 """
        code = "10 PRINT (5 + 3) * 2"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 16)

    def test_no_fold_with_variable(self):
        """ 5 + X should NOT fold when X is multi-write; stays as BinaryOp """
        code = "10 X = 1\n20 X = X + 1\n30 PRINT 5 + X"
        ast, _ = compile_and_optimize(code)
        stmt = ast.lines[2].statements[0].items[0]
        self.assertIsInstance(stmt, AST.BinaryOp)

    def test_const_folds_and_assignment_becomes_nop(self):
        """ When a single-write constant is used in PRINT, it replaces. """
        code = "10 A = 5\n20 PRINT A + 3"
        ast, _ = compile_and_optimize(code)
        # Line 10: A=5 becomes Nop (single-write const)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Nop)
        # Line 20: A replaced by 5, 5+3 = 8
        self.assertEqual(ast.lines[1].statements[0].items[0].value, 8)


class TestFunctionConstantFold(unittest.TestCase):
    """ Test that functions with constant arguments are folded. """

    def test_asc_literal(self):
        code = '10 PRINT ASC("H")'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Integer)
        self.assertEqual(result.value, 72)

    def test_asc_empty_string(self):
        code = '10 PRINT ASC("")'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Integer)
        self.assertEqual(result.value, 0)

    def test_asc_not_folded_with_var(self):
        code = '10 S$ = "H"\n20 S$ = S$ + "X"\n30 PRINT ASC(S$)'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[2].statements[0].items[0]
        self.assertIsInstance(result, AST.Function)
        self.assertEqual(result.name, "ASC")

    def test_chrss_literal(self):
        code = '10 PRINT CHR$(65)'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.String)
        self.assertEqual(result.value, "A")

    def test_chrss_not_folded_with_var(self):
        code = '10 R = 65\n20 R = R + 1\n30 PRINT CHR$(R)'
        ast, _ = compile_and_optimize(code)
        result = ast.lines[2].statements[0].items[0]
        self.assertIsInstance(result, AST.Function)

    def test_cint_from_real(self):
        code = "10 PRINT CINT(3.7)"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Integer)
        self.assertEqual(result.value, 4)

    def test_cint_from_real_negative(self):
        code = "10 PRINT CINT(-2.3)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, -2)

    def test_cint_from_integer(self):
        code = "10 PRINT CINT(5)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 5)

    def test_creal_from_integer(self):
        code = "10 PRINT CREAL(5)"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Real)
        self.assertAlmostEqual(result.value, 5.0)

    def test_creal_from_real(self):
        code = "10 PRINT CREAL(3.14)"
        ast, _ = compile_and_optimize(code)
        result = ast.lines[0].statements[0].items[0]
        self.assertIsInstance(result, AST.Real)
        self.assertAlmostEqual(result.value, 3.14)

    def test_fix_positive(self):
        code = "10 PRINT FIX(3.7)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 3)

    def test_fix_negative(self):
        code = "10 PRINT FIX(-3.7)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, -3)

    def test_int_positive(self):
        code = "10 PRINT INT(3.7)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 3)

    def test_int_negative(self):
        code = "10 PRINT INT(-3.7)"
        ast, _ = compile_and_optimize(code)
        # INT uses floor (toward negative infinity), so -3.7 -> -4
        self.assertEqual(ast.lines[0].statements[0].items[0].value, -4)

    def test_int_of_integer(self):
        code = "10 PRINT INT(5)"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 5)

    def test_nested_function_fold(self):
        """ ASC(CHR$(65)) should fold to 65. """
        code = "10 PRINT ASC(CHR$(65))"
        ast, _ = compile_and_optimize(code)
        self.assertEqual(ast.lines[0].statements[0].items[0].value, 65)


class TestDeadCodeElimination(unittest.TestCase):
    """ Test that single-write constant variables are eliminated. """

    def test_const_variable_eliminated(self):
        """
        A variable written once with a constant and used later should be
        replaced by that constant. The assignment becomes Nop.
        """
        code = "10 A = 5\n20 R = A + 3"
        ast, _ = compile_and_optimize(code)
        # Line 10: assignment of A=5 becomes Nop
        self.assertIsInstance(ast.lines[0].statements[0], AST.Nop)
        # Line 20: R = 8, R is also single-write so also Nop
        self.assertIsInstance(ast.lines[1].statements[0], AST.Nop)

    def test_multi_write_not_eliminated(self):
        """ Variable written twice should NOT be eliminated. """
        code = "10 A = 5\n20 A = 10\n30 R = A"
        ast, _ = compile_and_optimize(code)
        # First assignment stays as Assignment (not Nop)
        self.assertIsInstance(ast.lines[0].statements[0], AST.Assignment)

    def test_const_command(self):
        """ CONST declares a variable that is used and can be optimized. """
        code = "10 CONST A = 5\n20 R = A + 3"
        ast, syms = compile_and_optimize(code)
        # A should be replaced by constant in usage
        self.assertIsInstance(ast.lines[1].statements[0], AST.Nop)

    def test_array_item_not_eliminated(self):
        """ Array assignments should not cause elimination issues. """
        code = "10 DIM A(10)\n20 A(0) = 5\n30 R = A(0)"
        ast, _ = compile_and_optimize(code)
        # Should not crash, and the array item stays as is
        self.assertIsInstance(ast.lines[1].statements[0], AST.Assignment)


class TestPeepholeRemaining(unittest.TestCase):
    """ Test remaining peephole optimization rules. """

    def test_ldhl_pushhl_ldhl_popde(self):
        from basopt import BasOptimizer
        source = (
            "    ld      hl,0\n"
            "    push    hl\n"
            "    ld      hl,(G_VAR_J)\n"
            "    pop     de\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ex      de,hl", result)

    def test_ldhl0_addhlhl(self):
        from basopt import BasOptimizer
        source = (
            "    ld      hl,0\n"
            "    add     hl,hl\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ld      hl,0", result)
        self.assertNotIn("add     hl,hl", result)

    def test_ldhl0_ldde_addhlde(self):
        from basopt import BasOptimizer
        source = (
            "    ld      hl,0\n"
            "    ld      de,256\n"
            "    add     hl,de\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ld      hl,256", result)

    def test_ldhl_lde_dece(self):
        from basopt import BasOptimizer
        source = (
            "    ld      hl,10\n"
            "    ld      e,l\n"
            "    dec     e\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ld      e,(10 & 0xFF)-1", result)

    def test_pushbc_lda_popbc(self):
        from basopt import BasOptimizer
        source = (
            "    push    bc\n"
            "    ld      a,(ix+5)\n"
            "    pop     bc\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ld      a,(ix+5)", result)
        self.assertNotIn("push    bc", result)
        self.assertNotIn("pop     bc", result)

    def test_popde_pushde_ex(self):
        from basopt import BasOptimizer
        source = (
            "    pop     de\n"
            "    push    de\n"
            "    ex      de,hl\n"
        )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source)
        self.assertIn("ex      de,hl", result)
        self.assertNotIn("pop     de", result)
        self.assertNotIn("push    de", result)


if __name__ == "__main__":
    unittest.main()
