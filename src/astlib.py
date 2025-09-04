r"""
Abstract Sintax Tree (AST) nodes and auxiliary methods.

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
from typing import Optional
from enum import Enum
import json

class ExpType(str, Enum):
    """ Nodes related to expressions have a result type """
    Void = "Void",
    Integer = "Integer",
    Real = "Real",
    String = "String",
    Mismatch = "Mismatch",
    
def exptype_derive(op1: "Statement", op2: "Statement") -> ExpType:
    if ExpType.String in (op1.etype, op2.etype):
        """ String literals can be mixed only with other strings """
        if op1.etype != op2.etype:
            return ExpType.Mismatch
        return ExpType.String
    if ExpType.Real in (op1.etype, op2.etype):
        """ By default any operations with reals will result in real """
        return ExpType.Real
    return ExpType.Integer

def exptype_fromname(ident: str) -> ExpType:
    if "!" in ident:
        return ExpType.Real
    elif "$" in ident:
        return ExpType.String
    return ExpType.Integer

def exptype_isnum(etype: ExpType) -> bool:
    return etype in (ExpType.Integer, ExpType.Real)

def exptype_isint(etype: ExpType) -> bool:
    return etype == ExpType.Integer

def exptype_isreal(etype: ExpType) -> bool:
    return etype == ExpType.Real

def exptype_isstr(etype: ExpType) -> bool:
    return etype == ExpType.String

def exptype_isvalid(etype: ExpType) -> bool:
    return etype in (ExpType.Integer, ExpType.Real, ExpType.String)

# ---------- Basic Tree Nodes ----------

class ASTNode:
    id: str

    def __init__(self, id: str):
        self.id = id

class Program(ASTNode):
    lines: list["Line"]

    def __init__(self, lines: list["Line"]):
        super().__init__(id="Program")
        self.lines = lines

class Line(ASTNode):
    number: int
    statements: list["Statement"]

    def __init__(self, number: int, statements: list["Statement"]):
        super().__init__(id="Line")
        self.number=number
        self.statements=statements

class Statement(ASTNode):
    etype: ExpType

    def __init__(self, etype: ExpType, id: str):
        super().__init__(id=id)
        self.etype = etype

class Nop(Statement):
    """ can be used to return something after an error occurred """

    def __init__(self):
        super().__init__(etype=ExpType.Void, id="NOP")

# ---------- Expresions ----------

class Assignment(Statement):
    target: Statement
    source: Statement
    id: str = "Assignment"

    def __init__(self, target: Statement, source: Statement, etype: ExpType):
        super().__init__(etype=etype, id="Assignment")
        self.target = target
        self.source = source

class BinaryOp(Statement):
    op: str
    left: Statement
    right: Statement

    def __init__(self, op: str, left: Statement, right: Statement, etype: ExpType):
        super().__init__(etype=etype, id="BinaryOp")
        self.left = left
        self.right = right
        self.op = op

class UnaryOp(Statement):
    op: str
    operand: Statement

    def __init__(self, op: str, operand: Statement, etype: ExpType):
        super().__init__(etype=etype, id="UnaryOp")
        self.operand = operand
        self.op = op

class Range(Statement):
    low: str | int
    high: str | int

    def __init__(self, low: int | str, high: int | str, etype: ExpType):
        super().__init__(etype=etype, id="Range")
        self.low = low
        self.high = high

class Integer(Statement):
    value: int

    def __init__(self, value: int):
        super().__init__(etype=ExpType.Integer, id="Integer")
        self.value = value

class Real(Statement):
    value: float

    def __init__(self, value: float):
        super().__init__(etype=ExpType.Real, id="Real")
        self.value = value

class String(Statement):
    value: str

    def __init__(self, value: str):
        super().__init__(etype=ExpType.String, id="String")
        self.value = value

class Variable(Statement):
    name: str

    def __init__(self, name: str, etype: ExpType):
        super().__init__(etype=etype, id="Variable")
        self.name = name
    
class Array(Statement):
    name: str
    sizes: list[int]

    def __init__(self, name: str, etype: ExpType, sizes: list[int]):
        super().__init__(etype=etype, id="Array")
        self.name = name
        self.sizes = sizes

class ArrayItem(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement]):
        super().__init__(etype=etype, id="ArrayItem")
        self.name = name
        self.args = args

class Pointer(Statement):
    var: Variable

    def __init__(self, var: Variable):
        super().__init__(etype=ExpType.Integer, id="Pointer")
        self.var = var

class Stream(Statement):
    value: int

    def __init__(self, value: int = 0):
        super().__init__(etype=ExpType.Integer, id="Stream")
        self.value = value

# ---------- Statement Nodes ----------

class If(Statement):
    condition: Statement
    then_block: list[Statement]
    else_block: list[Statement]

    def __init__(self, condition: Statement, then_block: list[Statement], else_block: list[Statement]):
        super().__init__(etype=ExpType.Void, id="If")
        self.condition = condition
        self.then_block = then_block
        self.else_block = else_block

class ForLoop(Statement):
    var: Variable
    start: Statement
    end: Statement
    step: Optional[Statement]
    body: list[Statement]

    def __init__(self, var: Variable, start: Statement, end: Statement, body: list[Statement], step: Optional[Statement]=None):
        super().__init__(etype=ExpType.Void, id="ForLoop")
        self.var = var
        self.start = start
        self.end = end
        self.step = step
        self.body = body

class WhileLoop(Statement):
    condition: Statement
    body: list[Statement]

    def __init__(self, condition: Statement, body: list[Statement]):
        super().__init__(etype=ExpType.Void, id="WhileLoop")
        self.condition = condition
        self.body = body

class BlockEnd(Statement):
    name: str
    var: str

    def __init__(self, name: str, var: str = ""):
        super().__init__(etype=ExpType.Void, id="BlockEnd")
        self.name = name
        self.var = var 

class Comment(Statement):
    text: str = ""

    def __init__(self, text: str):
        super().__init__(etype=ExpType.Void, id="Comment")
        self.text = text

# ------ Commands and Functions -------
    
class RSX(Statement):
    command: str = ""

    def __init__(self, command: str):
        super().__init__(etype=ExpType.Void, id="RSX")
        self.command = command

class Command(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, args: list[Statement] = []):
        super().__init__(etype=ExpType.Void, id="Command")
        self.name = name
        self.args = args

class Function(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement] = []):
        super().__init__(etype=etype, id="Function")
        self.name = name
        self.args = args

class UserFun(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement]):
        super().__init__(etype=etype, id="UserFun")
        self.name = name
        self.args = args

class Print(Statement):
    items: list[Statement]

    def __init__(self, items: list[Statement]):
        super().__init__(etype=ExpType.Void, id="Print")
        self.items = items

class Input(Statement):
    vars: list[str]

    def __init__(self, vars: list[str]):
        super().__init__(etype=ExpType.Void, id="Input")
        self.vars = vars

class DefFN(Statement):
    name: str 
    args: list[Variable]
    body: Statement

    def __init__(self, name: str, args: list[Variable], body: Statement):
        super().__init__(etype=ExpType.Void, id="DefFN")
        self.name = name
        self.args = args
        self.body = body
    
# ------ Serialize -------
    
def to_json(root: Program) -> str:
    return json.dumps({}, indent=2)
