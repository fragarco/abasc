'Example taken from https://amstrad.es/forum/viewtopic.php?t=1736
'***********************************
'*********** FILL - Basic **********
MODE 1:DIM x(50),y(50)
T!=TIME

MOVE 100,100
DRAW 150,150,2:DRAW 100,200:DRAW 200,200:DRAW 180,180:DRAW 200,140:DRAW 200,100:DRAW 100,100
MOVE 120,120:TAG:PRINT"X Y Z";:TAGOFF

'*** Calling parameters
x=160:y=160:f=3:GOSUB FILLSUB:PRINT TIME-T!:END

LABEL FILLSUB
    '******** Subrutine FILL ********
    '*** Test background color
    z=0:hf=TEST(x,y):IF hf=f THEN RETURN
    '*** Are coord still inside the screen?
    LABEL DRAWLINE
    IF x<0 OR x>639 OR y<0 OR y>399 THEN GOTO NEWCOORDS
    '*** Search going up
    WHILE TEST(x,y)=hf AND y<399
        y=y+2
    WEND
    y=y-2:fl=-1:fr=-1
    '*** Draw line going down
    1090 WHILE y>=0 AND TEST(x,y)=hf
        '*** Test to the left
        vfl=fl:fl=TEST(x-2,y)
        IF vfl<>hf AND fl=hf THEN x(z)=x-2:y(z)=y:z=z+1
        '*** Test to the right
        vfr=fr:fr=TEST(x+2,y)
        IF vfr<>hf AND fr=hf THEN x(z)=x+2:y(z)=y:z=z+1
        '*** Draws a point
        PLOT x,y,f:y=y-2
    WEND
    LABEL NEWCOORDS
    '*** Extract new coords
    z=z-1
    IF z>=0 THEN x=x(z):y=y(z):GOTO DRAWLINE
    '*** Return if empty
RETURN