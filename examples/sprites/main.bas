' This example shows how to include a library (sprites.bas is located in
' src/lib/base).
' Instead of RESTORE <label>: call DRAWSP8xH(x,Y,8) is also possible to use
' call DRAWSPADDR8xH(@LABEL(<label>),X,Y,8)

CHAIN MERGE "base/screen.bas"

MODE 1
BORDER 0
FOR Y=8 TO 200 STEP 2
    FOR X=1 TO 300 STEP 2
        RESTORE CLEARSP:  call ScrDrawSprite(X,Y)
        RESTORE MYSPRITE: call ScrDrawSprite(X+2,Y)
        FRAME
    NEXT
    RESTORE CLEARSP: call ScrDrawSprite(X+2,Y)
NEXT
END

' Sprite data format:
'     1st byte = Width in bytes
'     2nd byte = Height in lines
'     n bytes  = pixel information
' CAUTION: DATA expects 16 bit numbers so the first number codifies
' width and height (as the Amstrad CPC is little-endian height goes
' in the MSB and weidth in the LSB')
LABEL MYSPRITE:
DATA &0802  ' width = 2 bytes, height = 8 lines
DATA &C030
DATA &E070
DATA &F4F2
DATA &F0F0
DATA &F0F0
DATA &B4D2
DATA &6861
DATA &C030

LABEL CLEARSP:
DATA &0802  ' width = 2 bytes, height = 8 lines
DATA 0,0,0,0,0,0,0,0