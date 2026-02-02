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

chain merge "cpctelera/cpctelera.bas"

''''''''''''''''''''''''''''''''''''''''/
' STRUCTURES AND GLOBALS
'
const MAP.WIDTH  = 20
const MAP.HEIGHT = 16
const SCR.HEIGHT = 200
const SCR.WIDTH  = 80

' Variables defining a tilemap located on the screen
' x,y - Location of the tilemap on the screen (byte coordinates)
' Viewport of the tilemap to show:
' x,y - Coordinates of the upper-left corner of the viewport relative to the tilemap
' w,h - Width and height in tiles of the viewport

tilemap.x = 0
tilemap.y = 0
viewport.x = 0
viewport.y = 0
viewport.w = MAP.WIDTH
viewport.h = MAP.HEIGHT

' Screen Buffers
'   0xC000 - Main Screen Buffer
'   0x8000 - BackBuffer (Requires moving program stack, that originally is at 0xBFFF)
'
DIM buffers(1)
buffers(0) = CPCT.VMEMSTART: buffers(1) = &8000

''''''''''''''''''''''''''''''''''''''''/
' Swaps between front-screen buffer and back-screen buffer. It manipulates 
' CRTC to change which buffer is shown at the screen, and then switches 
' the two buffers to make the reverse operation next time it gets called.
'
sub swapBuffers
   shared buffers[]
   shared VMP.PAGE80, VMP.PAGEC0, CPCT.VMEMSTART
   ' Change what is shown on the screen (present backbuffer (1) is changed to 
   ' front-buffer, so it is shown at the screen)
   ' cpct_setVideoMemoryPage requires the 6 Most Significant bits of the address,
   ' so we have to shift them 10 times to the right (as addresses have 16 bits)
   '
   page = VMP.PAGE80
   if buffers(1) = CPCT.VMEMSTART then page = VMP.PAGEC0
   call cpctSetVideoMemoryPage(page)
   
   ' Once backbuffer is being shown at the screen, we switch our two 
   ' variables to start using (0) as backbuffer and (1) as front-buffer
   aux = buffers(0)
   buffers(0) = buffers(1)
   buffers(1) = aux
end sub

''''''''''''''''''''''''''''''''''''''''/
' Wait for a given key to be pressed
'
sub wait4Key(cpctkey)
   ' First, if the key is already pressed, wait for 
   ' it being released
   call cpctScanKeyboardf()
   while cpctIsKeyPressed(cpctkey) <> 0
      call cpctScanKeyboardf()
   wend

   ' And now, wait for the key being pressed again
   while cpctIsKeyPressed(cpctkey) = 0
      call cpctScanKeyboardf()
   wend
end sub

''''''''''''''''''''''''''''''''''''''''/
' Shows messages on how to use this program on the screen and waits
' until de user presses a key.
'
sub showMessages
   shared KEY.SPACE
   pen 2
   print "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
   print "             TILEMAPS DEMO"
   print "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
   pen 1
   print "Shows  a tilemap  through   a  viewport,";
   print "letting you control the  location of the";
   print "tilemap and the size and position of the";
   print "viewport. All is done  using CPCTelera's";
   print "function cpctetmDrawTileBox2x4, from its";
   print "EasyTileMaps module.": print
   print "These are the control Keys:": print: pen 1
   print "Cursors  - Move tilemap location."
   print "  1, 2   - Change viewport width."
   print "  3, 4   - Change viewport height."
   print " W,A,S,D - Move viewport.": print
   pen 3
   print "       Press [Space] to continue"

   ' Wait for the user to press Space before continuing
   call wait4Key(KEY.SPACE)
end sub

