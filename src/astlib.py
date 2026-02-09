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
from typing import Optional, Sequence
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
    """
    Strings are restrictive and only can be conbined with other string.
    For all other types we convert to the most representation range
    Real > Integer
    """
    if ExpType.String in (op1.etype, op2.etype):
        """ String literals can be mixed only with other strings """
        if op1.etype != op2.etype:
            return ExpType.Mismatch
        return ExpType.String
    elif ExpType.Void in (op1.etype, op2.etype):
        return ExpType.Void
    elif ExpType.Mismatch in (op1.etype, op2.etype):
        return ExpType.Mismatch
    elif ExpType.Real in (op1.etype, op2.etype):
        return ExpType.Real
    else:
        return ExpType.Integer

def exptype_fromname(ident: str) -> ExpType:
    sufix = ident[-1]
    if sufix == "!":
        return ExpType.Real
    elif sufix == "$":
        return ExpType.String
    else:
        return ExpType.Integer

def exptype_memsize(t: ExpType) -> int:
    if t == ExpType.Real:
        return 5    # 5 bytes floating-point number
    elif t == ExpType.String:
        return 255  # 1 byte with str length plus 254 characters max
    else:
        return 2    # 2 bytes integer

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

def exptype_compatible(etype1: ExpType, etype2: ExpType) -> bool:
    if ExpType.Mismatch in (etype1, etype2) or ExpType.Void in (etype1, etype2):
        return False
    if ExpType.String in (etype1, etype2):
        return etype1 == etype2
    return True

# ---------- Basic Tree Nodes ----------

class ASTNode:
    id: str
    line: int
    col: int

    def __init__(self, id: str) -> None:
        self.id = id
        self.line = 0
        self.col = 0

    def set_origin(self, line: int, col: int) -> None:
        self.line = line
        self.col = col

    def to_json(self) -> dict:
        return {
            "id": self.id,
            "line": self.line,
            "col": self.col
        }

    def __str__(self) -> str:
        return json.dumps(self.to_json(), indent=2)

class Program(ASTNode):
    lines: list["Line"]

    def __init__(self, lines: list["Line"]) -> None:
        super().__init__(id="Program")
        self.lines = lines

    def to_json(self) -> dict:
        d = super().to_json()
        d["lines"] = [l.to_json() for l in self.lines]
        return d

class Line(ASTNode):
    number: int
    statements: list["Statement"]

    def __init__(self, number: int, statements: list["Statement"]) -> None:
        super().__init__(id="Line")
        self.number=number
        self.statements=statements

    def to_json(self) -> dict:
        d = super().to_json()
        d["number"] = self.number
        d["statements"] = [s.to_json() for s in self.statements]
        return d

class Statement(ASTNode):
    etype: ExpType

    def __init__(self, etype: ExpType, id: str) -> None:
        super().__init__(id=id)
        self.etype = etype

    def to_json(self) -> dict:
        d = super().to_json()
        d["etype"] = str(self.etype)
        return d

class Nop(Statement):
    """ can be used to return something after an error occurred """

    def __init__(self) -> None:
        super().__init__(etype=ExpType.Void, id="NOP")

    def to_json(self) -> dict:
        return super().to_json()

# ---------- Expresions ----------

class Assignment(Statement):
    target: Statement
    source: Statement
    id: str = "Assignment"

    def __init__(self, target: Statement, source: Statement, etype: ExpType) -> None:
        super().__init__(etype=etype, id="Assignment")
        self.target = target
        self.source = source

    def to_json(self) -> dict:
        d = super().to_json()
        d["target"] = self.target.to_json(),
        d["source"] = self.source.to_json()
        return d

class BinaryOp(Statement):
    op: str
    left: Statement
    right: Statement

    def __init__(self, op: str, left: Statement, right: Statement, etype: ExpType) -> None:
        super().__init__(etype=etype, id="BinaryOp")
        self.left = left
        self.right = right
        self.op = op

    def to_json(self) -> dict:
        d = super().to_json()
        d["op"] = self.op
        d["left"] = self.left.to_json()
        d["right"] = self.right.to_json()
        return d

