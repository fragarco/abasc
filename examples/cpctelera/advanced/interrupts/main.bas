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

' Offset from the start of a character row to the next in video memory
const  ROW.OFFSET = &50

' Static variable to be preserved from call to call in the interrupt callback
static.i = 0

'
' MAIN FUNCTION
'    Code starts here
'
label MAIN
   ' We disable firmware and then set the function myInterruptHandler to be 
   ' called on each interrupt. Disabling firmware is not actually necessary if it 
   ' is not going to be reenabled. 
   call cpctDisableFirmware()
   call cpctSetInterruptHandler( @LABEL(myInterruptHandler) )

   ' Print some messages about this example
   gosub printMessages

   ' Loop forever. This code does nothing. However, interrupts happen and they
   ' automatically call myInterruptHandler, which changes border color.
   while 1: wend
end

'
' Interrupt Handler 
'    This code will be called each time an interrupt occurs.
'    To let us see when do this happen visually, this code changes the color
' of the border each time it is called.
'
label myInterruptHandler
   ' Set the color of the border differently for each interrupt
   call cpctSetBorder(static.i)
   ' Count one more interrupt. There are 6 interrupts in total (0-5)
   static.i = static.i + 1
   if static.i > 5 then static.i=0
return

'
' Print some messages on the screen about this example
'
label printMessages
   pvm = CPCT.VMEMSTART
   call cpctSetDrawCharM1(0, 3)
   call cpctDrawStringM1("Interrupt Handler Example", pvm)

   pvm = pvm + (3 * ROW.OFFSET)
   call cpctSetDrawCharM1(1, 0)
   call cpctDrawStringM1("This example is running a void loop, but", pvm)
   pvm = pvm + ROW.OFFSET
   call cpctDrawStringM1("border color is changed 6 times each", pvm)
   pvm = pvm + ROW.OFFSET
   call cpctDrawStringM1("frame. This change  is done by the inte-", pvm)
   pvm = pvm + ROW.OFFSET
   call cpctDrawStringM1("rrupt handler. As z80 produces 300 inte-", pvm)
   pvm = pvm + ROW.OFFSET
   call cpctDrawStringM1("rrupts per second, you have 6 per frame.", pvm)
return
