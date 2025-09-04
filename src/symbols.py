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
from dataclasses import dataclass, asdict
from typing import Optional, Any
from enum import Enum
import copy
import json
import astlib as AST

class SymType(str, Enum):
    Variable = "Variable"
    Array = "Array"
    Label = "Label"
    Function = "Function"

@dataclass
class SymEntry:
    symtype: SymType
    exptype: AST.ExpType
    locals: "SymTable"
    writes: int = 1
    reads: int = 0
    nargs: int = 0

class SymTable:
    syms: dict[str, SymEntry]

    def __init__(self):
        self.syms = {}

    def add(self, ident: str, info: SymEntry, context: str = "") -> bool:
        ident = ident.upper()
        context = context.upper()
        if context == "":
            # Global context
            if ident not in self.syms:
                self.syms[ident] = copy.deepcopy(info)
                return True
            else:
                # If the sym exists and it is a variable or array that keeps
                # being of the same type, that is allowed and writes
                # must be incremented
                if not self.syms[ident].symtype in (SymType.Variable, SymType.Array):
                    return False
                if info.symtype == self.syms[ident].symtype and info.exptype == self.syms[ident].exptype:
                    self.syms[ident].writes += 1
                    return True
        else:
            # Local context
            if context in self.syms:
                return self.syms[context].locals.add(ident, info)
        return False
        
    def find(self, ident: str, context: str = "") -> Optional[SymEntry]:
        ident = ident.upper()
        context = context.upper()
        if context == "":
            # Global context
            if ident in self.syms:
                return self.syms[ident]
        else:
            # Local context
            if context in self.syms:
                s = self.syms[context].locals.find(ident)
                if s is None:
                    # Search in the global context
                    return self.find(ident)
                return s
        return None

def symsto_json(syms: dict[str, SymEntry]) -> dict:
    jsontable = {}
    for s in syms.keys():
        data = syms[s]
        info = {
            "symtype": data.symtype,
            "exptype": data.exptype,
            "writes":  data.writes,
            "reads": data.reads,
            "nargs": data.nargs,
            "locals": symsto_json(data.locals.syms)
        }
        jsontable[s] = info
    return jsontable
