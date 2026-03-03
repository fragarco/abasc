'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 Dardalorth / Fremos / Carlio
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

' Some useful constants
const MAP.WTILES   = 40
const MAP.HTILES   = 50
const ALIEN.WBYTES =  6
const ALIEN.HBYTES = 24
const ALIEN.WTILES =  3
const ALIEN.HTILES =  6
const TILE.WBYTES  =  2
const TILE.HBYTES  =  4

'
' Variables for defining the location of an alien 
'
alien.tx = 0: alien.ty = 0  ' Location on the screen (in tiles)
alien.vx = 1: alien.vy = 1  ' Movement velocity      (in tiles)

background = @LABEL("g_background") ' ASM labels included at the
aliensp = @LABEL("g_alien")         ' end of this file
tileset = @LABEL("g_tileset")
palette = @LABEL("g_palette")

' Sets the transparent mask table for color 0, mode 0
' equivalent to cpctm_createTransparentMaskTable
masktable = cpctCreateTransparentMaskTablePen0M0()

''''''''''''''''''''''''''''''''''''''''''''
' Wait for n VSYNCs
'
sub waitNVSYNCs(n)
   label waitdo
      call cpctWaitVSYNC()
      n = n - 1
   if n > 0 then asm "halt": asm "halt": goto waitdo
end sub

''''''''''''''''''''''''''''''''''''''''''''
' MAIN PROGRAM: move a sprite over a background
'
label MAIN
   ' Initialize screen, palette and background
   gosub initialization

   '
   ' Main loop: Moves the sprite left-to-right and vice-versa
   '
   while 1
      ' Check if sprite is going to got out the screen and produce bouncing in its case
      if alien.vx < 0 then
         if alien.tx < -alien.vx then alien.vx = 1
      else
         if (alien.tx + alien.vx + ALIEN.WTILES >= MAP.WTILES) then alien.vx = -1
      end if

      if alien.vy < 0 then
         if (alien.ty < -alien.vy) then alien.vy = 1
      else
         if (alien.ty + alien.vy + ALIEN.HTILES >= MAP.HTILES) then alien.vy = -1
      end if

      ' Wait for VSYNC before drawing to the screen to reduce flickering
      ' We also wait for several VSYNC to make it move slow, or it will be too fast
      call waitNVSYNCs(2)

      ' Redraw a tilebox over the alien to erase it (redrawing background over it)
      call cpctetmDrawTileBox2x4(alien.tx, alien.ty, ALIEN.WTILES, ALIEN.HTILES, MAP.WTILES, CPCT.VMEMSTART, background)
      ' Move the alien and calculate it's new location on screen
      alien.tx = alien.tx + alien.vx 
      alien.ty = alien.ty + alien.vy
      pscra = cpctGetScreenPtr(CPCT.VMEMSTART, TILE.WBYTES*alien.tx, TILE.HBYTES*alien.ty)
      ' Draw the alien in its new location
      call cpctDrawSpriteMaskedAlignedTable(aliensp, pscra, ALIEN.WBYTES, ALIEN.HBYTES, masktable)
   wend
end

''''''''''''''''''''''''''''''''''''/
' Initialization routine
'    Disables firmware, initializes palette and video mode and
' draws the background
'
label initialization
   call cpctDisableFirmware()      ' Disable firmware to prevent it from interfering
   call cpctSetPalette(palette, 7) ' Set palette using hardware colour values
   call cpctSetBorder (HWC.BLACK)  ' Set border colour same as background (Black)
   call cpctSetVideoMode(0)        ' Change to Mode 0 (160x200, 16 colours)

   ' Set the internal tileset for drawing Tilemaps
   call cpctetmSetTileset2x4(tileset)

   ' Draw the background tilemap
   call cpctetmDrawTilemap2x4f(MAP.WTILES, MAP.HTILES, CPCT.VMEMSTART, background)  
return

asm "read 'img/alien.asm'"
asm "read 'img/map.asm'"
asm "read 'img/tiles.asm'"

