'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2016 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

' Sprite size (in bytes)
const SP.W = 23
const SP.H = 54

' Screen size (in bytes)
const SCR.W = 80
const SCR.H = 200

' Floor location
const FLOOR.Y = 160
const FLOOR.HEIGHT = 10
FLOOR.COLOR = cpctpx2byteM0(1,2)

' Looking at right or left
const LOOK.LEFT  = 0
const LOOK.RIGHT = 1

'
' INITIALIZE: Initialize CPC, Draw Floor and Instructions
'
sub initialize
   shared HWC.BLACK, CPCT.VMEMSTART
   shared FLOOR.Y, FLOOR.HEIGHT, FLOOR.COLOR
   shared SCR.W
   ' Disable firmware to prevent it from interfering with setPalette and setVideoMode
   call cpctRemoveInterruptHandler()

   ' Set up the hardware palette using hardware colour values
   call cpctSetPalette(@LABEL("g_palette"), 8)
   call cpctSetBorder(HWC.BLACK)
   
   ' Set video mode 0 (16&200, 16 colours)
   call cpctSetVideoMode(0)

   ' Draw floor. As cpct_drawSolidBox cannot draw boxes wider than 63 bytes
   ' and Screen width is 80 bytes, we draw 2 boxes of SCR_W/2 (40 bytes) each
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART,       0, FLOOR.Y)
   call cpctDrawSolidBox(pvideomem, FLOOR.COLOR, SCR.W/2, FLOOR.HEIGHT)
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, SCR.W/2, FLOOR.Y)
   call cpctDrawSolidBox(pvideomem, FLOOR.COLOR, SCR.W/2, FLOOR.HEIGHT)

   ' Draw instructions
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART,  0, 20)
   call cpctSetDrawCharM0(2, 0)
   call cpctDrawStringM0("  Sprite Flip Demo  ", pvideomem)
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART,  0, 34)
   call cpctSetDrawCharM0(4, 0)
   call cpctDrawStringM0("[Cursor]",   pvideomem)
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, 40, 34)
   call cpctSetDrawCharM0(3, 0)
   call cpctDrawStringM0("Left/Right", pvideomem)
end sub

'
' MAIN: Using keyboard to move a sprite example
'
label MAIN
   x=20                     ' Sprite horizontal coordinate
   lookingAt = LOOK.RIGHT   ' Know where the sprite is looking at 
   nowLookingAt = lookingAt ' New looking direction after keypress

   ' Initialize the Amstrad CPC
   call initialize()

   ' 
   ' Infinite moving loop
   '
   while 1
      ' Scan Keyboard (fastest routine)
      ' The Keyboard has to be scanned to obtain pressed / not pressed status of
      ' every key before checking each individual key's status.
      call cpctScanKeyboardf()

      ' Check if user has pressed a Cursor Key and, if so, move the sprite if
      ' it will still be inside screen boundaries
      if cpctIsKeyPressed(KEY.RIGHT) and (x < (SCR.W - SP.W)) then
         x = x + 1
         nowLookingAt = LOOK.RIGHT
      else
         if cpctIsKeyPressed(KEY.LEFT) and (x > 0) then
            x = x - 1
            nowLookingAt = LOOK.LEFT
         end if
      end if
      ' Check if we have changed looking direction      
      if lookingAt <> nowLookingAt then
         lookingAt = nowLookingAt
         call cpctHflipSpriteM0(SP.W, SP.H, @LABEL("g_spirit"))
      end if

      ' Get video memory byte for coordinates x, y of the sprite (in bytes)
      pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, x, FLOOR.Y - SP.H)

      ' Draw the sprite in the video memory location got from coordinates x, y
      call cpctDrawSprite(@LABEL("g_spirit"), pvideomem, SP.W, SP.H)
   wend
end

asm "read 'img/spirit.asm'"