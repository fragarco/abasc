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

; cpc_DrawMaskSpTileMap assumes that HL points to a structure that defines
; a sprite as follows:
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
;   sprite dimensions in bytes width, height
;   list of data: mask, sprite, mask, sprite...
; There is a tool called Sprot that allows to generate masked sprites for z88dk.

; CPC_DRAWMASKSPTILEMAP
; The sprite content is written in the double buffer using its mask information.
; This routine expects that HL points to a structure like the one present just
; above. The sprite information will be drawn in the current X,Y coordenates.
; This routine doesn't mark the occupied tiles as "dirty" (touched). That
; must be done calling the routine cpc_PutSpTileMap.
; Inputs:
;     HL  address to the sprite structure.
; Outputs:
;	  None
;     AF, HL, DE, BC and IX are modified.
cpc_DrawMaskSpTileMap:
	ex      de,hl
	db      &DD        ; IX extended opcodes 
	ld      l,e        ; IXL = E
	db      &DD
	ld      h,d        ; IXH = D
    ld      a,(ix+8)   ; current X
    ld      e,(ix+9)   ; current Y
    ld	    hl,T_WSIZE_BYTES * 256
    ld      d,l
    ld      b,8
__putmasksp_multloop:
	add     hl,hl
	jr      nc,__putmasksp_next
    add     hl,de
__putmasksp_next:
	djnz    __putmasksp_multloop
	ld      e,a
	add     hl,de
	ld      de,T_DOUBLEBUFFER_ADDR
	add     hl,de      ; HL points to the position in the doublebuffer 
	ld      (ix+4),l   ; store that in coord0 structure member
    ld      (ix+5),h
	ld      e,(ix+0)
    ld      d,(ix+1)   ; DE points to the sprite data
    ld      a,(de)     ; A = width
    ld      (__putmasksp_hloop+2),a ; self modifying code
    ld      b,a
    ld      a,T_WSIZE_BYTES
    sub     b
    ld      c,a
	inc     de
	ld      a,(de)
	inc     de
__putmasksp_maskv:    ; mark for self modifying code
	ld      b,0
	db      &DD       ; IX extended opcodes
	ld      h,a		  ; IXH = A
__putmasksp_hloop:
	db      &DD       ; IX extended opcodes
	ld      l,4		  ; IXL = 4  but is self modifying code
	ex      de,hl
__putmasksp_wloop:
	ld      a,(de)	  ; background byte
	and     (hl)	  ; apply mask
	inc     hl
	or      (hl)	  ; add sprite byte
	ld      (de),a	  ; write the result
	inc     de
	inc     hl
	db      &DD       ; IX extended opcodes
	dec     l		  ; dec IXL
	jr      nz,__putmasksp_wloop
   	db      &DD       ; IX extended opcodes
   	dec     h         ; dec IXH
   	ret     z
   	ex      de,hl
	add     hl,bc
	jp      __putmasksp_hloop
