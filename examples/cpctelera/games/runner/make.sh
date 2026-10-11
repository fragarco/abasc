#!/bin/sh

#
# This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
# and generate files that can be used in emulators or real  hardware for the Amstrad CPC
#
# USAGE: ./make.sh [clear | dsk]
#


ABASC_HOME="../../../.."

# If the "bin" folder exists, all tools are taken from there;
# otherwise they fall back to the Python scripts from "src".

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
