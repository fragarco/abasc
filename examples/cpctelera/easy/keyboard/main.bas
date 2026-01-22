'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C)      2015 Maximo / Cheesetea / ByteRealms (@rgallego87)
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

' Code adapted to ABASC by Javier "Dwayne Hicks" Garcia
' This example controls a sprite using the cursor keys in mode 1

CHAIN MERGE "cpctelera/cpctelera.bas"

SYMBOL AFTER 256 ' do not define default SYMBOL table

' Sprite size (in bytes)
CONST SPW = 12
CONST SPH = 62

' Screen size (in bytes)
CONST SCRW = 80
CONST SCRH = 200

' Actual sprite data and its palette
SPMEM = @LABEL(CTLOGO.SPRITE)
SPPAL = @LABEL(CTLOGO.PALETTE)

'
' MAIN: Using keyboard to move a sprite example
'
LABEL MAIN
   x = 10: y = 10
   videomem = &C000
   '
   ' Set up the screen
   '
   ' Disable firmware to prevent it from interfering with setPalette and setVideoMode
   call cpctRemoveInterruptHandler()

   ' Set the colour palette
   call cpctSetPalette(SPPAL, 4) ' Set up the hardware palette using hardware colours
   call cpctSetPALColour(16,&14)   ' Set Border to INK 0

   ' Set video mode 1 (320x200, 4 colours)
   call cpctSetVideoMode(1)

   ' Infinite moving loop
   WHILE 1
      ' Scan Keyboard (fastest routine)
      ' The Keyboard has to be scanned to obtain pressed / not pressed status of
      ' every key before checking each individual key's status.
      call cpctScanKeyboardf()

      ' Check if user has pressed a Cursor Key and, if so, move the sprite if
      ' it will still be inside screen boundaries
      if cpctIsKeyPressed(KEY.Right) and x < (SCRW - SPW) then x = x + 1
      if cpctIsKeyPressed(KEY.Left)  and x > 0 then x = x - 1 
      if cpctIsKeyPressed(KEY.Up) and y > 0 then y = y - 1
      if cpctIsKeyPressed(KEY.Down) and y < (SCRH - SPH) then y = y + 1
      
      ' Get video memory byte for coordinates x, y of the sprite (in bytes)
      videomem = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)
      ' Draw the sprite in the video memory location got from coordinates x, y
      call cpctDrawSprite(SPMEM, videomem, SPW, SPH)
   WEND
END

LABEL CTLOGO.PALETTE:
ASM "db &14, &0A, &0B, &00"

LABEL CTLOGO.SPRITE:
ASM "read 'img/ctlogo.asm'"