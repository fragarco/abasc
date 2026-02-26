CLS
T! = TIME
DIM Proofer$(4) 
DIM ProoferSurname$(4)
DIM a(10,10)
FOR n=0 to 4 
    READ Proofer$(n)  
    READ ProoferSurname$(n)  
    PRINT Proofer$(n);" "ProoferSurname$(n)   
    DATA Bob,Smith,Dicky,Jones,Malcolm,Green,Alan,"Brown",Ivor,Curry
NEXT

FOR times=0 TO 10
    FOR N=0 TO 5 
        READ A$ 
        PRINT A$;" ";
        LABEL LOOPDATA
        DATA restored,data,can,be,read,again   
    NEXT 
    PRINT 
    RESTORE LOOPDATA
NEXT
PRINT TIME-T!

WHILE INKEY$ = "": WEND

RESTORE DATABLOCK
FOR j=0 to 5
    FOR i=0 to 5
        READ a(i,j): PRINT i;j,a(i,j)
    NEXT
NEXT
END

LABEL DATABLOCK
DATA 10,-11,12,-13,14,-15
DATA 20,-21,22,-23,24,-25
DATA 30,-31,32,-33,34,-35
DATA 40,-41,42,-43,44,-45
DATA 50,-51,52,-53,54,-55
DATA 60,-61,62,-63,64,-65
