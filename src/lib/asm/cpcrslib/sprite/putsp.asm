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

; CPC_PUTSP
; Draws a sprite passed in DE in the video memory pointed by HL.
; Inputs:
;     HL video memory address
;     DE address to the sprite definition
;     BC sprite width and height
; Outputs:
;	  None
;     AF, HL, DE, BC and IY are modified.
cpc_PutSp:
	ld      a,b
    ld      (__putsp_width+1),a ; self modifying code		
	sub     1
	cpl
	ld      (__putsp0_add_newline+1),a ; self modifying code
	; continues in cpc_PutSp0

; PRIVATE ROUTINE
; Draws the sprint
cpc_PutSp0:
	db      &FD ; IY extended opcode
	ld      h,c	;
	ld      b,7
__putsp_width:
__putsp0_height_loop:
	ld      c,4 ; self modifying code
__putsp0_width_loop:
	ld      a,(de)
	ld      (hl),a
	inc     de
	inc     hl
	dec     c
	jr      nz,__putsp0_width_loop
	db      &FD ; IY extended opcode
	dec     h   ; 
	ret     z
__putsp0_add_newline:
	ld      c,&FF ; self modifying code
	add     hl,bc
	jr      nc,__putsp0_height_loop ; next line if no CF
	ld      bc,&C050
	add     hl,bc
	ld      b,7
	jr      __putsp0_height_loop

; CPC_PUTSPXY
; Draws a sprite in the video memory position set by HL.
; Inputs:
;     L  X coord
;     H  Y coord
;     DE address to the sprite
;     BC sprite width and height
; Outputs:
;	  None
;     AF, HL, DE, BC and IY are modified.
cpc_PutSpXY:
	push    de
	push    bc
	call    cpc_GetScrAddress
	pop     bc
	pop     de
    jp      cpc_PutSp