class UnaryOp(Statement):
    op: str
    operand: Statement

    def __init__(self, op: str, operand: Statement, etype: ExpType) -> None:
        super().__init__(etype=etype, id="UnaryOp")
        self.operand = operand
        self.op = op

    def to_json(self) -> dict:
        d = super().to_json()
        d["op"] = self.op
        d["operand"] = self.operand.to_json()
        return d

class Range(Statement):
    low: str | int
    high: str | int

    def __init__(self, low: int | str, high: int | str, etype: ExpType) -> None:
        super().__init__(etype=etype, id="Range")
        self.low = low
        self.high = high

    def to_json(self) -> dict:
        d = super().to_json()
        d["low"] = self.low
        d["hight"] = self.high
        return d

class Integer(Statement):
    value: int

    def __init__(self, value: int) -> None:
        super().__init__(etype=ExpType.Integer, id="Integer")
        self.value = value

    def to_json(self) -> dict:
        d = super().to_json()
        d["value"] = self.value
        return d

class Real(Statement):
    value: float

    def __init__(self, value: float) -> None:
        super().__init__(etype=ExpType.Real, id="Real")
        self.value = value

    def to_json(self) -> dict:
        d = super().to_json()
        d["value"] = self.value
        return d

class String(Statement):
    value: str

    def __init__(self, value: str) -> None:
        super().__init__(etype=ExpType.String, id="String")
        self.value = value

    def to_json(self) -> dict:
        d = super().to_json()
        d["value"] = self.value
        return d

class Variable(Statement):
    name: str

    def __init__(self, name: str, etype: ExpType) -> None:
        super().__init__(etype=etype, id="Variable")
        self.name = name

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        return d
    
class Array(Statement):
    name: str
    sizes: list[int]
    datasz: int

    def __init__(self, name: str, etype: ExpType, sizes: list[int], datasz: int) -> None:
        super().__init__(etype=etype, id="Array")
        self.name = name
        self.sizes = sizes
        self.datasz = datasz

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["sizes"] = self.sizes
        d["datasz"] = self.datasz
        return d

class ArrayItem(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement]) -> None:
        super().__init__(etype=etype, id="ArrayItem")
        self.name = name
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["args"] = [a.to_json() for a in self.args]
        return d

class Pointer(Statement):
    var: Variable | ArrayItem | Label | String

    def __init__(self, var: Variable | ArrayItem | Label | String) -> None:
        super().__init__(etype=ExpType.Integer, id="Pointer")
        self.var = var

    def to_json(self) -> dict:
        d = super().to_json()
        if isinstance(self.var, String):
            d["ident"] = self.var.value    
        else:
            d["ident"] = self.var.to_json()
        return d

class Stream(Statement):
    value: int

    def __init__(self, value: int = 0) -> None:
        super().__init__(etype=ExpType.Integer, id="Stream")
        self.value = value

    def to_json(self) -> dict:
        d = super().to_json()
        d["value"] = self.value
        return d

class Separator(Statement):
    sym: str
    
    def __init__(self, symbol: str) -> None:
        super().__init__(etype=ExpType.Void, id="Separator")
        self.sym = symbol

    def to_json(self) -> dict:
        d = super().to_json()
        d["symbol"] = self.sym
        return d

# ---------- Statement Nodes ----------

class If(Statement):
    condition: Statement
    has_else: bool
    is_inline: bool
    inline_then: list[Statement] = []
    inline_else: list[Statement] = []
    else_label: str    # used during code generation
    end_label: str      # used during code generation

    def __init__(self, condition: Statement, inline_then: list[Statement] = [], inline_else: list[Statement] = []) -> None:
        super().__init__(etype=ExpType.Void, id="If")
        self.condition = condition
        self.inline_then = inline_then
        self.inline_else = inline_else
        self.has_else = len(inline_else) > 0
        self.is_inline = len(inline_then) > 0
        self.else_label = ""
        self.end_label = ""

    def to_json(self) -> dict:
        d = super().to_json()
        d["condition"] = self.condition.to_json()
        d["is_inline"] = self.is_inline
        d["has_else"] = self.has_else
        if self.is_inline:
            d["inline_then"] = [s.to_json() for s in self.inline_then]
            d["inline_else"] = [s.to_json() for s in self.inline_else]
        return d
    
