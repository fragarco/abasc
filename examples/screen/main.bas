' This is not the best example of how to load two images and cicle them.
' But the idea is just to show how to load a simple screen file generated
' using the IMG.py tool. Check out the make file to see how both screens
' are generated.

' WARNING: as this example uses IMG.py, the Python installation needs to
' have installed the Python's standard library to manage image files.
' this could be performed easily using the command:
' pip3 install pillow

MODE 0
BORDER 0

LABEL START

INK 0,0: INK 1,7: INK 2,13: INK 3,16: INK 4,17: INK 5,1: INK 6,4: INK 7,26
INK 8,10: INK 9,3: INK 10,25: INK 11,14: INK 12,12: INK 13,23: INK 14,9: INK 15,6
LOAD "poli1.scn", &C000

FOR i=0 to 800: FRAME: NEXT

CLS
INK 0,0: INK 1,26: INK 2,17: INK 3,13: INK 4,5: INK 5,14: INK 6,4: INK 7,25
INK 8,1: INK 9,16: INK 10,12: INK 11,3: INK 12,10: INK 13,11: INK 14,22: INK 15,9
LOAD "poli2.scn", &C000

FOR i=0 to 800: FRAME: NEXT
CLS
GOTO START
END

