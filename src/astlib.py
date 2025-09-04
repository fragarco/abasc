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
from dataclasses import dataclass, field, asdict
from typing import Optional
from enum import Enum, auto
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

@dataclass
class Program(ASTNode):
    lines: list["Line"]
    id: str = "Program"

@dataclass
class Line(ASTNode):
    number: int
    statements: list["Statement"]
    id: str = "Line"

@dataclass
class Statement(ASTNode):
    etype: ExpType

@dataclass
class Nop(Statement):
    """ can be used to return something after an error occurred """
    etype: ExpType = ExpType.Void
    id: str = "NOP"

# ---------- Expresions ----------

@dataclass
class Assignment(Statement):
    target: Statement
    source: Statement
    id: str = "Assignment"

@dataclass
class BinaryOp(Statement):
    op: str
    left: Statement
    right: Statement
    id: str = "BinaryOp"

@dataclass
class UnaryOp(Statement):
    op: str
    operand: Statement
    id: str = "UnaryOp"

@dataclass
class Range(Statement):
    low: str | int
    high: str | int
    id: str = "Range"

@dataclass
class Integer(Statement):
    value: int = 0
    etype: ExpType = ExpType.Integer
    id: str = "Integer"

@dataclass
class Real(Statement):
    value: float = 0.0
    etype: ExpType = ExpType.Real
    id: str = "Real"

@dataclass
class String(Statement):
    value: str = ""
    etype: ExpType = ExpType.String
    id: str = "String"

@dataclass
class Variable(Statement):
    name: str = ""
    id: str = "Variable"

@dataclass
class Array(Statement):
    name: str = ""
    sizes: list[int] = field(default_factory=list)
    id: str = "Array"

@dataclass
class ArrayItem(Statement):
    name: str = ""
    args: list[Statement] = field(default_factory=list)
    id: str = "ArrayItem"

@dataclass
class Pointer(Statement):
    var: Variable = Variable(etype=ExpType.Integer)
    etype: ExpType = ExpType.Integer
    id: str = "Pointer"

@dataclass
class Stream(Statement):
    value: int = 0
    etype: ExpType = ExpType.Integer
    id: str = "Stream"

# ---------- Statement Nodes ----------

@dataclass
class If(Statement):
    condition: Statement = Nop()
    then_block: list[Statement] = field(default_factory=list)
    else_block: list[Statement] = field(default_factory=list)
    etype: ExpType = ExpType.Void
    id: str = "If"

@dataclass
class ForLoop(Statement):
    var: Variable = Variable(ExpType.Integer)
    start: Statement = Nop()
    end: Statement = Nop()
    step: Optional[Statement] = None
    body: list[Statement]  = field(default_factory=list)
    etype: ExpType = ExpType.Void
    id: str = "ForLoop"

@dataclass
class WhileLoop(Statement):
    condition: Statement = Nop()
    body: list[Statement]= field(default_factory=list)
    etype: ExpType = ExpType.Void
    id: str = "WhileLoop"

@dataclass
class BlockEnd(Statement):
    name: str = ""
    var: str = ""
    etype: ExpType = ExpType.Void
    id: str = "BlockEnd"

@dataclass
class Comment(Statement):
    text: str = ""
    etype: ExpType = ExpType.Void
    id: str = "Comment"

# ------ Commands and Functions -------
    
@dataclass
class RSX(Statement):
    command: str = ""
    etype: ExpType = ExpType.Void
    id: str = "RSX"

@dataclass
class Command(Statement):
    name: str = ""
    etype: ExpType = ExpType.Void
    args: list[Statement] = field(default_factory=list)
    id: str = "Command"

@dataclass
class Function(Statement):
    name: str = ""
    args: list[Statement] = field(default_factory=list)
    id: str = "Function"

@dataclass
class UserFun(Statement):
    name: str = ""
    args: list[Statement] = field(default_factory=list)
    id: str = "UserFun"

@dataclass
class Print(Statement):
    items: list[Statement] = field(default_factory=list)
    etype: ExpType = ExpType.Void
    id: str = "Print"

@dataclass
class Input(Statement):
    vars: list[str] = field(default_factory=list)
    etype: ExpType = ExpType.Void
    id: str = "Input"

@dataclass
class DefFN(Statement):
    name: str = ""
    args: list[Variable] = field(default_factory=list)
    body: Statement = Nop()
    etype: ExpType = ExpType.Void
    id: str = "DefFN"

# ------ Serialize -------
    
def to_json(root: Program) -> str:
    return json.dumps(asdict(root), indent=2)
