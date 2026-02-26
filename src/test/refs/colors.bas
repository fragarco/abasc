' Simple example using the main commands to control
' screen and text colors
T! = TIME
MODE 1
BORDER 0
PAPER 3
INK 0,1,2
PEN 0
PRINT "Hello world"
PRINT TIME - T!
END