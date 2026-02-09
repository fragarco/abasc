'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2018 Miguel Sánchez aka PixelArtM (@PixelArtM)
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
'
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' CPCTELERA EXAMPLE: SCROLL A TILEMAP
'------------------------------------------------------------------------------
'------------------------------------------------------------------------------
' This example shows how CPCtelera easytilemap functions can be used to
' scroll a tilemap in a simple way. This technique was used by many games
' back in the day.
'
' The technique consists in redrawing the whole viewport at each frame. Hence,
' scrolling is produced by drawing a different (scrolled) viewport of the 
' tilemap each time. cpct_etm_drawTilemap4x8_ag can draw viewports of a tilemap.
' On each call, a new viewport inside the tilemap is selected and drawn, and 
' that produces the scroll effect. 
'
' This demo draws a 16x16 tiles (128x128 pixels) viewport that gets redrawn 
' scrolled consistently at ~21 FPS. cpct_etm_drawTilemap4x8_ag is fast enough
' to let you create scrolling games with decent framerates just following
' this technique. However, if you carefully redesign which parts have to be
' redrawn, you may get higher framerates without having to resort to more 
' complicated hardware scrolling techniques.
'
' Building, Frames and Tiles are contributed by @PixelArtM (https:'twitter.com/PixelArtM)
' and distributed under Creative Commons CC-BY-SA-3.0 License
'------------------------------------------------------------------------------

' Required Include files
chain merge "cpctelera/cpctelera.bas"
chain merge "modules/video.bas"

' USEFUL CONSTANTS AND PRECALCULATIONS
'
const  TILE.W     = 4  ' Width of a tile in bytes
const  TILE.H     = 8  ' Height of a tile in bytes
const  VIEWPORT.W = 16 ' Width of the viewport in tiles
const  VIEWPORT.H = 16 ' Height of the viewport in tiles
const  VIEW.X     = 8  ' X location of the viewport in bytes
const  VIEW.Y     = 32 ' Y location of the viewport in bytes
const  BUILDING.W = 32
const  BUILDING.H = 32
const  FRAMEUD.W  = 21
const  FRAMEUD.H  = 4
const  FRAMELR.W  = 4
const  FRAMELR.H  = 16

' Pre-calculate the offset in bytes at which the viewport has to be drawn. This place will
' be the same in relative coordinates. For instance, standard video memory starts at &C000.
' If this viewport was to be drawn at &C120, &120 would be the offset. This offset would
' be the same if it was to be drawn at a hardware backbuffer starting at &8000, as it would 
' be drawn at &8120. To calculate only this offset, we use cpctm_screenPtr with 0 as 
' video memory pointer. The resulting calculation will contain only the offset, and that offset
' could then be added to the start pointer of any video memory buffer to be used.
' Remember that we use cpctm_screenPtr macro because all values are constant, and so is the result.
VIEWPORT.OFFSET = cpctGetScreenPtr(0, VIEW.X, VIEW.Y)

''''''''''''''''''''''''''''''''''''''''''
' DRAW BUILDING SCROLLED
'    This function draws the scrolling background inside the frame, which is a 
' building. The parameter offset controls the offset at which the viewport to 
' be drawn is located, inside the g_building tilemap. By changing offset, different
' viewports are drawn, and a scrolling effect can be performed.
'
sub drawBuidlingScrolled(offset)
   shared VIEWPORT.OFFSET
   ' vmem points to the place in present hardware backbuffer where the viewport
   ' is to be drawn. This place is the same inside a given hardware backbuffer,
   ' and hence we can have a pre-calculated VIEWPORT_OFFSET to directly add to
   ' the start of the current hardware backbuffer in memory 
   vmem = videoGetBackBufferPtr() + VIEWPORT.OFFSET
   
   ' DRAW THE g_building TILEMAP SCROLLED
   '    Scroll is controlled by offset, which is just representing the index of the first
   ' tile inside the g_building tilemap that has to be drawn. 
   call cpctetmDrawTilemap4x8ag(vmem, @LABEL("g_building") + offset)

   ' After drawing the tilemap, switch video buffers to display recently drawn backbuffer
   call videoSwitchBuffers()
end sub

