' -----------------------------LICENSE NOTICE------------------------------------
'   This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'
'  This program is free software: you can redistribute it and/or modify
'  it under the terms of the GNU Lesser General Public License as published by
'  the Free Software Foundation, either version 3 of the License, or
'  (at your option) any later version.
'
'  This program is distributed in the hope that it will be useful,
'  but WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

' Code adapted to ABASC by Javier "Dwayne Hicks" Garcia
'
' Details about this example:
'
'    cpctpx2byteM1 function gets 4 values, corresponding to 4 firmware colours, 
' for each one of the 4 pixels that can be drawn with 1 single byte in Mode 1. 
' Then this function mixes all these 4 values into 1 8-bit value which is in 
' screen pixel format. Drawing 1 byte of that pattern is the same as drawing 4
' pixels on the screen with the 4 given colours, in the given order. 
'
'    This byte pattern can be used in drawSolidBox and clearScreen functions.
'
CHAIN MERGE "cpctelera/cpctelera.bas"

call cpctRemoveInterruptHandler()
call cpctClearScreen(&00)

' Lets draw some boxes

' 3 boxes with varying colour patterns
call cpctDrawSolidBox(&C235, cpctpx2byteM1(2, 2, 1, 1), 10, 20) 
call cpctDrawSolidBox(&C245, cpctpx2byteM1(1, 0, 2, 1), 10, 20) 
call cpctDrawSolidBox(&C255, cpctpx2byteM1(0, 2, 0, 1), 10, 20) 

' 3 stripped boxes in 2 alternating colours
call cpctDrawSolidBox(&C325, &AA, 10, 20) ' &AA = cpct_px2byteM1(3, 0, 3, 0)
call cpctDrawSolidBox(&C335, &A0, 10, 20) ' &A0 = cpct_px2byteM1(1, 0, 1, 0)
call cpctDrawSolidBox(&C345, &0A, 10, 20) ' &0A = cpct_px2byteM1(2, 0, 2, 0)

' Another 3 stripped boxes, with the strips displaced
call cpctDrawSolidBox(&C415, &55, 10, 20) ' &55 = cpct_px2byteM1(0, 3, 0, 3)
call cpctDrawSolidBox(&C425, &50, 10, 20) ' &50 = cpct_px2byteM1(0, 1, 0, 1)
call cpctDrawSolidBox(&C435, &05, 10, 20) ' &05 = cpct_px2byteM1(0, 2, 0, 2)
                     
' 3 Boxes in solid colour (4 pixels of the same colour)
call cpctDrawSolidBox(&C505, cpctpx2byteM1(3, 3, 3, 3), 10, 20) ' &FF 
call cpctDrawSolidBox(&C515, cpctpx2byteM1(2, 2, 2, 2), 10, 20) ' &F0
call cpctDrawSolidBox(&C525, cpctpx2byteM1(1, 1, 1, 1), 10, 20) ' &0F

END

