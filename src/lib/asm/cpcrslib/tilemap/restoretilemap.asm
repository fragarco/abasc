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

; CPC_RESTORETILEMAP
; Goes through all the dirty (touched) tiles and restores the double buffer
; background tile in that position, according to what is stored in the tiles_bgmap.
; Inputs:
;     None
; Outputs:
;	  None
;     AF, HL, DE, BC and IX are modified.
cpc_RestoreTileMap:
	ld      ix,tiles_dirty
__updatescr_loop:
	ld      e,(ix+0)
	ld      a,&FF
	cp      e
	ret     z		; end of tiles_dirty array
	ld      d,(ix+1)
	inc     ix
	inc     ix      ; next item in tiles_dirty											;3
__updatescr_finddbpos:
	; Lets find the tile position in the double buffer
	ld      c,d
	sla     c       ; Y x 2
	ld      b,0
	push    bc
	ld      hl,tiles_doblebuffer_lines
	add     hl,bc
	ld      c,(hl)
	inc     hl
	ld      b,(hl)  ; BC has the line address in the double buffer
	ld      l,e
	sla     l       ; X x 2
	ld      h,0
	add     hl,bc   ; HL has the position in the double buffer 
	pop     bc
	push    hl
__updatescr_findtile:
	ld      hl,tiles_bgmap_lines
	add     hl,bc   ; offset in the bgmap lines lookup table
	ld      c,(hl)
	inc     hl
	ld      b,(hl)  ; BC points to the bgmap line start
	ld      l,e
	ld      h,0
	add     hl,bc   ; X offset
	ld      l,(hl)  ; tile number
	ld      h,0
	add     hl,hl   ; calculate offset in the tiles array
	add     hl,hl
	add     hl,hl
	add     hl,hl  ; x16
	ld      de,tiles_tilearray
	add     hl,de  ; hl points now to the tile's bytes
	pop     de     ; position in the double buffer
__updatescr_drawindb:
	ldi
	ldi
	ex      de,hl
	ld      bc,T_WSIZE_BYTES - 2
	ld      a,c
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	ex      de,hl
	ld      c,a
	add     hl,bc
	ex      de,hl
	ldi
	ldi
	jp __updatescr_loop	