''''''''''''''''''''''''''''''''''''''''''
' DRAW SCROLL FRAME
'    Draws a frame around the scrolling viewport in the screen. This frame is 
' just static decoration. This frame is defined using 2 tilemaps: one for up/down
' parts of the frame, and the other for left/right parts.
'
sub drawFrame
   shared TILE.W, TILE.H, FRAMEUD.W, FRAMELR.W
   vmembuffer = videoGetBackBufferPtr()  ' Get present Hardware Back Buffer were we are going to draw
   ' DRAW UP-DOWN PARTS OF THE FRAME
   '
   '    Up-Down parts of the frame share the same tilemap (g_frame_ud), so we 
   ' set up internal values for drawTilemap4x8_ag once, and then use it twice.
   ' All values for this tilemap are automatically generated at maps/frame_updown.c.
   ' Tileset data is automatically generated at maps/tileset.c
   ' Size: (Complete Frame Width x g_frame_ud_H) = (20 x 4 tiles)
   ' tilemap_width: g_frame_ud_W (21 tiles)
   ' tileset: g_tileset (starts in memory at g_tileset_00)
   call cpctetmSetDrawTilemap4x8ag(20, 4, FRAMEUD.W, @LABEL("g_tileset_00"))
   ' Draw the upper part of the tilemap at the start of the hardware backbuffer
   call cpctetmDrawTilemap4x8ag(vmembuffer, @LABEL("g_frame_ud"))
   ' Draw the lower part of the tilemap. First, calculate its location from coordinates:
   '   Coord.X: At the left part of the screen, so 0.
   '   Coord.Y: As this part of the frame is 4 tiles wide, and the complete frame takes 24
   '            tiles, this is to be located at tile 24-4 = 20.
   ' Both coordinates need to be multiplied by width and height of tiles in bytes, to get
   ' actual byte coordinates for getScreenPtr.
   vmem = cpctGetScreenPtr(vmembuffer,  0, 20*TILE.H)
   ' This lower part will be displaced 1 tile to the right to create the effect of a 
   ' displaced frame. The g_frame_ud tilemap is 21 tiles wide for this.
   call cpctetmDrawTilemap4x8ag(vmem, @LABEL("g_frame_ud") + 1)

   ' DRAW LEFT-RIGHT PARTS OF THE FRAME
   '
   '    We follow same scheme as with Up-Down parts, but we use a different tilemap
   ' (g_frame_lr) which is designed for this. This tilemap has both left and right 
   ' frame parts integrated, so half the tilemap is the left part, and the other half 
   ' the right part.
   ' All values for this tilemap are automatically generated at maps/frame_leftright.c.
   ' Size: (g_frame_lr_W/2 x g_frame_lr_H) = (2 x 16 tiles)
   ' tilemap_width: g_frame_lr_W (4 tiles)
   ' tileset: g_tileset (starts in memory at g_tileset_00)   
   call cpctetmSetDrawTilemap4x8ag( 2, 16, FRAMELR.W, @LABEL("g_tileset_00"))
   ' Draw the left part of the tilemap just below previously drawn upper part,
   ' that is at (0, 4) tile coordinates.
   vmem = cpctGetScreenPtr(vmembuffer,  0, 4*TILE.H)
   call cpctetmDrawTilemap4x8ag (vmem, @LABEL("g_frame_lr"))   
   ' Draw the right part of the tilemap just below previously drawn upper part, and at the
   ' right-most part of the screen. At (20 - 2, 4) = (18, 4) tile coordinates.
   vmem = cpctGetScreenPtr(vmembuffer, 18*TILE.W, 4*TILE.H)
   call cpctetmDrawTilemap4x8ag(vmem, @LABEL("g_frame_lr") + 2)
end sub

