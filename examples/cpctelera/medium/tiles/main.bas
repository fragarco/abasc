'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

' Table with all the tiles and the required information to draw them
dim tile.addr(5)  ' Pixel data defining the tile
dim tile.w(5)     ' Width in bytes of the tile
dim tile.h(5)     ' Height in bytes of the tile

tile.addr(0) = @LABEL("waves_2x4"): tile.w(0) = 2: tile.h(0) = 4
tile.addr(1) = @LABEL("waves_4x4"): tile.w(1) = 4: tile.h(1) = 4
tile.addr(2) = @LABEL("waves_2x8"): tile.w(2) = 2: tile.h(2) = 8
tile.addr(3) = @LABEL("F_2x8")    : tile.w(3) = 2: tile.h(3) = 8
tile.addr(4) = @LABEL("waves_4x8"): tile.w(4) = 4: tile.h(4) = 8
tile.addr(5) = @LABEL("FF_4x8")   : tile.w(5) = 4: tile.h(5) = 8

'
' Fills all the screen with sprites using drawTileAlignedXXX functions
'
sub fillupScreen(tile)
   shared tile.addr[], tile.w[], tile.h[]
   shared CPCT.VMEMSTART
   tilesperline = (80 \ tile.w(tile)) - 1 ' Number of tiles per line = LINEWIDTH / TILEWIDTH

   ' Cover all the screen (200 pixels) with tiles
   for y=0 to 199 step tile.h(tile) 
      pvideomem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, y) ' Calculate byte there this pixel line starts

      ' Draw all the tiles for this line
      for x=0 to tilesperline       
         ' Select the appropriate function to draw the tile, and draw it
         select case tile
            case 0: call cpctDrawTileAligned2x4f (tile.addr(tile), pvideomem)
            case 1: call cpctDrawTileAligned4x4f (tile.addr(tile), pvideomem)
            case 2: call cpctDrawTileAligned2x8  (tile.addr(tile), pvideomem)
            case 3: call cpctDrawTileAligned2x8f (tile.addr(tile), pvideomem)
            case 4: call cpctDrawTileAligned4x8  (tile.addr(tile), pvideomem)
            case 5: call cpctDrawTileAligned4x8f (tile.addr(tile), pvideomem)
         end select

         ' Increase video memory pointer by tile->width bytes (point to next tile's place)
         pvideomem = pvideomem + tile.w(tile)
      next
   next
end sub

'
' MAIN LOOP
'

' Constants used to control length of waiting time
const WAITCLEARED = 2999 
const WAITPAINTED = 19999 

label MAIN
   ' Initialization
   call cpctRemoveInterruptHandler()
   call cpctSetVideoMode(0)

   ' Main loop: filling the screen using the 4 different basic 
   '            aligned functions in turns.
   while 1
      ' 4 iterations of filling up the screen out of tiles using
      ' the 4 different tile-drawing functions
      for i=0 to 5
         ' First, clear the screen and wait for a while
         call cpctClearScreen(0)
         for w=0 to WAITCLEARED: next

         ' Then, fill up the screen with the next tile-drawing function and wait another while
         call fillupScreen(i)
         for w=0 to WAITPAINTED: next
      next
   wend
end

asm "read 'img/sprites.asm'"