'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2017 Bouche Arnaud
'  Copyright (C) 2017 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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
chain merge "modules/declarations.bas"
chain merge "modules/drawing.bas"
chain merge "modules/managerVideoMem.bas"
chain merge "modules/textDraing.bas"

''''''''''''''''''''''''''''''''''''''''/
' Mask Table Definition for Mode 1
cpctm_createTransparentMaskTable(gMaskTable, MASKTABLE.LOCATION, M1, 0)

''''''''''''''''''''''''''''''''''''''''''''''
' CHECK USER INPUT
' 
'    Reads user input and changes selected draw function accordingly
'
sub CheckUserInput
   shared KEY.1, KEY.2, KEY.3
   call cpctScanKeyboardf()
   
   if cpctIsKeyPressed(KEY.1) then
      call SelectDrawFunction(1)
      call DrawTextSelectionSign(1)
   end if
   if cpctIsKeyPressed(KEY.2) then
      call SelectDrawFunction(2)
      call DrawTextSelectionSign(2)
   end if
   if  cpctIsKeyPressed(KEY.3) then
      call SelectDrawFunction(3)
      call DrawTextSelectionSign(3)
   end if
end sub

''''''''''''''''''''''''''''''''''''''''''''''
' INITIALIZATION
' 
'    Initializes the CPC and all systems before starting the main loop
'
sub Initialization
   ' We need to disable firmware in order to set the palette and
   ' to be able to use a second screen between 0x8000 and 0xBFFF
   call cpctRemoveInterruptHandler() 
   call cpctSetPalette(@LABEL("g_palette"), 5) ' Set the palette
   call InitializeVideoMemoryBuffers()  ' Initialize video buffers
   call InitializeDrawing()             ' Initialize Drawing Module
   call SelectDrawFunction(1)           ' Select the 1st Drawing function
   call DrawTextSelectionSign(1)        ' Mark 1st Drawing function as Selected
   call DrawInfoText()                  ' Draw User Info Text 
end sub

''''''''''''''''''''''''''''''''''''''''''''''
' MAIN PROGRAM
' 
void main(void) {
   ' Change stack location before any call. We will be using
   ' memory from 0x8000 to 0xBFFF as secondary buffer, so
   ' the stack must not be there or it will get overwritten
   call cpctSetStackLocation(NEWSTACKLOCATION)
   
   ' Initialize everything
   call Initialization()
   
   ' Main Loop
   while 1
      call CheckUserInput()
      call ScrollAndDrawSpace()
   wend
end

asm "read 'img/back.asm'"
asm "read 'img/fire.asm'"
asm "read 'img/ship.asm'"
asm "read 'img/title.asm'"
