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

; CPC_RRI
; Rotates the given number of lines to the left. The lines that go out of the
; screen are appended on the RIGHT.
; Inputs:
;     HL video memory address (position)
;     DE height (D) and width (E)
; Outputs:
;	  None
;     AF, HL, DE and BC are modified.
cpc_RRI:
	ld      a,d
	ld      (__width_cpcrri+1),a ; self modifying code
	inc     hl
__height_cpcrri:
	ld      a,e
__cpcrri_loop:
	push    af
	push    hl
	dec     hl
	ld      a,(hl)
	ld      d,h
	ld      e,l
	inc     hl
	ld      b,0
__width_cpcrri:
	ld      c,50 ; self modifying code
	ldir
	dec     hl
	ld      (hl),a
	pop     hl
	pop     af
	dec 	a
	ret     z
	ld      bc,&800	; next character line
	add     hl,bc
	jr      nc,__cpcrri_loop ; next line
	ld      bc,&C050
	add     hl,bc
	jr      __cpcrri_loop
