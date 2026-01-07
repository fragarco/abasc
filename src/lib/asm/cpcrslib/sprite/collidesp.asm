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

; cpc_CollideSp assumes that HL and DE points to a structure that
; defines a sprite as follows:
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
;   sprite dimensions in bytes withd, height
;   list of data: mask, color, mask, color... (for masked sprites)
;   list of color bytes (for non masked sprites)
; There is a tool called Sprot that allows to generate masked sprites for z88dk.

; CPC_COLLIDESP
; Checks if two sprites collide.
; Inputs:
;     HL address to the first sprite structure
;     DE address to the second sprite structure
; Outputs:
;	  HL  returns -1 (True) or 0 (False)
;     AF, HL, DE, BC and IY are modified.
cpc_CollideSp:
	push    hl
	pop     ix
	push    de
	pop     iy
	ld      l,(ix+0)
	ld      h,(ix+1)
	ld      b,(hl)	 
	inc     hl
	ld      c,(hl)
	ld      l,(iy+0)
	ld      h,(iy+1)
	ld      d,(hl)	 
	inc     hl		 ; BC = width, height sprite 1
	ld      e,(hl)	 ; DE = width, height sprite 2

	ld      a,(ix+8) ; current X sprite1
	sub     d		 ; minus width sprite2
	cp      (iy+8)	 ; (xsp1 - wsp2) < ysp2 ?
	jr      nc,__collide_false
	add     d
	add     b				
	dec     a
	cp      (iy+8)
	jr      c,__collide_false
	ld      a,(ix+9)  ; Lets check now Y axis
	sub     e
	cp      (iy+9)
	jr      nc,__collide_false
	add     e
	add     c
	dec     a
	cp      (iy+9)
	jr      c,__collide_false  
__collide_true:
	ld      hl,&FFFF
	ret
__collide_false:
	ld      hl,0
	ret
