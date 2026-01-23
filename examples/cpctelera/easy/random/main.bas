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
'  but WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

chain merge "cpctelera/cpctelera.bas"

' Total random numbers to show (up to 255)
CONST NRND.NUMBERS = 50

'''''''''''''''''''''''''''''''''
' wait4UserKeypress
'    Waits till the user presses a key, counting the number of
' loop iterations passed.
'
' Returns:
'    <u32> Number of iterations passed
'
function wait4UserKeypress
   c = 1    ' Count the number of cycles passed till user k

   ' Wait 'till the user presses a key, counting loop iterations
   while cpctIsAnyKeyPressedf() = 0
      c = c + 1                  ' One more cycle
      call cpctScanKeyboardf()   ' Scan the scan the keyboard
   wend
   wait4UserKeypress = c
end function

'''''''''''''''''''''''''''''''''
' initialize
'    Shows introductory messages and initializes the pseudo-random
' number generator
'
sub initialize
   ' Introductory message
   pen 3: print "========= BASIC RANDOM NUMBERS =========": print
   pen 2: print "Press any key to generate random numbers": print

   ' Wait till the users presses a key and use the number of
   ' passed cycles as random seed for the Random Number Generator
   seed = wait4UserKeypress() ' Value to initialize the random seed

   ' Print the seed and seed the random number generator
   pen 3: print "Selected seed:"; seed: PRINT
   call cpctSRand(seed)
end sub

'''''''''''''''''''''''''''''''''
' printRandomNumbers
'    Prints some random numbers in the screen, as requested.
' INPUT:
'    nNumbers - Total amount of pseudo-random numbers to print
'
sub printRandomNumbers(nNumbers)
   ' Anounce numbers
   pen 3: print "Generating"; nNumbers; " random numbers"
   pen 1: print
   ' Count from nNumbers to 0, printing random numbers
   n = nNumbers
   while n > 0
      n = n - 1
      randomnumber = cpctRand()  ' Get next random number
      PRINT randomnumber;        ' Print it 
   wend

   ' End printing with newlines
   print: print
end sub

'''''''''''''''''''''''''''''''''
' MAIN ENTRY POINT OF THE APPLICATION
'
label MAIN
   ' Loop forever
   while 1
      ' Initialize everything and print some random numbers
      call initialize()  
      call printRandomNumbers(NRND.NUMBERS)

      ' Wait 'till the user stops pressing a key
      call cpctScanKeyboardf()
      while cpctIsAnyKeyPressedf() <> 0
         call cpctScanKeyboardf()
      wend
   wend
end
