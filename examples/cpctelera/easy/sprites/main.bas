'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 Stefano Beltran / ByteRealms (stefanobb at gmail dot com)
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
' Draw CPCtelera's Squared Banner (Mode 0)
'
sub drawBanner
    ' Clear the screen filling it up with 0's
    call cpctClearScreenf64(0)

    ' Set Mode 0 Squared Banner palette and change to Mode 0
    call cpctSetPalette(@LABEL(BANNER.PAL), 16)
    call cpctSetVideoMode(0)

    ' Draw CPCtelera's Squared Banner in 2 parts of 80x96 pixels (40x96 bytes in mode 0)
    ' We have to draw it in two parts because cpct_drawSprite function cannot 
    ' draw sprites wider than 63 bytes. 
    ' Remember: in Mode 0, 1 byte = 2 pixels

    ' Draw left part at screen byte coordinates  ( 0, 52) (pixel coordinates ( 0, 52))
    ' Banner parts = ( 80x96  pixels in Mode 0 => 40x96  bytes)
    const BANNERW = 40
    const BANNERH = 96
    pvideo = cpctGetScreenPtr(&C000,  0, 52)
    call cpctDrawSprite(@LABEL(BANNER.IMG0),  pvideo, BANNERW, BANNERH)

    ' Draw right part at screen byte coordinates (40, 52) (pixel coordinates (80, 52))
    pvideo = cpctGetScreenPtr(&C000, 40, 52)
    call cpctDrawSprite(@LABEL(BANNER.IMG1), pvideo, BANNERW, BANNERH)
end sub

'
' Draw CPCtelera's Logo (Mode 1)
'
sub drawLogo
    ' Clear the screen filling it up with 0's
    call cpctClearScreenf64(0)

    ' Set Mode 1 Logo palette and change to Mode 1
    call cpctSetPalette(@LABEL(LOGO.PAL), 4)
    call cpctSetVideoMode(1)     

    ' Draw CPCtelera's Logo as one unique sprite 160x191 pixels (40x191 bytes in mode 1)
    ' Remember: in Mode 1, 1 byte = 4 pixels    

    ' Draw the sprite at screen byte coordinates (20, 4) (pixel coordinates (80, 4))
    ' Logo = (160x191 pixels in Mode 1 => 40x191 bytes)
    const LOGOW = 40
    const LOGOH = 191
    pvideo = cpctGetScreenPtr(&C000, 20, 4)
    call cpctDrawSprite(@LABEL(LOGO.IMG), pvideo, LOGOW, LOGOH)
end sub

'
' MAIN: Keyboard check example
'
label MAIN
    ' Number of loops to wait between each sprite drawing
    ' as a 16 bits integer the max is 65535 so we wait for
    ' VSYNC signal instead of using a bigger WAITLOOPS number
    WAITLOOPS = 1000
    
    ' Disable firmware to prevent it from interfering with setVideoMode
    call cpctRemoveInterruptHandler()

    ' Convert palettes from firmware colour values to 
    ' hardware colours (which are used by cpct_setPalette)
    call cpctFW2HW(@LABEL(BANNER.PAL), 16)
    call cpctFW2HW(@LABEL(LOGO.PAL), 4)

    ' Set the border white
    call cpctSetBorder(HWC.BrightWhite)

    ' Infinite main loop
    while 1
        ' Draw CPCtelera's Logo and wait for a while
        call drawLogo()
        for i=1 TO WAITLOOPS: call cpctWaitVSYNC(): next
        ' Draw CPCtelera's Banner and wait for a while
        call drawBanner()
        for i=1 TO WAITLOOPS: call cpctWaitVSYNC(): next
    wend
end

LABEL LOGO.PAL:
ASM "read 'img/logo_pal.asm'"

LABEL LOGO.IMG:
ASM "read 'img/logo.asm'"

LABEL BANNER.PAL:
ASM "read 'img/banner_pal.asm'"

LABEL BANNER.IMG0:
ASM "read 'img/banner_00.asm'"

LABEL BANNER.IMG1:
ASM "read 'img/banner_01.asm'"