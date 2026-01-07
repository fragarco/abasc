#!/usr/bin/env python

"""
BINDIFF.PY by Javier Garcia

Simple tool to compare two binary files.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation in its version 3.

This program is distributed in the hope that it will be useful
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
"""
__author__='Javier "Dwayne Hicks" Garcia'
__version__='1.4.0'

import sys
import argparse

def error(message):
    print(f"[bindiff] error: {message}")

def _compare_bins(path1, path2):
    try:
        with open(path1, "rb") as fd:
            file1 = fd.read()
        with open(path2, "rb") as fd:
            file2 = fd.read()
    except Exception as e:
        error(str(e))
        return 1

    diffs = 0
    if len(file1) != len(file2):
        print(f"Sizes are different: {len(file1)} <> {len(file2)}")
    
    filesize = min(len(file1), len(file2))
    for i in range(0, filesize):
        if file1[i] != file2[i]:
            print(f"Byte {i:08X}: {file1[i]:02X} <> {file2[i]:02X}")
            diffs = diffs + 1
    if diffs > 0:
        error(f"files are different ({diffs} differences in total)")
        return 1
    print("[bindiff] files match (0 differences in total)")
    return 0

def process_args():
    parser = argparse.ArgumentParser(
        prog = 'bindiff.py',
        description = 'Simple tool to compare two binary files. The maximum size per file is 4MB.'
    )
    parser.add_argument('file1', help = 'First binary file.')
    parser.add_argument('file2', help = 'Second binary file.')
    parser.add_argument('-v', '--version', action='version', version=f'BinDiff Version {__version__}',
                        help = "Shows program's version and exits")
    args = parser.parse_args()
    return args

def main():
    args = process_args()
    sys.exit(_compare_bins(args.file1, args.file2))

if __name__ == "__main__":
    main()