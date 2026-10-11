#!/usr/bin/env python
"""
ASMPRJ.PY by Javier Garcia

ASMPRJ is a simple utility to generate a basic ABASM project.
It creates a make.bat or make.sh file and a main.asm source file.

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
from __future__ import annotations

__author__: str = 'Javier "Dwayne Hicks" Garcia'
__version__: str = '1.5.0'

import argparse
import os
import platform
import re
import stat
import sys

WINDOWS_TEMPLATE = r"""@echo off

REM *
REM * This file is just an example of how ABASM and DSK/CDT utilities can be called to assemble programs
REM * and generate files that can be used in emulators or real hardware for the Amstrad CPC
REM *
REM * USAGE: make [clear]

@setlocal

SET ABASMHOME={HOME}

IF EXIST "%ABASMHOME%\bin" goto :abasm_tools_bin
	SET ASM=python "%ABASMHOME%\src\abasm.py"
	SET DSK=python "%ABASMHOME%\src\dsk.py"
    SET CDT=python "%ABASMHOME%\src\cdt.py"
    SET IMG=python "%ABASMHOME%\src\img.py"
	GOTO :abasm_tools_end
:abasm_tools_bin
	SET ASM="%ABASMHOME%\bin\abasm.exe"
	SET DSK="%ABASMHOME%\bin\dsk.exe"
    SET CDT="%ABASMHOME%\bin\cdt.exe"
    SET IMG="%ABASMHOME%\bin\img.exe"
:abasm_tools_end

SET LOADADDR=0x1200
SET SOURCE=main
SET TARGET={TARGET}

SET RUNASM=%ASM% --start=%LOADADDR% %SOURCE%.asm
SET RUNDSK=%DSK% %TARGET%.dsk --new --put-bin %SOURCE%.bin --load-addr %LOADADDR% --map-file %SOURCE%.map --start-addr MAIN

IF "%1"=="clear" (
    DEL %SOURCE%.bin
    DEL %SOURCE%.lst
    DEL %SOURCE%.map
    DEL %TARGET%.dsk
    DEL %TARGET%.cdt
) ELSE (
    CALL %RUNASM% && CALL %RUNDSK%
)

@endlocal
@echo on
"""

UNIX_TEMPLATE = """#!/usr/bin/env bash

#
# This file is just an example of how ABASM and DSK/CDT utilities can be called to assemble programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear]
#

ABASMHOME="{HOME}"

if [ -d "$ABASMHOME/bin" ]; then
    ASM="$ABASMHOME/bin/abasm"
    DSK="$ABASMHOME/bin/dsk"
    CDT="$ABASMHOME/bin/cdt"
    IMG="$ABASMHOME/bin/img"
else
    ASM="python $ABASMHOME/src/abasm.py"
    DSK="python $ABASMHOME/src/dsk.py"
    CDT="python $ABASMHOME/src/cdt.py"
    IMG="python $ABASMHOME/src/img.py"
fi

LOADADDR=0x1200
SOURCE=main
TARGET={TARGET}

RUNASM="$ASM --start=$LOADADDR $SOURCE.asm"
RUNDSK="$DSK $TARGET.dsk --new --put-bin $SOURCE.bin --load-addr $LOADADDR --map-file $SOURCE.map --start-addr MAIN"

if [ "$1" = "clear" ]; then
    rm -f "$SOURCE.bin"
    rm -f "$SOURCE.lst"
    rm -f "$SOURCE.map"
    rm -f "$TARGET.dsk"
    rm -f "$TARGET.cdt"
else
    $RUNASM && $RUNDSK
fi
"""

MAIN_ASM = """OUT_CHAR equ &BB5A    ; Amstrad Firmware routine for char printing

; Main entry point. Make file will search for this symbol and
; set its address as the starting point for the program.

org &1200

main:
    ld   hl, message
    call print_string
    call new_line
loop:
    jp   loop

message: db "Hello world!",0
 
print_string:
    ld   a,(hl)
    or   a
    ret  z
    inc  hl
    call OUT_CHAR
    jr   print_string

new_line:
    ld   a,13
    call OUT_CHAR
    ld   a,10
    jp   OUT_CHAR
