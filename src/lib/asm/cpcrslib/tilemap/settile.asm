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

read 'cpcrslib/tilemap/constants.asm'

; CPC_SETTILE
; Stores in the "tiles game screen" the index or "tile"
; that must be rendered in that X,Y position.
; Inputs:
;     H  X position
;     L  Y position
;     C  Tile number (index in the tiles_tilearray structure)
; Outputs:
;	  None
;     AF, HL, DE and B are modified.
cpc_SetTile:
	ld      a,h
    ld      e,l
    ld	    hl,T_WIDTH * 256 ; h = 40, l = 0
    ld      d,l              ; de = Y
	ld		b,8              ; a  = X
__settile_loop:
	add     hl,hl
    jr      nc,__settile_next
    add     hl,de
__settile_next:
	djnz    __settile_loop
	ld      e,a
	add     hl,de				  ; add X
	ld      de,tiles_bgmap
	add     hl,de
	ld      (hl),c
    ret
