1 ' THIS CODE IS A MODIFICATION OF TU_PRIMER_JUEGO.BAS INCLUDED
2 ' IN THE 8 BITS DE PODER FRAMEWORK.
3 ' PLEASE NOTICE THAT IT USES THE LOAD COMMAND HERE INSTEAD
4 ' OF USING AN EXTERNAL LOADER.
5 ' 
6 ' NOTICE ALSO THAT ANY FLOAT VALUE MUST BE EXPLICITLY CONVERTED
7 ' TO INTEGER BECAUSE ABASC CANNOT CHECK THE RSX PARAMS SIGNATURE
8 ' AND FLOATS WILL BE PASSED AS POINTERS TO THE 5-BYTES REAL NUMBERS'
9 '
10 MEMORY 23599: LOAD "8bp0.bin",23600 ' ASSEMBLING OPTION =0
20 MODE 0: DEFINT A-Z: CALL &6B78:' install RSX
21 ENT 1,10,100,3
30 ON BREAK GOSUB 320 
40 CALL &BC02:'restaura paleta por defecto por si acaso
50 INK 0,0:'fondo negro
60 FOR j=0 TO 31:|SETUPSP,j,0,0:NEXT:|3D,0:'reset sprites
70 |SETLIMITS,0,80,0,124: ' establecemos los limites de la pantalla de juego
80 PLOT 0,74*2:DRAW 640,74*2
90 x=40:y=100:' coordenadas del personaje
100 PRINT "SCORE:"
110 |SETUPSP,31,0,1+32:' status del personaje
120 |SETUPSP,31,7,1'secuencia de animacion asignada al empezar
130 |LOCATESP,31,y,x:'colocamos al sprite (sin imprimirlo aun)
140 |MUSIC,1,0,0,5:puntos=0      
150 cor=32:cod=32:|COLSPALL,@cor,@cod:' configura comando de colision
160 |PRINTSPALL,0,0,0,0: 'configura comando de impresion
170 '--- ciclo de juego ---
180 c=c+1
190 ' lee el teclado y posiciona al personaje
191 IF INKEY(27)=0 THEN IF dir<>0 THEN |SETUPSP,31,7,1:dir=0 ELSE |ANIMA,31:x=x+1:GOTO 195
192 IF INKEY(34)=0 THEN IF dir<>1 THEN |SETUPSP,31,7,2:dir=1 ELSE |ANIMA,31:x=x-1
195 |LOCATESP,31,y,x
200 |AUTOALL:|PRINTSPALL
210 |COLSPALL
220 IF cod<32 THEN BORDER 7:SOUND 4,638,30,15,0,1:puntos=puntos-1:|SETUPSP,cod,0,9:LOCATE 7,1:PRINT puntos:GOTO 250 ELSE BORDER 0    
230 IF c MOD 20=0 THEN puntos=puntos+10 :LOCATE 7,1:PRINT puntos
235 ' WARNING: original RND*3-1 and RND*80 have been modifyed to use CINT, otherwise ABASC will try to pass a real number to these
236 ' RSX functions. Unfortunately, there is no way for ABASC to know what types are expected in each RSX call, therefore must be
237 ' the programmer who performs any required cast.
240 IF c MOD 5=0 THEN |SETUPSP,i,9,19:|SETUPSP,i,5,4,CINT(RND*3.0-1.0):|SETUPSP,i,0,11:|LOCATESP,i,10,CINT(RND*80.0): i=i+1:IF i=30 THEN i=0
250 IF c < 1000 GOTO 180
310 '---fin del juego---
320 |MUSIC: INK 0,0:PEN 1:BORDER 0