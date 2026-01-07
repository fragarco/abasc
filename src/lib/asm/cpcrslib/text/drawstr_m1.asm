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

; CPC_DRAWSTR_M1
; Prints a null-terminated string using a custom font and direct
; hardware access in the video memory indicated (ONLY MODE 1).
; Requires a designed custom font like the example provided in
; font_color.asm
; The text is drawn using 4 colours as described in cpc_SetTextColors_M0
; Inputs:
;     HL video memory address
;     DE address to the null-terminated string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStr_M1:
	ld      (_rslib_drawm1_dest),hl
	ex      de,hl
__drawstr_m1loop:
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
	call    _rslib_decodech_m1
	ld      hl,(_rslib_drawm1_dest)
	ld      de,_colorfont_chm1_decoded
	db      &FD	   ; Extended opcode IY
	ld      h,8    ; ld iyh,8
	call    cpc_DrawChar_M1
	ld      hl,(_rslib_drawm1_dest)
	inc     hl
	ld      (_rslib_drawm1_dest),hl
	pop     hl
	inc     hl
	jr      __drawstr_m1loop:

; CPC_DRAWSTRXY_M1
; Prints a null-terminated string using a custom font and direct
; hardware access in the X and Y position (ONLY MODE 1).
; Requires a designed custom font like the example provided in
; font_color.asm
; Inputs:
;     L  X coord.
;     H  Y coord.
;     DE address to the null-terminated string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStrXY_M1:
	push    de
	call    cpc_GetScrAddress
	pop     de
	jp      cpc_DrawStr_M1

TXT1_PEN0 equ &00
TXT1_PEN1 equ &80
TXT1_PEN2 equ &08
TXT1_PEN3 equ &88

; CPC_SETTEXTCOLOR_M1
; Replaces the four bytes with color codes used by 
; cpc_DrawStr_M1 and cpc_DrawStrXY_M1 routines.
; The values are coded in a special maner:
; &00 = 0, &80 = 1, &08 = 2, &88 = 3.
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
cpc_SetTextColors_M1:
	ld      de,_rslib_drawm1_colors
	ld      bc,4
	ldir
	ret

; PRIVATE ROUTINE
; Draws a char, DE points to the memory with the decoded char
; IYH is the height in lines, HL is de video memory destination.
cpc_DrawChar_M1:
	ld      b,7
	ld      c,b
__drawchm1_loop:
	ex      de,hl
	ldi
	db      &FD		; Extended opcode IY
	dec     h		; dec iyh
	ret     z
	ex      de,hl
	ld      c,&FF	; line jump
	add     hl,bc
	jr      nc,__drawchm1_loop
	ld      bc,&C050
	add     hl,bc
	ld      b,7
	jr      __drawchm1_loop

; PRIVATE ROUTINE
; Gets the font char representation and decodes it
; to create the letter sprite.
; Based on code created by Kevin Thacker.
_rslib_decodech_m1:
	ld      iy,_colorfont_chm1_decoded
	ld      b,8
	ld      ix,_rslib_drawm1_temp
__decodech_loop:
	push    bc
	push    hl
	ld      a,(hl)
	ld      hl,_rslib_drawm1_bytedata
	ld      (hl),a
	ld      (ix+0),0
	ld      b,4
__decodech_colorsloop:
	push    hl
	call    apply_drawm1_colors
	pop     hl
	srl     (hl)
	srl     (hl)
	djnz    __decodech_colorsloop
	ld      a,(ix+0)
	ld      (iy+0),a
	inc     iy
	pop     hl
	inc     hl
	pop     bc
	djnz    __decodech_loop:
	ret

; PRIVATE ROUTINE
; There are 4 possible colours coded in the first 2 bits.
apply_drawm1_colors:
	ld      a,3
	and     (hl)
	ld      hl,_rslib_drawm1_colors
	ld      e,a
	ld      d,0
	add     hl,de
	ld      c,(hl)
	ld      a,b
	dec     a
	or      a
	jr      z,__apply_no_rotate
__applym1_loop:
	srl     c
	dec     a
	jr      nz,__applym1_loop
__apply_no_rotate:
	ld      a,c
	or      (ix+0)
	ld      (ix+0),a
	ret

_rslib_drawm1_colors: 	db 	 &00,&88,&80,&08
_rslib_drawm1_dest: 	dw   0
_rslib_drawm1_bytedata: db 	 0b00011011
_rslib_drawm1_temp:		defs 3
_colorfont_chm1_decoded:defs 16