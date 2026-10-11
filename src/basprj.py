#!/usr/bin/env python
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
__version__= "1.4.0"

import argparse
import os
import platform
import stat
import re
import sys

WINDOWS_TEMPLATE: str = r"""@ECHO OFF

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used in emulators or real hardware for the Amstrad CPC
REM *
REM * USAGE: make [clear | dsk]

@setlocal

set ABASC_HOME={HOME}

IF EXIST "%ABASC_HOME%\bin" GOTO :abasc_tools_bin
    SET BASC=python "%ABASC_HOME%\src\abasc.py"
    SET DSK=python "%ABASC_HOME%\src\utils\dsk.py"
    SET CDT=python "%ABASC_HOME%\src\utils\cdt.py"
    SET IMG=python "%ABASC_HOME%\src\utils\img.py"
    SET ASM=python "%ABASC_HOME%\src\utils\abasm.py"
GOTO :abasc_tools_end
:abasc_tools_bin
    SET BASC="%ABASC_HOME%\bin\abasc.exe"
    SET DSK="%ABASC_HOME%\bin\dsk.exe"
    SET CDT="%ABASC_HOME%\bin\cdt.exe"
    SET IMG="%ABASC_HOME%\bin\img.exe"
    SET ASM="%ABASC_HOME%\bin\abasm.exe"
:abasc_tools_end

SET SOURCE=main
SET TARGET={TARGET}
SET LOADADDR=0x0040

SET RUNBAS=%BASC% %SOURCE%.bas
SET RUNDSK=%DSK% %TARGET%.dsk --new --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR%
SET RUNCDT=%CDT% %TARGET%.cdt -n --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR% --name %TARGET%

IF "%1"=="clear" (
    IF EXIST "%SOURCE%.bpp" del "%SOURCE%.bpp"
    IF EXIST "%SOURCE%.lex" del "%SOURCE%.lex"
    IF EXIST "%SOURCE%.ast" del "%SOURCE%.ast"
    IF EXIST "%SOURCE%.sym" del "%SOURCE%.sym"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.asm"
    IF EXIST "%SOURCE%.s" del "%SOURCE%.s"
    IF EXIST "%SOURCE%.lst" del "%SOURCE%.lst"
    IF EXIST "%SOURCE%.map" del "%SOURCE%.map"
    IF EXIST "%SOURCE%.bin" del "%SOURCE%.bin"
    IF EXIST "%TARGET%.dsk" del "%TARGET%.dsk"
    IF EXIST "%TARGET%.cdt" del "%TARGET%.cdt"
) ELSE IF "%1"=="dsk" (
    CALL %RUNBAS% %2 %3 && CALL %RUNDSK%
) ELSE IF "%1"=="cdt" (
    CALL %RUNBAS% %2 %3 && CALL %RUNCDT% 
) ELSE (
    CALL %RUNBAS% %*
)

@endlocal
@ECHO ON
"""

UNIX_TEMPLATE: str = r"""#!/usr/bin/env bash

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

ABASC_HOME="{HOME}"

if [ -d "$ABASC_HOME/bin" ]; then
    BASC="$ABASC_HOME/bin/abasc"
    DSK="$ABASC_HOME/bin/dsk"
    CDT="$ABASC_HOME/bin/cdt"
    IMG="$ABASC_HOME/bin/img"
    ASM="$ABASC_HOME/bin/abasm"
else
    BASC="python $ABASC_HOME/src/abasc.py"
    DSK="python $ABASC_HOME/src/utils/dsk.py"
    CDT="python $ABASC_HOME/src/utils/cdt.py"
    IMG="python $ABASC_HOME/src/utils/img.py"
    ASM="python $ABASC_HOME/src/utils/abasm.py"
fi

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

def abasc_home_dir() -> str:
    """Path to the ABASC root folder (the parent of 'src' and 'bin')."""
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
    We have to use lambda functions to avoid the problem with Windows paths and re.sub
    calls raising errors like 're.error: bad escape'.
    Only the ABASC_HOME line is rewritten, so everything else in the make file
    (extra tools, customizations, ...) is preserved.
    """
    return re.sub(
        r'^set ABASC_HOME=.*$',
        lambda _: f'set ABASC_HOME={home}',
        content,
        flags=re.MULTILINE,
    )

def update_project_unix(content: str, home: str) -> str:
    """ 
    Linux shouldn't have the same problem than Windows with bars in the path, but
    lets use the lambda workaround just in case.
    Only the ABASC_HOME line is rewritten, so everything else in the make file
    (extra tools, customizations, ...) is preserved.
    """
    return re.sub(
        r'^ABASC_HOME=.*$',
        lambda _: f'ABASC_HOME="{home}"',
        content,
        flags=re.MULTILINE,
    )

def update_project(target_dir: str, is_windows: bool) -> None:
    make_name: str = "make.bat" if is_windows else "make.sh"
    make_path: str = os.path.join(target_dir, make_name)

    if not os.path.isfile(make_path):
        print(f"{make_name} was not found in {target_dir}", file=sys.stderr)
        sys.exit(1)

    home = abasc_home_dir()

    with open(make_path, "r", encoding="utf-8") as f:
        content: str = f.read()
    if is_windows:
        content = update_project_win(content, home)
    else:
        content = update_project_unix(content, home)
    if home not in content:
        print(f"No ABASC_HOME line found in {make_path}", file=sys.stderr)
        print("The file is not a basprj generated make file. Regenerate it with -n", file=sys.stderr)
        sys.exit(1)
    with open(make_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print(f"{make_name} was sucessfully updated")

def create_project(target_dir: str, is_windows: bool) -> None:
    target_name: str = target_name_from_dir(target_dir)
    home = abasc_home_dir()

    if is_windows:
        make_name: str = "make.bat"
        make_content: str = WINDOWS_TEMPLATE.format(
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
