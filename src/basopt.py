"""
Applies some optimizations to an Abstract Syntatic Tree (AST)
and, as a result, returns a modified AST ready for code generation 

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
"""

from __future__ import annotations
from typing import List, Optional, cast, Any
import astlib as AST
import symbols as SYM

# NOTE: list of possible optimizations
# - UnaryOp MINUS with Real or Integer literal, store just the resulting number

class BasOptimizer:
    def __init__(self) -> None:
        self.modified = False

    def _op_binaryop(self, node: AST.BinaryOp) -> AST.Statement:
        literals = ("String", "Integer", "Real")
        if node.right.id in literals and node.left.id in literals:
            command = f'''{repr(node.left.value)} {node.op} {repr(node.right.value)}''' # type: ignore[attr-defined]
            try:
                result = eval(command)                 
                self.modified = True
                nnode: AST.Statement = node
                if type(result) == str:
                    nnode = AST.String(value=result)
                if type(result) == int:
                    nnode = AST.Integer(value=result)
                if type(result) == float:
                    nnode = AST.Real(value=result)
                if type(result) == bool:
                    result = -1 if result else 0
                    nnode = AST.Integer(value=result)
                nnode.line = node.line
                nnode.col = node.col
                return nnode
            except:
                return node
        # functions calls, variables, etc.
        if node.right.id not in literals:
            node.right = self._op_statement(node.right)
        if node.left.id not in literals:
            node.left = self._op_statement(node.left)    
        return node 

    # ----------------- AST Trasversal functions -----------------

    def _op_statement(self, stmt: AST.Statement) -> AST.Statement:
        if isinstance(stmt, AST.BinaryOp):
            stmt = self._op_binaryop(stmt)
        if isinstance(stmt, AST.Assignment):
            stmt.source = self._op_statement(stmt.source)
        elif isinstance(stmt, AST.If):
            stmt.condition = self._op_statement(stmt.condition)
        elif isinstance(stmt, AST.ForLoop):
            stmt.start = self._op_statement(stmt.start)
            stmt.end = self._op_statement(stmt.end)
            if stmt.step is not None: stmt.step = self._op_statement(stmt.step)
        elif isinstance(stmt, AST.WhileLoop):
            stmt.condition = self._op_statement(stmt.condition)
        elif isinstance(stmt, AST.Print):
            for i in range(0, len(stmt.items)):
                stmt.items[i] = self._op_statement(stmt.items[i])
        elif isinstance(stmt, AST.UserFun):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
        elif isinstance(stmt, AST.Function):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
        elif isinstance(stmt, AST.Command):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
        return stmt
      
    def optimize_ast(self, program: AST.Program, syms: SYM.SymTable) -> tuple[AST.Program, SYM.SymTable]:
        print("Optimizing expressions...")
        self.modified = True
        while self.modified:
            self.modified = False
            for line in program.lines:
                for i in range(0, len(line.statements)):
                    line.statements[i] = self._op_statement(line.statements[i])
        return program, syms
