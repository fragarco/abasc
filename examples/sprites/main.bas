' This example shows how to include a library (sprites.bas is located in
' src/lib/base).
' Instead of RESTORE <label>: call DRAWSP8xH(x,Y,8) is also possible to use
' call DRAWSPADDR8xH(@LABEL(<label>),X,Y,8)

CHAIN MERGE "base/sprites.bas"

MODE 1
BORDER 0
FOR Y=8 TO 200 STEP 2
    FOR X=1 TO 300 STEP 2
        RESTORE CLEARSP:  call DrawDataSp(X,Y,8)
        RESTORE MYSPRITE: call DrawDataSp(X+2,Y,8)
        FRAME
    NEXT
    RESTORE CLEARSP: call DrawDataSp(X+2,Y,8)
NEXT
END
LABEL MYSPRITE: DATA &C030,&E070,&F4F2,&F0F0,&F0F0,&B4D2,&6861,&C030
LABEL CLEARSP : DATA 0,0,0,0,0,0,0,0