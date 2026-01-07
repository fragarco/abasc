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

read 'cpcrslib/tilemap/constants.asm'

; CPC_GETDPUBLEBUFFERADDRESS
; Given a X and Y position, returns in HL the address in the Tilemap
; double buffer.
; Inputs:
;     H  X position
;     L  Y position
; Outputs:
;	  HL Address in the tilemap double buffer.
;     AF, HL, DE and B are modified.
cpc_GetDoubleBufferAddress:
	ld      a,h
    ld      e,l
    ld	    hl,T_WSIZE_BYTES * 256
    ld      d,l
	ld		b,8
__getdouble_loop:
	add     hl,hl
    jr      nc,__getdouble_next
    add     hl,de
__getdouble_next:
	djnz    __getdouble_loop
	ld      e,a
	add     hl,de
	ld      de,T_DOUBLEBUFFER_ADDR
	add     hl,de
    ret

