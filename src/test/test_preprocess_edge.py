"""
Preprocessor edge case tests.

From project source directory:

python3 -m unittest test/test_preprocess_new.py
"""

import unittest
import os
import tempfile
from baserror import BasError
from baspp import LocBasPreprocessor


def preprocess(code: str, increment: int = 10) -> tuple:
    """Helper to preprocess code and return (codelines, finalcode)."""
    pp = LocBasPreprocessor()
    return pp.preprocess("TEST.BAS", code, increment)


class TestLineNumberGeneration(unittest.TestCase):

    def test_no_line_numbers_auto_assign(self):
        """ Lines without numbers get auto-assigned. """
        program = "CLS\nPRINT \"A\"\nEND"
        _, code = preprocess(program)
        lines = code.strip().split('\n')
        self.assertEqual(len(lines), 3)
        self.assertTrue(lines[0].startswith("10 "))
        self.assertTrue(lines[1].startswith("20 "))
        self.assertTrue(lines[2].startswith("30 "))

    def test_mixed_line_numbers(self):
        """ Mix of explicit and auto line numbers. """
        program = "10 CLS\nPRINT \"A\"\n50 END"
        _, code = preprocess(program)
        lines = code.strip().split('\n')
        self.assertEqual(len(lines), 3)
        self.assertTrue(lines[0].startswith("10 "))
        # Auto number after explicit 10: autonum = 10+10 = 20, then 20+10 = 30
        self.assertTrue(lines[1].startswith("30 "))
        self.assertTrue(lines[2].startswith("50 "))

    def test_explicit_line_number_order_must_increase(self):
        """ Line numbers going backward should raise error. """
        program = "50 CLS\n10 PRINT \"A\""
        with self.assertRaises(BasError):
            preprocess(program)

    def test_line_number_less_than_auto(self):
        """ Explicit number less than auto-generated should error. """
        program = "100 CLS\nPRINT \"A\"\n50 END"
        with self.assertRaises(BasError):
            preprocess(program)

    def test_increment_value_1(self):
        """ Custom increment of 1. """
        program = "CLS\nPRINT \"A\"\nEND"
        _, code = preprocess(program, increment=1)
        lines = code.strip().split('\n')
        self.assertTrue(lines[0].startswith("1 "))
        self.assertTrue(lines[1].startswith("2 "))
        self.assertTrue(lines[2].startswith("3 "))

    def test_increment_value_5(self):
        """ Custom increment of 5. """
        program = "CLS\nPRINT \"A\"\nEND"
        _, code = preprocess(program, increment=5)
        lines = code.strip().split('\n')
        self.assertTrue(lines[0].startswith("5 "))
        self.assertTrue(lines[1].startswith("10 "))
        self.assertTrue(lines[2].startswith("15 "))

    def test_only_explicit_numbers(self):
        """ All lines have explicit numbers; they must be in order. """
        program = "10 CLS\n20 PRINT \"A\"\n30 END"
        _, code = preprocess(program)
        lines = code.strip().split('\n')
        self.assertEqual(lines[0], "10 CLS")
        self.assertEqual(lines[1], "20 PRINT \"A\"")
        self.assertEqual(lines[2], "30 END")


class TestLineHandling(unittest.TestCase):

    def test_empty_lines_ignored(self):
        """ Empty lines should be skipped. """
        program = "\nCLS\n\nPRINT \"A\"\n\n"
        _, code = preprocess(program)
        lines = [l for l in code.strip().split('\n') if l.strip()]
        self.assertEqual(len(lines), 2)

    def test_whitespace_only_lines_ignored(self):
        """ Lines with only whitespace should be skipped. """
        program = "   \nCLS\n   \nPRINT \"A\""
        _, code = preprocess(program)
        lines = [l for l in code.strip().split('\n') if l.strip()]
        self.assertEqual(len(lines), 2)

    def test_leading_trailing_spaces_preserved_in_code(self):
        """ Spaces within the code should be preserved. """
        program = "  CLS  "
        _, code = preprocess(program)
        # After preprocessing, line should have content
        lines = [l for l in code.strip().split('\n') if l.strip()]
        self.assertIn("CLS", lines[0])


