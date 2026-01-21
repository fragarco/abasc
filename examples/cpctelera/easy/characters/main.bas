' -----------------------------LICENSE NOTICE------------------------------------
'   This file is part of CPCtelera: An Amstrad CPC Game Engine
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

' Code adapted to ABASC by Javier "Dwayne Hicks" Garcia

CHAIN MERGE "cpctelera/cpctelera.bas"

' Global variables
videomem = &C000     ' Pointer to video memory
DIM colours(5)       ' 6 entries for 3 pairs of foreground / background colour
DIM maxcol(2)        ' Number of colour each mode has (0 = 16, 1 = 4, 2 = 2)
DIM incs(2)          ' Byte increment for each mode

maxcol(0) = 16: maxcol(1) = 4: maxcol(2) = 2
incs(0) = 4: incs(1) = 2: incs(2) = 1

' This function calculates next video memory location, cycling pointer
' when it exceedes the end of standard screen video memory
'
SUB incVideoPos(inc)
    ' Increments video memory pointer in given 'inc' bytes
    SHARED videomem   ' Declare access to videomem global variable
    videomem = videomem + inc
    ' Check if video memory is greater that the last screen location where
    ' ... a character can be writen (25 character lines go from 0xC000 to 0xC7D0)
    ' If we exceed the range, restore the pointer
    IF videomem > &C7D0 THEN videomem = &C000
END SUB

' Print all 256 characters using a concrete drawing function and increment
'
SUB print256Chars(vmode, icolour)
    ' Calculate increment in bytes, for every time we want to move 
    ' video memory pointer to the next character
    SHARED videomem, incs[], colours[]   ' Declare access to global variables
    inc = incs(vmode)
    fg = colours(icolour)
    bg = colours(icolour+1)
    ' Set colours to be used for text drawing
    SELECT CASE vmode
        CASE 2: call cpctSetDrawCharM2(fg, bg)
        CASE 1: call cpctSetDrawCharM1(fg, bg)
        CASE 0: call cpctSetDrawCharM0(fg, bg)
    END SELECT
   ' Draw the complete set of 256 characters (excluding char 0)
    FOR charnum=1 TO 255
        SELECT CASE vmode
            CASE 2: call cpctDrawCharM2(videomem, charnum)
            CASE 1: call cpctDrawCharM1(videomem, charnum)
            CASE 0: call cpctDrawCharM0(videomem, charnum)
        END SELECT
        ' Point to next location on screen to draw (increment bytes required for this mode)
        call incVideoPos(inc)
    NEXT
END SUB

' Function to repeat N times drawing 256 characters on a given mode
' The function modifies video memory pointer and colours (received by reference)
'
SUB drawCharacters(maxtimes, vmode, icolour)
    SHARED colours[], maxcol[]   ' Declare access to global variables
                                 ' to change its values and not only read them
    call cpctClearScreen(0)      ' Clear Screen filling up with 0's
    call cpctSetVideoMode(vmode) ' Set desired video mode

    ' Print the complete set of 256 characters maxtimes times
    FOR times=1 TO maxtimes
        ' Each time we start printing the set, we change foreground and background colours.
        ' We loop foreground colours up to the max colour, and then loop background colours
        fg = colours(icolour) + 1
        IF fg = maxcol(vmode) THEN
            fg = 0
            bg = colours(icolour+1) + 1
            IF bg = maxcol(vmode) THEN
                bg = 0
            END IF
            colours(icolour+1) = bg
        END IF
        colours(icolour) = fg
        ' Print all 256 chars in mode 1 usingcurrent colours
        call print256Chars(vmode, icolour)
    NEXT
END SUB

' Drawing Characters example: MAIN
'
LABEL MAIN
    ' Disable firmware to prevent it from restoring our video memory changes 
    ' ... and interfering with drawChar functions
    call cpctRemoveInterruptHandler()
    ' Loop forever showing characters on different modes and colours
    '
    WHILE 1
        call cpctClearScreen(0)
        call drawCharacters(14, 2, 0) ' Drawing on mode 2, 14 times
        call drawCharacters(17, 1, 2) ' Drawing on mode 1, 17 times
        call drawCharacters(21, 0, 4) ' Drawing on mode 0, 21 times
    WEND
END