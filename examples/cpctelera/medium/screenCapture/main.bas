'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2018 Arnaud Bouche
'  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

''''''''''''''''''''''''''''''''''''''''/
' INCLUDES
chain merge "cpctelera/cpctelera.bas"

''''''''''''''''''''''''''''''''''''''''/
' USEFUL MACROS AND CONSTANTS
'

const SCREEN.CY   =  200
const SCREEN.CX   =  80
const VMEM.SIZE   =  &4000

const UFO.W       =  16
const UFO.H       =  21
const UFO.Y       =  120
const UFO.INITX   =  0
const GRADIENT.CY =  10
const BUILDING1.W =  11
const BUILDING1.H =  125
const BUILDING2.W =  7
const BUILDING2.H =  103
const BUILDING3.W =  9
const BUILDING3.H =  80

''''''''''''''''''''''''''''''''''''''''/
' INITIALIZATION
' 
sub Initialization
   shared CPCT.VMEMSTART, HWC.BLACK, VMEM.SIZE
   call cpctRemoveInterruptHandler()            ' Disable firmware to take full control of the CPC
   call cpctSetVideoMode(0)                     ' Set mode 0
   call cpctSetPalette(@LABEL("g_palette"), 16) ' Set the palette
   call cpctSetBorder(HWC.BLACK)                ' Set the border color with Hardware color
   
   ' Fill screen with color index 4 (Red)
   call cpctMemset(CPCT.VMEMSTART, cpctpx2byteM0(4, 4), VMEM.SIZE)
end sub

''''''''''''''''''''''''''''''''''''''''/
' GET UFO CURRENT ANIMATION SPRITE
'
ufo.anim = 0       ' Currently selected animation sprite
DIM ufo.sprites(3) ' Array of all four animation sprites
ufo.sprites(0) = @LABEL("g_ufo_0"): ufo.sprites(1) = @LABEL("g_ufo_1")
ufo.sprites(2) = @LABEL("g_ufo_2"): ufo.sprites(3) = @LABEL("g_ufo_3")

function GetUfoSprite
   ' Private UFO Animation-Status Data
   shared ufo.anim, ufo.sprites[]
   ' Just get next animation sprite and return it
   ufo.anim = (ufo.anim + 1) mod 4
   GetUfoSprite = ufo.sprites(ufo.anim)
end function

''''''''''''''''''''''''''''''''''''''''/
' DRAW UFO
'
draw.moveRight = 0
draw.posX = 0

sub DrawUFO
   shared CPCT.VMEMSTART, UFO.Y, UFO.W, UFO.H, SCREEN.CX
   ' Private data to control UFO location and status
   shared draw.moveRight, draw.posX
   
   ' Get a pointer to the start of the UFO sprite in video memory
   ' previous to moving. Background will need to be restored at this 
   ' precise location to erase UFO before drawing it in its next location
   pvmemufoBg = cpctGetScreenPtr(CPCT.VMEMSTART, draw.posX, UFO.Y)

   ' UFO Moves towards right or left
   ' When border is reached, movement direction changes
   if draw.moveRight then
      ' If right border reached go to left border
      if draw.posX = (SCREEN.CX - UFO.W) then
         draw.moveRight = 0        ' Change direction
      else 
         draw.posX = draw.posX + 1 ' Move to right
      end if
   else
      ' If left border reached go to right border
      if draw.posX = 0 then draw.moveRight = 1 else draw.posX = draw.posX - 1
   end if
   
   ' Get a pointer to the Screen Video Memory location where 
   ' UFO will be drawn next (in its new location after movement)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, draw.posX, UFO.Y)
   
   ' Wait for VSync and draw background and UFO
   ' This drawing operation is fast enough not to be caught by the raster, and does not produce
   ' any flickering. In other case you have to use double-buffer to prevent this.
   call cpctWaitVSYNC()
   
   '--- UFO REDRAWING
    
   ' Erase UFO at its previous location by drawing background over it
   call cpctDrawSprite(@LABEL(gScreenCapture), pvmemufoBg, UFO.W, UFO.H)
   
   ' Before drawing UFO at its new location, copy the background there
   ' to gScreenCapture buffer. This will let us restore it next time
   ' the UFO moves.
   call cpctGetScreenToSprite(pvmem, @LABEL(gScreenCapture), UFO.W, UFO.H)
   
   ' Draw UFO at its new location
   sp = GetUfoSprite()
   call cpctDrawSpriteMasked(sp, pvmem, UFO.W, UFO.H)
end sub

''''''''''''''''''''''''''''''''''''''''/
' FILL LINE OF COLOR
'
sub FillLine(pixColor, lineY)
   shared SCREEN.CX, CPCT.VMEMSTART
   ' Get a pointer to the start of line Y of screen video memory
   ' and fill it with given colour 
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, lineY)
   call cpctMemset(pvmem, pixColor, SCREEN.CX)
end sub

