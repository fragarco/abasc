10 ' Example of how to see the real representation of a number in memory
20 T!=TIME
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
140 REM real number printing
150 print "0.0", 0.0
160 print "1000", 1000.0
170 print "0.1", 0.1
180 print "0.3", 0.3
190 print "0.06339", 0.06339
200 print "0.006339", 0.006339
210 print "-0.3", -0.3
220 print "-0.06339", -0.006339
230 print "0.000001", 0.000001
240 print "0.0000001", 0.0000001
250 print "0.00000001", 0.00000001
260 print "1.23456789", 1.23456789
270 print "0.123456789", 0.123456789
280 print "5", 5.0
290 print "123", 123.0
300 print "1099", 1099.0
310 print "1234.567", 1234.567
320 print "-123", -123.0
330 print "-1099", -1099.0
340 print "123456789", 123456789
350 print "1.234567E+09", 1234567890
360 print "1.0000E+09", 1000000000
370 print "1.0000E+10", 10000000000.0
380 print "1.3000E+10", 12999999999.0
390 print "1.0000E-10", 0.0000000001
400 print "6.34000E-03", 0.0063399999
410 PRINT "TIEMPO:"TIME-T!
420 END
