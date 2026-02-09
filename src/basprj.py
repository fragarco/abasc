#!/usr/bin/env python3
"""
BASPRJ.PY by Javier Garcia

BASPRJ is a simple utility to generate a simple ABASC project.
It creates a make.bat or make.sh file and a main.bas source file.

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
__version__= "0.99 beta"

import argparse
import os
import platform
import stat
import re
import sys
from typing import List

WINDOWS_TEMPLATE: str = r"""@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used in emulators or real hardware for the Amstrad CPC
REM *
REM * USAGE: make [clear | dsk]

@setlocal

set BASC=python3 "{BASC}"
set DSK=python3 "{DSK}"
set CDT=python3 "{CDT}"
set IMG=python3 "{IMG}"
set ASM=python3 "{ASM}"

set SOURCE=main
set TARGET={TARGET}

set LOADADDR=0x0040

set RUNBAS=%BASC% %SOURCE%.bas
set RUNDSK=%DSK% %TARGET%.dsk --new --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR%
set RUNCDT=%CDT% %TARGET%.cdt -n --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR% --name %TARGET%

IF "%1"=="clear" (
    IF EXIST "%SOURCE%.bpp" del "%SOURCE%.bpp"
    IF EXIST "%SOURCE%.lex" del "%SOURCE%.lex"
    IF EXIST "%SOURCE%.ast" del "%SOURCE%.ast"
    IF EXIST "%SOURCE%.sym" del "%SOURCE%.sym"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.asm"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.s"
    IF EXIST "%SOURCE%.lst" del "%SOURCE%.lst"
    IF EXIST "%SOURCE%.map" del "%SOURCE%.map"
    IF EXIST "%SOURCE%.bin" del "%SOURCE%.bin"
    IF EXIST "%TARGET%.dsk" del "%TARGET%.dsk"
    IF EXIST "%TARGET%.cdt" del "%TARGET%.cdt"
) ELSE IF "%1"=="dsk" (
    call %RUNBAS% %2 %3 && call %RUNDSK%
) ELSE IF "%1"=="cdt" (
    call %RUNBAS% %2 %3 && call %RUNCDT% 
) ELSE (
    call %RUNBAS% %*
)

@endlocal
@echo on
"""

UNIX_TEMPLATE: str = r"""#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

BASC="python3 {BASC}"
DSK="python3 {DSK}"
CDT="python3 {CDT}"
IMG="python3 {IMG}"
ASM="python3 {ASM}"

SOURCE=main
TARGET={TARGET}

LOADADDR=0x0040

RUNBAS="$BASC $SOURCE.bas"
RUNDSK="$DSK $TARGET.dsk --new --put-bin $SOURCE.bin --load-addr $LOADADDR --start-addr $LOADADDR"
RUNCDT="$CDT $TARGET.cdt -n --put-bin $SOURCE.bin --load-addr $LOADADDR --start-addr $LOADADDR --name $TARGET"

if [ "$1" = "clear" ]; then
    rm -f "$SOURCE.bpp"
    rm -f "$SOURCE.lex"
    rm -f "$SOURCE.ast"
    rm -f "$SOURCE.sym"
    rm -f "$SOURCE.asm"
    rm -f "$SOURCE.s"
    rm -f "$SOURCE.lst"
    rm -f "$SOURCE.map"
    rm -f "$SOURCE.bin"
    rm -f "$TARGET.dsk"
    rm -f "$TARGET.cdt"
elif [ "$1" = "dsk" ]; then
    $RUNBAS $2 $3 && $RUNDSK
elif [ "$1" = "cdt" ]; then
    $RUNBAS $2 $3 && $RUNCDT
else
    $RUNBAS $@
fi
"""

MAIN_BAS: str = """' Simple generated main file

MODE 1
LABEL mainloop
    PRINT "Hello World!"
    GOTO mainloop
