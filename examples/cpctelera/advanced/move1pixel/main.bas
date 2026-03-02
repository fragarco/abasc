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
chain merge "base/math.bas"

'''''''''''''''''''''''''''''''''''''''''''''
' DATA STRUCTURES AND CONSTANT VALUES
'

' Constant values
const SCR.WPIXELS = 160
const SCR.HPIXELS = 200
const PIXELSPERBYTE = 2
const SPRITE.WPIXELS = 16
const SPRITE.HPIXELS = 24
const SPRITE.WBYTES = SPRITE.WPIXELS \ PIXELSPERBYTE
const SPRITE.HBYTES = SPRITE.HPIXELS

const SHIFT.EVEN = 0  ' Sprite is un-shifted (starts on even pixel)
const SHIFT.ODD  = 1  ' Sprite is shifted    (starts on odd pixel)

' Struct for storing entity information

RECORD entity; x, y, nx, ny, w, h, sprite, shift
' x,  y  Pixel Location
' nx, ny Next pixel location
' w,  h  Width and height of the entity (in bytes!)
' sprite Sprite
' shift  Sprite shifting status (EVEN, ODD)
DECLARE hero$ FIXED 16 ' Our character

'''''''''''''''''''''''''''''''''''''''''''''
' Shift all pixels of a sprite to the right
'
sub shiftSpritePixelsRight(sprite, size)
   ' Shift all bits to the right, to move sprite 1 pixel to the right    
   prevrightpixel = 0 ' Value of the right-pixel of a byte, and the right-pixel of the previous byte
   label shiftdo
      ' Save the right pixel value of this byte (even bits)
      rightpixel = peek(sprite) and &X01010101
      ' Mix the right pixel of the previous byte (that now is left pixel) with 
      ' the left pixel of the present byte (that now should be right pixel)
      newvalue = shiftLeft(prevrightpixel) or shiftRight(peek(sprite) and &X10101010)
      poke sprite, newvalue
      ' Saved right pixel is stored as the previous byte right pixel, for next iteration
      prevrightpixel = rightpixel
      sprite = sprite + 1
      size = size - 1
   if size > 0 then goto shiftdo
end sub

'''''''''''''''''''''''''''''''''''''''''''''
' Shift all pixels of a sprite to the left
'
sub shiftSpritePixelsLeft(sprite, size)
   nextbyte = sprite + 1 ' Maintain a pointer to the next byte of the sprite 
   
   ' Shift all bits to the left, to move sprite 1 pixel to the left
   ' Assuming leftmost column is free (zeroed)
   ' Iterate up to the next-to-last byte, as the last byte is a special case
   size = size - 1 
   while size > 0
      ' Each byte is the mix of its right pixel (even bits) shifted to the left
      ' to become left pixel, and the left pixel of the next byte shifted to the right,
      ' to become right pixel.
      newvalue = shiftLeft(peek(sprite) and &X01010101) or shiftRight(peek(nextbyte) and &X10101010)
      poke sprite, newvalue
      sprite = sprite + 1
      nextbyte = nextbyte + 1
      size = size - 1
   wend
   ' Last byte has its right pixel shifted to the left to become left pixel, and
   ' zeros added as new right pixel
   poke sprite, shiftLeft(peek(sprite) and &X01010101)
end sub

'''''''''''''''''''''''''''''''''''''''''''''
' Shift an sprite to draw it at an even or odd location
'
sub shiftSprite(hero$)
   shared SHIFT.ODD, SHIFT.EVEN
   ' Depending on its present status, shifting will be to the left or to the right
   ' We always assume that the original sprite had its rightmost pixel column free (zeroed)
   if hero$.entity.shift = SHIFT.EVEN then     
      ' Shift sprite right & update shifting status
      call shiftSpritePixelsRight(hero$.entity.sprite, hero$.entity.w * hero$.entity.h)
      hero$.entity.shift = SHIFT.ODD
   else
      ' Shift sprite left & update shifting status
      call shiftSpritePixelsLeft(hero$.entity.sprite, hero$.entity.w * hero$.entity.h)
      hero$.entity.shift = SHIFT.EVEN
   end if
end sub

