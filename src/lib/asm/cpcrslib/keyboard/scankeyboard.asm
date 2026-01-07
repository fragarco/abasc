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

; CPC_SCANKEYBOARD
; Reads all keyboard matrix lines and leaves the resulting bytes
; in the keymap table. This routine must be called before trying 
; to use cpc_CheckKey.
; Inputs:
;     None
; Outputs:
;	  None
;     AF, HL, DE and BC are modified.
cpc_ScanKeyboard:
    di
    ld      hl,_cpcrslib_keymap
    ld      bc,&F782
    out     (c),c
    ld      bc,&F40E
    ld      e,b
    out     (c),c
    ld      bc,&F6C0
    ld      d,b
    out     (c),c
    ld      c,0
    out     (c),c
    ld      bc,&F792
    out     (c),c
    ld      a,&40   ; First line
    ld      c,&4A   ; 49 is the last line
__scankeyboard_loop:
	ld      b,d
    out     (c),a   ; select line
    ld      b,e
    ini             ; read status byte and write it into the keymap
    inc     a
    cp      c
    jr      c,__scankeyboard_loop
    ld      bc,&F782
    out     (c),c
    ei
    ret
