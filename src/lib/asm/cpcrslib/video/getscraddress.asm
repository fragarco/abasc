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

; CPC_GETSCRADDRESS
; Returns in HL de video memory address for the X, Y coords
; given as input.
; Inputs:
;      L X coord
;      H Y coord
; Outputs:
;	  HL video memory address
;     AF, HL, DE and BC are modified.
cpc_GetScrAddress:
	ld      a,l
	ld      (__getaddress_addw+1),a ; self modifying code
	ld      a,h
	srl     a
	srl     a
	srl     a

	ld      d,a	
	sla     a
	sla     a
	sla     a
	sub     h
	neg

	ld      e,a
	ld      l,d
	ld      h,0
	add     hl,hl
	ld      bc,__getaddres_linelookup
	add     hl,bc
	ld      c,(hl)
	inc     hl
	ld      h,(hl)
	ld      l,c
	push    hl
	ld      d,0
	ld      hl,__getaddres_offsets
	add     hl,de
	ld      a,(hl)
	pop     hl
	add     h
	ld      h,a
__getaddress_addw:
	ld      e,0  ; self mofiying code
	add     hl,de
	ret

__getaddres_linelookup:
dw &C000,&C050,&C0A0,&C0F0,&C140,&C190,&C1E0,&C230,&C280,&C2D0,&C320,&C370,&C3C0
dw &C410,&C460,&C4B0,&C500,&C550,&C5A0,&C5F0,&C640,&C690,&C6E0,&C730,&C780

__getaddres_offsets: db &00,&08,&10,&18,&20,&28,&30,&38