class ForLoop(Statement):
    var: Variable
    start: Statement
    end: Statement
    step: Optional[Statement]
    start_label: str    # used during code generation
    end_label: str      # used during code generation
    var_label: str      # used during code generation

    def __init__(self, var: Variable, start: Statement, end: Statement, step: Optional[Statement]=None) -> None:
        super().__init__(etype=ExpType.Void, id="ForLoop")
        self.var = var
        self.start = start
        self.end = end
        self.step = step
        self.start_label = ""
        self.end_label = ""

    def to_json(self) -> dict:
        d = super().to_json()
        d["var"] = self.var.to_json()
        d["start"] = self.start.to_json()
        d["end"] = self.end.to_json()
        d["step"] = None if self.step is None else self.step.to_json()
        return d
    
class WhileLoop(Statement):
    condition: Statement
    start_label: str      # used during code generation
    end_label: str      # used during code generation

    def __init__(self, condition: Statement) -> None:
        super().__init__(etype=ExpType.Void, id="WhileLoop")
        self.condition = condition
        self.end_label = ""
        self.start_label = ""

    def to_json(self) -> dict:
        d = super().to_json()
        d["condition"] = self.condition.to_json()
        return d

class SelectCase(Statement):
    condition: Statement
    options: int
    defaultcase: bool
    var_label: str         # used during code generation 
    case_labels: list[str] # used during code generation
    def_label: str         # used during code generation 
    end_label: str         # used during code generation
    currentopt: int        # used during code generation

    def __init__(self, condition: Statement) -> None:
        super().__init__(etype=ExpType.Void, id="SelectCase")
        self.condition = condition
        self.options = 0
        self.defaultcase = False
        self.end_label = ""
        self.start_label = ""
        self.currentopt = 0

    def to_json(self) -> dict:
        d = super().to_json()
        d["condition"] = self.condition.to_json()
        d["options"] = self.options
        d["default case"] = self.defaultcase
        return d

class BlockEnd(Statement):
    name: str
    var: str

    def __init__(self, name: str, var: str = "") -> None:
        super().__init__(etype=ExpType.Void, id="BlockEnd")
        self.name = name
        self.var = var 

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["var"] = self.var
        return d

class Comment(Statement):
    text: str = ""

    def __init__(self, text: str) -> None:
        super().__init__(etype=ExpType.Void, id="Comment")
        self.text = text

    def to_json(self) -> dict:
        d = super().to_json()
        d["text"] = self.text
        return d

class Label(Statement):
    value: str

    def __init__(self, value: str) -> None:
        super().__init__(etype=ExpType.Void, id="Label")
        self.value = value

    def to_json(self) -> dict:
        d = super().to_json()
        d["value"] = self.value
        return d

# ------ Commands and Functions -------
    
class RSX(Statement):
    command: str = ""
    args: list[Statement]

    def __init__(self, command: str, args: list[Statement] = []) -> None:
        super().__init__(etype=ExpType.Void, id="RSX")
        self.command = command
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["command"] = self.command
        d["args"] = [a.to_json() for a in self.args]
        return d

class Command(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, args: list[Statement] = []) -> None:
        super().__init__(etype=ExpType.Void, id="Command")
        self.name = name
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["args"] = [a.to_json() for a in self.args]
        return d

class Function(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement] = []) -> None:
        super().__init__(etype=etype, id="Function")
        self.name = name
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["args"] = [a.to_json() for a in self.args]
        return d

class UserFun(Statement):
    name: str
    args: list[Statement]

    def __init__(self, name: str, etype: ExpType, args: list[Statement]) -> None:
        super().__init__(etype=etype, id="UserFun")
        self.name = name
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["args"] = [a.to_json() for a in self.args]
        return d

class Data(Statement):
    args: list[Statement]
    linelabel: str
    userlabel: str

    def __init__(self, args: list[Statement], linelabel: str, userlabel: str) -> None:
        super().__init__(etype=ExpType.Void, id="Data")
        self.args = args
        self.linelabel = f"_data_{linelabel}_label"
        self.userlabel = "" if userlabel == "" else f"_data_{userlabel}_label"

    def to_json(self) -> dict:
        d = super().to_json()
        d["args"] = [a.to_json() for a in self.args]
        d["linelabel"] = self.linelabel
        d["userlabel"] = self.userlabel
        return d

