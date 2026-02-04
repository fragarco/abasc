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

'
' Get a 16-bits colour pattern out of a sequence of 4 firmware colours (one for each mode 0 pixel)
'
function getColourPattern(c1, c2, c3, c4)
   getColourPattern = (cpctpx2byteM0(c3, c4) and &FF00) or (cpctpx2byteM0(c1, c2) and &00FF)
end function

'
' Wait for the VSYNC n consecutive times (n/50 seconds wait, aprox)
'
sub waitNVSYNCs(nstops)
   label dowait
      ' Wait for next VSYNC is detected
      call cpctWaitVSYNC()
      ' If this is not the last VSYNC to wait, 
      ' wait for 2 halts, to ensure VSYNC signal has stopped
      ' before waiting to detect it again
      nstops = nstops - 1
      if nstops > 0 then
         asm "halt" ' Halt stops the Z80 until next interrupt.
         asm "halt" ' There are 6 interrupts per VSYNC (1/300 seconds each)
      end if
   if nstops > 0 then goto dowait
end sub

'
' Clear 2 times the screen with a given colour to see the effect,
'    using standard cpct_memset function
'
sub doSomeClears8(colour, vsyncs)
   for i=0 to 1
      pattern = cpctpx2byteM0(colour, colour)
      call waitNVSYNCs(vsyncs)
      call cpctMemset(&C000, pattern, &4000)
      call waitNVSYNCs(vsyncs)
      call cpctMemset(&C000, 0, &4000)
   next
end sub

'
' Clear 2 times the screen with a given colour to see the effect,
'    using a given memset function
'
sub doSomeClears(func, colour, vsyncs)
   for i=0 to 1
      pattern = getColourPattern(colour, colour, colour, colour)
      call waitNVSYNCs(vsyncs)
      if func = 0 then call cpctMemsetf8(&C000, pattern, &4000) else call cpctMemsetf64(&C000, pattern, &4000)
      call waitNVSYNCs(vsyncs)
      if func = 0 then call cpctMemsetf8(&C000, 0, &4000) else call cpctMemsetf64(&C000, 0, &4000)
   next
end sub

'
' MAIN: Loop infinitely while clearing the screen, to test it visually
'
label MAIN 
   colour = 1: vsyncs = 50

   ' Disable firmware to prevent it from interfering with setVideoMode
   ' Then set videomode to 0
   call cpctRemoveInterruptHandler() 
   call cpctSetVideoMode(0)

   ' Infinite screen clearing loop
   while 1
      ' Clear the screen using standard memset (5,17 frames to clear)
      call cpctSetBorder(4)
      call doSomeClears8(colour, vsyncs)

      ' Clear the screen using fast  8-byte chuncks memset (1,77 frames to clear)
      call cpctSetBorder(1)
      call doSomeClears(0, colour, vsyncs)

      ' Clear the screen using fast 64-byte chuncks memset (1,33 frames to clear)
      call cpctSetBorder(5)
      call doSomeClears(1, colour, vsyncs)

      ' Next colour and less time
      colour = colour + 1
      if colour > 15 then colour = 1
      vsyncs = vsyncs - 1
      if vsyncs = 0 then vsyncs = 50
   wend
end
