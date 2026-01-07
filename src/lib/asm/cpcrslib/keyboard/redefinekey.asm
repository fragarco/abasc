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
read 'cpcrslib/keyboard/vars.asm'

; CPC_REDEFINEKEY
; Waits until a valid key (a key that is not already in the assignment table)
; is pressed and stores it in the given table index (0..15)
; Inputs:
;      L  Key assignment table index to redefine (0..15)
; Outputs:
;	  None (stores in the table entry the new line + byte values)
;     AF, HL, DE, BC and IX are modified.
cpc_RedefineKey:
	ld      de,_cpcrslib_keys_table
	sla     l		 ; each entry occupies 2 bytes
	ld      h,0
	add     hl,de 	
	ld      (hl),&FF ; erase current entry information
	inc     hl
	ld      (hl),&FF
	dec     hl
	push    hl
	call    _rslib_capture_key
	pop     hl
	ld      a,(_cpcrslib_keybyte)
	ld      (hl),a
	inc     hl
	ld      a,(_cpcrslib_keyline)
	ld      (hl),a
	ret

; PRIVATE ROUTINE
; Captures a keyboard key press looping through the 10 lines of the
; keyboard matrix.
; Leaves the first line and byte active in:
; _cpcrslib_keyline and _cpcrslib_keybyte
; Pressed key must no appear in the assigment table or it will be descarted.
_rslib_capture_key:
	ld      a,&40
__capturekey_loop:
	push    af
	ld      (_cpcrslib_keyline),a
	call    cpc_TestKeyboard
	or      a
	jr      nz,__capturekey_press
	pop     af
	inc     a
	cp      &4A   ; loop from &40 to &49
	jr      nz,__capturekey_loop
	; Repeat until a key is pressed
	jr      _rslib_capture_key
__capturekey_press:
	ld      (_cpcrslib_keybyte),a
	pop     af
	call    __rslib_find_keyassignment
	ret     nc
	jr		__capturekey_loop

; PRIVATE ROUTINE
; Checks if an entry in the key assignment table already exists
; Returns CF set if the entry (line  + byte) exists.
__rslib_find_keyassignment:
	ld      b,&F	; max number of entries
	ld      ix,_cpcrslib_keys_table
__checkassignment_loop:
	ld      a,(_cpcrslib_keybyte)
	cp      (ix)
	jr      z, __checkassignment_line
	inc     ix
	inc     ix
	djnz    __checkassignment_loop
	ccf
	ret
__checkassignment_line:
	ld      a,(_cpcrslib_keyline)
	cp      (ix+1)
	jr      z,__checkassigment_found
	inc     ix
	inc     ix
	djnz    __checkassignment_loop
	ccf
	ret
__checkassigment_found:
	scf
	ret
