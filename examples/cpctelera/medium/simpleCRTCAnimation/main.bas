'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2017 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'
'  This program is free software: you can redistribute it and/or modify
'  it under the terms of the GNU Lesser General Public License as published by
'  the Free Software Foundation, either version 3 of the License, or
'  (at your option) any later version.
'
'  This program is distributed in the hope that it will be useful,
'  but WITHOUT ANY WARRANTY without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

chain merge "cpctelera/cpctelera.bas"

'''''''''''''''''''''''''''''''''/
' INITIALIZATION
'    Sets the initial configuration for the CPC
'
sub initialization
   shared HWC.BLACK, CPCT.VMEMSTART
   ' Disable the firmware to prevent it from resetting the colour of the border
   call cpctRemoveInterruptHandler()
   ' Set Border colour to black
   call cpctSetBorder(HWC.BLACK)
   ' Draw a stripes pattern at the screen
   call cpctMemsetf8(CPCT.VMEMSTART, &35CA, &4000)
end sub

'''''''''''''''''''''''''''''''''/
' OPEN-CLOSE ANIMATION
'    Performs one step of openning or closing the screen visible
' area. It does so by setting CRTC Register 1 (which controls
' the visible width of the screen in charaters).
v = 0
sub openCloseAnimation
   shared v

   ' Change the width of the screen in characters to its next value
   value = peek(@LABEL(widths) + v)
   call cpctSetCRTCReg(1, value)   ' Set CRTC Register 1 = Screen Width in characters
   
   ' Calculate next width in the widhts vector by adding 1 to v and
   ' then performing modulo 128 operation to ensure it does
   ' cicle over the 128 widths without going out of range
   v = (v + 1) mod 128
end sub

'''''''''''''''''''''''''''''''''/
' MAIN PROGRAM
label MAIN
   call initialization() ' Initialize the screen
   ' Main animation loop
   while 1
      call cpctWaitVSYNC()      ' Wait for VSYNC
      call openCloseAnimation() ' Perform animation step

      ' Wait for 2 consecutive interrupts to ensure
      ' we have exited from the VSYNC up signal zone.
      ' Otherwise, cpct_waitVSYNC would detect VSYNC 
      ' instantly, not waiting for next VSYNC, which is
      ' what we want.
      call cpctWaitHalts(2)
   wend
end

'
' WIDTHS TABLE
'    This 128-byte table holds the widths the screen has to be
' configured to. This table has been calculated using a sinus
' distribution in order to simulate smooth acceleration and 
' deceleration of the close-open movement
'
label widths
   asm "db 40, 40, 40, 40, 40, 40, 39, 39, 39, 39, 39, 38, 38, 38, 37, 37"
   asm "db 37, 36, 36, 35, 35, 34, 34, 33, 33, 32, 32, 31, 30, 30, 29, 28"
   asm "db 28, 27, 26, 26, 25, 24, 23, 22, 22, 21, 20, 19, 18, 17, 16, 15"
   asm "db 15, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0"
   asm "db  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15"
   asm "db 15, 16, 17, 18, 19, 20, 21, 22, 22, 23, 24, 25, 26, 26, 27, 28"
   asm "db 28, 29, 30, 30, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37"
   asm "db 37, 37, 38, 38, 38, 39, 39, 39, 39, 39, 40, 40, 40, 40, 40, 40"
