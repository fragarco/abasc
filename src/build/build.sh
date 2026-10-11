#!/usr/bin/env bash

SCRIPTDIR=$(dirname "$0")

COMMON_FLAGS="--onefile -p$SCRIPTDIR/../ -p$SCRIPTDIR/../utils -p$SCRIPTDIR/../emitters --distpath $SCRIPTDIR/../../bin"

ABASC="pyinstaller $SCRIPTDIR/../abasc.py $COMMON_FLAGS"
BASPRJ="pyinstaller $SCRIPTDIR/../basprj.py $COMMON_FLAGS"
ABASM="pyinstaller $SCRIPTDIR/../utils/abasm.py $COMMON_FLAGS"
DSK="pyinstaller $SCRIPTDIR/../utils/dsk.py $COMMON_FLAGS"
CDT="pyinstaller $SCRIPTDIR/../utils/cdt.py $COMMON_FLAGS"
IMG="pyinstaller $SCRIPTDIR/../utils/img.py $COMMON_FLAGS"
ASMPRJ="pyinstaller $SCRIPTDIR/../utils/asmprj.py $COMMON_FLAGS"

$ABASC && $BASPRJ && $ABASM && $DSK && $CDT && $IMG && $ASMPRJ

rm -rd "$SCRIPTDIR/../../bin/lib"
cp -R "$SCRIPTDIR/../lib/" "$SCRIPTDIR/../../bin/lib/"