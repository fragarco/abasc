' Example of how to see the real representation of a number in memory

a! = 43.375
PRINT "PRINT ADDRESS";@a!    ' prints the memory address
PRINT "MEMORY CONTENT:"
FOR i=0 TO 4
    PRINT HEX$(PEEK(@a!+i), 2);
NEXT

END