1 ' DIAMON TRAIL
2 ' A BASIC program appeared in Machine Code Routines for your Amstrad
3 ' to ilustrate the use of SCR HW SCROLL (firmware call). That call
4 ' has been added as a routine in BASE package which is append at the end
10 RANDOMIZE TIME:hi=0
20 CLS:sc=0:x=3+INT(RND*24):y=10:c=x+y\2
30 x=3+INT(RND*24):c=x+y\2
40 LOCATE 1,1:PRINT STRING$(x,CHR$(143));STRING$(y," ");STRING$(40-x-y,CHR$(143))
50 IF RND<0.3 THEN PEN 3:LOCATE x+1+INT(RND*y),1:PRINT CHR$(203):PEN 1
60 IF RND<0.15 THEN PEN 2:LOCATE x+1+INT(RND*y),1:PRINT CHR$(227):PEN 1
70 LOCATE c,22:PRINT " "
80 c=c+(INKEY(8)=0)-(INKEY(1)=0)
90 GOSUB 10000 ' scrScrollDown
100 t=TEST(c*16-8, 56)
110 LOCATE c,22:PRINT CHR$(229)
120 LOCATE 1,25:PRINT "PTOS:";SC
130 IF t=1 OR t=3 GOTO 180
140 IF t=2 THEN SOUND 1,40,5,7:sc=sc+50
150 sc=sc+10:IF sc MOD 300=0 THEN y=y-1-(y=5)
160 x=x+INT(RND*3)-1+(x>24)-(x<3)
170 GOTO 40
180 CLS:LOCATE 5,10:PRINT"CRAAAAAAASH!!!!"
190 SOUND 1,1000,200,7
200 LOCATE 5,11:PRINT"TU PUNTUACION HA SIDO DE";sc
210 IF sc<hi GOTO 230
220 LOCATE 5,12:PRINT"ES UN NUEVO RECORD": hi=sc
230 LOCATE 5,13:PRINT"EL RECORD ACTUAL ES";hi
240 LOCATE 6,24:PRINT"Pulsa espacio para jugar nuevamente"
250 WHILE INKEY$<>" ":WEND
260 GOTO 20
270 CHAIN MERGE "base/base.bas"
10000 ' Call to library SUB scrScrollDown
10001 ' which comes from base/base.bas
10002 CALL scrScrollDown(): RETURN