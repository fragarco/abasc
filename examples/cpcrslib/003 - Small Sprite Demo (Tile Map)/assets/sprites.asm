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

; EXAMPLE 003 - Small Sprite Demo (Tile Map)

; Firmware palette
;_sp_palette:
;    db 0,13,1,6,26,24,15,8,10,22,14,3,18,4,11,25

; Sprite data structure:
;   two bytes with width and height.
;   list of data: mask, color, mask, color... (for masked sprites width = width *)
;   list of color bytes (for non masked sprites)
; There is a tool called Sprot that allows to generate masked sprites for z88dk.
; ask for it: www.amstrad.es/forum/
_sp_1:
    db 4,15	
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&45,&00,&3C,&00,&3C,&55,&8A
    db &00,&8A,&00,&55,&00,&AA,&00,&45
    db &00,&8A,&00,&20,&00,&00,&00,&65
    db &00,&28,&00,&55,&00,&AA,&00,&14
    db &00,&7D,&00,&BE,&00,&FF,&00,&BE
    db &AA,&14,&00,&FF,&00,&BE,&55,&28
    db &AA,&00,&00,&3C,&00,&79,&55,&00
    db &00,&51,&00,&51,&00,&A2,&55,&A2
    db &00,&F3,&00,&10,&00,&20,&00,&F3
    db &00,&F3,&00,&51,&00,&A2,&00,&F3
    db &55,&28,&00,&0F,&00,&0F,&AA,&14
    db &FF,&00,&55,&0A,&AA,&05,&FF,&00
    db &55,&02,&55,&28,&AA,&14,&AA,&01
    db &00,&03,&55,&02,&AA,&01,&00,&03

_sp_2:
    db 4,21
    db &FF,&00,&00,&CC,&00,&CC,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&E5,&00,&DA,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &00,&A9,&00,&03,&00,&03,&00,&56
    db &00,&A9,&00,&03,&00,&03,&00,&56
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &AA,&01,&00,&06,&00,&09,&55,&02
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
 