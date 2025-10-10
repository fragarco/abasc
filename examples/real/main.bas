' Example of how to see the real representation of a number in memory
T=TIME
CLS
a! = 43.375
PRINT "PRINT ADDRESS";@a!    ' prints the memory address
PRINT "MEMORY CONTENT (HEX):"
FOR i=0 TO 4
    PRINT i,HEX$(PEEK(@a!+i), 2)
NEXT
PRINT "MEMORY CONTENT (BIN):"
FOR i=0 TO 4
    PRINT i,BIN$(PEEK(@a!+i), 8)
NEXT
PRINT "TIEMPO:"TIME-T
END
