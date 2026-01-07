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
;   sprite dimensions in bytes withd, height
;   list of data: mask, color, mask, color... (for masked sprites)
;   list of color bytes (for non masked sprites)
; There is a tool called Sprot that allows to generate masked sprites for z88dk.

read 'cpcrslib/tilemap/adddirtytile.asm'

; CPC_PUTSPTILEMAP
; Transfer current coordinates to old coordinates and marks the
; tiles occupied by the sprite as "dirty" (touched).
; Inputs:
;     HL  address to the sprite structure.
; Outputs:
;	  None
;     AF, HL, DE, BC and IX are modified.
cpc_PutSpTileMap:
    ex      de,hl
    db      &DD       ; IX extended opcodes
    ld      l,e       ; IXL = E
    db      &DD       ; IX extended opcodes
    ld      h,d       ; IXH = D                                   ;2
    ld      l,(ix+0)  ; address to sprite width and height
    ld      h,(ix+1)
    ld      c,(hl)    ; width (but actual bytes is width*2)
    inc     hl
    ld      b,(hl)    ; height
    dec     b         ; so we start at 0
    dec     c         ; so we start at 0
    ld      l,(ix+10) ; old coordinates
    ld      h,(ix+11) ; stored in HL
    ld      e,(ix+8)  ; current coordinates
    ld      d,(ix+9)  ; stored in DE
    ld      (ix+10),e
    ld      (ix+11),d ; ox, oy = cx, cy
    push    hl
    srl     l         ; ox/2
    srl     h
    srl     h
    srl     h         ; oy/8
    ld      a,h
    ld      (__putsptiles_wloop+1),a ; self modifying code
    ex      de,hl
    pop     hl
    add     hl,bc     ; calculate sprite's final x,y
    srl     l         ; (ox + width)/2
    srl     h
    srl     h
    srl     h         ; (oy + height)/2
    xor     a
    sbc     hl,de     ; length
    ld      a,h
    inc     a
    ld      (__putsptiles_hsteps+1),a ; self modifying code
    inc     l
 	ld      b,l
__putsptiles_wloop:
	ld      d,&00
__putsptiles_hsteps:
    ld      c,0
__putsptiles_hloop:
    ; DE has the tile's X and Y position
    call    cpc_AddDirtyTile
    inc     d
    dec     c
    jr      nz,__putsptiles_hloop
    inc     e
    dec     b
    jr      nz,__putsptiles_wloop
    ret
