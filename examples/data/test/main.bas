10 CLS
20 T1 = TIME
30 DIM Proofer$(4)
40 DIM ProoferSurname$(4)
50 FOR n=0 to 4
60 READ Proofer$(n)
70 READ ProoferSurname$(n)
80 PRINT Proofer$(n);" "ProoferSurname$(n)
90 DATA Bob,Smith,Dicky,Jones,Malcolm,Green,Alan,"Brown",Ivor,Curry
100 NEXT
110 T2 = TIME
120 FOR times=0 TO 10
130 FOR N=0 TO 5
140 READ A$
150 PRINT A$;" ";
160 'LABEL loopdata
170 DATA restored,data,can,be,read,again
180 NEXT
190 PRINT
200 RESTORE 160
210 NEXT
220 PRINT T2-T1,TIME-T2
230 END
