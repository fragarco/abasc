;-----------------------------LICENSE NOTICE------------------------------------
;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU Lesser General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU Lesser General Public License for more details.
;
;  You should have received a copy of the GNU Lesser General Public License
;  along with this program.  If not, see <http:;www.gnu.org/licenses/>.
;------------------------------------------------------------------------------

;
; A 2x4 tile full of background colour (PEN 0)
;
g_tile_background: ; 2*4
   db &00, &00
   db &00, &00
   db &00, &00
   db &00, &00


;
; A 2x4 tile full of yellow colour (PEN 1)
;
g_tile_yellow:
   db &F0, &F0
   db &F0, &F0
   db &F0, &F0
   db &F0, &F0

;
; A 2x4 tile full of blue colour (PEN 2)
;
g_tile_blue:
   db &0F, &0F
   db &0F, &0F
   db &0F, &0F
   db &0F, &0F

;
; A 2x4 tile full of red colour (PEN 3)
;
g_tile_red:
   db &FF, &FF,
   db &FF, &FF,
   db &FF, &FF,
   db &FF, &FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/
; Tileset: Ordered array of pointers to the different tiles that are used
;          in the tilemap. 
;
g_tileset:
   db g_tile_background, g_tile_yellow, g_tile_blue, g_tile_red

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/
; Tilemap: 2D matrix of tile-indexes (1-byte each). Each tile-index refers to the 
;          tile that occupies that index location inside the tileset array.
;
g_tilemap:   ; 20 * 16
   db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
   db 3, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 3
   db 3, 1, 0, 1, 2, 2, 2, 0, 0, 0, 2, 0, 2, 0, 1, 0, 1, 0, 0, 3
   db 3, 1, 0, 1, 2, 0, 0, 0, 1, 0, 2, 0, 2, 0, 1, 0, 1, 0, 0, 3
   db 3, 0, 1, 0, 2, 2, 0, 1, 0, 1, 2, 2, 2, 0, 1, 0, 1, 0, 0, 3
   db 3, 0, 1, 0, 2, 0, 0, 1, 0, 1, 2, 2, 2, 0, 0, 0, 0, 0, 0, 3
   db 3, 0, 1, 0, 2, 0, 0, 1, 1, 1, 2, 0, 2, 0, 1, 0, 1, 0, 0, 3
   db 3, 0, 0, 0, 2, 2, 2, 1, 0, 1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 3
   db 3, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3
   db 3, 2, 2, 2, 1, 2, 0, 1, 1, 1, 2, 0, 2, 0, 1, 0, 2, 2, 2, 3
   db 3, 0, 2, 0, 1, 2, 0, 1, 0, 0, 2, 2, 2, 1, 0, 1, 2, 0, 2, 3
   db 3, 0, 2, 0, 1, 2, 0, 1, 1, 0, 2, 0, 2, 1, 0, 1, 2, 0, 2, 3
   db 3, 0, 2, 0, 1, 2, 0, 1, 1, 0, 2, 0, 2, 1, 1, 1, 2, 2, 2, 3
   db 3, 0, 2, 0, 1, 2, 0, 1, 0, 0, 2, 0, 2, 1, 0, 1, 2, 0, 0, 3
   db 3, 0, 2, 0, 1, 2, 2, 2, 1, 1, 2, 0, 2, 1, 0, 1, 2, 0, 0, 3
   db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
