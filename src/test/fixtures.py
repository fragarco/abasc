"""
Shared test fixtures and helpers for the ABASC compiler tests.

Usage:
    from fixtures import compile_program, compile_to_asm, mk_codelines
"""

from baspp import CodeLine
from baslex import LocBasLexer
from basparse import LocBasParser
from baserror import WarningLevel as WL
from symbols import SymTable
import astlib as AST
from basopt import BasOptimizer
from typing import Any, List, Tuple

def mk_codelines(source: str, lines: List[str]) -> List[CodeLine]:
    """Create a list of CodeLine objects from a list of source lines."""
    return [CodeLine(source, i + 1, line) for i, line in enumerate(lines)]


def compile_program(code: str, warning_level: WL = WL.NONE) -> Tuple[AST.Program, SymTable]:
    """
    Parse a BASIC source string into an AST and symbol table.
    The code string should have at least one newline at the end.
    Returns (program, symtable).
    """
    code = code.rstrip() + '\n'
    lx = LocBasLexer(code)
    tokens = list(lx.tokens())
    codelines = mk_codelines("TEST.BAS", code.split('\n'))
    return LocBasParser(codelines, tokens, warning_level=warning_level).parse_program()


def compile_and_optimize(code: str) -> Tuple[AST.Program, SymTable]:
    """
    Parse and optimize a BASIC source string.
    Returns (optimized_program, symtable).
    """
    program, symtable = compile_program(code)
    optimizer = BasOptimizer()
    return optimizer.optimize_ast(program, symtable)
