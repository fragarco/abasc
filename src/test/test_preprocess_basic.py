"""
From project source directory:

python3 -m unittest test/test_lexer.py
"""

import unittest
from baserror import BasError
from baspp import LocBasPreprocessor

class TestPreprocess(unittest.TestCase):

    def _preprocess(self, program: str):
        pp = LocBasPreprocessor()
        return pp.preprocess("TEST.BAS", program, 10)

    def test_adding_linenumbers(self):
        program="""
CLS
A = 5
IF A=5 THEN
    PRINT A
END
"""
        expected="""10 CLS
20 A = 5
30 IF A=5 THEN
40 PRINT A
50 END
"""
        _, code = self._preprocess(program)
        self.assertEqual(expected, code)

    def test_fail_insertfile(self):
        program='''CHAIN MERGE "ANOTHERFILE.BAS"'''
        with self.assertRaises(BasError):
            self._preprocess(program)

if __name__ == "__main__":
    unittest.main()