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

read 'cpcrslib/video/getscraddress.asm'

; CPC_DRAWSTR_M0
; Prints a null-terminated string using a custom font and direct
; hardware access in the video memory indicated (ONLY MODE 0).
; Requires a designed custom font like the example provided in
; font_color.asm
; The text is drawn using 4 colours as described in cpc_SetTextColors_M0
; Inputs:
;     HL video memory address
;     DE address to the null-terminated string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStr_M0:
	ld      (_rslib_drawm0_dest),hl
	ex      de,hl
__drawstr_m0loop:
	ld      a,(cpc_colorfont_first)
	ld      b,a
	ld      a,(hl)
	or      a
	ret     z
	sub     b	   ; lets substract first available letter
	ld      bc,cpc_colorchars
	push    hl
	ld      l,a    ; current letter
	ld      h,0
	add     hl,hl
	add     hl,hl
	add     hl,hl  ; each letter is 8 bytes
	add     hl,bc  ; HL ends pointing to the start of our letter
	call    _rslib_decodech_m0
	ld      hl,(_rslib_drawm0_dest)
	ld      a,8
	ld      de,_colorfont_chm0_decoded
	call    cpc_DrawChar_M0
	ld      hl,(_rslib_drawm0_dest)
	inc     hl
	inc     hl
	ld      (_rslib_drawm0_dest),hl
	pop     hl
	inc     hl
	Jr      __drawstr_m0loop

; CPC_DRAWSTRXY_M0
; Prints a null-terminated string using a custom font and direct
; hardware access in the X and Y position (ONLY MODE 0).
; Requires a designed custom font like the example provided in
; font_color.asm
; Inputs:
;     L  X coord.
;     H  Y coord.
;     DE address to the null-terminated string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStrXY_M0:
	push    de
	call    cpc_GetScrAddress
	pop     de
	jp      cpc_DrawStr_M0

TXT0_PEN0  equ &00
TXT0_PEN1  equ &80
TXT0_PEN2  equ &08
TXT0_PEN3  equ &88
TXT0_PEN4  equ &20
TXT0_PEN5  equ &A0
TXT0_PEN6  equ &28
TXT0_PEN7  equ &A8
TXT0_PEN8  equ &02
TXT0_PEN9  equ &82
TXT0_PEN10 equ &0A
TXT0_PEN11 equ &8A
TXT0_PEN12 equ &22
TXT0_PEN13 equ &A2
TXT0_PEN14 equ &2A
TXT0_PEN15 equ &AA

; CPC_SETTEXTCOLORS_M0
; Replaces the four bytes with color codes used by 
; cpc_DrawStr_M0 and cpc_DrawStrXY_M0 routines.
; The values are coded in a special maner:
; &00 = 0, &80 = 1, &08 = 2, &88 = 3...
; TXT0_PENXX can be used instead of the raw values.
; The four values are used as follows:
;    byte 0 is the background color.
;    byte 1 is color for the character top area.
;    byte 2 is color for the character middle area.
;    byte 3 is color for the character bottom area.
; Inputs:
;     HL address with the new four bytes
; Outputs:
;	  None
;     HL, BC and DE are modified.
cpc_SetTextColors_M0:
	ld      de,_rslib_drawm0_colors
	ld      bc,4
	ldir
	ret

; PRIVATE ROUTINE
; Draws a char, DE points to the memory with the decoded char
; A is the character height, HL is de video memory destination.
cpc_DrawChar_M0:
	ld      b,7
	ld      c,b
__drawchm0_loop:
	ex      de,hl
	ldi
	ldi
	dec     a
	ret     z
	ex      de,hl
	ld      c,&FE	; line jump
	add     hl,bc
	jr      nc,__drawchm0_loop
	ld      bc,&C050
	add     hl,bc
	ld      b,7
	jr      __drawchm0_loop

; PRIVATE ROUTINE
; Gets the font char representation and decodes it
; to create the letter sprite.
; Code by Kevin Thacker.
_rslib_decodech_m0:		
	push    de
	ld      iy,_colorfont_chm0_decoded
	ld      b,8
__decodech0_loop:
	push    bc
	push    hl
	ld      e,(hl)
	call    apply_draw0_colors
	ld      (iy+0),d
	inc     iy
	call    apply_draw0_colors
	ld      (iy+0),d
	inc     iy
	pop     hl
	inc     hl
	pop     bc
	djnz    __decodech0_loop
	pop     de
	ret

; PRIVATE ROUTINE
; Code char color for mode 0 screen
apply_draw0_colors:
	ld      d,0 ; initial byte at end will be result of 2 pixels combined
	call    apply_draw0_colors_pixel
	rlc     d
	call    apply_draw0_colors_pixel
	rrc     d
	ret

; PRIVATE ROUTINE
; Code char color for mode 0 screen.
; Shift out pixel into bits 0 and 1 (source)
; Returns one of the four colors in D
apply_draw0_colors_pixel:
	rlc     e
	rlc     e
	ld      a,e
	and     &03
	ld      hl,_rslib_drawm0_colors
	add     a,l
	ld      l,a
	ld      a,h
	adc     a,0
	ld      h,a
	ld      a,d
	or      (hl)
	ld      d,a
	ret

_rslib_drawm0_colors: 	db &00,&88,&80,&08
_rslib_drawm0_dest:   	dw 0
_colorfont_chm0_decoded:defs 16


	