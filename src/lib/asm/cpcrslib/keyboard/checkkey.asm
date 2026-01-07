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

read 'cpcrslib/keyboard/vars.asm'

; CPC_CHECKKEY
; Return -1 (True) if the given key in the assignment table
; is pressed, otherwise it returns 0 (False). This routine uses
; the matrix state captured by cpc_ScanKeyboard, and as a result,
; this last routine must be called before any call to cpc_CheckKey.
; Inputs:
;     L index of the key assignment table
; Outputs:
;	  HL  -1 (True) if the key is pressed, otherwise 0.
;     AF, HL, DE and BC are modified.
cpc_CheckKey:
	sla     l
	inc 	l
	ld 		h,0
	ld 		de,_cpcrslib_keys_table
	add 	hl,de
	ld 		a,(hl)  ; assignment line 
	sub 	&40		; from 40-49 to 0-9
	ex 		de,hl	; DE stores the key assignment data
	ld		hl,_cpcrslib_keymap	; current keyboard matrix status
	ld 		c,a
	ld 		b,0
	add 	hl,bc
	ld 		a,(hl)	; current status for the desired line
	ex 		de,hl
	dec 	hl		; byte info in the assigment table
	and 	(hl) 	; let's check if the byte information
	cp 		(hl)	; matches
	ld 		hl,0
	ret 	z
	dec 	hl
	ret