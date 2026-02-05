'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2015 Dardalorth / Fremos / Carlio
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

' Death sprite Width and Height in _bytes_. In Mode 1, 1 Byte = 8 pixels,
' ...then 36 x 44 pixels = 9 x 44 bytes.
const SPR.W = 9
const SPR.H = 44

'
' EXAMPLE: Measuring free microseconds per frame after drawing a sprite
'
label MAIN
   x = 0: y = 0               ' Sprite coordinates (in bytes)
   pvideomem = CPCT.VMEMSTART ' Sprite initial video memory byte location (where it will be drawn)
   ms = 0                     ' Available microseconds until next VSYNC, after all main loop calculations

   ' First, disable firmware to prevent it from intercepting our palette and video mode settings (and,
   ' at the same time, winning some speed not having to process firmware code at every interrupt)
   call cpctRemoveInterruptHandler()
   ' Set palette and Screen Border (transform firmware to hardware colours and then set them)
   paladdr = @LABEL("sp_palette")
   call cpctfw2hw(paladdr, 4)
   call cpctSetPalette(paladdr, 4)
   call cpctSetBorder (peek(paladdr+1))
   call cpctSetVideoMode(1)         ' Ensure MODE 1 is set
   call cpctSetDrawCharM1(3, 0)     ' Always draw characters using same colours (3 (Yellow) / 0 (Grey))

   ' Main Loop
   while 1
      ' Scan Keyboard and change sprite location if cursor keys are pressed
      call cpctScanKeyboardf()
      if cpctIsKeyPressed(KEY.RIGHT) and (x < (80 - SPR.W)) then x = x + 1
      if cpctIsKeyPressed(KEY.LEFT) and (x > 0) then x = x - 1
      if cpctIsKeyPressed(KEY.UP) and (y > 0)   then y = y - 1
      if cpctIsKeyPressed(KEY.DOWN) and (y < (200 - SPR.H)) then y = y + 1
      pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)
      ' Wait VSYNC monitor signal to synchronize the loop with it. We'll start drawing the sprite
      ' calculations always at the same time (when VSYNC is first detected)
      call cpctWaitVSYNC()

      ' Draw the sprite at its new location on screen. 
      ' Sprite automatically erases previous copy of itself on the screen because it moves 
      ' 1 byte at a time and has a &00 border that overwrites previous colours on that place
      
      call cpctDrawSprite(@LABEL("sp_death"), pvideomem, SPR.W, SPR.H)
      
      ' Wait to next VSYNC signal, calculating the amount of free microseconds (time we wait for VSYNC)
      ' As documented on <cpct_count2VSYNC>, function returns number of loop iterations (L), and 
      ' microseconds shall be calculated as ms = 14 + 9*L (CPU Cycles will then be 4*ms)
      ' With this, we measure exact time it takes for us to draw the sprite
      ms = 14 + 9 * cpctCount2VSYNC()

      ' Print 5 digits on the upper right corner of the screen, 
      ' with the amount of free microseconds calculated in previous step. 
      ' Digits will be printed at screen locations (&C046, &C048, &C04A, &C04C, &C04E)
      for i=0 to 4
         digit = ASC("0") + (ms mod 10)
         call cpctDrawCharM1(&C04E - 2*i, digit)
         ms = ms \ 10
      next
   wend
end

asm "read 'img/sprites.asm'"