' Example of how to see the real representation of a number in memory
T!=TIME
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

REM real number printing
print "0.0", 0.0
print "1000", 1000.0
print "0.1", 0.1
print "0.3", 0.3
print "0.06339", 0.06339
print "0.006339", 0.006339
print "-0.3", -0.3
print "-0.006339", -0.006339
print "0.000001", 0.000001
print "0.0000001", 0.0000001
print "0.00000001", 0.00000001
print "1.23456789", 1.23456789
print "0.123456789", 0.123456789
print "5", 5.0
print "123", 123.0
print "1099", 1099.0
print "1234.567", 1234.567
print "-123", -123.0
print "-1099", -1099.0
print "123456789", 123456789
print "1.234567E+09", 1234567890 
print "1.0000E+09", 1000000000
print "1.0000E+10", 10000000000.0
print "1.3000E+10", 12999999999.0
print "1.0000E-10", 0.0000000001
print "6.34000E-03", 0.0063399999 

PRINT "TIEMPO:"TIME-T!
END
