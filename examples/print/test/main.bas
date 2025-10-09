10 ' Simple example of jumping to labels and the use
20 ' of PRINT and INKEY$
30 CLS
40 PRINT "Select Yes or No (Y/N)?"
50 tries = 0
60 'LABEL mainloop
70 a$=INKEY$
80 IF a$="" THEN GOTO 60
90 IF a$="y" OR a$="Y" THEN GOTO 140
100 IF a$="N" OR a$="n" THEN GOTO 190
110 PRINT "You typed ";a$
120 tries = tries + 1
130 GOTO 60
140 'LABEL endyes
150 PRINT "You have selected YES ";
160 PRINT "after ";tries;" tries"
170 tries = 0
180 GOTO 60
190 'LABEL endno
200 PRINT "You have selected NO ";
210 PRINT "after ";tries;" tries"
220 tries = 0
230 GOTO 60
