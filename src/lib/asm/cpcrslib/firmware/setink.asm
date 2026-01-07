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

; CPC PALETTE (taken from https://www.cpcwiki.eu/index.php/CPC_Palette)
; FW	HW		Color
; 0 	&54 	Black
; 1 	&44 	Blue
; 2 	&55 	Bright Blue
; 3 	&5C 	Red
; 4 	&58 	Magenta
; 5 	&5D 	Mauve
; 6 	&4C 	Bright Red
; 7 	&45 	Purple
; 8 	&4D 	Bright Magenta
; 9 	&56 	Green
; 10 	&46 	Cyan
; 11 	&57 	Sky Blue
; 12 	&5E 	Yellow
; 13 	&40 	White
; 14 	&5F 	Pastel Blue
; 15 	&4E 	Orange
; 16 	&47 	Pink
; 17 	&4F 	Pastel Magenta
; 18 	&52 	Bright Green
; 19 	&42 	Sea Green
; 20 	&53 	Bright Cyan
; 21 	&5A 	Lime
; 22 	&59 	Pastel Green
; 23 	&5B 	Pastel Cyan
; 24 	&4A 	Bright Yellow
; 25 	&43 	Pastel Yellow
; 26 	&4B 	Bright White

; CPC_SETINKFW
; Sets the color of a PEN using the Firmware values.
; Inputs:
;     A  PEN number (0-15)
;     B  First  firmware color
;     C  Second firmware color
; Outputs:
;	  None
;     AF, HL, DE and BC are modified.
cpc_SetInkFW:
	jp      &BC32 ; SCR SET INK