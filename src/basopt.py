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
import re
import astlib as AST
import symbols as SYM

class BasOptimizer:
    def __init__(self) -> None:
        self.modified = False
        self.context = ""

    # ----------------- AST optimizations -----------------

    def _op_ASC(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.String):
            self.modified = True
            if node.args[0].value != "":
                nnode = AST.Integer(value = ord(node.args[0].value[0]))
            else:
                nnode = AST.Integer(value = 0)
            nnode.set_origin(node.line, node.col)
            return nnode
        return node

    def _op_CHRSS(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.Integer):
            self.modified = True
            nnode = AST.String(value=chr(node.args[0].value))
            nnode.line = node.args[0].line
            nnode.col = node.args[0].col
            return nnode
        return node

    def _op_CINT(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.Real):
            self.modified = True
            fvalue = node.args[0].value
            roff = -0.5 if fvalue < 0.0 else 0.5
            nnode = AST.Integer(value=int(fvalue + roff))
            nnode.line = node.args[0].line
            nnode.col = node.args[0].col
            return nnode
        elif isinstance(node.args[0], AST.Function) and node.args[0].name == "TIME":
            # Lets use the interger version of TIME
            self.modified = True
            node.args[0].etype = AST.ExpType.Integer
            return node.args[0]
        return node

    def _op_CREAL(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.Real):
            self.modified = True
            nnode = AST.Real(value=float(node.args[0].value))
            nnode.line = node.args[0].line
            nnode.col = node.args[0].col
            return nnode
        return node
    
    def _op_END_FUNCTION(self, node: AST.Command) -> AST.Statement:
        self.context = ""
        return node

    def _op_END_SUB(self, node: AST.Command) -> AST.Statement:
        self.context = ""
        return node

    def _op_FIX(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.Real):
            self.modified = True
            nnode = AST.Integer(value=int(node.args[0].value))
            nnode.line = node.args[0].line
            nnode.col = node.args[0].col
            return nnode
        return node

    def _op_FOR(self, node: AST.ForLoop) -> AST.Statement:
        node.start = self._op_statement(node.start)
        node.end = self._op_statement(node.end)
        if node.step is not None:
            node.step = self._op_statement(node.step)
        return node

    def _op_IF(self, node: AST.If) -> AST.Statement:
        node.condition = self._op_statement(node.condition)
        statements: list[AST.Statement] = []
        if len(node.inline_then):
            for st in node.inline_then:
                st = self._op_statement(st)
                statements.append(st)
            node.inline_then = statements
        if len(node.inline_else):
            statements = []
            for st in node.inline_else:
                st = self._op_statement(st)
                statements.append(st)
            node.inline_else = statements    
        return node

    def _op_INT(self, node: AST.Function) -> AST.Statement:
        if isinstance(node.args[0], AST.Real):
            self.modified = True
            num = node.args[0].value
            if num < 0.0:
                nnode = AST.Integer(value=int(node.args[0].value))
                nnode.line = node.args[0].line
                nnode.col = node.args[0].col
                return nnode
            else:
                nnode =  AST.Integer(value=int(node.args[0].value - 0.999999999))
                nnode.line = node.args[0].line
                nnode.col = node.args[0].col
                return nnode
        return node

    def _op_WHILE(self, node:AST.WhileLoop) -> AST.Statement:
        node.condition = self._op_statement(node.condition)
        return node

    def _op_variable(self, node: AST.Variable) -> AST.Statement:
        """ 
        Variables as part of expressions. Integer ones that are
        only assigned once can be optimized as constants.
        """
        entry = self.syms.find(node.name, SYM.SymType.Variable, self.context)
        if entry is not None and entry.writes == 1:
            if entry.const is not None:
                self.modified = True
                nnode = AST.Integer(value=entry.const)
                nnode.line = node.line
                nnode.col = node.col
                return nnode
        return node

    def _op_assignment(self, node: AST.Assignment) -> AST.Statement:
        node.source = self._op_statement(node.source)
        if isinstance(node.target, AST.Variable):
            if isinstance(node.source, AST.Integer):
                entry = self.syms.find(node.target.name, SYM.SymType.Variable, self.context)
                if entry is not None and entry.writes == 1 and entry.const is None:
                    entry.const = node.source.value
                    self.modified = True
                    nnode = AST.Nop()
                    nnode.line = node.line
                    nnode.col = node.col
                    return nnode
        return node

    def _op_binaryop(self, node: AST.BinaryOp) -> AST.Statement:
        literals = ("String", "Integer", "Real")
        if node.right.id in literals and node.left.id in literals:
            # We replace AND and OR by its bitwise Python operators
            command = f'''{repr(node.left.value)}'''   # type: ignore [attr-defined]
            command += f" {node.op} ".replace("AND", "&").replace("OR", "|").replace("MOD", "%").replace("\\", "//")
            command += f'''{repr(node.right.value)}''' # type: ignore [attr-defined]
            try:
                result = eval(command)                 
                self.modified = True
                nnode: AST.Statement = node
                if node.etype == AST.ExpType.String:
                    nnode = AST.String(value=str(result))
                elif node.etype == AST.ExpType.Real:
                    nnode = AST.Real(value=float(result))
                else:
                    if type(result) == bool:
                        result = -1 if result else 0
                    nnode = AST.Integer(value=int(result))
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

    def _op_keyword(self, stmt: AST.Command | AST.Function) -> AST.Statement:
        keyword = stmt.name
        funcname = "_op_" + keyword.replace('$','SS').replace(' ', '_')
        op_keyword_fn = getattr(self, funcname , None)
        if op_keyword_fn is not None:
            return op_keyword_fn(stmt)
        return stmt

    def _op_statement(self, stmt: AST.Statement) -> AST.Statement:
        if isinstance(stmt, AST.Variable):
            stmt = self._op_variable(stmt)
        elif isinstance(stmt, AST.BinaryOp):
            stmt = self._op_binaryop(stmt)
        elif isinstance(stmt, AST.Assignment):
            stmt = self._op_assignment(stmt)
        elif isinstance(stmt, AST.If):
            stmt = self._op_IF(stmt)
        elif isinstance(stmt, AST.ForLoop):
            stmt = self._op_FOR(stmt)
        elif isinstance(stmt, AST.WhileLoop):
            stmt = self._op_WHILE(stmt)
        elif isinstance(stmt, AST.Print):
            for i in range(0, len(stmt.items)):
                stmt.items[i] = self._op_statement(stmt.items[i])
        elif isinstance(stmt, AST.UserFun):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
        elif isinstance(stmt, AST.Function):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
            stmt = self._op_keyword(stmt)
        elif isinstance(stmt, AST.Command):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
            stmt = self._op_keyword(stmt)
        elif isinstance(stmt, AST.DefSUB):
            self.context = stmt.name
        elif isinstance(stmt, AST.DefFUN):
            self.context = stmt.name
        elif isinstance(stmt, AST.RSX):
            for i in range(0, len(stmt.args)):
                stmt.args[i] = self._op_statement(stmt.args[i])
        return stmt
      
    def optimize_ast(self, program: AST.Program, syms: SYM.SymTable) -> tuple[AST.Program, SYM.SymTable]:
        print("Optimizing expressions...")
        self.modified = True
        self.syms = syms
        while self.modified:
            self.modified = False
            for line in program.lines:
                for i in range(0, len(line.statements)):
                    line.statements[i] = self._op_statement(line.statements[i])
        return program, syms

    # ----------------- peephole optimizations -----------------


    _ph_rules = [
        (
            r"ld      hl,([&0-9a-fA-F]+).*:ld      a,l",
            r"ld      a,\1 & 0xFF"
        ),
        (
            r"ld      hl,([&0-9a-fA-F]+).*:ld      c,l(.*):ld      b,l(.*)",
            r"ld      c,\1 & 0xFF\n    ld      b,c"
        ),
        (
            r"ld      hl,([&0-9a-fA-F]+).*:ld      b,l",
            r"ld      b,\1 & 0xFF"
        ),
        (
            r"ld      hl,([&0-9a-fA-F]+).*:ld      c,l",
            r"ld      c,\1 & 0xFF"
        ),
        (
            r"ld      hl,(.*):push    hl(.*):ld      hl,(.*):pop     de",
            r"ld      hl,\1\n    ex      de,hl\n    ld      hl,\3"
        ),
        (
            r"push    bc(.*):ld      a,(.*):pop     bc",
            r"ld      a,\2"
        ),
        (
            r"pop     de:push    de:ex      de,hl",
            r"ex      de,hl"
        ),
        (
            r"ld      hl,([&0-9a-fA-F]+).*:ld      e,l(.*):dec     e",
            r"ld      e,(\1 & 0xFF)-1"
        ),
    ]

    def optimize_peephole(self, code: str) -> str:
        print("Optimizing assembly code...")
        # apply peephole rules
        for pattern, optcode in self._ph_rules:
            regex = pattern.replace(r":", r"[\r\n]+\s*")
            expr = re.compile(regex, flags=re.IGNORECASE)

            code = re.sub(expr, optcode, code)
        return code
