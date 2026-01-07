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
; Captures a rectangle from the video memory and stores it in the
; memory address pointed by DE.
; Inputs:
;     HL video memory address
;     DE address to the storage memory
;     BC width and height of the area to capture
; Outputs:
;	  None
;     AF, HL, DE, BC and IY are modified.
cpc_GetSp:
	ld      a,b
	ld      (__getsp0_height+1),a   ; self modifying code
	sub     1
	cpl
	ld      (__getsp0_linejump+1),a ; self modifying code
	; continues in cpc_GetSp0

; PRIVATE ROUTINE
;
cpc_GetSp0:
	db      &FD ; extended IY opcode
	ld      h,c	;
	ld      b,7
__getsp0_height:
	ld      c,0 ; self modifying code
__getsp0_width_loop:
	ld      a,(hl)
	ld      (de),a
	inc     de
	inc     hl
	dec     c
	jr      nz,__getsp0_width_loop
	db      &FD ; IY extended opcode
	dec     h
	ret     z
__getsp0_linejump:
	ld      c,&FF ; self modifying code
	add     hl,bc
	jr      nc,__getsp0_height ; next line if not CF
	ld      bc,&C050
	add     hl,bc
	ld      b,7
	jr      __getsp0_height

; CPC_GETSPXY
; Captures a video memory area defined by X and Y
; and stores it in the memory address pointed by DE.
; Inputs:
;     L  X coord
;     H  Y coord
;     DE address to the storage memory
;     BC width and height of the area to capture
; Outputs:
;	  None
;     AF, HL, DE, BC and IY are modified.
cpc_GetSpXY:
	push    de
	push    bc
	call    cpc_GetScrAddress
	pop     bc
	pop     de
    jp      cpc_GetSp