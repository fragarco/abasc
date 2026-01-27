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

' SCR.WIDTH:
' SCR.HEIGHT: Size of the full screen video memory in bytes
' BG.WIDTH:
' BG.HEIGHT:  Size of the background image in bytes
' BG.X BG.Y:  (x,y) byte coordinates of the upper-left corner
'             of the background image
const SCR.WIDTH  = 80
const SCR.HEIGHT = 200
const BG.HEIGHT  = 128
const BG.WIDTH   = 80
const BG.X       = 0
const BG.Y       = 72

''''''''''''''''''''''''''''''''''''/
' drawBackground
'    Draws the background from pixel line 72 onwards
'
sub drawBackground
   shared BG.X, BG.Y, BG.WIDTH, BG.HEIGHT, CPCT.VMEMSTART
   ' Get a pointer to the (x,y) location in the screen where 
   ' the background has to be drawn (its upper-left corner)
   p = cpctGetScreenPtr(CPCT.VMEMSTART, BG.X, BG.Y)

   ' The sprite of the background is split into 2 spites of half
   ' its wide, to bypass the limit of 63-bytes that drawSprite can draw.
   ' So, we have to draw them both. The first on (x,y) and the second
   ' on (x + BG_WIDTH/2, y)
   call cpctDrawSprite(@label(background0), p, BG.WIDTH/2, BG.HEIGHT)
   call cpctDrawSprite(@label(background1), p+BG.WIDTH/2, BG.WIDTH/2, BG.HEIGHT)
end sub

''''''''''''''''''''''''''''''''''''/
' drawSpriteMixed
'    draws a (sprite) of size (width,height) at a given location (x,y) using
' a given blending (mode)
'
sub drawSpriteMixed(blendmode, sprite, x, y, w, h)
   ' Get a pointer to the (x,y) location in the screen where
   ' the sprite will be drawn (its upper-left corner)
   shared CPCT.VMEMSTART
   p = cpctGetScreenPtr(CPCT.VMEMSTART, x, y)

   ' Set the blend mode to use before drawing the sprite using blending
   call cpctSetBlendMode(blendmode)

   ' Draw the sprite to screen with blending
   call cpctDrawSpriteBlended(p, w, h, sprite)
end sub

''''''''''''''''''''''''''''''''''''/
' drawCurrentSpriteAtRandom
'    draws the current selected sprite using the current selected blending
' mode at a random (x,y) location inside the map
'
sub drawCurrentSpriteAtRandom
   shared BG.X, BG.Y, BG.WIDTH, BG.HEIGHT
   shared blendmode[], itemsp[], selectedBlendMode, selectedItem
   ' Select 2 random coordinates to put the sprite inside the background
   ' Take into account the width (4) and height (8) of sprites in bytes
   ' not to put them too close to the boundaries
   x = BG.X + ( cpctRand() mod (BG.WIDTH  - 4) )
   y = BG.Y + ( cpctRand() mod (BG.HEIGHT - 8) )

   ' Draw the selected item with selected blending mode
   call drawSpriteMixed(blendmode(selectedBlendMode), itemsp(selectedItem), x, y, 4, 8)
end sub

''''''''''''''''''''''''''''''''''''/
' drawUserInterfaceStatus
'    draws the current user interface status values: the selected item
' and the selected blending mode
'
sub drawUserInterfaceStatus
   shared CPCT.VMEMSTART, blendname$[], itemname$[], itemsp[]
   shared selectedBlendMode, selectedItem
   ' Get a pointer to the (x,y) location in the screen where
   ' the name and sprite of the item will be drawn
   p = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 60)
   
   ' Select foreground/background colours for drawStringM0 functions
   call cpctSetDrawCharM0(8, 0)

   ' Draw the name of the item and its corresponding sprite
   ' The sprite has to be drawn 7 characters to the right (7*4 = 28 bytes)
   call cpctDrawStringM0(itemname$(selectedItem), p)
   call cpctDrawSprite(itemsp(selectedItem), p + 28, 4, 8)
   
   ' Do the same as before to draw the name of the current blending mode
   p = cpctGetScreenPtr(CPCT.VMEMSTART, 52, 60)
   call cpctDrawStringM0(blendname$(selectedBlendMode), p)
end sub

''''''''''''''''''''''''''''''''''''/
' drawUserInterfaceMessages
'    draws the messages that conform the user interface 
'
sub drawUserInterfaceMessages
   shared CPCT.VMEMSTART
   ' Draw first two strings at the top-left corner of the screen
   ' (exactly at CPCT_VMEM_START) and 8 characters to the right (8*4 = 32 bytes)
   call cpctSetDrawCharM0(3, 0)
   call cpctDrawStringM0("[Space]", CPCT.VMEMSTART)
   call cpctSetDrawCharM0(9, 0)
   call cpctDrawStringM0("Draw Item", CPCT.VMEMSTART+32)
   
   ' Get a pointer to the first pixel in the 15th line of the screen
   ' And draw there next 2 strings, being the second 8 characters to the right also
   p = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 15)
   call cpctSetDrawCharM0(3, 0)
   call cpctDrawStringM0("[1] [2]", p)
   call cpctSetDrawCharM0(9, 0)
   call cpctDrawStringM0("Select", p+32)

   ' Repeat same operation as before, but to draw at the start of the 30th line
   p = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 30)
   call cpctSetDrawCharM0(3, 0)
   call cpctDrawStringM0("[Esc]", p)
   call cpctSetDrawCharM0(9, 0)
   call cpctDrawStringM0("Clear", p+32)

   ' And to same operation again, but to put messages for 
   ' selected Item and Blend mode on the 50th line of the screen
   p = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 50)
   call cpctSetDrawCharM0(1, 6)
   call cpctDrawStringM0("   Item     Blend   ", p)
end sub