''''''''''''''''''''''''''''''''''''''''/
' Read User Keyboard Input and do associated actions
'
sub readKeyboardInput
   shared tilemap.x, tilemap.y, viewport.x, viewport.y, viewport.w, viewport.h
   shared SCR.WIDTH, SCR.HEIGHT, MAP.WIDTH, MAP.HEIGHT
   shared KEY.DOWN, KEY.UP, KEY.LEFT, KEY.RIGHT
   shared KEY.1, KEY.2, KEY.3, KEY.4
   shared KEY.W, KEY.S, KEY.A, KEY.D
   ' Read keyboard continuously until the user perfoms an action
   while 1
      ' Scan Keyboard
      call cpctScanKeyboardf() 

      ' Check all the user keys one by one and, if one of them is pressed
      ' perform the action and return to the application
      '
      ' Move Tilemap Up (4 by 4 pixels, as it can only be placed
      ' ... on pixel lines 0 and 4
      if cpctIsKeyPressed(KEY.UP) and tilemap.y <> 0 then
         tilemap.y = tilemap.y - 4
         goto readkeyend
      end if
      ' Move Tilemap Down (same as moving Up, 4 by 4 pixels)
      if cpctIsKeyPressed(KEY.DOWN) and (tilemap.y < (SCR.HEIGHT - 4*MAP.HEIGHT)) then 
         tilemap.y = tilemap.y + 4   
         goto readkeyend
      end if
      ' Move Tilemap Left 2 pixels (1 byte)
      if cpctIsKeyPressed(KEY.LEFT) and (tilemap.x <> 0) then
         tilemap.x = tilemap.x - 1
         goto readkeyend
      end if
      ' Move Tilemap Right 2 pixels (1 byte)
      if cpctIsKeyPressed(KEY.RIGHT) and (tilemap.x < (SCR.WIDTH - 2*MAP.WIDTH)) then
         tilemap.x = tilemap.x + 1      
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.2) and (viewport.x + viewport.w < MAP.WIDTH) then
         viewport.w = viewport.w + 1 ' Enlarge viewport Horizontally
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.1) and (viewport.w > 1) then
         viewport.w = viewport.w - 1 ' Reduce viewport Horizontally
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.4) and (viewport.y + viewport.h < MAP.HEIGHT) then
         viewport.h = viewport.h + 1   ' Enlarge viewport Vertically
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.3) and (viewport.h > 1) then
         viewport.h = viewport.h - 1   ' Reduce viewport Vertically
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.W) and (viewport.y > 0) then
         viewport.y = viewport.y - 1   ' Move viewport Up
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.S) and (viewport.y + viewport.h < MAP.HEIGHT) then
         viewport.y = viewport.y + 1   ' Move viewport Down
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.A) and (viewport.x > 0) then
         viewport.x = viewport.x - 1   ' Move viewport Left
         goto readkeyend
      end if
      if cpctIsKeyPressed(KEY.D) and ((viewport.x + viewport.w) < MAP.WIDTH) then
         viewport.x = viewport.x + 1   ' Move viewport Right
         goto readkeyend
      end if
   wend
   label readkeyend
end sub

''''''''''''''''''''''''''''''''''''''''/
' Draws the tilemap in a new location or with a change in its viewport.
'  The drawing is done in the backbuffer and then shown in the screen when it's
'  done, switching screen buffers just after the VSYNC
'
sub drawScreenTilemap
   shared tilemap.x, tilemap.y
   shared viewport.x, viewport.y, viewport.w, viewport.h
   shared buffers[], MAP.WIDTH
   
   ' Clear the backbuffer
   call cpctMemsetf64(buffers(1), &00, &4000)

   ' Calculate the new location where the tilemap is to be drawn in
   ' the backbuffer, using x, y coordinates of the tilemap
   ptmscr = cpctGetScreenPtr(buffers(1), tilemap.x, tilemap.y)
   tilemap = @LABEL("g_tilemap")
   ' Draw the viewport of the tilemap in the backbuffer (pointed by ptmscr)
   call cpctetmDrawTileBox2x4(viewport.x, viewport.y, viewport.w, viewport.h, MAP.WIDTH, ptmscr, tilemap)
   
   ' Wait for VSYNC and change screen buffers just afterwards, 
   ' to make the backbuffer show on the screen
   call cpctWaitVSYNC()
   call swapBuffers()
end sub

''''''''''''''''''''''''''''''''''''''''/
' Main application's code
'
sub application
   ' First show user messages
   call showMessages()

   ' Initialize the application
   call cpctRemoveInterruptHandler() ' Firmware must be disabled for this application to work
   call cpctSetBorder(0)             '    Set the border colour gray and.. 
   call cpctSetPALColour(0, &14)     ' ...background black

   ' VERY IMPORTANT: Before using EasyTileMap functions (etm), the internal
   ' pointer to the tileset must be set. 
   call cpctetmSetTileset2x4(@LABEL("g_tileset"))

   ' Indefinitely draw the tilemap, listen to user input, 
   ' do changes and draw it again
   while 1
      call drawScreenTilemap()   ' Redraws the tilemap
      call readKeyboardInput()   ' Waits for a user input and makes associated changes
   wend
end sub

''''''''''''''''''''''''''''''''''''''''/
' MAIN PROGRAM:
'  Sets a new location for the stack and then calls the application code. 
'  Setting a new stack location must be done first, and the function doing it
'  must not use the stack (so, better not to use any local variable). Then,
'  it is preferable to just set it and call the application code.
'
label MAIN
   ' Move program's stack from 0xC000 to 0x8000. System return addresses are
   ' already stored at 0xBFFA - 0xBFFF, but we don't care about them as our
   ' program will never return to the system.
   call cpctSetStackLocation(&8000)

   ' Start the application 
   call application()   
end

asm "read 'img/tilemap.asm'"
