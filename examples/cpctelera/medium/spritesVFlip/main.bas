'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

'''''''''''''''''''''''''''''''''/
' INCLUDE HEADERS
'
chain merge "cpctelera/cpctelera.bas"

'''''''''''''''''''''''''''''''''/
' DEFINE CONSTANTS
'
const INIT.X = 20    ' Initial coordinates for sprites
const INIT.Y = 100   '
const ROCKET.W = 4
const ROCKET.H = 14

x = INIT.X: y = INIT.Y    ' x, y coordinates
vx = 1: vy = 0            ' vx, vy velocity (vx not 0 to force initial drawing)

'''''''''''''''''''''''''''''''''/
' DRAW ROCKETS
'    Draws a rocket twice at location x, y in the screen. The
' left rocket is drawn normal, and the right one is drawn 1 byte
' to the right (2 mode 0 pixels) and vertically flipped.
'
sub drawRockets(x, y)
   shared CPCT.VMEMSTART
   shared ROCKET.W, ROCKET.H
   '-----Draw the left sprite
   '
   ' Get a pointer to video memory byte for location (x, y)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)
   ' Draw g_rocket sprite at location (x, y) pointed by pvmem
   call cpctDrawSprite(@LABEL("g_rocket"), pvmem, ROCKET.W, ROCKET.H)

   '-----Draw the Right sprite
   '
   ' Assuming pvmem points to upper-left byte of the rocket sprite in
   ' video memory, calculate a pointer to the bottom-left byte.
   ' Equivalent to: cpct_getScreenPtr(CPCT_VMEM_START, x, (y + G_ROCKET_H - 1) )
   pvmem = cpctGetBottomLeftPtr(pvmem, ROCKET.H)
   ' As we don't want to overwrite the left rocket, this right rocket will
   ' be drawn 1 byte to its right. That means moving to the right (adding) 
   ' a number of bytes equal to the width of the rocket + 1. 
   pvmem = pvmem + ROCKET.W + 1
   ' Finally, draw the right rocket vertically flipped. This draw function
   ' does the drawing bottom-to-top in the video memory. That's the reason
   ' to have a pointer to the bottom-left.
   call cpctDrawSpriteVFlip(@LABEL("g_rocket"), pvmem, ROCKET.W, ROCKET.H)  

   ' cpct_drawSpriteVFlip_f could be used instead for faster drawing, 
   ' at the cost of more memory consumption (+125 bytes, as it uses an unrolled loop)
end sub

'''''''''''''''''''''''''''''''''/
' CLEAR ROCKETS
'    Draws a black solid box to clear both rockets at once.
'
sub clearRockets(x, y)
   shared ROCKET.W, ROCKET.H, CPCT.VMEMSTART
   '-----Overwrite sprites with a Black Solid Box
   '
   ' Get a pointer to video memory byte location for (x, y)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)
   ' Draw a Black Solid Box (color index 0 for both pixels of each byte).
   ' Width of the box must be 2 times the width of a Rocket + 1 (as both
   ' rockets are separated by 1 byte). Height is the same as the rockets.
   call cpctDrawSolidBox(pvmem, cpctpx2byteM0(0, 0), 2*ROCKET.W+1, ROCKET.H)
end sub

'''''''''''''''''''''''''''''''''/
' GET USER INPUT
'    Checks user input (keyboard) and sets movement velocity
' (vx, vy). Velocities are passed by reference.
'
sub getUserInput
   shared vx, vy
   shared KEY.O, KEY.P, KEY.Q, KEY.A
   ' Velocities will be 0 unless a keypress is detected
   vx = 0: vy = 0

   ' Scan the keyboard and update keypresses
   call cpctScanKeyboardf()

   ' Check for user keys (OPQA) one by one, and update velocities
   ' by one byte depending on which ones are pressed
   if cpctIsKeyPressed(KEY.O) then vx = vx - 1  ' O: Left
   if cpctIsKeyPressed(KEY.P) then vx = vx + 1  ' P: Right
   if cpctIsKeyPressed(KEY.Q) then vy = vy - 1  ' Q: Up
   if cpctIsKeyPressed(KEY.A) then vy = vy + 1  ' A: Down
end sub

'''''''''''''''''''''''''''''''''/
' INITIALIZATION
'    Sets the initial configuration for the CPC
'
sub initialize
   shared HWC.BLACK
   call cpctRemoveInterruptHandler()             ' Disable firmware to prevent it from restoring mode and palette
   call cpctSetVideoMode(0)                      ' Set video mode to 0 (16&200, 16 colours)
   call cpctSetPalette(@LABEL("g_palette"), 16)  ' Set the palette using hardware values generated at rocket.h
   call cpctSetBorder(HWC.BLACK)                 ' Set border colour to Black 
end sub

'''''''''''''''''''''''''''''''''/
' MAIN PROGRAM
'
label MAIN
   ' First of all, initialize the CPC
   call initialize()

   ' Perform the Main Loop forever
   while 1
      ' Wait to the VSYNC signal to ensure that any drawing we 
      ' do is performed afterwards to prevent raster from overtaking us
      ' and generating flickering. Also, limiting action to 50Hz
      call cpctWaitVSYNC()
      
      ' Only perform any new drawing to screen whenever there 
      ' is going to be any movement (vx or vy not 0)
      '    BEWARE! Rockets may move outside screen boundaries, because 
      '    (x, y) coordinates are updated without any boundaries check.
      if vx or vy then
         call clearRockets(x, y)  ' Clear Rockets
         x = x + vx: y = y + vy   ' Update x,y coordinates according to velocity
         call drawRockets(x, y)   ' Draw Rockets at their new location
      end if

      ' Get user input for next movements
      call getUserInput()
   wend
end

asm "read 'img/rocket.asm'"
