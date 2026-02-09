r"""
Symbol Table class and auxiliary methods for the Amstrad Locomotive
BASIC compiler.

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
from dataclasses import dataclass, field
from typing import Optional, Any
from enum import Enum
import astlib as AST
import copy

class SymType(str, Enum):
    Variable = "Variable"
    Array = "Array"
    Param = "Parameter"
    ArrayParam = "ArrayParam"
    Label = "Label"
    Function = "Function"
    Procedure = "Procedure"
    RSX = "RSX"
    Record = "Record"

@dataclass
class SymEntry:
    symtype: SymType
    exptype: AST.ExpType
    locals: "SymTable"
    label: str = ""
    writes: int = 1
    calls: int = 0      # Used by SUB, FUNCTION and DEF FN: times that a func is called
    nargs: int = 0      # Used by routines and arrays
    argtypes: list[AST.ExpType] = field(default_factory=list) # used by routines
    args: list[AST.Statement] = field(default_factory=list)   # used by routines
    indexes:  list[int] = field(default_factory=list) # Used by arrays
    memoff: int = 0     # if it's a param, offset in the call stack frame
    datasz: int = 0     # integers = 2, reals = 5, string up to 255
    heapused: int = 0    # rutines can consume heap (temp) memory and we need to track that
    const: Optional[int] = None # Used by the optimizer to store constant integer values

class SymTable:
    syms: dict[str, SymEntry]

    def __init__(self) -> None:
        self.syms = {}

    def _gen_label(self, name: str, entry: SymEntry, prefix: str) -> str:
        name = name.replace("!","_R").replace("$","_S").replace("%","_I").replace(".","_")
        prefix = prefix.replace("!","_R").replace("$","_S").replace("%","_I").replace(".","_")
        prefix = "G_" if prefix == "" else (prefix.upper() + "_")
        if entry.symtype == SymType.Variable:
            return f"{prefix}VAR_{name.upper()}"
        elif entry.symtype == SymType.Param:
            return f"{prefix}ARG_{name.upper()}"
        elif entry.symtype == SymType.ArrayParam:
            return f"{prefix}ARG_ARRAY_{name.upper()}"
        elif entry.symtype == SymType.Array:
            return f"{prefix}ARRAY_{name.upper()}"
        elif entry.symtype == SymType.Label:
            return f"__label_{name.upper()}"
        elif entry.symtype == SymType.Function:
            return f"FN_{name.upper()}"
        elif entry.symtype == SymType.Procedure:
            return f"SUB_{name.upper()}"
        elif entry.symtype == SymType.RSX:
            return f"RSX_{name.upper()}"
        return ""

    def _code_symtype(self, ident: str, stype: SymType) -> str:
        if stype == SymType.Variable:
            return f"VAR_{ident}"
        elif stype == SymType.Param:
            return f"ARG_{ident}"
        elif stype == SymType.ArrayParam:
            return f"ARG_ARRAY_{ident}"
        elif stype == SymType.Array:
            return f"ARRAY_{ident}"
        elif stype == SymType.Label:
            return f"LABEL_{ident}"
        elif stype == SymType.Function:
            return f"FN_{ident}"
        elif stype == SymType.Procedure:
            return f"SUB_{ident}"
        elif stype == SymType.RSX:
            return f"RSX_{ident}"
        return ident

    def add(self, ident: str, info: SymEntry, context: str = "", prefix: str = "") -> bool:
        """ 
        Returns FALSE if the symbol exists and is not a VARIABLE or ARRAY which
        can be added multiple times (extra writes)
        """
        if "$." in ident:
            # check for Record pattern
            ident = ident.split('.')[0]
        ident = ident.upper()
        keyident = self._code_symtype(ident, info.symtype)
        context = context.upper()
        if context == "":
            # Global context
            if keyident not in self.syms:
                self.syms[keyident] = copy.deepcopy(info)
                self.syms[keyident].label = self._gen_label(ident, info, prefix)
                return True
            else:
                # If the sym exists and it is a variable, param or array that keeps
                # being of the same type, that is allowed and writes
                # must be incremented
                if not self.syms[keyident].symtype in (SymType.Variable, SymType.Array, SymType.Param):
                    return False
                # Check values is of the same type and also that this is not a constant
                if self.syms[keyident].exptype == info.exptype and self.syms[keyident].const is None:
                    self.syms[keyident].writes += 1
                    return True
        else:
            # Local contexts
            for ftype in [SymType.Function, SymType.Procedure]:
                keyfun = self._code_symtype(context, ftype)
                if keyfun in self.syms:
                    return self.syms[keyfun].locals.add(ident, info, context="", prefix=context)
        return False

    def add_shared(self, ident: str, info: SymEntry, context: str) -> bool:
        """ 
        Allows programs to bind a local variable in a SUB or FUNCTION routine
        to a global variable.
        """
        ident = ident.upper()
        context = context.upper()
        if context != "":
            # Add the bind in the local context pointing to a global variable (prefix = "")
            # In this way they will share important information as the number of writes
            for ftype in [SymType.Function, SymType.Procedure]:
                keyfun = self._code_symtype(context, ftype)
                if keyfun in self.syms:
                    keyident = self._code_symtype(ident, info.symtype)
                    if keyident not in self.syms[keyfun].locals.syms:
                        self.syms[keyfun].locals.syms[keyident] = info
                        return True
        return False

    def find(self, ident: str, stype: SymType, context: str = "") -> Optional[SymEntry]:
        if "$." in ident:
            # check for Record pattern
            ident = ident.split('.')[0]
        ident = ident.upper()
        keyident = self._code_symtype(ident, stype)
        context = context.upper()
        if context == "":
            # Global context (usually main program)
            # can also be a search in symbols for a given local context
            if keyident in self.syms:
                return self.syms[keyident]
        else:
            # Local context
            for ftype in [SymType.Function, SymType.Procedure]:
                keyfun = self._code_symtype(context, ftype)
                if keyfun in self.syms:
                    return self.syms[keyfun].locals.find(ident, stype)
        return None

def symsto_json(syms: dict[str, SymEntry]) -> dict:
    jsontable = {}
    for s in syms.keys():
        data = syms[s]
        info = {
            "symtype": data.symtype,
            "symlabel": data.label,
            "exptype": data.exptype,
            "writes":  data.writes,
            "calls": data.calls,
            "nargs": data.nargs,
            "argtypes": data.argtypes,
            "indexes": data.indexes,
            "locals": symsto_json(data.locals.syms),
            "datasz": data.datasz,
            "memoffset": data.memoff,
            "heapused": data.heapused

        }
        jsontable[s] = info
    return jsontable
