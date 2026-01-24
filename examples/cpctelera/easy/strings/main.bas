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
'  but WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

chain merge "cpctelera/cpctelera.bas"

' Constant to set the number of VSYNCs to wait for as a delay between 
' each pair of strings drawn. This will let as see how they are
' drawn, making it a little bit slower.
' - WFRAMES = 3 (Work at 12.5 FPS (50/3))
const WFRAMES = 3

'
' Wait n complete screen frames of (1/50)s
'
sub waitframes(nframes)
   ' Loop for nframe times, waiting for VSYNC
   for i=1 to nframes
      call cpctWaitVSYNC()

      ' VSYNC is usually active for ~1500 cycles, then we have to do 
      ' something that takes approximately this amount of time before
      ' waiting for the next VSYNC, or we will find the same VSYNC signal
      ' This active wait loop will do at least 500 comparisons
      for j=1 to 500: next
   next
end sub

'
' Strings Example: Main program
'
label MAIN
   DIM colours(5)  ' 6 Colour values (0-5), 2 for each mode

   ' First, disable firmware to prevent it from restoring video modes and 
   ' interfering with drawString functions
   call cpctRemoveInterruptHandler()

   ' Loop forever showing characters on different modes and colours
   '
   while 1
      '
      ' Show some strings in Mode 0, using different colours
      '
      ' Clear Screen filling it up with 0's and set mode 0
      call cpctClearScreen(0)
      call cpctSetVideoMode(0)

      ' Let's start drawing strings at the start of video memory (0xC000)
      ' This constant is defined in cpctelera/video.bas
      pvideomem = CPCT.VMEMSTART

      ' Draw 25 strings, 1 for each character line on the screen
      for times=0 to 24
         ' Pick up the next foreground colour available for next string
         ' rotating colours when the 16 available have been used
         ' We use module 16 (AND 0x0F) for faster calculations
         colours(0) = (colours(0) + 1) and &000F
         
         ' Draw the string and wait for some VSYNCs
         call cpctSetDrawCharM0(colours(0), colours(3))
         call cpctDrawStringM0("$ Mode 0 string $", pvideomem)
         call waitframes(WFRAMES)

         ' Point to the start of the next character line on screen (80 bytes away)
         pvideomem = pvideomem + &50
      next
      ' Rotate background colour for next time we draw Mode 0 strings
      colours(3) = (colours(3) + 1) and &000F

      '
      ' Show some strings in Mode 1, using different colours
      '
      ' Clear Screen filling it up with 0's and set mode 1
      call cpctClearScreen(0)
      call cpctSetVideoMode(1)
      
      ' Let's start drawing strings at the start of video memory (0xC000)
      pvideomem = CPCT.VMEMSTART

      ' Draw 25 strings, 1 for each character line on the screen    
      for times=0 to 24

         ' Rotate foreground colour using module 4 (AND 0x03)
         colours(1) = (colours(1) + 1) and &0003

         ' Draw a string using drawString function for mode 1
         call cpctSetDrawCharM1(colours(1), colours(4))
         call cpctDrawStringM1("Mode 1 string :D", pvideomem)
         ' Rotate foreground colour again
         colours(1) = (colours(1) + 1) and &0003
         call cpctSetDrawCharM1(colours(1), colours(4))
         call cpctDrawStringM1("Mode 1 string :D", pvideomem + 38)

         ' Rotate foreground colour another time and wait for a few VSYNCs
         colours(1) = (colours(1) + 1) and &0003
         call waitframes(WFRAMES)

         ' Point to the start of the next character line on screen (80 bytes away)
         pvideomem = pvideomem + &50
      next
      colours(4) = (colours(4) + 1) and &0003

      '
      ' Show some strings in Mode 2, using different colours
      '

      ' Clear Screen filling it up with 0's and set mode 2
      call cpctClearScreen(0)
      call cpctSetVideoMode(2)

      ' Let's start drawing strings at the start of video memory (0xC000)    
      pvideomem = CPCT.VMEMSTART

      ' Draw 25 strings, 1 for each character line on the screen    
      for times=0 to 24
         ' Alternate between foreground and background colour for the character
         ' using an XOR 1 operation that alternates the value between 0 and 1
         colours(2) = colours(2) xor 1
         
         ' Draw string on the screen using current colour and wait for a few VSYNCs
         call cpctSetDrawCharM2(colours(2), colours(5))
         call cpctDrawStringM2("And, finally, this is a long mode 2 string!!", pvideomem)
         call waitframes(WFRAMES)

         ' Point to the start of the next character line on screen (80 bytes away)
         pvideomem = pvideomem + &50
      next
      ' Alternate Background colour value too, for the next iteration
      colours(5) = colours(5) xor 1
   wend
end
