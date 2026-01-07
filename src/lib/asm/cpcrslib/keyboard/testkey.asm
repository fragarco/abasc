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
read 'cpcrslib/keyboard/testkeyboard.asm'

; CPC_TESTKEY
; Checks if the key assigned to the given index in the key assignment table
; is pressed.
; Inputs:
;     L  Index in the key assignment table (0..15)
; Outputs:
;	  HL -1 (True) if the key is pressed, 0 otherwise
;     AF, BC, HL and DE are modified.
cpc_TestKey:
	sla     l
	inc     l
	ld      h,0
	ld      de,_cpcrslib_keys_table
	add     hl,de
	ld      a,(hl)  ; Line value in the assignment table
	call    cpc_TestKeyboard
	dec     hl	    ; point to byte value in the table
	and     (hl)	; A contains the value of scanning the keyboard
	cp      (hl)
	ld      hl,0    ; HL = 0 (False)
	ret     nz
	dec     hl      ; HL = -1 (True)
	ret
