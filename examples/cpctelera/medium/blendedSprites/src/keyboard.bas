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

''''''''''''''''''''''''''''''''''''/
' updateKeyboardStatus
'    Checks user input and updates status of the relevant keys of 
' the keyboard
'
sub updateKeyboardStatus
   shared keyid[], keystatus[]
   shared KEYST.FREE, KEYST.PRESSED, KEYST.STILLPRESS, KEYST.RELEASED
   ' First read all present status of the keys in the keyboard
   call cpctScanKeyboard()

   ' Then iterate through our array of keys to consider, and 
   ' check if there has been status changes on any of them
   for i=0 to 3
      ' Modifications depend in whether the key is pressed or not
      if cpctIsKeyPressed(keyid(i)) then
         ' Key is pressed now, check if that represents a change
         ' with respect to previous status, and update status accordingly
         select case keystatus(i)
            ' If key was "just pressed" move it to Still pressed
            case KEYST.PRESSED:  keystatus(i) = KEYST.STILLPRESS
            ' If key was free or released, move it to "just pressed"
            case KEYST.FREE:     keystatus(i) = KEYST.PRESSED
            case KEYST.RELEASED: keystatus(i) = KEYST.PRESSED
         end select
      else
         ' Key is released now, check if that represents a change
         ' with respect to previous status, and update status accordingly
         select case keystatus(i)
            ' If key was pressed in any form, move it to "just released"
            case KEYST.PRESSED:    keystatus(i) = KEYST.RELEASED
            case KEYST.STILLPRESS: keystatus(i) = KEYST.RELEASED
            ' If key was already released, move it to Free
            case KEYST.RELEASED:   keystatus(i) = KEYST.FREE
         end select         
      end if
   next
end sub