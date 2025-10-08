"""
Amstrad Locomotive BASIC compiler.

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
import sys, os
import argparse
import time
import traceback
from baspp import LocBasPreprocessor, CodeLine
from baslex import LocBasLexer, Token
from basparse import LocBasParser
from cpcemitter import CPCEmitter
from symbols import symsto_json, SymTable
import astlib as AST
import abasm as ABASM
from basopt import BasOptimizer
import json

__author__='Javier "Dwayne Hicks" Garcia'
__version__='0.0dev'


def process_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog='basc.py',
        description='A Locomotive BASIC compiler for the Amstrad CPC'
    )
    parser.add_argument('infile', help="BAS file with pseudo Locomotive Basic code.")
    parser.add_argument('-o', '--out', help="Target file name without extension. If missing, <infile> name will be used.")
    parser.add_argument('-v', '--verbose', action='store_true', help="Save to file the outputs of each compile step.")
    parser.add_argument('--version', action='version', version=f' Basc (Locomotive BASIC Compiler) Version {__version__}', help = "Shows program's version and exits")
    parser.add_argument('--debug', action='store_true', help="Shows some extra information when compilation fails")
    args = parser.parse_args()
    return args

def clear(sourcefile: str):
    basefile = sourcefile.upper() 
    files: list[str] = [
        basefile.replace('.BAS', '.PP'),
        basefile.replace('.BAS', '.LEX'),
        basefile.replace('.BAS', '.AST'),
    ]
    for f in files:
        if os.path.exists(f):
            os.remove(f)

def readsourcefile(source: str) -> str:
    with open(source, "r") as fd:
        return fd.read()

def check_linenums(source: str) -> bool:
    """ 
    Check if the first character in the source code is a number which indicates
    line numbers are in use.
    """
    code = source.strip()
    return code[0].isdigit()

def preprocess(infile: str, content: str, verbose: bool) -> tuple[list[CodeLine], str]:
    pp = LocBasPreprocessor()
    nopp = False # check_linenums(content)
    if nopp:
        codelines, code = pp.ascodelines(infile, content)
    else:
        codelines, code = pp.preprocess(infile, content, 10)
    if verbose:
        ppfile = infile.upper().replace('BAS', 'PP')
        pp.save_output(ppfile, code)
    return (codelines, code)

def lexpass(infile: str, code: str, verbose: bool) -> list[Token]:
    lx = LocBasLexer(code)
    lexjson, tokens = lx.tokens_json()
    if verbose:
        lexfile = infile.upper().replace('BAS','LEX')
        with open(lexfile, "w") as fd:
            fd.write(lexjson)
    return tokens

def parser(infile: str, codelines: list[CodeLine], tokens: list[Token], verbose: bool) -> tuple[AST.Program, SymTable]:
    parser = LocBasParser(codelines, tokens)
    ast, symtable = parser.parse_program()
    if verbose:
        astjson = ast.to_json()
        astfile = infile.upper().replace('BAS','AST')
        with open(astfile, "w") as fd:
            fd.write(json.dumps(astjson, indent=4))
        symfile = infile.upper().replace('BAS','SYM')
        symjson = symsto_json(symtable.syms)
        with open(symfile, "w") as fd:
            fd.write(json.dumps(symjson, indent=4))
    return (ast, symtable)

def emit(infile: str, codelines: list[CodeLine], ast:AST.Program, symtable: SymTable, verbose: bool):
    emitter = CPCEmitter(codelines, ast, symtable, verbose=verbose)
    asmcode = emitter.emit_program()
    asmfile = infile.upper().replace('BAS','ASM')
    with open(asmfile, "w") as fd:
            fd.write(asmcode)
    ABASM.assemble(asmfile)

def main() -> None:
    start_t = time.process_time()
    args = process_args()
    outfile = args.out if args.out is not None else args.infile.rsplit('.')[0]
    infile = args.infile
    try:
        clear(infile)
        bascontent = readsourcefile(infile)
        codelines, code = preprocess(infile, bascontent, args.verbose)
        tokens = lexpass(infile, code, args.verbose)
        ast, symtable = parser(infile, codelines, tokens, args.verbose)
        optimizer = BasOptimizer()
        ast, symtable = optimizer.optimize_ast(ast, symtable)
        emit(infile, codelines, ast, symtable, args.verbose)
    except Exception as e:
        print(str(e))
        if args.debug:
            print(traceback.format_exc())
        sys.exit(1)
    print(f"Done in {time.process_time()-start_t:.2f} seconds")

if __name__ == "__main__":
    main()
    sys.exit(0)