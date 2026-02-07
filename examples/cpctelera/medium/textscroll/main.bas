'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Created in collaboration with Roald Strauss (aka mr_lou / CPCWiki)
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

' Useful constants
'  * Start of screen video memory
'  * Size in bytes of a complete screen video pixel line
'  * Offset from the start of a pixel line to the start of the next (inside same group of 8 pixel lines)
'  * Screen character line to be used for scrolling (0-24)
const PIXEL.LINESIZE   = &0050
const PIXEL.LINEOFFSET = &0800
const CHARLINE         = 12

'
' Waits n times for a VSYNC signal (1/50s). After each VSYNC signal,
' if waits for 2 interrupts (using HALT 2 times) to ensure that VSYNC
' stops being active until looking for the next VSYNC signal.
'
sub waitnVSYNCs(n)
   label wait.do
      ' Wait for 1 VSYNC signal
      call cpctWaitVSYNC()

      ' If we still have to wait for more VSYNC signals, wait first
      ' for this present VSYNC signal to become inactive. For that,
      ' wait for 2 system interrupts using ASM halt instruction.
      n = n - 1
      if n then 
         asm "halt"
         asm "halt"
      end if
   if n then goto wait.do
end sub

'
' Scrolls a Character line (8 pixel lines) 1 byte to the left. To do
' this, it goes byte by byte copying the next byte (the one to the right)
'   pCharline: pointer to the first byte of the character line (the 8 pixel lines)
'   lineSize:  number of total bytes a pixel line has
'
sub scrollLine(pCharline, lineSize)
   shared CPCT.VMEMSTART, PIXEL.LINEOFFSET
   ' Scroll 8 pixel lines. This loop is executed 8 times: when pCharline is incremented
   ' the 9th time, it will overflow (will be greater than &FFFF, cycling through &0000)
   ' and will be lower than &C000.
   while pCharline > CPCT.VMEMSTART
      call cpctMemcpy(pCharline, pCharline+1, lineSize)
      pCharline = pCharline + PIXEL.LINEOFFSET
   wend
end sub

'
' MAIN LOOP
'
label MAIN
   ' Test to be used for scrolling (declared constant as it won't be modified,
   ' and that prevents compiler from generating code for initializing it)
   text$ = "This is a simple software scrolling mode 1 text. Not really smooth, but easy to understand.     "

   ' Pointer to the first byte of the screen character line
   ' (8 pixel lines) to be scrolled. First 25 pixel lines of screen
   ' video memory are the 25 pixel 0 lines of each screen character line
   ' (group of 8 pixel lines), hence this calculation.
   pCharlineStart = CPCT.VMEMSTART + (PIXEL.LINESIZE * CHARLINE)

   ' Pointer to the first byte of the last screen character of the
   ' character line (last 2 bytes of the 8 pixel lines)
   pNextCharLocation = pCharlineStart + PIXEL.LINESIZE - 2

   textlen = len(text$)  ' Save the lenght of the text for later use
   nextChar  = 0         ' Next character of the text to be drawn on the screen
   penColour = 1         ' Pen colour for the characters

   ' Infinite scrolling loop
   call cpctSetDrawCharM1(1, 3)
   call cpctDrawStringM1("Hold any key to pause scroll", CPCT.VMEMSTART)
   call cpctSetDrawCharM1(penColour, 0)
   while 1
      ' When holding a key, wait for release (Loop scanning the keyboard
      ' until no single key is pressed)
      label main.do
         call cpctScanKeyboardf()
      if cpctIsAnyKeyPressedf() then goto main.do

      ' Draw next character at the rightmost character location of the
      ' character line being scrolled
      ' ABASC strings store their length in the first byte so we need to
      ' add +1 when accessing an specific character
      call cpctDrawCharM1(pNextCharLocation, peek(@text$ + 1 + nextChar))

      ' nextChar will hold the index of the next Character, returning to
      ' the first one when there are no more characters left, and changing
      ' Pen colour for next sentence
      nextChar = nextChar + 1
      if nextChar = textlen then
         nextChar = 0
         penColour = penColour + 1
         if penColour > 3 then penColour = 1
         call cpctSetDrawCharM1(penColour, 0)
      end if

      ' Scroll character line 2 times, as each scroll call will move
      ' the pixels 1 byte = 4 pixels. So, 2 times = 8 pixels = 1 Character
      ' Synchronize with VSYNC previous to each call to make it smooth
      call waitnVSYNCs(2)
      call scrollLine(pCharlineStart, PIXEL.LINESIZE)
      call waitnVSYNCs(2)
      call scrollLine(pCharlineStart, PIXEL.LINESIZE)
   wend
end
