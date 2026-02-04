'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine 
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'  Copyright (C) 2015 SunWay / Fremos / Carlio 
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

'''''''''''''''''''''''''''''''''''''''''''''
' Palette definition (Same palette for all the sprites)
'

' Palette for mode 0 coded in RGB using 3 nibbles (&_RGB) 
' and 2 bits per nibble (0 = 0, 1 = 128, 2 = 255).
'  > Examples, &0111 means R=1, G=1, B=1 (128, 128, 128),
'  >           &0201 means R=2, G=0, B=1 (255,   0, 128)
DIM rgbpalette(17,3)

' Translation table from RGB to Amstrad CPC Hardware colour values
'    So, G_rgb2hw[R][G][B] = CPC hw colour
'    Indexes are R, G, B values with this mapping: 0=0, 1=128, 2=255 
DIM rgb2hw(3,3,3)

sub initPalette
  shared rgbpalette[],rgb2hw[]
  '    RGB          Firmware
  rgbpalette(0,0) = 1:rgbpalette(0,1) = 1:rgbpalette(0,2) = 1 '  &0D
  rgbpalette(1,0) = 2:rgbpalette(1,1) = 1:rgbpalette(1,2) = 0 '  &0F
  rgbpalette(2,0) = 1:rgbpalette(2,1) = 0:rgbpalette(2,2) = 0 '  &03
  rgbpalette(3,0) = 2:rgbpalette(3,1) = 2:rgbpalette(3,2) = 0 '  &18
  rgbpalette(4,0) = 0:rgbpalette(4,1) = 0:rgbpalette(4,2) = 1 '  &01
  rgbpalette(5,0) = 0:rgbpalette(5,1) = 0:rgbpalette(5,2) = 2 '  &14
  rgbpalette(6,0) = 2:rgbpalette(6,1) = 0:rgbpalette(6,2) = 0 '  &06
  rgbpalette(7,0) = 2:rgbpalette(7,1) = 2:rgbpalette(7,2) = 2 '  &1A
  rgbpalette(8,0) = 0:rgbpalette(8,1) = 0:rgbpalette(8,2) = 0 '  &00
  rgbpalette(9,0) = 0:rgbpalette(9,1) = 0:rgbpalette(9,2) = 2 '  &02
  rgbpalette(10,0) = 0:rgbpalette(10,1) = 1:rgbpalette(10,2) = 2 '  &0B
  rgbpalette(11,0) = 0:rgbpalette(11,1) = 2:rgbpalette(11,2) = 0 '  &12
  rgbpalette(12,0) = 2:rgbpalette(12,1) = 0:rgbpalette(12,2) = 2 '  &08
  rgbpalette(13,0) = 1:rgbpalette(13,1) = 0:rgbpalette(13,2) = 2 '  &05
  rgbpalette(14,0) = 2:rgbpalette(14,1) = 1:rgbpalette(14,2) = 1 '  &10
  rgbpalette(15,0) = 0:rgbpalette(15,1) = 1:rgbpalette(15,2) = 0 '  &09
  rgbpalette(16,0) = 1:rgbpalette(16,1) = 1:rgbpalette(16,2) = 1 '  &0D Border

  ' R=0
  rgb2hw(0,0,0) = &14: rgb2hw(0,0,1) = &04: rgb2hw(0,0,2) = &15 ' R=0, G=0, B=(0, 1, 2)
  rgb2hw(0,1,0) = &16: rgb2hw(0,1,1) = &06: rgb2hw(0,1,2) = &17 ' R=0, G=1, B=(0, 1, 2)
  rgb2hw(0,2,0) = &12: rgb2hw(0,2,1) = &02: rgb2hw(0,2,2) = &13 ' R=0, G=2, B=(0, 1, 2)
  ' R=1 (128)
  rgb2hw(1,0,0) = &1C: rgb2hw(1,0,1) = &18: rgb2hw(1,0,2) = &1D ' R=1, G=0, B=(0, 1, 2)
  rgb2hw(1,1,0) = &1E: rgb2hw(1,1,1) = &00: rgb2hw(1,1,2) = &1F ' R=1, G=1, B=(0, 1, 2)
  rgb2hw(1,2,0) = &1A: rgb2hw(1,2,1) = &19: rgb2hw(1,2,2) = &1B ' R=1, G=2, B=(0, 1, 2)
  ' R=2 (255)
  rgb2hw(2,0,0) = &0C: rgb2hw(2,0,1) = &05: rgb2hw(2,0,2) = &0D ' R=2, G=0, B=(0, 1, 2)
  rgb2hw(2,1,0) = &0E: rgb2hw(2,1,1) = &07: rgb2hw(2,1,2) = &0F ' R=2, G=1, B=(0, 1, 2)
  rgb2hw(2,2,0) = &0A: rgb2hw(2,2,1) = &03: rgb2hw(2,2,2) = &0B ' R=2, G=2, B=(0, 1, 2)
end sub


'''''''''''''''''''''''''''''''''/
' Sets a Palette colour from RGB values (0=0, 1=128, 2=255)
' but with a maximum limited value for each component (maxrgb)
'  It uses G_rgb2hw array to map RGB values into hardware colour values
'
DIM maxrgb(2)
sub setPALColourRGBLimited(palindex)
  shared rgb2hw[], rgbpalette[], maxrgb[]
  DIM s(2)  ' Final RGB values that will be set
  
  ' Check the 3 RGB components individually, and truncate them
  ' to left them below the limits established by maxrgb[]
  for i=0 to 2
    s(i) = rgbpalette(palindex, i)  ' The colour component to set is the one given in rgb[]

    ' If this colour component exceeds the maximum value for this 
    ' component, we truncate it to the maximum value
    if rgbpalette(palindex, i) > maxrgb(i) then s(i) = maxrgb(i)
  next

  ' Get the hardware colour value from its RGB components
  i = rgb2hw(s(0), s(1), s(2))

  ' Set the palette colour
  call cpctSetPALColour(palindex, i)
