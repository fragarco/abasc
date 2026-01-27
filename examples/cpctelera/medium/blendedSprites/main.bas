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

' Arrays containing all possible CPCtelera blending modes 
' along with a 3-character name associated to every one.
'
DIM blendmode(8)
DIM blendname$(8) FIXED 3
blendmode(0) = CPCTBLEND.XOR: blendname$(0) = "XOR"
blendmode(1) = CPCTBLEND.AND: blendname$(1) = "AND"
blendmode(2) = CPCTBLEND.OR : blendname$(2) = "OR "
blendmode(3) = CPCTBLEND.ADD: blendname$(3) = "ADD"
blendmode(4) = CPCTBLEND.SUB: blendname$(4) = "SUB"
blendmode(5) = CPCTBLEND.LDI: blendname$(5) = "LDI"
blendmode(6) = CPCTBLEND.ADC: blendname$(6) = "ADC"
blendmode(7) = CPCTBLEND.SBC: blendname$(7) = "SBC"
blendmode(8) = CPCTBLEND.NOP: blendname$(8) = "NOP"

' Arrays containing all possible Items to be displayed,
' their sprites and names
'
DIM itemsp(3)
DIM itemname$(3) FIXED 6
itemsp(0) = @label(item00): itemname$(0) = " Skull"
itemsp(1) = @label(item01): itemname$(1) = " Paper"
itemsp(2) = @label(item02): itemname$(2) = "Potion"
itemsp(3) = @label(item03): itemname$(3) = "   Cat"

const KEYST.FREE        = 0 ' Not pressed
const KEYST.PRESSED     = 1 ' Pressed "just now"
const KEYST.STILLPRESS  = 2 ' Pressed (maintained)
const KEYST.RELEASED    = 3 ' Released "just no

DIM keyid(4), keystatus(4)
keyid(0) = KEY.SPACE: keystatus(0) = KEYST.FREE
keyid(1) = KEY.ESC  : keystatus(1) = KEYST.FREE
keyid(2) = KEY.1    : keystatus(2) = KEYST.FREE
keyid(3) = KEY.2    : keystatus(3) = KEYST.FREE

' Set initial selections for item and blending mode
selectedBlendMode = 0
selectedItem = 0

chain merge "cpctelera/cpctelera.bas"
chain merge "src/draw.bas"
chain merge "src/keyboard.bas"

''''''''''''''''''''''''''''''''''''/
' selectNextItem
'    Selects the next item and redraws the user interface
'
sub selectNextItem
   shared selectedItem
   ' Next item is item + 1, except when we run out of items.
   ' In that later case, we select again the first item (0)
   selectedItem = selectedItem + 1
   if selectedItem > 3 then selectedItem = 0
   ' Draw changes
   call drawUserInterfaceStatus()
end sub

''''''''''''''''''''''''''''''''''''/
' selectNextBlendMode
'    Selects the next blending mode and redraws the user interface
'
sub selectNextBlendMode
   shared selectedBlendMode
   ' Next blending mode is blendmode + 1, except when we run out of modes.
   ' In that later case, we select again the first blending mode (0)
   selectedBlendMode = selectedBlendMode + 1
   if selectedBlendMode > 8 then selectedBlendMode = 0
   ' Draw changes
   call drawUserInterfaceStatus()
end sub

''''''''''''''''''''''''''''''''''''/
' performUserActions
'    Checks user input and performs selected actions
'
sub performUserActions
   shared keystatus[], KEYST.PRESSED
   ' Checks status of every key in the g_keys array
   ' Those keys with "Pressed" status trigger their associated action
   ' Important: Pressed means "pressed just now". When the user maintains
   '            a key pressed, it moves to StillPressed status.
   for i=0 to 3
      if keystatus(i) = KEYST.PRESSED then
         select case i
            case 0: call drawCurrentSpriteAtRandom()
            case 1: call drawBackground()
            case 2: call selectNextItem()
            case 3: call selectNextBlendMode()
         end select
      end if
   next
end sub

''''''''''''''''''''''''''''''''''''/
' Initialization routine
'    Disables firmware, initializes palette and video mode
'
sub initialize 
   shared HWC.BLACK
   ' Disable firmware to prevent it from interfering
   call cpctRemoveInterruptHandler()
   
   ' 1. Set the palette colours using hardware colour values
   ' 2. Set border colour to black
   ' 3. Set video mode to 0 (160x200, 16 colours)
   call cpctSetPalette(@label(palette), 11)
   call cpctSetBorder(HWC.BLACK)
   call cpctSetVideoMode(0)

   ' Draw the Background and the user interface
   call drawUserInterfaceMessages()   
   call drawBackground()

   call drawUserInterfaceStatus()
end sub

''''''''''''''''''''''''''''''''''''/
' Main entry point of the application
'
label MAIN
   call initialize()  ' Initialize the Amstrad CPC, 

   ' Loop forever checking keyboard status and then
   ' performing selected user actions
   while 1
      call updateKeyboardStatus()
      call performUserActions()
   wend
end

label palette
   asm "db 20, 4, 28, 12, 22, 30, 0, 31, 27, 3, 11"

label background0
   asm "read 'img/scifibg00.asm'"

label background1
   asm "read 'img/scifibg01.asm'"

label item00
   asm "read 'img/items00.asm'"

label item01
   asm "read 'img/items01.asm'"

label item02
   asm "read 'img/items02.asm'"

label item03
   asm "read 'img/items03.asm'"