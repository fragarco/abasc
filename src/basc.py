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
from baspp import LocBasPreprocessor, CodeLine
from baslex import LocBasLexer
from basparse import LocBasParser
from symbols import symsto_json
import astlib as AST
import json

__author__='Javier "Dwayne Hicks" Garcia'
__version__='0.0dev'


def process_args():
    parser = argparse.ArgumentParser(
        prog='basc.py',
        description='A Locomotive BASIC compiler for the Amstrad CPC'
    )
    parser.add_argument('infile', help="BAS file with pseudo Locomotive Basic code.")
    parser.add_argument('-o', '--out', help="Target file name without extension. If missing, <infile> name will be used.")
    parser.add_argument('-v', '--verbose', action='store_true', help="Save to file the outputs of each compile step.")
    parser.add_argument('--nopp', action='store_true', help="Do not preprocess the source file.")
    parser.add_argument('--version', action='version', version=f' Basc (Locomotive BASIC Compiler) Version {__version__}', help = "Shows program's version and exits")

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

def main() -> None:
    start_t = time.process_time()
    args = process_args()
    if args.out == None:
        args.out = args.infile.rsplit('.')[0]

    try:
        with open(args.infile, "r") as fd:
            bascontent = fd.read()
    except Exception as e:
        print(str(e))
        print(f"{time.process_time()-start_t:.2f} seconds")
        sys.exit(1)
    clear(args.infile)
    codelines: list[CodeLine] = []
    code: str = ""
    pp = LocBasPreprocessor()
    if not args.nopp:
        try:
            codelines, code = pp.preprocess(args.infile, bascontent, 10)
            if args.verbose:
                ppfile = args.infile.upper().replace('BAS', 'PP')
                pp.save_output(ppfile, code)
        except Exception as e:
            print(str(e))
            print(f"{time.process_time()-start_t:.2f} seconds")
            sys.exit(1)
    else:
        codelines, code = pp.ascodelines(args.infile, bascontent)

    lx = LocBasLexer(code)
    lexjson, tokens = lx.tokens_json()
    if args.verbose:
        lexfile = args.infile.upper().replace('BAS','LEX')
        with open(lexfile, "w") as fd:
            fd.write(lexjson)
    
    parser = LocBasParser(codelines, tokens)
    try:
        ast, symtable = parser.parse_program()
    except Exception as e:
        print(str(e))
        print(f"{time.process_time()-start_t:.2f} seconds")
        sys.exit(1)
    if args.verbose:
        astjson = ast.to_json()
        astfile = args.infile.upper().replace('BAS','AST')
        with open(astfile, "w") as fd:
            fd.write(json.dumps(astjson, indent=4))
        symfile = args.infile.upper().replace('BAS','SYM')
        symjson = symsto_json(symtable.syms)
        with open(symfile, "w") as fd:
            fd.write(json.dumps(symjson, indent=4))
    print(f"Done in {time.process_time()-start_t:.2f} seconds")

if __name__ == "__main__":
    main()
