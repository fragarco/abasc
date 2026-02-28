#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

BASC="python3 ../../../../src/abasc.py"
DSK="python3  ../../../../src/utils/dsk.py"
CDT="python3  ../../../../src/utils/cdt.py"
IMG="python3  ../../../../src/utils/img.py"
ASM="python3  ../../../../src/utils/abasm.py"

SOURCE=main
TARGET=runner

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
