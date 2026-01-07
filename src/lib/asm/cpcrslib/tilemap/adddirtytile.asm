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

; cpc_PutSpTileMap assumes that HL points to a structure that defines a sprite as follows:
; sprite:
;    sprite1_sp0: dw _spritedata
;    sprite1_sp1: dw _spritedata
;    sprite1_coord0: dw 0
;    sprite1_coord1: dw 0
;    sprite1_cx: db 0       ; current coordinates
;    sprite1_cy: db 0
;    sprite1_ox: db 0       ; old coordinates
;    sprite1_oy: db 0
;    sprite1_move1: db 0
;    sprite1_move:  db 0
;
; Where _spritedata is the actual sprite pixels as follows:
;   list of data: mask, color, mask, color... (for masked sprites)
;   list of color bytes (for non masked sprites)
; There is a tool called Sprot that allows to generate masked sprites for z88dk.

read 'cpcrslib/tilemap/constants.asm'

; CPC_ADDDIRTYTILE
; Checks if the given tile X and Y position is already in the dirty table.
; If not, it adds the tile position to the list.
; Inputs:
;     DE  Tile X and Y position.
; Outputs:
;	  None
;     AF and HL are modified.
cpc_AddDirtyTile::
	ld      hl,tiles_dirty
__updatedirty_lastloop:
	ld      a,(hl)
	cp      &FF
	jr      z,__updatedirty_add
	cp      e
	jr      z,__updatedirty_checkbyte2
	inc     hl
	inc     hl
	jr      __updatedirty_lastloop
__updatedirty_checkbyte2:
	inc     hl
	ld      a,(hl)
	cp      d
	ret     z	     ; Both bytes are equal so we don't need to add this tile
	inc     hl
	jr      __updatedirty_lastloop
__updatedirty_add:
	ld      (hl),e
	inc     hl
	ld      (hl),d
	inc     hl
	ld      (hl),&FF ; End of data
	ret
