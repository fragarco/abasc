10 ' This is small variation of the BASIC test
20 ' created by Noel Llopis to measure the speed of
30 ' different BASIC versions in 8 bit machines
40 ' Amstrad usually takes around 28s when using real numbers
50 ' and 17s when using integers.
60 ' This is a good way to measure if the compiler produces
70 ' speed improvements at all.
80 T = TIME
90 CLS
100 FOR i=1 to 10
110 FOR j=1 to 1000
120 s = 1000 + j
130 NEXT j
140 PRINT ".";
150 NEXT i
160 PRINT " END!"
170 PRINT TIME-T
180 END
