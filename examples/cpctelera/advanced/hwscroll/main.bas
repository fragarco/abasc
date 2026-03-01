'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 Stefano Beltran / ByteRealms (stefanobb at gmail dot com)
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
' Code mofied by Javier "Dwayne Hicks" Garcia

chain merge "cpctelera/cpctelera.bas"

' Size of the sprite (in bytes)
' Logo = (16&191 pixels in Mode 1 => 4&191 bytes)
const LOGO.W = 40
const LOGO.H = 191

'
' Pre-calculated sinus table.
'     Sinus wave, expanded by a factor of 20 and moved from [-10,10] to [0, 20]
'     Used to move the logo using a sinusoidal movement
'
LABEL sinusOffsets ' 256 bytes
    ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,6,6,7,7,7,7"
    ASM "db 8,8,8,8,9,9,9,9,10,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13,14,14,14,14,14,15,15,15,15,16,16,16,16"
    ASM "db 16,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20"
    ASM "db 20,20,20,20,20,20,20,20,20,20,20,20,20,20,19,19,19,19,19,19,19,19,19,19,18,18,18,18,18,18,18,17,17,17,17"
    ASM "db 17,17,16,16,16,16,16,15,15,15,15,14,14,14,14,14,13,13,13,13,12,12,12,12,11,11,11,11,10,10,10,10,10,9,9,9"
    ASM "db 9,8,8,8,8,7,7,7,7,6,6,6,6,6,5,5,5,5,4,4,4,4,4,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0"
    ASM "db 0,0,0,0,0,0"


'
' Draw CPCtelera's Logo (Mode 1)
'
sub drawLogo
    SHARED LOGO.W, LOGO.H, CPCT.VMEMSTART
    ' Clear the screen filling it up with 0's
    call cpctClearScreen(0)
    
    palette = @LABEL("G_logo_palette") ' Get ASM label address
    ' Initialize palette and video mode    
    call cpctfw2hw(palette, 4)        ' Convert palettes from firmware colour values to hardware colours
    call cpctSetPalette(palette, 4)   ' Set hardware palette   
    call cpctSetBorder(peek(palette)) ' Set the border white, using colour 0 from palette (after converting it to hardware values)
    call cpctSetVideoMode(1)          ' Set video mode 1 (32&200 pixels)

    ' Draw CPCtelera's Logo as one unique sprite 16&191 pixels (4&191 bytes in mode 1)
    ' Remember: in Mode 1, 1 byte = 4 pixels    

    ' Draw the sprite at screen byte coordinates (40, 4) (pixel coordinates (160, 4))
    ' The sprite will be at its rightmost position to be able to use left scrolling 
    ' to control it. Left scrolling at this position only requires to move the Video Screen
    ' pointer forward, which makes pixels "move to the left" as start of video memory becomes
    ' nearer to them.
    pvideo = cpctGetScreenPtr(CPCT.VMEMSTART, 40, 4)
    call cpctDrawSprite(@LABEL("G_CPCt_logo"), pvideo, LOGO.W, LOGO.H)
end sub

'
' MAIN: Basic hardware scroll example
'
label MAIN
    i=0 ' Iterations counter: loops through the sinus_offsets table.
    
    ' Initialize screen and draw logo
    call cpctDisableFirmware() ' Disable firmware to prevent it from interfering with setVideoMode
    call drawLogo()            ' Initialize palette and draw CPCtelera's Logo 
        
    '
    ' Main Loop: infinitely move cup side-to-side
    '
    while 1
        ' Move the screen video pointer to a new offset (4-by-4 bytes), causing an horizontal scroll
        ' We move the pointer forward up to 4*20 bytes = 80 bytes (1 complete pixel line) and then
        ' return it to original offset. This makes pixels move to the left up to 1 line and 
        ' return to their original position
        i = i + 1: if i = 256 then i = 0
        call cpctSetVideoMemoryOffset(peek(@LABEL(sinusOffsets) + i))  
        
        ' Synchronize with VSYNC + 1 HSYNC to slow down the movement
        call cpctWaitVSYNC()   ' Wait for VSYNC signal
        ASM "halt"   ' HALT assembler instruction makes CPU wait till next HSYNC signal
    wend
end

ASM "read 'img/sprites.asm'"