''''''''''''''''''''''''''''''''''''''''/
' DRAW SKY PART FILLED WITH GRADIENT
'
function DrawSkyGradient(cy, posY, colorFront, colorBack)
   shared SCREEN.CY
   ' Get Mode 0 screen pixel colour representations for front and back colours
   pixFront = cpctpx2byteM0(colorFront, colorFront)
   pixBack  = cpctpx2byteM0(colorBack, colorBack)

   ' Draw gradient zone
   for j=0 to (cy - 1)
      ' If end of screen reached stop drawing
      if posY = (SCREEN.CY - 2) then exit for 

      ' Draw lines of color
      for i=0 to (cy - j - 1)
         call FillLine(pixFront, posY)
         posY = posY + 1
      next
      call FillLine(pixBack, posY)
      posY = posY + 1
   next
   
   ' Return ending line colorized
   DrawSkyGradient = posY
end function

''''''''''''''''''''''''''''''''''''''''/
' DRAW SKY WITH GRADIENT ZONES FOR BACKGROUND
'
dim sky.colors(7)
sky.colors(0) = 2: sky.colors(1) = 15: sky.colors(2) = 2
sky.colors(3) = 7: sky.colors(4) = 10: sky.colors(5) = 13
sky.colors(6) = 8: sky.colors(7) = 4

sub DrawSky
   ' Define color of gradient sky parts
   shared sky.colors[], GRADIENT.CY
   
   ' Current line filled with color
   startLine = 0
   ' Screen is divided into gradient zone
   for i=1 to 7
      startLine = DrawSkyGradient(GRADIENT.CY - i, startLine, sky.colors(i), sky.colors(i - 1))
   next
end sub

''''''''''''''''''''''''''''''''''''''''/
' DRAW CITY WITH ALL BUILDING FOR BACKGROUND
'
dwc.pvmem1 = cpctGetScreenPtr(CPCT.VMEMSTART, 10, SCREEN.CY - BUILDING1.H)
dwc.pvmem2 = cpctGetScreenPtr(CPCT.VMEMSTART, 30, SCREEN.CY - BUILDING2.H)
dwc.pvmem3 = cpctGetScreenPtr(CPCT.VMEMSTART, 40, SCREEN.CY - BUILDING1.H)
dwc.pvmem4 = cpctGetScreenPtr(CPCT.VMEMSTART, 67, SCREEN.CY - BUILDING2.H)
dwc.pvmem5 = cpctGetScreenPtr(CPCT.VMEMSTART, 60, SCREEN.CY - BUILDING3.H)
sub DrawCity
   shared CPCT.VMEMSTART, SCREEN.CY
   shared BUILDING1.W, BUILDING1.H, BUILDING2.W, BUILDING2.H, BUILDING3.W, BUILDING3.H
   shared dwc.pvmem1, dwc.pvmem2, dwc.pvmem3, dwc.pvmem4, dwc.pvmem5
   
   call cpctDrawSprite(@LABEL("g_building_1"), dwc.pvmem1, BUILDING1.W, BUILDING1.H)
   call cpctDrawSprite(@LABEL("g_building_2"), dwc.pvmem2, BUILDING2.W, BUILDING2.H)
   call cpctDrawSprite(@LABEL("g_building_1"), dwc.pvmem3, BUILDING1.W, BUILDING1.H)
   call cpctDrawSprite(@LABEL("g_building_2"), dwc.pvmem4, BUILDING2.W, BUILDING2.H)
   call cpctDrawSprite(@LABEL("g_building_3"), dwc.pvmem5, BUILDING3.W, BUILDING3.H)
end sub

''''''''''''''''''''''''''''''''''''''''/
' INITIALIZE FIRST BACKGROUND CAPTURE    
' 
ic.pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, UFO.INITX, UFO.Y)
sub  InitCapture
   shared CPCT.VMEMSTART
   shared UFO.INITX, UFO.Y, UFO.W, UFO.H
   shared ic.pvmem
   ' Get Screen Video Memory pointer of default UFO location 
   ' and make a copy of the background pixel data there to gScreenCapture buffer
   call cpctGetScreenToSprite(ic.pvmem, @LABEL(gScreenCapture), UFO.W, UFO.H)
end sub

''''''''''''''''''''''''''''''''''''''''/
' DRAW BACKGROUND WITH GRADIENT SKY AND BUILDING     
' 
sub DrawBackground
   call DrawSky()
   call DrawCity()
   
   call InitCapture()
end sub

'''''''''''''''''''''''''''/
' MAIN PROGRAM
' 
label MAIN
   call Initialization()   ' Initialize everything
   call DrawBackground()   ' Draw background with sky and buildings
   
   ' Main Loop: Permanently move and draw the UFO
   while 1
      call DrawUFO()
   wend
end

''''''''''''''''''''''''''''''''''''''''/
' GLOBAL VARIABLES

' This array will contain a copy of the background in the video memory region that
' we will be overwritting with the UFO sprite. This copy will let us erase the 
' UFO sprite restoring the previous background.
label gScreenCapture
asm "defs 16*21" 

''''''''''''''''''''''''''''''''''''''''/
' SPRITES
asm "read 'img/ufo.asm'"
asm "read 'img/building_1.asm'"
asm "read 'img/building_2.asm'"
asm "read 'img/building_3.asm'"
