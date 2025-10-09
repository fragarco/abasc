10 ' CHR$ Example of use with special transparency mode
20 ' This example is taken from the Fremos old webpage and
30 ' its series of tutorials about printing sprites in BASIC
40 ' http://fremos.cheesetea.com/2014/03/06/sprites-con-caracteres-en-basic-amstrad-cpc
50 MODE 1
60 LOCATE 10,20
70 PEN 2: PRINT CHR$(233)
80 PRINT CHR$(22)+CHR$(1)
90 LOCATE 10,20
100 PEN 3: PRINT CHR$(232)
110 END