10 ' Example of how to see the real representation of a number in memory
20 T=TIME
30 CLS
40 a! = 43.375
50 PRINT "PRINT ADDRESS";@a!    ' prints the memory address
60 PRINT "MEMORY CONTENT (HEX):"
70 FOR i=0 TO 4
80 PRINT i,HEX$(PEEK(@a!+i), 2)
90 NEXT
100 PRINT "MEMORY CONTENT (BIN):"
110 FOR i=0 TO 4
120 PRINT i,BIN$(PEEK(@a!+i), 8)
130 NEXT
140 PRINT "TIEMPO:"TIME-T
150 END
