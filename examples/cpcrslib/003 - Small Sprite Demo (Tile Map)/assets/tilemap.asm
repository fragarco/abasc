; Code adapted to ABASM syntax by Javier "Dwayne Hicks" Garcia
; Based on CPCRSLIB:
; Copyright (c) 2008-2015 Raúl Simarro <artaburu@hotmail.com>
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of
; this software and associated documentation files (the "Software"), to deal in the
; Software without restriction, including without limitation the rights to use, copy,
; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
; and to permit persons to whom the Software is furnished to do so, subject to the
; following conditions:
;
; The above copyright notice and this permission notice shall be included in all copies
; or substantial portions of the Software.
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
; PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
; FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
; OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
; DEALINGS IN THE SOFTWARE.

; Define your tile data at the end of this file

;----------------------------------------------------------------------------------------
; SCREEN AND BUFFER ADDRESSES
;----------------------------------------------------------------------------------------

; Top-Left screen value where Tile Map will be shown.
T_VIDEOMEMORY_ADDR   equ &C0A4
; Memory location where the double buffer (aka superbuffer) that composes the
; Tile Map (or superbuffer) starts. This buffer consumes T_WIDTH * 2 + T_HEIGHT * 8 bytes.
T_DOUBLEBUFFER_ADDR  equ &8000

;----------------------------------------------------------------------------------------
; TILE MAP DIMENSIONS
;----------------------------------------------------------------------------------------
; Video memory 640x200 bits arreged depending on video mode.
T_WIDTH  equ 32 	; Width of screen in Tiles. Max = 40 (40*2 = 80 * 8 = 640 bits)
T_HEIGHT equ 16		; Heigh of screen in Tiles. Max = 20 (20*8 = 160 bits + 40 bits of margin)

; Invisible tile margins (in tiles). 
; This area is not shown on the screen. It can be used to make the sprites appear or disappear
; of the screen.

T_HIDDENW equ 2		; Number of horizontal hidden tiles 		
T_HIDDENH equ 0		; Number of vertical hidden tiles 

;----------------------------------------------------------------------------------------
; Transparent colour for cpc_PutTrSpTileMap2b routine
; for printing sprites using transparent color a mask color selection is 
; requiered. The color is defined through two bytes using the screen mode
; arrangement.
;----------------------------------------------------------------------------------------
; Example colour number 7:
; mask1	= 	&54 
; mask2	= 	&A8
;
; 0:  &00, &00
; 1:  &80, &40
; 2:  &04, &08
; 3:  &44, &88
; 4:  &10, &20
; 5:  &50, &A0
; 6:  &14, &28
; 7:  &54, &A8
; 8:  &01, &02
; 9:  &41, &82
; 10: &05, &0A
; 11: &45, &8A
; 12: &11, &22
; 13: &51, &A2
; 14: &15, &2A
; 15: &55, &AA

T_MASK1 equ 0
T_MASK2 equ 0

;------------------------------------------------------------------------------------
; TILE DATA. TILES MUST BE DEFINED HERE!
;------------------------------------------------------------------------------------

tiles_tilearray: ; Each tile is 2 x 8 bytes
; tile 0
    db &00,&00
    db &40,&00
    db &40,&00
    db &40,&00
    db &40,&00
    db &40,&00
    db &40,&C0
    db &00,&00
; tile 1
    db &3C,&00
    db &3C,&00
    db &00,&3C
    db &00,&3C
    db &3C,&00
    db &3C,&00
    db &00,&3C
    db &00,&3C
;tile 2
    db &00,&00
    db &15,&00
    db &00,&2A
    db &15,&00
    db &00,&2A
    db &15,&00
    db &00,&00
    db &00,&00
; tile 3
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
    db &FF,&FF
