#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#

ABASC_HOME="../.."

# If the "bin" folder exists, all tools are taken from there;
# otherwise they fall back to the Python scripts from "src".

if [ -d "$ABASC_HOME/bin" ]; then
    BASC="$ABASC_HOME/bin/abasc"
    DSK="$ABASC_HOME/bin/dsk"
else
    BASC="python3 $ABASC_HOME/src/abasc.py"
    DSK="python3 $ABASC_HOME/src/utils/dsk.py"
fi

SOURCE=main
TARGET=mchase

COMPILE="$BASC"
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