"""

def abasm_home_dir() -> str:
    """Path to the ABASM root folder (the parent of 'src' and 'bin')."""
    # This is the directory for our script
    script_dir: str = os.path.dirname(os.path.abspath(__file__))
    if getattr(sys, 'frozen', False):
        # We are running the exectuable file so let's get where the executable
        # is because the initial path is where the system uncompresses the binary
        script_dir = os.path.dirname(os.path.abspath(sys.executable))
    return os.path.normpath(os.path.join(script_dir, os.pardir))

def target_name_from_dir(path: str) -> str:
    return os.path.basename(os.path.normpath(path))

def update_project_win(content: str, home: str) -> str:
    """
    We have to use lamda functions to avoid the problem with Windows paths and re.sub calls
    raising errors like 're.error: bad escape'.
    Only the ABASM_HOME line is rewritten, so everything else in the make file
    (extra tools, customizations, ...) is preserved.
    """
    return re.sub(
        r'^set ABASM_HOME=.*$',
        lambda m: f'set ABASMHOME={home}',
        content,
        flags=re.MULTILINE,
    )

def update_project_unix(content: str, home: str) -> str:
    """ 
    Linux shouldn't have the same problem than Windows with bars in the path, but
    lets use the lambda workaround just in case.
    Only the ABASMHOME line is rewritten, so everything else in the make file
    (extra tools, customizations, ...) is preserved.
    """
    return re.sub(
        r'^ABASMHOME=.*$',
        lambda m: f'ABASMHOME="{home}"',
        content,
        flags=re.MULTILINE,
    )

def update_project(target_dir: str, is_windows: bool) -> None:
    make_name = "make.bat" if is_windows else "make.sh"
    make_path = os.path.join(target_dir, make_name)

    if not os.path.isfile(make_path):
        print(f"{make_name} was not found in {target_dir}", file=sys.stderr)
        sys.exit(1)

    home = abasm_home_dir()

    with open(make_path, "r", encoding="utf-8") as f:
        content: str = f.read()
    if is_windows:
        content = update_project_win(content, home)
    else:
        content = update_project_unix(content, home)
    if home not in content:
        print(f"No ABASMHOME line found in {make_path}", file=sys.stderr)
        print("The file is not an asmprj generated make file. Regenerate it with -n", file=sys.stderr)
        sys.exit(1)
    with open(make_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print(f"{make_name} was sucessfully updated")

def create_project(target_dir: str, is_windows: bool) -> None:
    target_name: str = target_name_from_dir(target_dir)
    home = abasm_home_dir()

    make_name: str
    make_content: str
    if is_windows:
        make_name = "make.bat"
        make_content = WINDOWS_TEMPLATE.format(
            HOME=home,
            TARGET=target_name,
        )
    else:
        make_name = "make.sh"
        make_content = UNIX_TEMPLATE.format(
            HOME=home,
            TARGET=target_name,
        )

    make_path: str = os.path.join(target_dir, make_name)
    with open(make_path, "w", newline="\n") as f:
        f.write(make_content)

    if not is_windows:
        st: os.stat_result = os.stat(make_path)
        os.chmod(make_path, st.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

    print(f"Project initialized: {target_dir}")
    print(f"- {make_name} created")
    main_asm_path: str = os.path.join(target_dir, "main.asm")
    if not os.path.exists(main_asm_path):
        with open(main_asm_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(MAIN_ASM)
        print(f"- main.asm created")

def create_argv_parser() -> argparse.ArgumentParser:
    parser: argparse.ArgumentParser = argparse.ArgumentParser(
        description="Creates or updates an ABASM project skeleton"
    )
    group: argparse._MutuallyExclusiveGroup = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-n", "--new", metavar="TARGET DIRECTORY",
        help="Generates a new project folder with a make file (use '.' for current directory)",
    )
    group.add_argument(
        "-u", "--update", metavar="TARGET DIRECTORY",
        help="Updates paths to ABASM and DSK tools",
    )
    parser.add_argument(
        "-v", "--version", action='version', version=f' Asmprj Version {__version__}',
        help = "Shows program's version and exits")
    return parser

def main() -> None:
    parser: argparse.ArgumentParser = create_argv_parser()
    args: argparse.Namespace = parser.parse_args()
    is_windows: bool = platform.system().lower().startswith("win")

    target_dir: str
    if args.update is not None:
        target_dir = (
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
