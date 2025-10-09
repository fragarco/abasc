10 ' Simple example using the main commands to control
20 ' screen and text colors
30 T = TIME
40 MODE 1
50 BORDER 0
60 PAPER 3
70 INK 0,1,2
80 PEN 0
90 PRINT "Hello world"
100 T = TIME - T
110 PRINT T
120 END
