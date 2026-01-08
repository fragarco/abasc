#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

BASC="python3 ../../src/abasc.py"
DSK="python3 ../../src/utils/dsk.py"

SOURCE=main
TARGET=bombardero

HEAPADDR=0x0170
CODEADDR=0x4000

RUNBAS="$BASC $SOURCE.bas --code $CODEADDR --heap $HEAPADDR"
RUNDSK="$DSK $TARGET.dsk --new --put-bin $SOURCE.bin --load-addr $HEAPADDR --start-addr $CODEADDR"

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
elif [ "$1" = "dsk" ]; then
    $RUNBAS && $RUNDSK
else
    $RUNBAS $@
fi
