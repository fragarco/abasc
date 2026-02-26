10 'BOMBARDERO por DAVE TOWN
20 'copyright (c) AMSOFT 1984
30 '
40 MODE 1:CLS:INK 0,0:BORDER 0:INK 1,18:INK 2,6:INK 3,4:INK 5,15:INK 6,2:INK 7,24:INK 8,8:INK 9,26:INK 10,10:INK 11,20:INK 12,12:INK 13,16:INK 14,14:INK 15,21
50 SYMBOL AFTER 240:SYMBOL 241,&40,&60,&70,&7F,&7F,&EF,&7,&0:SYMBOL 242,&0,&32,&7A,&FE,&FA,&F2,&E0,&0
60 puntos=0:maxi=0:avi$=CHR$(241)+CHR$(242):x=2:y=2:cae=0:a=2:b=2
70 GOSUB 480
80 CLS
90 PEN 2:LOCATE 1,15:INPUT"Elija nivel: 0 (AS) a 5 (PRINCIPIANTE) ",nivel
100 IF nivel<0 OR nivel>5 THEN GOTO 90
110 nivel=nivel+10
120 LOCATE 1,15:PRINT CHR$(18);:LOCATE 1,15:INPUT"Elija velocidad: 0 (MAX) a 100(MIN) ",vel
130 IF vel>100 OR vel<0 GOTO 120
140 '
150 'Edificios
160 '
170 MODE 0:FOR base=5 TO 15:FOR altura=21 TO INT(RND(1)*8+nivel) STEP-1:LOCATE base,altura:PEN base-2:PRINT CHR$(143)+CHR$(8)+CHR$(11)+CHR$(244);:NEXT:NEXT
180 PLOT 0,20,4:DRAW 640,20,4
190 LOCATE 1,25:PEN 2:PRINT"PUNTOS";puntos;:LOCATE 13,25:PRINT"MAX";maxi;
200 '
210 'Juego
220 '
230 FRAME
235 LOCATE x-1,y:PRINT" ";
240 PEN 1:LOCATE x,y:PRINT avi$;:PEN 2
245 FOR DELAY=0 to 1000: NEXT
250 IF y=21 AND x=15 THEN GOTO 290:ELSE GOTO 340
260 '
270 'Aterriza
280 '
290 FOR c=0 TO 1000:NEXT
300 puntos=puntos+100-(nivel*2):nivel=nivel-1:x=2:y=2:a=2:b=2:cae=0
310 IF nivel<10 THEN nivel=10:vel=vel-20
320 IF vel<0 THEN vel=0
330 GOTO 150
340 FOR c=0 TO vel:NEXT
350 x=x+1
360 IF x=18 THEN LOCATE x-1,y:PRINT CHR$(18);:x=2:y=y+1:LOCATE x,y:PEN 1:PRINT avi$;:PEN 2
370 a$=INKEY$:IF a$=" " AND cae=0 THEN cae=1:b=y+2:a=x
380 IF y=21 THEN cae=0
390 IF cae=1 THEN LOCATE a,b:PRINT CHR$(252);:LOCATE a,b-1:PRINT" ";:b=b+1:IF b>21 THEN LOCATE a,b:PRINT" ";:LOCATE a,b-1:PRINT" ";:LOCATE a,b-1:PRINT" ":a=0:b=0:cae=0:SOUND 3,4000,10,12,0,0,10
400 ga=(a-0.5)*32:gb=400-(b*16):bomba=TEST(ga,gb)
410 IF bomba>0 THEN GOTO 670
420 gx=((x+1.5)*32):gy=408-(y*16):choque=TEST(gx,gy)
430 IF choque>0 THEN GOTO 570
440 GOTO 230
450 '
460 'Instrucciones
470 '
480 LOCATE 1,2:PEN 1:PRINT"Usted esta pilotando un avion sobre una ciudad desierta y tiene que pasar sobre los edificios para aterrizar y repostar.Su avion se mueve de izquierda a derecha.";:PRINT
490 PRINT:PRINT"Al llegar a la derecha, el avion vuelve a salir por la izquierda, pero MAS BAJO.Dispone de un numero limitado de bombas y puede hacerlas caer sobre los edifici-cios pulsando la BARRA ESPACIADORA.";:PRINT
500 PRINT:PRINT"Cada vez que aterriza, sube la alturade los edificios y la velocidad.";:PRINT:PRINT:PRINT"UNA VEZ DISPARADA UNA BOMBA,YA NO PUEDE DISPARAR OTRA MIENTRAS NO HAYA EXPLOSIO-NADO LA PRIMERA!!!":
510 PEN 2:LOCATE 1,24:PRINT:PRINT"Pulse una tecla para empezar.";
520 a$=INKEY$:IF a$="" GOTO 520
530 RETURN
540 '
550 'Colision
560 '
570 LOCATE x-1,y:PRINT CHR$(32)+CHR$(32)+CHR$(32)+CHR$(253)+CHR$(8)+CHR$(238)+CHR$(8);
580 FOR t=1 TO 10:SOUND 7,4000,5,15,0,0,5:PEN t:PRINT CHR$(253)+CHR$(8)+CHR$(238)+CHR$(8)+CHR$(32)+CHR$(8);:FOR tm=0 TO 50:NEXT:NEXT:PEN 2
590 CLS:LOCATE 1,5:PRINT"Ha conseguido";puntos;"puntos."
600 IF puntos>maxi THEN maxi=puntos:LOCATE 1,8:PRINT"BATIO EL RECORD!!";
610 puntos=0:LOCATE 1,12:PRINT"Pulse V para volver a empezar";
620 a$=INKEY$:IF a$="v" OR a$="V" GOTO 630 ELSE GOTO 620
630 PEN 1:MODE 1:x=2:y=2:a=2:b=2:GOTO 90
640 '
650 'Edificio bombardeado
660 '
670 LOCATE a,b-1:PRINT" "+CHR$(8);:PEN 4:FOR tr=1 TO INT(RND(1)*3)+1:puntos=puntos+ 5:SOUND 3,4000,10,12,0,0,10:LOCATE a,b:FOR t=0 TO 4:PRINT CHR$(253)+CHR$(8)+CHR$(32)+CHR$(8);:NEXT:b=b+1
680 IF b=24 THEN b=b-1
690 NEXT
700 LOCATE 7,25:PEN 2:PRINT puntos;:cae=0:a=x:b=y:PEN 4:GOTO 230
                                