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

; This constants allow users to set the border color without having to deal
; with the firmware number. They set the same color in B and C so they won't
; produce any flash.
FW_BLACK 	equ &0000 ; 0 	&54 	Black
FW_BLUE  	equ &0101 ; 1 	&44 	Blue
FW_BBLUE 	equ &0202 ; 2 	&55 	Bright Blue
FW_RED   	equ &0303 ; 3 	&5C 	Red
FW_MAGENTA 	equ &0404 ; 4 	&58 	Magenta
FW_MAUVE 	equ &0505 ; 5 	&5D 	Mauve
FW_BRED  	equ &0606 ; 6 	&4C 	Bright Red
FW_PURPLE  	equ &0707 ; 7 	&45 	Purple
FW_BMAGENTA equ &0808 ; 8 	&4D 	Bright Magenta
FW_GREEN 	equ &0909 ; 9 	&56 	Green
FW_CYAN  	equ &0A0A ; 10 	&46 	Cyan
FW_SBLUE 	equ &0B0B ; 11 	&57 	Sky Blue
FW_YELLOW  	equ &0C0C ; 12 	&5E 	Yellow
FW_WHITE 	equ &0D0D ; 13 	&40 	White
FW_PBLUE 	equ &0E0E ; 14 	&5F 	Pastel Blue
FW_ORANGE 	equ &0F0F ; 15	&4E 	Orange
FW_PINK  	equ &1010 ; 16	&47 	Pink
FW_PMAGENTA equ &1111 ; 17	&4F 	Pastel Magenta
FW_BGREEN 	equ &1212 ; 18 	&52 	Bright Green
FW_SGREEN 	equ &1313 ; 19 	&42 	Sea Green
FW_BCYAN 	equ &1414 ; 20 	&53 	Bright Cyan
FW_LIME  	equ &1515 ; 21 	&5A 	Lime
FW_PGREEN 	equ &1616 ; 22 	&59 	Pastel Green
FW_PCYAN 	equ &1717 ; 23 	&5B 	Pastel Cyan
FW_BYELLOW 	equ &1818 ; 24 	&4A 	Bright Yellow
FW_PYELLOW 	equ &1919 ; 25 	&43 	Pastel Yellow
FW_BWHITE 	equ &1A1A ; 26 	&4B 	Bright White

; CPC_SETINKFW
; Sets the color of the border using the Firmware.
; Inputs:
;     B First firmware color
;     C Second firmware color
; Outputs:
;	  None
;     AF, HL, DE and BC are modified.
cpc_SetBorderFW:
	jp      &BC38 ; SCR_SET_BORDER