'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
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
'  Example adapted by Javier "Dwayne Hicks" Garcia

chain merge "cpctelera/cpctelera.bas"

''''''''''''''''''''''''''''''''''''''''/
' USEFUL MACROS AND CONSTANTS
const MAXSCROLL     =  80
const SCR.TILEWIDTH =  40
const MAP.WIDTH     = 120
const MAP.HEIGHT    =  46

''''''''''''''''''''''''''''''''''''''''/
' STRUCTURES 

' We could have used RECORD but let's use regular variables to simulate a
' structure defining a tilemap located on the screen
scr.pvideo   = CPCT.VMEMSTART
scr.ptilemap = @LABEL("g_tilemap")
scr.scroll   = 0
scrolloffset = 0 ' Requested scroll offset

''''''''''''''''''''''''''''''''''''''''/
' Main application's code
'
label MAIN
   gosub initializeCPC ' Initialize the machine and set up all necessary things

   ' Indefinitely draw the tilemap, listen to user input, 
   ' do changes and draw it again
   while 1
      label continue
      ' Waits for a user input and return requested scroll offset
      gosub wait4KeyboardInput ' sets scrolloffset

      ' Ensure requested scroll_offset is possible before doing it
      if scrolloffset > 0 then
         if scr.scroll = MAXSCROLL then goto continue  ' Do not scroll passed the right limit
      else
         if scr.scroll = 0 then goto continue  ' Do not scroll passed the left limit
      end if
      ' Scroll and redraw the tilemap
      gosub scrollScreenTilemap
   wend
end

''''''''''''''''''''''''''''''''''''''''/
' Read User Keyboard Input and do associated actions
'
label wait4KeyboardInput
   ' Read keyboard continuously until the user perfoms an action
   while 1
      ' Scan Keyboard
      call cpctScanKeyboardf() 

      ' Check user keys for controlling scroll. If one of them is pressed
      ' return the associated scroll offset.
      if cpctIsKeyPressed(KEY.RIGHT) then
         scrolloffset = 1
         return
      else
         if cpctIsKeyPressed(KEY.LEFT) then scrolloffset = -1: return
      end if
   wend
' end waitKeyboardInput

''''''''''''''''''''''''''''''''''''''''/
' Scrolls the tilemap, relocates pointers and draws left and right columns 
' with their new content after scrolling
'
label scrollScreenTilemap
   ' Select leftmost or rightmost column of the tilemap to be redrawn 
   ' depending on the direction of the scrolling movement made
   if scrolloffset > 0 then column = SCR.TILEWIDTH-1 else column = 0

   ' Update pointers to tilemap drawable window, tilemap upper-left corner in video memory
   ' and scroll offset
   scr.pvideo = scr.pvideo + (2*scrolloffset) ' Video memory starts now 2 bytes to the left or to the right
   scr.ptilemap = scr.ptilemap + scrolloffset ' Move the start pointer to the tilemap 1 tile (1 byte) to point to the drawable zone (viewport)
   scr.scroll   = scr.scroll + scrolloffset   ' Update scroll offset to produce scrolling

   ' Wait for VSYNC before redrawing,
   call cpctWaitVSYNC()
     
   ' Do hardware scrolling to the present offset
   call cpctSetVideoMemoryOffset(scr.scroll)    
   
   ' Redraw newly appearing column (either it is left or right)
   ' (X, Y) Upper-left Location of the Box (column in this case) to be redrawn
   ' (Width, Height) of the Box (column) to be redrawn
   ' Width of the full tilemap (which is wider than the screen in this case)
   ' Pointer to the upper-left corner of the tilemap in video memory
   ' Pointer to the first tile of the tilemap to be drawn (upper-left corner
   ' ... of the tilemap viewport window)
   call cpctetmDrawTileBox2x4(column, 0, 1, MAP.HEIGHT, MAP.WIDTH, scr.pvideo, scr.ptilemap)                                                

   ' When scrolling to the right, erase the character (2x8) bytes that scrolls-out
   ' through the top-left corner of the screen. Othewise, this pixel values will 
   ' loop and appear through the bottom-down corner later on.
   ' When scrolling to the left, erase the character that appears on the left, just
   ' below the visible tilemap
   if scrolloffset > 0 then 
      call cpctDrawSolidBox(scr.pvideo - 2, 0, 2, 8)  ' top-left scrolled-out char
   else
      brchar = cpctGetScreenPtr(scr.pvideo, 0, 4*MAP.HEIGHT)
      call cpctDrawSolidBox(brchar, 0, 2, 8)  ' bottom-right scrolled-out char
   end if
return

''''''''''''''''''''''''''''''''''''''''/
' Machine initialization code
'
label initializeCPC
   palette = @LABEL("g_palette")
   ' Initialize the application
   call cpctDisableFirmware()       ' Firmware must be disabled for this application to work
   call cpctSetVideoMode(0)         ' Set Mode 0 (16&200, 16 Colours)
   call cpctSetPalette(palette, 13) ' Set Palette 
   call cpctSetBorder(HWC.BLACK)    ' Set the border and background colours to black

   ' VERY IMPORTANT: Before using EasyTileMap functions (etm), the internal
   ' pointer to the tileset must be set. 
   call cpctetmSetTileset2x4(@LABEL("g_tileset"))   

   ' Clean up the screen 
   call cpctMemset(CPCT.VMEMSTART, &00, &4000)

   ' Draw the full tilemap for the first time
   ' (X, Y) upper-left corner of the tilemap
   ' (Width, Height) of the Box to be drawn (all the screen)
   ' Width of the full tilemap (which is wider than the screen)
   ' Pointer to the start of video memory (upper-left corner of the tilemap in the screen)
   ' Pointer to the first tile of the tilemap to be drawn (upper-left corner of the tilemap viewport window)
   call cpctetmDrawTileBox2x4(0, 0, SCR.TILEWIDTH, MAP.HEIGHT, MAP.WIDTH, CPCT.VMEMSTART, @LABEL("g_tilemap"))
return

asm "read 'img/tiles.asm'"
asm "read 'img/tilemap.asm'"