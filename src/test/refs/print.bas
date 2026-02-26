' Simple example of jumping to labels and the use
' of PRINT and INKEY$

CLS
LABEL start
PRINT "Select Yes or No (Y/N)?"
tries = 0

LABEL mainloop
    a$=INKEY$
    IF a$="" THEN GOTO mainloop
    IF a$="y" OR a$="Y" THEN GOTO endyes
    IF a$="N" OR a$="n" THEN GOTO endno
    PRINT "You typed ";a$
    tries = tries + 1
    GOTO mainloop

LABEL endyes
    PRINT "You have selected YES ";
    PRINT "after ";tries;" tries"
    tries = 0
    GOTO start

LABEL endno
    PRINT "You have selected NO ";
    PRINT "after ";tries;" tries"
    tries = 0
    GOTO start


