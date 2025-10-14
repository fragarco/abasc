CLS
T1 = TIME
DIM Proofer$(4) 
DIM ProoferSurname$(4)  
FOR n=0 to 4 
    READ Proofer$(n)  
    READ ProoferSurname$(n)  
    PRINT Proofer$(n);" "ProoferSurname$(n)   
    DATA Bob,Smith,Dicky,Jones,Malcolm,Green,Alan,"Brown",Ivor,Curry
NEXT
T2 = TIME
FOR times=0 TO 10
    FOR N=0 TO 5 
        READ A$ 
        PRINT A$;" ";
        LABEL loopdata
        DATA restored,data,can,be,read,again   
    NEXT 
    PRINT 
    RESTORE loopdata
NEXT
PRINT T2-T1,TIME-T2
END