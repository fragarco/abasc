10 'Example taken from https://amstrad.es/forum/viewtopic.php?t=1736
20 '***********************************
30 '*********** FILL - Basic **********
40 MODE 1:DIM x(50),y(50)
50 T=TIME
60 MOVE 100,100:DRAW 150,150,2:DRAW 100,200:DRAW 200,200:DRAW 180,180:DRAW 200,140:DRAW 200,100:DRAW 100,100
70 MOVE 120,120:TAG:PRINT"X Y Z";:TAGOFF
80 '*** Starting parameters
90 x=160:y=160:f=3:GOSUB 1000:PRINT TIME-T:END
1000 '******** Subrutine FILL ********
1010 '*** Test background color
1020 z=0:hf=TEST(x,y):IF hf=f THEN RETURN
1030 '*** Are coord still inside the screen?
1040 IF x<0 OR x>639 OR y<0 OR y>399 THEN 1190
1050 '*** Search going up
1060 WHILE TEST(x,y)=hf AND y<399:y=y+2:WEND
1070 y=y-2:fl=-1:fr=-1
1080 '*** Draw line going down
1090 WHILE y>=0 AND TEST(x,y)=hf
1100 '*** Test to the left
1110 vfl=fl:fl=TEST(x-2,y)
1120 IF vfl<>hf AND fl=hf THEN x(z)=x-2:y(z)=y:z=z+1
1130 '*** Test to the right
1140 vfr=fr:fr=TEST(x+2,y)
1150 IF vfr<>hf AND fr=hf THEN x(z)=x+2:y(z)=y:z=z+1
1160 '*** Draws a point
1170 PLOT x,y,f:y=y-2
1180 WEND
1190 '*** Extract new coords
1200 z=z-1
1210 IF z>=0 THEN x=x(z):y=y(z):GOTO 1040
1220 '*** Return if empty
1230 RETURN