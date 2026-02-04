'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 SunWay / Fremos / Carlio 
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
chain merge "modules/utils.bas"
chain merge "modules/palette.bas"

'
' MAIN: Palette Effects Example
'
label MAIN
  ' Create a table with the 3 sprites that will be used
  DIM img.spr(2), img.x(2), img.y(2), img.w(2), img.h(2)
  img.spr(0) = @LABEL("G_Goku"): img.x(0) = 30: img.y(0) = 75: img.w(0) = 20: img.h(0) = 49
  img.spr(1) = @LABEL("G_Vegeta"): img.x(1) = 22: img.y(1) = 60: img.w(1) = 36: img.h(1) = 80
  img.spr(2) = @LABEL("G_No13"): img.x(2) = 22: img.y(2) = 60: img.w(2) = 36: img.h(2) = 80

  ' Initialize the CPC
  call cpctRemoveInterruptHandler() ' Disable firmware to prevent it from interfering
  call cpctSetVideoMode(0)          ' Set video mode 0 (160x200, 16 colours)
  call setBlackPalette(0, 16)       ' Set all 17 colours (16 palette + border) to Black
  call initPalette()
  '
  ' Infinite Loop
  '
  while 1
    ' Iterate through the 3 sprites using fade in / fade out palette effect
    for i=0 to 2
      call cpctClearScreen(&00)   ' Clear the screen filling it up with 0's
      
      ' Calculate video memory location for next sprite and draw it
      pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, img.x(i), img.y(i))
      call cpctDrawSprite(img.spr(i), pvmem, img.w(i), img.h(i))

      call waitFrames(50)                   ' Wait 1 second  ( 50 VSYNCs)
      call fadeIn(0, 16, 4)  ' Do a Fade in effect to show the sprite
      
      call waitFrames(100)                   ' Wait 2 seconds (100 VSYNCs)
      call fadeOut(0, 16, 4)  ' Do a Fade out effect to return to black
    next
  wend
end

asm "read 'modules/sprites.asm'"