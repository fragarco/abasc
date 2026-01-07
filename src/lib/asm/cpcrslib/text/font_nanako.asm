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

; CPCRSLIB FONT
; This font is based on the one used by NANAKO CPC GAME
; programmed by ANJUEL and NA_TH_AN.
; Can be used with cpc_Print_M1 and cpc_PrintXY_M1 but
; NOT with cpc_DrawStr routines.

; First defined char number (ASCII)
cpc_charfont_first: db 32	

; Each byte defines a row of 8 bits.
; Very similar to what SYMBOL command does.
cpc_charfont:   
   db 0,0,0,0,0,0,0,0
   db 28,8,8,8,28,0,8,0
   db 10,10,0,0,0,0,0,0
   db 36,126,36,36,36,126,36,0
   db 16,62,32,60,4,124,8,0
   db 0,50,52,8,22,38,0,0
   db 0,16,40,58,68,58,0,0
   db 16,16,0,0,0,0,0,0
   db 16,112,80,64,80,112,16,0
   db 8,14,10,2,10,14,8,0
   db 0,42,28,28,42,0,0,0
   db 0,8,8,62,8,8,0,0
   db 0,0,0,0,12,12,0,0
   db 0,0,0,62,0,0,0,0
   db 0,0,0,0,12,12,16,0
   db 0,4,8,16,32,64,0,0
   db 62,34,34,34,34,34,62,0
   db 12,4,4,4,4,4,4,0
   db 62,34,2,62,32,34,62,0
   db 62,36,4,28,4,36,62,0
   db 32,32,36,62,4,4,14,0
   db 62,32,32,62,2,34,62,0
   db 62,32,32,62,34,34,62,0
   db 62,36,4,4,4,4,14,0
   db 62,34,34,62,34,34,62,0
   db 62,34,34,62,2,34,62,0
   db 0,24,24,0,0,24,24,0
   db 0,24,24,0,0,24,24,32
   db 4,8,16,32,16,8,4,0
   db 0,0,126,0,0,126,0,0
   db 32,16,8,4,8,16,32,0
   db 64,124,68,4,28,16,0,16
   db 0,56,84,92,64,60,0,0
   db 126,36,36,36,60,36,102,0
   db 124,36,36,62,34,34,126,0
   db 2,126,66,64,66,126,2,0
   db 126,34,34,34,34,34,126,0
   db 2,126,66,120,66,126,2,0
   db 2,126,34,48,32,32,112,0
   db 2,126,34,32,46,36,124,0
   db 102,36,36,60,36,36,102,0
   db 56,16,16,16,16,16,56,0
   db 28,8,8,8,8,40,56,0
   db 108,40,40,124,36,36,102,0
   db 112,32,32,32,34,126,2,0
   db 127,42,42,42,42,107,8,0
   db 126,36,36,36,36,36,102,0
   db 126,66,66,66,66,66,126,0
   db 126,34,34,126,32,32,112,0
   db 126,66,66,74,126,8,28,0
   db 126,34,34,126,36,36,114,0
   db 126,66,64,126,2,66,126,0
   db 34,62,42,8,8,8,28,0
   db 102,36,36,36,36,36,126,0
   db 102,36,36,36,36,24,0,0
   db 107,42,42,42,42,42,62,0
   db 102,36,36,24,36,36,102,0
   db 102,36,36,60,8,8,28,0
   db 126,66,4,8,16,34,126,0
   db 4,60,36,32,36,60,4,0
   db 0,64,32,16,8,4,0,0
   db 32,60,36,4,36,60,32,0
   db 0,16,40,68,0,0,0,0
   db 0,0,0,0,0,0,0,0
   db 0,100,104,16,44,76,0,0
   db 126,36,36,36,60,36,102,0
   db 124,36,36,62,34,34,126,0
   db 2,126,66,64,66,126,2,0
   db 126,34,34,34,34,34,126,0
   db 2,126,66,120,66,126,2,0
   db 2,126,34,48,32,32,112,0
   db 2,126,34,32,46,36,124,0
   db 102,36,36,60,36,36,102,0
   db 56,16,16,16,16,16,56,0
   db 28,8,8,8,8,40,56,0
   db 108,40,40,124,36,36,102,0
   db 112,32,32,32,34,126,2,0
   db 127,42,42,42,42,107,8,0
   db 126,36,36,36,36,36,102,0
   db 126,66,66,66,66,66,126,0
   db 126,34,34,126,32,32,112,0
   db 126,66,66,74,126,8,28,0
   db 126,34,34,126,36,36,114,0
   db 126,66,64,126,2,66,126,0
   db 34,62,42,8,8,8,28,0
   db 102,36,36,36,36,36,126,0
   db 102,36,36,36,36,24,0,0
   db 107,42,42,42,42,42,62,0
   db 102,36,36,24,36,36,102,0
   db 102,36,36,60,8,8,28,0
   db 126,66,4,8,16,34,126,0
   db 4,60,36,96,96,36,60,4
   db 0,16,16,16,16,16,16,0
   db 32,60,36,6,6,36,60,32
   db 0,0,16,40,68,0,0,0
   db 126,66,90,82,90,66,126,0