end sub

'''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''
'' PALETTE FUNCTIONS
''    * Fade in
''    * Fade out
''    * Set all the colours to black
'''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''/
' Fade in palette effect 
'   Does a fade in palette effect applied to a [min_pi, max_pi]
' range of palette colours 
'
sub fadeIn(minpi, maxpi, nframes)
  shared rgbpalette[], maxrgb[]
  ' Maximum components for the 3 RGB values, initially 0 (to slowly increase)
  maxrgb(0) = 0: maxrgb(1) = 0: maxrgb(2) = 0

  ' Do the Fade in effect iteratively for all the 3 RGB components (R, G, B)
  for col=0 to 2 ' Index of the colour component to change (R=0, G=1, B=2)
    ' Go increasing the present maximum colour component up to 
    ' its maximum value, 2 (0=0, 1=128, 2=255)
    while maxrgb(col) <= 2
      ' Set all the palette colours in the selected range again, 
      ' with the present maxrgb[] limits
      for pindex=minpi to maxpi
        call setPALColourRGBLimited(pindex)
      next
      maxrgb(col) = maxrgb(col) + 1 ' Increase present maximum colour component limit
      call waitFrames(nframes) ' Wait some frames to slow down the effect and see the changes
    wend
  next
end sub


'''''''''''''''''''''''''''''''''/
' Fade out palette effect 
'   Does a fade in palette effect applied to a [min_pi, max_pi]
' range of palette colours 
'
sub fadeOut(minpi, maxpi, nframes)
  shared rgbpalette[], maxrgb[]
  maxrgb(0) = 2: maxrgb(1) = 2: maxrgb(2) = 2 ' Maximum components for the 3 RGB values, initially 2 (to slowly decrease)

  ' Do the Fade out effect iteratively for all the 3 RGB components (R, G, B)
  for col=0 to 2 ' Index of the colour component to change (R=0, G=1, B=2)
    ' Go decreasing the present maximum colour component down to 
    ' its minimum value, 0 (2=255, 1=128, 0=0)
    label dofadeout
      maxrgb(col) = maxrgb(col) - 1  ' Decrease present maximum colour component limit

      ' Set all the palette colours in the selected range again, 
      ' with the present maxrgb[] limits
      for pindex=minpi to maxpi
        call setPALColourRGBLimited(pindex)
      next
      call waitFrames(nframes) ' Wait some frames to slow down the effect and see the changes
    if maxrgb(col) > 0 then goto dofadeout
  next
end sub

'''''''''''''''''''''''''''''''''
' Set all palette colours in a given range [min_pi, max_pi] 
' to black colour value (RGB = 0,0,0)
'
sub setBlackPalette(minpi, maxpi)
  shared rgb2hw[]
  ' Go through all the palette colours in the range [min_pi, max_pi] 
  for i=minpi to maxpi
    call cpctSetPALColour(i, rgb2hw(0,0,0))
  next  
end sub