'''''''''''''''''''''''''''''''''''''''''''''
' Redraw an entity on the screen, synchronized with VSYNC.
'  - It erases previous location of the entity, then draws it at its new location
'
sub drawEntity(hero$)
   shared PIXELSPERBYTE, CPCT.VMEMSTART
   ' First, check if we have to shift the sprite because next horizontal location
   ' in pixels does not coincide with present shifting status of the Entity
   ' Remaining of dividing by 2: even pixels = 0, odd pixels = 1.
   if hero$.entity.shift <> (hero$.entity.nx MOD 2) then call shiftSprite(hero$)
   ' Wait for VSYNC
   call cpctWaitVSYNC()

   ' Erase the sprite drawing a 0 colour (background) box
   ' Horizontal location is in pixels, so we divide it by the number of pixels per byte
   ' (2 in mode 0) to give the screen location in bytes, as cpct_getScreenPtr requires
   pscr = cpctGetScreenPtr(CPCT.VMEMSTART, hero$.entity.x \ PIXELSPERBYTE, hero$.entity.y)
   call cpctDrawSolidBox(pscr, 0, hero$.entity.w, hero$.entity.h)
   
   ' Draw the sprite at its present location on the screen
   pscr = cpctGetScreenPtr(CPCT.VMEMSTART, hero$.entity.nx \ PIXELSPERBYTE, hero$.entity.ny)
   call cpctDrawSprite(hero$.entity.sprite, pscr, hero$.entity.w, hero$.entity.h)

   ' Update sprite coordinates
   hero$.entity.x = hero$.entity.nx
   hero$.entity.y = hero$.entity.ny
end sub

'''''''''''''''''''''''''''''''''''''''''''''
' Check User Input and perform actions
'
sub checkUserInput(hero$)
   shared PIXELSPERBYTE, SCR.WPIXELS, SCR.HPIXELS
   shared KEY.UP, KEY.DOWN, KEY.LEFT, KEY.RIGHT
   call cpctScanKeyboardf()
   ' Check input keys and produce movements 
   ' Checking also that we do not exit from boundaries
   if cpctIsKeyPressed(KEY.LEFT) and hero$.entity.nx > 0 then
      hero$.entity.nx = hero$.entity.nx - 1
   else
      endbyte = hero$.entity.nx + hero$.entity.w * PIXELSPERBYTE
      if cpctIsKeyPressed(KEY.RIGHT) and endbyte < SCR.WPIXELS then
         hero$.entity.nx = hero$.entity.nx + 1
      end if
   end if
   if cpctIsKeyPressed(KEY.UP) and hero$.entity.ny > 0 then
      hero$.entity.ny = hero$.entity.ny - 1
   else
      endbyte = hero$.entity.ny + hero$.entity.h
      if cpctIsKeyPressed(KEY.DOWN) and endbyte < SCR.HPIXELS then
         hero$.entity.ny = hero$.entity.ny + 1
      end if
   end if
end sub

'''''''''''''''''''''''''''''''''''''''''''''
' APPLICATION START
'
label MAIN
   ' Create and initialize the character entity
   hero$.entity.x = 32: hero$.entity.y = 88   ' Present pixel location
   hero$.entity.nx = 32: hero$.entity.ny = 88 ' Next pixel location
   hero$.entity.w = SPRITE.WBYTES             ' | Sprite Size in bytes
   hero$.entity.h = SPRITE.HBYTES             ' |
   hero$.entity.sprite = @LABEL("g_character")' Pointer to sprite definition
   hero$.entity.shift = SHIFT.EVEN            ' Pixel location is Even (32)

   ' Initialization
   palette = @LABEL("g_palette")
   call cpctDisableFirmware()         ' Firmware must be disabled
   call cpctSetVideoMode(0)           ' We will be using mode 0
   call cpctSetPalette(palette, 5)    ' We are only using 5 first palette colours
   call cpctSetBorder(peek(palette))  ' Set the border to the background colour (colour 0)
   call cpctClearScreenf64(&5555)     ' Fastly fillup the screen with a background pattern

   ' Loop forever
   while 1
      call checkUserInput(hero$)  ' Get user input and perform actions
      call drawEntity(hero$)      ' Draw the entity at its new location on screen
   wend
end

asm "read 'img/character.asm'"
