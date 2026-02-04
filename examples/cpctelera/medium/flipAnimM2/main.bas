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

chain merge "cpctelera/cpctelera.bas"

' Sprite size (in bytes)
const SP.W = 10
const SP.H = 94
const SP.X = 34
const SP.Y = 86

' Banner size (in bytes)
const BANNER.W = 80
const BANNER.H = 52

' Size of the screen (in bytes)
const SCR.W = 80

' Floor location and colour pattern
const FLOOR.Y = 180
const FLOOR.X = 30 
const FLOOR.W = 20
const FLOOR.H = 10

' Animation and timing
dim animframes(5)
animframes(0) = @LABEL("g_runner_0")
animframes(1) = @LABEL("g_runner_1")
animframes(2) = @LABEL("g_runner_2")
animframes(3) = @LABEL("g_runner_3")
animframes(4) = @LABEL("g_runner_4")
animframes(5) = @LABEL("g_runner_5")

'
' INITIALIZE: Initialize CPC, Draw demo banner and instructions
'
sub initialize
   shared CPCT.VMEMSTART, HWC.BLACK, HWC.WHITE
   shared BANNER.W, BANNER.H
   ' Disable firmware to prevent it from interfering with setPalette and setVideoMode
   call cpctRemoveInterruptHandler()

   ' Set up the hardware palette using hardware colour values
   call cpctSetBorder(HWC.BLACK)
   call cpctSetPALColour(0, HWC.BLACK)
   call cpctSetPALColour(1, HWC.WHITE)
   
   ' Set video mode 2 (64&200, 2 colours)
   call cpctSetVideoMode(2)

   ' Draw Demo banner at top-left corner of the screen (Start of video memory).
   ' We draw it in 2 parts, as cpct_drawSprite cannot draw sprites wider than 63 bytes.
   call cpctDrawSprite(@LABEL("g_banner_0"), CPCT.VMEMSTART             , BANNER.W/2, BANNER.H)
   call cpctDrawSprite(@LABEL("g_banner_1"), CPCT.VMEMSTART + BANNER.W/2, BANNER.W/2, BANNER.H)

   ' Draw instructions
   pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, 29, 60)
   call cpctSetDrawCharM2(0, 1)
   call cpctDrawStringM2("[Any Key] Run Opposite", pvideomem)
end sub

'
' MAIN: Using keyboard to move a sprite example
'
label MAIN
   nframe = 0  ' Actual animation frame
   cycles = 0  ' Number of waiting cycles done for present frame
   floorcolor = &X0000000001101010 ' Pixel pattern for the floor
   waitcycles = 6 ' Number of cycles to wait for each animation frame

   ' Initialize the Amstrad CPC
   call initialize()

   ' Sprites and the floor are always drawn at the same place. 
   ' We only need to calculate them once
   pvmemspr   = cpctGetScreenPtr(CPCT.VMEMSTART, SP.X, SP.Y)
   pvmemfloor = cpctGetScreenPtr(CPCT.VMEMSTART, FLOOR.X, FLOOR.Y)

   ' Infinite animation loop
   '
   while 1
      ' Scan Keyboard (fastest routine)
      ' The Keyboard has to be scanned to obtain pressed / not pressed status of
      ' every key before checking each individual key's status.
      call cpctScanKeyboardf()

      ' If any key is pressed, invert animation
      if cpctIsAnyKeyPressed() then
         for i=5 to 0 step -1
            call cpctHflipSpriteM2(SP.W, SP.H, animframes(i))
            ' This operation can also be done using ROM-friendly version code
            ' call cpctHflipSpriteM2r(animframes(i), SP.W, SP.H)
         next
      end if
 
      ' Check if we have to advance to the next animation frame
      ' And advance, if it is the case.
      cycles = cycles + 1
      if cycles = waitcycles then
         cycles = 0                   ' Restart frame counter
         nframe = nframe + 1
         if nframe = 5 then nframe = 0
         ' Advance floor 
         floorcolor = floorcolor XOR &00FF
      end if

      ' Wait for VSYNC and then draw the sprite
      call cpctWaitVSYNC()

      ' Draw the sprite in the video memory location got from coordinates x, y
      call cpctDrawSprite(animframes(nframe), pvmemspr, SP.W, SP.H)

      ' Draw floor (moving the pi)
      call cpctDrawSolidBox(pvmemfloor, floorcolor, FLOOR.W, FLOOR.H)
   wend
end

asm "read 'img/banner.asm'"
asm "read 'img/runner.asm'"