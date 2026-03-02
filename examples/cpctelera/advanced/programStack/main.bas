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

' Program Stack locations
const STACK.NEWLOCATION  = &0200
const STACK.PREVLOCATION = &C000

'
' Print some messages using firmware
'
sub printMessages

   ' Print some messages using printf (with firmware)
   pen 3
   print "   SET PROGRAM STACK LOCATION DEMO"
   print "  #################################"
   print: pen 1
   print "This program changes stack location"
   print "to &200, just below the start of the"
   print "main function."
   print
   print "With this change, the 3rd memory bank"
   print "can be enterely used as double buffer,"
   print "making easier to map code and data into"
   print "memory."
   print: pen 2
   print "If you want to check this, open the"
   print "debugger and have a look at the stack"
   print "pointer and the stack contents."
   print: pen 1
   print "Now you can use keys [1 - 2] to change"
   print "from main screen buffer to the double"
   print "buffer which contains a fullscreen image"
   print "with a pattern like this:"
   print
   for i=0 to 39
      pen 1: print "#";
      pen 3: print "#";
   next
end sub

'
' MAIN PROGRAM
'
label MAIN 
   ' Clear the screen with 0's and print some messages using firmware
   call cpctClearScreenf64(&0000)
   call printMessages()

   ' Firmware should be disabled when changing stack location,
   ' as it may restore original stack location, causing unexpected behaviour
   call cpctDisableFirmware()

   ' Set the stack to its new location. As this program starts at &200, 
   ' we move the stack to &1FF. The stack will grow from there to &00
   ' When doing this call, stack has 6 bytes stored in it. We copy them
   ' previous to stack change (Beware! This contents may change if main 
   ' function changes!)
   call cpctMemcpy(STACK.NEWLOCATION - 6, STACK.PREVLOCATION - 6, 6)
   call cpctSetStackLocation(STACK.NEWLOCATION - 6)

   ' Clear backbuffer at &8000, that can be used
   ' now because the stack has been moved to a new location
   call cpctMemsetf64(&8000, &FFF0, &4000)

   ' Infinite Loop
   '   Read Keyboard and change screen video memory page on demand
   while 1
      call cpctWaitVSYNC()
      call cpctScanKeyboard()     

      if cpctIsKeyPressed(KEY.1) then
         call cpctSetBorder(4)
         call cpctSetVideoMemoryPage(VMP.PAGEC0)
      else
         if cpctIsKeyPressed(KEY.2) then
            call cpctsetBorder(3)
            call cpctSetVideoMemoryPage(VMP.PAGE80)
         end if
      end if
   wend
end