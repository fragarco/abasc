'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2017 Bouche Arnaud
'  Copyright (C) 2017 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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
' USEFUL MACROS AND CONSTANTS
'
const SCREEN.BUFF        = &8000 ' Double buffer location
const MASKTABLE.SIZE     = &100
const MASKTABLE.LOCATION = &7F00 ' SCREEN_BUFF - MASK_TABLE_SIZE 
const NEWSTACKLOCATION   = &7E00 ' MASK_TABLE_LOCATION - MASK_TABLE_SIZE

' Sprites
const TITLE.W = 20
const TITLE.H = 16
const SHIP.W  = 5
const SHIP.H  = 10
const FIRE0.W = 1
const FIRE0.H = 6
const FIRE1.W = 1
const FIRE1.H = 6

' Locate ViewPort and Objects on Screen
SCREEN.WBYTES      = 80
SCREEN.H           = 200
VIEW.WPIXELS       = 200
VIEW.HPIXELS       = 60
MODE1PIXELSPERBYTE = 4
VIEW.WBYTES        = VIEW.WPIXELS \ MODE1PIXELSPERBYTE
VIEW.HBYTES        = VIEW.HPIXELS
VIEW.X             = (SCREEN.WBYTES - VIEW.WBYTES) \ 2
VIEW.Y             = 0
POS.TEXT           = VIEW.Y + VIEW.HBYTES + 20
POS.INFO           = VIEW.Y + VIEW.HBYTES + 70
POS.TITLEX         = (VIEW.WBYTES - TITLE.W) \ 2
POS.SHIPX          = ((VIEW.WBYTES - (SHIP.W \ 2)) \ 2)
POS.SHIPY          = ((VIEW.HBYTES - SHIP.H) \ 2 + 5)

' Memory location definition
const VIDEOMEM   = 0
const BUFFERMEM  = 1
const NBBUFFERS  = 2
