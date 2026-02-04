'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

' Use this palette with just 5 colours
asm "palette: db &14, &15, &13, &16, &0E"

''''''''''''''''''''''''''''''''''''
' MAIN: Just prints a sprite on top-left corner of the screen
'       The sprite comes from a binary file which is automatically converted
'
label MAIN
   ' Initializing the CPC
   call cpctRemoveInterruptHandler() ' Disable firmware (as we are going to use mode and colours)
   call cpctSetVideoMode(0)          ' Set video mode 0 (16&200, 16 colours)
   call cpctSetPalette(@LABEL("palette"), 5) ' Set first 5 colours from our palette (we aren't going to use more)
   
   ' Draw G_character sprite at top-left corner of the screen (first byte of video memory,
   ' which is located at &C000 in memory by default). 
   call cpctDrawSprite(@LABEL(sprite), CPCT.VMEMSTART, 8, 24)
   
   ' Loop forever
   while 1: wend
end

' Lets import sprite.bin and declare a label so we can get the memory address
label sprite
   asm "incbin 'img/sprite.bin'"
