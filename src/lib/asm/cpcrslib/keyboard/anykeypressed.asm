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

read 'cpcrslib/keyboard/testkeyboard.asm'

; CPC_ANYKEYPRESSED
; Checks if any key in the keyboard is pressed. If so, it returns -1 (True)
; in HL, otherwise it returns 0.
; Inputs:
;     None
; Outputs:
;	  HL -1 (True) if at least one key is pressed, 0 otherwise (False).
;     AF, HL and BC are modified.
cpc_AnyKeyPressed:
    call    _rslib_delay
    call    _rslib_delay
    call    _rslib_delay
	ld      a,&40    	; first matrix line
__anykey_loop:
	push    af
	call    cpc_TestKeyboard
	or      a
	jr      nz,__anykey_pressed
	pop     af
	inc     a			; increase matrix line
	cp      &4A			; to test range &40 .. &49
	jr      nz,__anykey_loop
	ld      hl,0
	ret
__anykey_pressed:
	pop     af
	ld      hl,&FFFF
	ret

; PRIVATE ROUTINE
; Implements a delay
_rslib_delay:
    ld      a,254
__rslib_delay_loop:
	push    af
	nop         ; avoid text pattern optimizations
	pop     af
	dec     a
	jr      nz, __rslib_delay_loop
	ret