"""

def script_tools_paths() -> List[str]:
    script_dir: str = os.path.dirname(os.path.abspath(__file__))
    return [
        os.path.join(script_dir, "abasc.py"),
        os.path.join(script_dir, "utils", "dsk.py"),
        os.path.join(script_dir, "utils", "cdt.py"),
        os.path.join(script_dir, "utils", "img.py"),
        os.path.join(script_dir, "utils", "abasm.py"),
    ]

def target_name_from_dir(path: str) -> str:
    return os.path.basename(os.path.normpath(path))

def update_project_win(content: str, paths: List[str]) -> str:
    """
    We have to use lamda functions to avoid the problem with Windows paths and re.sub calls
    raising errors like 're.error: bad escape'
    """
    expressions = [
        (r'^set BASC=.*$', 'set BASC=python3 '),
        (r'^set DSK=.*$',  'set DSK=python3 '),
        (r'^set CDT=.*$',  'set CDT=python3 '),
        (r'^set IMG=.*$',  'set IMG=python3 '),
        (r'^set ASM=.*$',  'set ASM=python3 ')
    ]
    for i,exp in enumerate(expressions):
        content = re.sub(
            exp[0],
            lambda _: exp[1] + f'"{paths[i]}"',
            content,
            flags=re.MULTILINE,
        )
    return content

def update_project_unix(content: str, paths: List[str]) -> str:
    """ 
    Linux shouldn't have the same problem than Windows with bars in the path, but
    lets use the lambda workaround just in case.
    """
    expressions = [
        (r'^BASC=.*$', 'BASC="python3 '),
        (r'^DSK=.*$',  'DSK="python3 '),
        (r'^CDT=.*$',  'CDT="python3 '),
        (r'^IMG=.*$',  'IMG="python3 '),
        (r'^ASM=.*$',  'ASM="python3 ')
    ]
    for i,exp in enumerate(expressions):
        content = re.sub(
            exp[0],
            lambda _: exp[1] + f'{paths[i]}"',
            content,
            flags=re.MULTILINE,
        )
    return content

def update_project(target_dir: str, is_windows: bool) -> None:
    make_name: str = "make.bat" if is_windows else "make.sh"
    make_path: str = os.path.join(target_dir, make_name)

    if not os.path.isfile(make_path):
        print(f"{make_name} was not found in {target_dir}", file=sys.stderr)
        sys.exit(1)

    paths = script_tools_paths()

    with open(make_path, "r", encoding="utf-8") as f:
        content: str = f.read()
    if is_windows:
        content = update_project_win(content, paths)
    else:
        content = update_project_unix(content, paths)
    with open(make_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print(f"{make_name} was sucessfully updated")

def create_project(target_dir: str, is_windows: bool) -> None:
    target_name: str = target_name_from_dir(target_dir)
    paths = script_tools_paths()

    if is_windows:
        make_name: str = "make.bat"
        make_content: str = WINDOWS_TEMPLATE.format(
            BASC=paths[0],
            DSK=paths[1],
            CDT=paths[2],
            IMG=paths[3],
            ASM=paths[4],
            TARGET=target_name,
        )
    else:
        make_name = "make.sh"
        make_content = UNIX_TEMPLATE.format(
            BASC=paths[0],
            DSK=paths[1],
            CDT=paths[2],
            IMG=paths[3],
            ASM=paths[4],
            TARGET=target_name,
        )
        
    make_path: str = os.path.join(target_dir, make_name)
    with open(make_path, "w", newline="\n") as f:
        f.write(make_content)

    if not is_windows:
        st = os.stat(make_path)
        os.chmod(make_path, st.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

    print(f"Project initialized: {target_dir}")
    print(f"- {make_name} created")
    main_bas_path: str = os.path.join(target_dir, "main.bas")
    if not os.path.exists(main_bas_path):
        with open(main_bas_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(MAIN_BAS)
        print(f"- main.bas created")

def create_argv_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Creates or updates an ABASC project skeleton"
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-n", "--new", metavar="TARGET DIRECTORY",
        help="Generates a new project folder with a make file (use '.' for current directory)",
    )
    group.add_argument(
        "-u", "--update", metavar="TARGET DIRECTORY",
        help="Updates paths to ABASC and DSK tools",
    )
    parser.add_argument(
        "-v", "--version", action='version', version=f' Basprj Version {__version__}',
        help = "Shows program's version and exits")
    return parser

def main() -> None:
    parser = create_argv_parser()
    args = parser.parse_args()
    is_windows: bool = platform.system().lower().startswith("win")

    if args.update is not None:
        target_dir: str = (
            os.getcwd() if args.update == "." else os.path.abspath(args.update)
        )
        update_project(target_dir, is_windows)
        sys.exit(0)

    if args.new == ".":
        target_dir = os.getcwd()
    else:
        target_dir = os.path.abspath(args.new)
        os.makedirs(target_dir, exist_ok=True)
    create_project(target_dir, is_windows)
    sys.exit(0)

if __name__ == "__main__":
    main()
