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

'
' printArray
'   This function prints the contents of a bitarray as characters on the screen.
' Value 0 is shown as '_' for visual clarity. Other values are shown as characters
' [1, 2, 3, 4, 5, 6, 7, 8, 9, :, ;, <, =, >, ?].
'
sub printArray(pvideomem, array$, items, func)
    ' Iterate through all the items in the array to print them one by one
    for i=0 to (items - 1)
      ' Access the array using the function that has been told to us 
      ' in the parameter 'thefunction'
      select case func
        ' Get element as a single bit (As return value could be anything, 
        ' we distinguish between 0 and >0, so out will finally be 0 or 1).
        case 0: if cpctGetBit(array$, i) > 0 then value = 1 else value = 0
        ' Get element as a pair of bits 
        case 1: value = cpctGet2Bits(array$, i)
        ' Get element as a chunk of 4 bits
        case 2: value = cpctGet4Bits(array$, i)
      end select
      ' Depending on the value got from getXBits function, calculate
      ' the character we have to print. (0 = '_', >0 = '0' + out)
      if value <> 0 then c = asc("0") + value else c = asc("_")

      ' Draw the character and point to the next byte in memory (next location
      ' to draw a character, as 1 byte = 8 pixels in mode 2)
      call cpctDrawCharM2(pvideomem, c)
      pvideomem = pvideomem + 1
    next
end sub

'
' Bit Arrays Example: Main
'
label MAIN

  declare array1$ fixed 10  ' Array of 80 1-bit elements (10 bytes)
  declare array2$ fixed 20  ' Array of 80 2-bit elements (20 bytes)
  declare array4$ fixed 40  ' Array of 80 4-bit elements (40 bytes)

  ' Disable firmware to prevent it from restoring video mode or
  ' interfering with our drawChar functions
  call cpctRemoveInterruptHandler()

  ' Set mode 2 for visual clarity on arrays printed
  call cpctSetVideoMode(2)
  call cpctSetDrawCharM2(1, 0) ' Draw characters in Foreground colour

  ' 
  ' Main Loop: loop forever showing arrays
  '
  while 1
    ' First, erase all contents of our 3 arrays,
    ' setting all their bits to 0
    array1$ = STRING$(10,0) ' replaces the call to cpct_memset
    array2$ = STRING$(20,0) ' replaces the call to cpct_memset
    array4$ = STRING$(40,0) ' replaces the call to cpct_memeset

    '
    ' Test 1: Set to 1 each bit on the array1 individually (all others to 0)
    '
    for i=0 TO 79
      ' Set Bit i to 1
      call cpctSetBit(array1$, 1, i)

      ' Print the complete array at the top of the screen
      call printArray(CPCT.VMEMSTART, array1$, 80, 0) 
      
      ' Reset again the bit to 0 an iterate
      call cpctSetBit(array1$, 0, i)
    next

    '
    ' Test 2: Fill in the array2 with individual values from 3 to 1 
    '              (all the rest should be 0)
    '
    for j=3 to 1 step -1 
      for i=0 to 79
        ' Set the index i to the value j (1 to 3)
        call cpctSet2Bits(array2$, j, i)

        ' Print the complete array
        call printArray(&C0A0, array2$, 80, 1)

        ' Reset the value of the item to 0 again
        call cpctSet2Bits(array2$, 0, i)
      next
    next

    '
    ' Test 3: Fill in the array4 with consecutive elements from 0 to 15,
    '         16 times, rotating all the 16 elements through all the positions
    '         in the array.
    '
    for j=0 to 15 
      for i=0 to 79
        ' Increment value using loop indexes and calculate module 16 (AND 0x0F)
        value = (i + j) and &0F

        ' Set next 4-bits element (i) to the calculated value and print the array
        call cpctSet4Bits(array4$, value, i)
        call printArray(&C140, array4$, 80, 2)
      next
    next

    '
    ' Test 4: Fill the array1 with 1's
    '
    for i=0 to 79
      ' Set next bit i to 1  
      call cpctSetBit(array1$, 1, i)

      ' Print the complete array1 again
      call printArray(CPCT.VMEMSTART, array1$, 80, 0) 
    next

    '
    ' Test 5: Fill the array2 with 3's, then with 2's and then with 1's
    '
    for j=3 to 1 step -1 
      for i=0 to 79
        ' Set next bit i to j (3, 2, 1)  
        call cpctSet2Bits(array2$, j, i)

        ' Print the complete array again
        call printArray(&C0A0, array2$, 80, 1)
      next
    next
  wend
end