class Print(Statement):
    stream: Optional[Statement]
    items: list[Statement]
    newline: bool

    def __init__(self, stream: Optional[Statement], items: list[Statement]) -> None:
        super().__init__(etype=ExpType.Void, id="Print")
        self.stream = stream
        self.items = items
        self.newline = True
        if len(items) > 0 and isinstance(items[-1], Separator):
            self.newline = items[-1].sym != ';'

    def to_json(self) -> dict:
        d = super().to_json()
        d["stream"] = self.stream.to_json() if self.stream is not None else None
        d["items"] = [a.to_json() for a in self.items]
        d["newline"] = self.newline
        return d

class Input(Statement):
    stream: Optional[Statement]
    prompt: str
    question: bool
    vars: Sequence[Variable | ArrayItem]

    def __init__(self, stream: Optional[Statement], prompt: str, question: bool, vars: list[Variable | ArrayItem]) -> None:
        super().__init__(etype=ExpType.Void, id="Input")
        self.stream = stream
        self.prompt = prompt
        self.vars = vars
        self.question = question

    def to_json(self) -> dict:
        d = super().to_json()
        d["stream"] = self.stream.to_json() if self.stream is not None else None
        d["prompt"] = self.prompt
        d["question"] = self.question
        d["vars"] = [v.to_json() for v in self.vars]
        return d

class ReadIn(Statement):
    prompt: str
    vars: Sequence[Variable | ArrayItem]

    def __init__(self, vars: list[Variable | ArrayItem]) -> None:
        super().__init__(etype=ExpType.Void, id="ReadIn")
        self.vars = vars

    def to_json(self) -> dict:
        d = super().to_json()
        d["vars"] = [v.to_json() for v in self.vars]
        return d

class LineInput(Statement):
    stream: Optional[Statement]
    prompt: str
    carriage: bool
    question: bool
    var: Variable | ArrayItem

    def __init__(self, stream: Optional[Statement], prompt: str, carriage: bool, question: bool, var: Variable | ArrayItem) -> None:
        super().__init__(etype=ExpType.Void, id="LineInput")
        self.stream = stream
        self.prompt = prompt
        self.carriage = carriage
        self.question = question
        self.var = var

    def to_json(self) -> dict:
        d = super().to_json()
        d["stream"] = self.stream.to_json() if self.stream is not None else None
        d["prompt"] = self.prompt
        d["carriage"] = self.carriage
        d["var"] = self.var.to_json()
        return d

class Write(Statement):
    stream: Optional[Statement]
    items: list[Statement]

    def __init__(self, stream: Optional[Statement], items: list[Statement]) -> None:
        super().__init__(etype=ExpType.Void, id="Write")
        self.stream = stream
        self.items = items

    def to_json(self) -> dict:
        d = super().to_json()
        d["stream"] = self.stream.to_json() if self.stream is not None else None
        d["items"] = [a.to_json() for a in self.items]
        return d

class DefFN(Statement):
    name: str 
    args: list[Variable|Array]
    body: Statement
    heapmem: int    # used by the emiter to save the amount of tmp memory per call

    def __init__(self, name: str, args: list[Variable|Array], body: Statement) -> None:
        super().__init__(etype=ExpType.Void, id="DefFN")
        self.name = name
        self.args = args
        self.body = body
        self.heapmem = 0

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["heap"] = self.heapmem
        d["args"] = [a.to_json() for a in self.args]
        d["body"] = self.body.to_json()
        return d

class DefFUN(Statement):
    name: str 
    asm: bool
    args: list[Variable|Array]

    def __init__(self, name: str, args: list[Variable|Array], asm=False) -> None:
        super().__init__(etype=ExpType.Void, id="DefFUN")
        self.name = name
        self.asm = asm
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["asm"] = self.asm
        d["args"] = [a.to_json() for a in self.args]
        return d

class DefSUB(Statement):
    name: str 
    asm: bool
    args: list[Variable|Array]

    def __init__(self, name: str, args: list[Variable|Array], asm=False) -> None:
        super().__init__(etype=ExpType.Void, id="SUB")
        self.name = name
        self.asm = asm
        self.args = args

    def to_json(self) -> dict:
        d = super().to_json()
        d["name"] = self.name
        d["asm"] = self.asm
        d["args"] = [a.to_json() for a in self.args]
        return d
