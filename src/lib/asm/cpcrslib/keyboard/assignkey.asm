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

; CPC_ASSIGNKEY
; Writes in the key assigment table a new key (Line + Byte matrix values).
; The file vars.asm includes some already defined constants.
; Inputs:
;     B  Line value in the keyboard matrix for the desired key
;     C  Byte value in the keyboard matrix for the desired key
;     E  Entry in the key asignment table (&0-&F)
; Outputs:
;	  None
;     Flags, HL and DE are modified.
cpc_AssignKey:						
	ld      hl,_cpcrslib_keys_table
	sla     e
	ld      d,0
	add     hl,de 		; Position in the key assignment table
	ld      (hl),c 		; Byte value
	inc     hl			
	ld      (hl),b		; Line value
	ret
