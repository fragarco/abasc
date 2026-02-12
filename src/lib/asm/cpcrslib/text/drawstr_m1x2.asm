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

read 'asm/cpcrslib/text/drawstr_m1.asm'

; CPC_DRAWSTR_M1X2
; Prints an ABASC type string (len in the first byte) using a custom
; font and direct hardware access in the video memory indicated (MODE 1).
; The size of the letters are double of the regular one.
; The text is drawn using 4 colours as described in cpc_SetTextColors_M1
; Inputs:
;     HL video memory address
;     DE address to the ABASC type string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStr_M1X2:
    ld      a,1   ; double size
	jp      cpc_DrawStr_M1


; CPC_DRAWSTRXY_M1
; Prints an ABASC type string using a custom font and direct
; hardware access in the X and Y position (ONLY MODE 1).
; The size of each letter is double the regular one.
; Inputs:
;     L  X coord.
;     H  Y coord.
;     DE address to the ABASC type string 
; Outputs:
;	  None
;     AF, HL, DE, BC, IX and IY are modified.
cpc_DrawStrXY_M1X2:
    push    de
    ld      a,1   ; double size
	call    cpc_GetScrAddress
	pop     de
	jp      cpc_DrawStr_M1