''''''''''''''''''''''''''''''''''''''''''
' INITIALIZES THE CPC FOR THIS DEMO
'    Set up VideoMode and colours, draw scroll frames on both screen buffers and
' set up values for g_building tilemap drawing that will be used later on.
'
sub initialize
   shared HWC.BLUE, BUILDING.W
   shared VIEWPORT.W, VIEWPORT.H
   call cpctRemoveInterruptHandler()            ' We use own mode and colours, firmware must be disabled
   call cpctSetVideoMode(0)                     ' Set video mode 0 (16&200 pixels, 2&25 characters, 16 colours)
   call cpctSetPalette(@LABEL("g_palette"), 16) ' Set our own colours defined en g_palette (automatically generated in maps/tileset.c)
   call cpctSetBorder(HWC.BLUE)                 ' Set border same as background colour: BLUE

   ' DRAW SCROLL FRAME ON BOTH SCREEN BUFFERS
   '   This frame will stay the same during all redraws, and hence we draw it
   ' only once on both video buffers. After that, we will only redraw the scrolling
   ' g_building viewport, that will be drawn inside the frame.
   call videoInitBuffers()    ' Initialize screen video buffers
   call drawFrame()           ' Draw a frame at the first selected screen buffer
   call videoSwitchBuffers()  ' Switch video buffers (current screen <--> current backbuffer)
   call drawFrame()           ' Draw the same frame at the second screen buffer

   ' SET UP INTERNAL VALUES FOR DRAWTILEMAP4x8_AG function
   '    We will use this function later on for each redraw of the viewport. However, as
   ' internal values will always be the same (same tileset, tilemap and viewport size), we 
   ' set them only once here, and then we just call the drawing function each time we need it.
   call cpctetmSetDrawTilemap4x8ag(VIEWPORT.W, VIEWPORT.H, BUILDING.W, @LABEL("g_tileset_00"))
end sub

''''''''''''''''''''''''''''''''''''''''''
' MAIN LOOP FOR THIS EXAMPLE
'    It draws the 16x16 character viewport, asks the user for key presses,
' recalculates new offset for the viewport inside the tilemap, and repeats.
'
sub game
   shared KEY.O, KEY.P, KEY.Q, KEY.A
   shared BUILDING.W, BUILDING.H
   shared VIEWPORT.W, VIEWPORT.H
   offset = 0   ' Offset in tiles of the start of the view window in the g_building tilemap
   x = 0: y = 0 ' (x, y) coordinates of the start of the view window in the g_building tilemap
   ' Loop forever
   while 1
      ' Draw the viewport scrolled inside the g_building tilemap 
      ' up to the current movement offset
      call drawBuidlingScrolled(offset)

      ' Check user input and update offset accordingly (OPQA for movement)
      ' Use (x, y) coordinates of the upper-left tile of the viewport to determine 
      ' valid movements (those that maintain viewport inside g_building tilemap boundaries).
      ' Size of the viewport (VIEWPORT_W, VIEWPORT_H) is used to check boundaries.
      ' Offset value update:
      '    - Right-Left movements select previous-next tile in the tilemap, so offset requires 
      '      to be updated (-1 for left), (+1 for right).
      '    - Up-Down movements want to select one tile up or one tile down. However, as the tilemap
      '      is stored as a 2D-array, it means that one tile up or down is 1 row away in memory
      '      (Each row is stored in memory after the previous row). Therefore, to select up-down
      '      tiles in memory, offset requires to be updated (-g_building_W for up), (+g_building_W for down)
      '
      call cpctScanKeyboardf()
      if cpctIsKeyPressed(KEY.O) and (x > 0) then x = x - 1: offset = offset - 1
      if cpctIsKeyPressed(KEY.P) and x < (BUILDING.W - VIEWPORT.W) then x = x + 1: offset = offset + 1
      if cpctIsKeyPressed(KEY.Q) and (y > 0) then y = y - 1: offset = offset - BUILDING.W
      if cpctIsKeyPressed(KEY.A) and y < (BUILDING.H - VIEWPORT.H) then y = y + 1: offset = offset + BUILDING.W
   wend
end sub

''''''''''''''''''''''''''''''''''''''''''
' MAIN ENTRY POINT FOR THIS EXAMPLE
'    Set new location for the stack, initialize CPC and execute the game
'
label MAIN
   ' This example needs 2 hardware screens for double buffer. As we want to use 
   ' &C000-&FFFF and &8000-&BFFF as screens, the program stack cannot be located 
   ' at &C000 (default location) because it would then overwrite part of the second 
   ' screen (&8000-&BFFF. Take into account that the stack grows backwards). Therefore, 
   ' the first thing to do is relocate the stack at &8000.
   call cpctSetStackLocation(&8000)
   
   ' Initialize CPC and run the game
   call initialize()
   call game()
end

asm "read 'img/building.asm'"
asm "read 'img/frame_leftright.asm'"
asm "read 'img/frame_updown.asm'"
asm "read 'img/tileset.asm'"
