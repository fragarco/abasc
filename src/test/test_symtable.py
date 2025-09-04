"""
From project source directory:

python3 -m unittest test/test_symtable.py
"""

import unittest
from symbols import SymTable, SymEntry, SymType
import astlib as AST

class TestSymTable(unittest.TestCase):

    def test_add_find_var_basic(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Variable,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        inserted = symt.add(ident="I", info=info, context="")
        self.assertTrue(inserted)
        entry = symt.find("I")
        self.assertTrue(entry is not None)

    def test_writes_basic(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Variable,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        inserted = symt.add(ident="I", info=info)
        self.assertTrue(inserted)
        inserted = symt.add(ident="I", info=info)
        self.assertTrue(inserted)
        entry = symt.find("I")
        self.assertEqual(entry.writes, 2)

    def test_writes_symtype_error(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Function,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        inserted = symt.add(ident="FNpow", info=info)
        self.assertTrue(inserted)
        inserted = symt.add(ident="FNpow", info=info)
        self.assertFalse(inserted)

    def test_writes_vartype_error(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Variable,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        inserted = symt.add(ident="I", info=info)
        self.assertTrue(inserted)
        info.exptype = AST.ExpType.Real
        inserted = symt.add(ident="I", info=info)
        self.assertFalse(inserted)

    def test_locals_basic(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Function,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        symt.add(ident="FNpow", info=info)
        info.symtype = SymType.Variable
        symt.add("I", info, context="FNpow")
        # I is not available in the global context
        sym = symt.find(ident="I", context="")
        self.assertTrue(sym is None)
        # I is available in the local context
        sym = symt.find(ident="I", context="FNpow")
        self.assertTrue(sym is not None)
        # Global A is avaiable in the local context
        symt.add(ident="A", info=info, context="")
        sym1 = symt.find(ident="A", context="FNpow")
        sym2 = symt.find(ident="A", context="")
        self.assertEqual(sym1, sym2)

    def test_local_precedence(self):
        symt = SymTable()
        info = SymEntry(
            symtype = SymType.Function,
            exptype = AST.ExpType.Integer,
            locals = SymTable()
        )
        symt.add(ident="FNpow", info=info)
        # Same identifier can exist in global and
        # local contexts being a different entity
        # Local has precedence over global
        info.symtype = SymType.Variable
        symt.add("I", info, context="FNpow")
        info.exptype = AST.ExpType.Real
        symt.add("I", info, context="")

        sym = symt.find(ident="I", context="")
        self.assertEqual(sym.exptype, AST.ExpType.Real)
        sym = symt.find(ident="I", context="FNpow")
        self.assertEqual(sym.exptype, AST.ExpType.Integer)

if __name__ == "__main__":
    unittest.main()
