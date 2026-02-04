'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 Dardalorth / Fremos / Carlio
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

' Background information
' Starting screen coordinates of the top-left pixel (in bytes)
' Width and Height of the background (in tiles)
const BACK.X = 12
const BACK.Y = 72
const BACK.W = 14
const BACK.H =  6

' Sprite size (in bytes)
const SPR.W = 4
const SPR.H = 16

' Cycles to wait between sprite movements
const WAITLOOPS = 1000

' Precalculate addresses to the tiles in the assembly file imported at the bottom
dim background(13,5)  ' list of tiles is [14][6][4*8] bytes

for y=0 to (BACK.H-1)
   for x=0 to (BACK.W-1)
      background(x,y) = @LABEL("background") + (6*x + y) * (4*8)
   next
next

''''''''''''''''''''''''''''''''''''/
' Draws a frame box around the "play zone"
'
sub drawFrame
   shared BACK.X, BACK.Y, BACK.W, BACK.H
   shared CPCT.VMEMSTART
  ' Colour pattern for frame boxes (2 pixels of PEN colour 15)
  pattern = cpctpx2byteM0 (15, 15)
  
  ' Draw top box
  pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, BACK.X, BACK.Y - 8)
  call cpctDrawSolidBox(pvmem, pattern, 4*BACK.W, 8)

  ' Draw bottom box
  pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, BACK.X, BACK.Y + 8*BACK.H)
  call cpctDrawSolidBox(pvmem, pattern, 4*BACK.W, 8)

  ' Draw left box
  pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, BACK.X - 4, BACK.Y - 8)
  call cpctDrawSolidBox(pvmem, pattern, 4, 8*(BACK.H + 2))

  ' Draw right box
  pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, (BACK.X + 4*BACK.W),  (BACK.Y - 8))
  call cpctDrawSolidBox(pvmem, pattern, 4, 8*(BACK.H + 2))
end sub

''''''''''''''''''''''''''''''''''''/
' Draws the complete tiled background
'    It paints all the tiles in the tile_array that defines the 
' background. That is the same as drawing the complete background.
'
sub drawBackground
   shared BACK.X, BACK.Y, BACK.W, BACK.H
   shared CPCT.VMEMSTART
   shared background[]
   ' Draw the complete background (BACK.W * BACK.H tiles)
   
   ' Traverse rows of the tile array
   for y=0 to (BACK.H-1)
      ' Point to the video memory byte where tiles of this row should start.
      ' X coordinate is always the same (first X coordinate, or BACK_X) and
      ' y coordinate increments by 8 with each row.
      pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, BACK.X, BACK.Y + 8*y)

      ' Traverse columns of the tile array
      for x=0 to (BACK.W-1)
         call cpctDrawTileAligned4x8f(background(x,y), pvideomem)  ' Draw next tile
         ' Point 4 bytes to the right, to the next place for tile 
         ' (as tiles are 4 bytes wide)
         pvideomem = pvideomem + 4  
      next
   next
end sub

''''''''''''''''''''''''''''''''''''/
' Repaints the background over an sprite to "erase" it
'    It uses (x, y) screen byte coordinates of the sprite to know the
' 4 tiles it will be "touching" and then repaints them 4. This is only
' valid for 8x16 pixels sprites (4x16 bytes)
'
sub repaintBackgroundOverSprite(x, y)
   shared BACK.X, BACK.Y
   shared CPCT.VMEMSTART
   shared background[]
   ' Calculate the tile in which is place the top-left corner of the sprite
   ' (x,y) coordinate refer to that point in bytes
   tilex = (x - BACK.X) \ 4   ' Calculate tile column into the tile array (integer division, 4 bytes per tile)
   tiley = (y - BACK.Y) \ 8   ' Calculate tile row into the tile array (integer division, 8 bytes per tile)
   scrx = BACK.X + 4*tilex    ' Calculate x screen byte coordinate of the tile
   scry = BACK.Y + 8*tiley    ' Calculate y screen byte coordinate of the tile
   
   ' Now we have the tile in which top-left corner of our sprite is placed.
   ' Our sprite is 4x16 bytes wide, so it can extend up to 1 tile to the right
   ' and up to 2 tiles downside. However, as our sprite always moves in X, it will
   ' always be aligned and will only extend 1 tile downside. So, drawing 4 tiles
   ' is enough to be sure that we are erasing the sprite and restoring the background.
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, scrx, scry)
   call cpctDrawTileAligned4x8f(background(tilex,tiley), pvmem)
   call cpctDrawTileAligned4x8f(background(tilex+1,tiley), pvmem + 4)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, scrx, scry + 8)
   call cpctDrawTileAligned4x8f(background(tilex, tiley+1), pvmem)
   call cpctDrawTileAligned4x8f(background(tilex+1, tiley+1), pvmem + 4)
end sub

''''''''''''''''''''''''''''''''''''/
' Initialization routine
'    Disables firmware, initializes palette and video mode and
' draws the background
'
sub initialization 
   call cpctRemoveInterruptHandler()     ' Disable firmware to prevent it from interfering
   call cpctfw2hw(@LABEL("palette"), 16) ' Convert firmware colours to hardware colours 
   call cpctSetPalette(@LABEL("palette"), 16)  ' Set palette using hardware colour values
   call cpctSetBorder(peek(@LABEL("palette"))) ' Set border colour same as background (0)
   call cpctSetVideoMode(0)            ' Change to Mode 0 (16&200, 16 colours)

   call drawFrame()       ' Draw a Frame around the "play zone"
   call drawBackground()  ' Draw the tiled background
end sub

label MAIN
   x  = BACK.X+1   ' x byte screen coord. of the sprite (1 byte to the right of the start of the "play zone")
   y  = BACK.Y+4*8 ' y byte screen coord. of the sprite (4 tiles down the start of the "play zone")
   vx = 1          ' Horizontal movement velocity in bytes (1 byte to the right)
   

   ' Initialize screen, palette and background
   call initialization()

   '
   ' Main loop: Moves the sprite left-to-right and vice-versa
   '
   while 1
      ' Draw the sprite with Mask. Calculate screen byte where to byte it
      ' and call drawSpriteMasked to ensure that the sprite is drawn without
      ' erasing the background. This is only valid for sprite defined with mask.
      pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)      
      call cpctDrawSpriteMasked(@LABEL("sprite_EMR"), pvmem, SPR.W, SPR.H)
      for i=0 to (WAITLOOPS-1): next   ' Wait for a little while
      call cpctWaitVSYNC()             ' Synchronize with VSYNC to prevent flickering
      
      call repaintBackgroundOverSprite(x, y) ' Repaint the background only where the sprite is located
      
      ' Move the sprite using its velocity (Just add vx to current x position)
      x = x + vx

      ' Check if we have crossed boundaries and, if it is the case,
      ' position sprite again where it was previously and change velocity sense.
      if (x < BACK.X) or (x > (BACK.X + 4*BACK.W - 5)) then
        x  = x - vx    ' Undo latest movement subtracting vx from current x position
        vx = -vx   ' Change the sense of velocity to start moving opposite

        ' Optionally, Sprite may be flipped to look backwards
        ' call cpctHflipSpriteMaskedM0(SPR.W, SPR.H, @LABEL("sprite_EMR"))
      end if
   wend
end

asm "read 'img/palette.asm'"
asm "read 'img/sprites.asm'"
asm "read 'img/background.asm'"
