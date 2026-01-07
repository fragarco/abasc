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

; CPC_SCROLLRIGHT00
; Increments by one the start address for the 20 entries stored in the
; lookup table tiles_videomemory_lines. It also decreases by one the first
; double buffer column to show in the cpc_ShowTileMap routine. Both things,
; will shift the tilemap rendered image to the RIGHT. the column (2 bytes)
; that goes away on the right is added to the left.
; Inputs:
;     None
; Outputs:
;	  None
;     Flags, HL B are modified.
cpc_ScrollRight00:
	ld      hl,tiles_videomemory_lines
	ld      b,20
__scrollr00_addloop:
	inc     (hl)
	inc     hl
	inc     hl
	djnz    __scrollr00_addloop
	ld      hl,(__showt2_doublubuffer_ini+1) ; self modifying code
	dec     hl
	ld      (__showt2_doublubuffer_ini+1),hl
	ret
