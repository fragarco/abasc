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

read 'asm/cpcrslib/text/drawstr_m0.asm'

; CPC_DRAWSTR_M0X2
; Prints an ABASC type string (len in the first byte) using a custom
; font and direct hardware access in the video memory indicated (MODE 0).
; The size of the letters are double of the regular one.
; The text is drawn using 4 colours as described in cpc_SetTextColors_M1
; Inputs:
;     HL video memory address
;     DE address to the ABASC type string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStr_M0X2:
    ld      a,1   ; double size
	jp      cpc_DrawStr_M0


; CPC_DRAWSTRXY_M0
; Prints an ABASC type string using a custom font and direct
; hardware access in the X and Y position (ONLY MODE 0).
; The size of each letter is double the regular one.
; Inputs:
;     L  X coord.
;     H  Y coord.
;     DE address to the ABASC type string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStrXY_M0X2:
    push    de
	call    cpc_GetScrAddress
	pop     de
	ld      a,1   ; double siz
	jp      cpc_DrawStr_M0