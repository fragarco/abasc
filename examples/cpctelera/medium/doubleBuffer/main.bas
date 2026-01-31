'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 Stefano Beltran / ByteRealms (stefanobb at gmail dot com)
'  Copyright (C) 2015 Maximo / Cheesetea / ByteRealms (@rgallego87)
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

' Size of each part of the CPCtelera Logo
const CPCT.W = 40
const CPCT.H = 96

' Size of the ByteRealms Logo
const BR.W   = 62
const BR.H   = 90

' Pointers to the hardware backbuffer, placed in bank 1 
' of the memory (0x4000-0x7FFF)
const SCR.BUFF = &4000

'''''''''''''''''''''''''''''''''''''''''''/
' Change Video Memory Page
'    This function changes what is drawn on screen by changing video memory page. 
' It alternates between page C0 (0xC000 - 0xFFFF) to page 40 (0x4000 - 0x7FFF). 
' Page C0 is default video memory, page 40 is used in this example as Back Buffer.
' It counts cycles (number of times this function is called) and changes from
' one buffer to the other when cycles exceed waitcycles (a parameter given).
'
cycles = 0   ' Static value to count the number of times this function has been called
page   = 0   ' Static value to remember the last page shown (0 = page 40, 1 = page C0)

sub changeVideoMemoryPage(waitcycles)
   shared cycles, page
   shared VMP.PAGE40, VMP.PAGEC0
   ' Count 1 more cycle and check if we have arrived to waitcycles
   cycles = cycles + 1
   if cycles >= waitcycles then     
      cycles = 0    ' We have arrived, restore count to 0
      
      ' Depending on which was the last page shown, we show the other 
      ' now, and change the page for the next time 
      if page <> 0 then
         call cpctSetVideoMemoryPage(VMP.PAGEC0) ' Set video memory at banck 3 (0xC000 - 0xFFFF)
         page = 0                                 ' Next page = 0
      else
         call cpctSetVideoMemoryPage(VMP.PAGE40) ' Set video memory at banck 1 (0x4000 - 0x7FFF)
         page = 1                                 ' Next page = 1
      end if
   end if
end sub

'''''''''''''''''''''''''''''''''''''''''''/
' MAIN: Hardware Double Buffer example.
'    Shows how to draw sprites in different screen video buffers and how to change
' which one is drawn into the screen.
'
label MAIN
   bry = 55 ' Y coordinate of the ByteRealms Logo 
   vy  = 1  ' Velocity of the ByteRealms Logo in Y axis

   ' Initialize CPC Mode and Colours
   palette = @label(palettefw)
   call cpctRemoveInterruptHandler()      ' Disable firmware to prevent it from interfering
   call cpctfw2hw       (palette, 16)     ' Convert Firmware colours to Hardware colours 
   call cpctSetPalette  (palette, 16)     ' Set up palette using hardware colours
   call cpctSetBorder   (HWC.BRIGHTWHITE) ' Set up the border to the background colour (white)
   call cpctSetVideoMode(0)               ' Change to Mode 0 (160x200, 16 colours)

   ' Clean up Screen and BackBuffer filling them up with 0's
   call cpctMemset(CPCT.VMEMSTART, &00, &4000)
   call cpctMemset(      SCR.BUFF, &00, &4000)

   ' Lets Draw CPCtelera's Squared Logo on the BackBuffer. We draw it at 
   ' byte coordinates (0, 52) with respect to the start of the Backbuffer.
   ' We have to draw it into 2 parts because drawSprite function cannot draw
   ' sprites wider than 63 bytes (and we have to draw 80). So we draw the
   ' logo in two 40-bytes wide parts.
   pvmem = cpctGetScreenPtr(SCR.BUFF, 0, 52)
   call cpctDrawSprite(@label(cpctlogo.left),  pvmem,          CPCT.W, CPCT.H)
   call cpctDrawSprite(@label(cpctlogo.right), pvmem + CPCT.W, CPCT.W, CPCT.H)

   '
   ' Inifite loop moving BR Logo and changing buffers regularly
   '
   while 1
      ' Draw the ByteRealms logo at its current Y location on the screen. Moving
      ' the logo does not leave a trail because we move it pixel to pixel and the
      ' sprite has a 0x00 frame around it in its pixel definition.
      pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 10, bry)          ' Locate sprite at (10,br_y) in Default Video Memory
      call cpctDrawSprite(@label(byterealms), pvmem, BR.W, BR.H) ' Draw the sprite

      ' Change video memory page (from Screen Memory to Back Buffer and vice-versa)
      ' every 2.5 secs (125 VSYNCs)
      call changeVideoMemoryPage(125)

      ' Calculate next location of the ByteRealms logo
      bry = bry + vy                              ' Add current velocity to Y coordinate
      if (bry < 1) or ((bry + BR.H) > 199) then   ' Check if it exceeds boundaries
         vy = -vy                           ' When we exceed boundaries, we change velocity sense
      end if
      ' Synchronize next frame drawing with VSYNC
      call cpctWaitVSYNC()
   wend
end

' Palette Definition
'       Palette defined using Firmware Colours (Mode 0, 16 colours + border)
label palettefw
   asm "db &1A, &03, &01, &00, &0D, &19, &14, &12"
   asm "db &16, &15, &13, &06, &07, &08, &02, &0A"

label cpctlogo.left:
   asm "read 'img/logo_left.asm'"

label cpctlogo.right:
   asm "read 'img/logo_right.asm'"

label byterealms:
   asm "read 'img/byterealms.asm'"