class TestChainMerge(unittest.TestCase):

    def test_chain_merge_file_not_found(self):
        """ CHAIN MERGE with non-existent file should error. """
        program = 'CHAIN MERGE "NONEXISTENT.BAS"'
        with self.assertRaises(BasError):
            preprocess(program)

    def test_chain_merge_successful(self):
        """ CHAIN MERGE with valid file should include its content. """
        with tempfile.NamedTemporaryFile(mode='w', suffix='.bas', delete=False) as f:
            f.write('10 REM INCLUDED\n')
            f.write('20 PRINT "FROM INCLUDE"\n')
            tmpfile = f.name
        try:
            program = f'CHAIN MERGE "{tmpfile}"\nPRINT "MAIN"'
            _, code = preprocess(program)
            self.assertIn("REM INCLUDED", code)
            self.assertIn("FROM INCLUDE", code)
            self.assertIn("MAIN", code)
        finally:
            os.unlink(tmpfile)

    def test_chain_merge_multiple_includes(self):
        """ Multiple CHAIN MERGE statements should work. """
        with tempfile.NamedTemporaryFile(mode='w', suffix='.bas', delete=False) as f1:
            f1.write('10 REM FILE1\n')
            tmpfile1 = f1.name
        with tempfile.NamedTemporaryFile(mode='w', suffix='.bas', delete=False) as f2:
            f2.write('20 REM FILE2\n')
            tmpfile2 = f2.name
        try:
            program = (
                f'CHAIN MERGE "{tmpfile1}"\n'
                f'CHAIN MERGE "{tmpfile2}"\n'
                'PRINT "DONE"'
            )
            _, code = preprocess(program)
            self.assertIn("REM FILE1", code)
            self.assertIn("REM FILE2", code)
            self.assertIn("DONE", code)
        finally:
            os.unlink(tmpfile1)
            os.unlink(tmpfile2)

    def test_chain_merge_missing_quotes(self):
        """ CHAIN MERGE without string literal should error. """
        program = "CHAIN MERGE"
        with self.assertRaises(BasError):
            preprocess(program)

    def test_chain_merge_nested(self):
        """ A file that includes another file that includes a third. """
        with tempfile.NamedTemporaryFile(mode='w', suffix='.bas', delete=False) as f3:
            f3.write('10 REM DEEP\n')
            tmpfile3 = f3.name
        with tempfile.NamedTemporaryFile(mode='w', suffix='.bas', delete=False) as f2:
            f2.write(f'CHAIN MERGE "{tmpfile3}"\n')
            f2.write('20 REM MIDDLE\n')
            tmpfile2 = f2.name
        try:
            program = f'CHAIN MERGE "{tmpfile2}"\n30 REM MAIN'
            _, code = preprocess(program)
            self.assertIn("REM DEEP", code)
            self.assertIn("REM MIDDLE", code)
            self.assertIn("REM MAIN", code)
        finally:
            os.unlink(tmpfile2)
            os.unlink(tmpfile3)


class TestEdgeCases(unittest.TestCase):

    def test_empty_file(self):
        """ Empty source should raise error. """
        with self.assertRaises(BasError):
            pp = LocBasPreprocessor()
            pp.preprocess_file("NONEXISTENT.BAS", 10)

    def test_nonexistent_file(self):
        """ File that doesn't exist should raise error. """
        with self.assertRaises(BasError):
            pp = LocBasPreprocessor()
            pp.preprocess_file("NONEXISTENT_FILE_THAT_DOES_NOT_EXIST.BAS", 10)

    def test_invalid_increment(self):
        """ Increment less than 1 should error. """
        with self.assertRaises(BasError):
            pp = LocBasPreprocessor()
            pp.preprocess_file("NONEXISTENT.BAS", 0)

    def test_windows_line_endings(self):
        """ Windows-style CRLF should be handled. """
        program = "CLS\r\nPRINT \"A\"\r\nEND"
        _, code = preprocess(program)
        lines = [l for l in code.strip().split('\n') if l.strip()]
        self.assertEqual(len(lines), 3)

    def test_mac_line_endings(self):
        """ Old-style CR line endings should be handled. """
        program = "CLS\rPRINT \"A\"\rEND"
        _, code = preprocess(program)
        lines = [l for l in code.strip().split('\n') if l.strip()]
        self.assertEqual(len(lines), 3)


if __name__ == "__main__":
    unittest.main()
