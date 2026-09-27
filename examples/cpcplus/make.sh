#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

SOURCE=main
TARGET=mchase

COMPILE="python3 ../../src/abasc.py"
DSK="python3 ../../src/utils/dsk.py"
DATAADDR=0x8000

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
    $DSK $TARGET.dsk -n --put-raw assets/TITLE.SCR --flag-sys
    $DSK $TARGET.dsk --put-raw assets/INSTR.SCR --flag-sys
    $DSK $TARGET.dsk --put-raw assets/MUSIC.BIN --flag-sys
    $DSK $TARGET.dsk --put-raw assets/PLAYER.BIN --flag-sys
    $COMPILE $SOURCE.BAS --data=$DATAADDR $2 $3 && $DSK $TARGET.dsk --put-bin $SOURCE.bin --load-addr=0x0040 --start-addr=0x0040
else
    $COMPILE $SOURCE.BAS --data=$DATAADDR $@
fi
