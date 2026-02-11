' Original Copyright (c) 2008-2015 Raúl Simarro <artaburu@hotmail.com>
' Modified by Javier "Dwayne Hicks" Garcia for ABASC
'
' Permission is hereby granted, free of charge, to any person obtaining a copy of this
' software and associated documentation files (the "Software"), to deal in the Software
' without restriction, including without limitation the rights to use, copy, modify, merge,
' publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
' to whom the Software is furnished to do so, subject to the following conditions:
' The above copyright notice and this permission notice shall be included in all copies or
' substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
' INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
' PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
' FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
' OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.

chain merge "cpcrslib/cpcrslib.bas"

const SP.W = 3
const SP.H = 16

label MAIN
    sprite = @LABEL("_sprite")
    buffer = @LABEL("_buffer")

	mode 1
	
    call rsPrintGphStrXYM1("1;PUTS;A;SPRITE;IN;THE;SCREEN", 0, 8*23)
    call rsPrintGphStrXYM1("PRESS;ANY;KEY", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend
	
    call rsPutSp(sprite, SP.W, SP.H, &C19B)
	' Captura de la pantalla el area indicada y la guarda en memoria.
    call rsPrintGphStrXYM1("2;CAPTURES;A;SCREEN;AREA;;;;;", 0, 8*23)
    call rsPrintGphStrXYM1("PRESS;ANY;KEY", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend

	call rsGetSp(buffer, SP.W, SP.H, &C19C)
    call rsPrintGphStrXYM1("3;PRINTS;CAPTURED;AREA", 0, 8*23)
    call rsPrintGphStrXYM1("PRESS;ANY;KEY", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend

	' En este ejemplo, imprime en &c19f el area capturada .
	call rsPutSp(buffer, SP.W, SP.H, &C19F)
	' Imprime el Sprite en modo XOR en la coordenada (x,y)=(100,50)
    call rsPrintGphStrXYM1("4;PUTS;A SPRITE;IN;XOR;MODE", 0, 8*23)
    call rsPrintGphStrXYM1("PRESS;ANY;KEY", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend

    call rsPutSpXOR(sprite, SP.W, SP.H, rsGetScrAddress(100, 50))
    call rsPrintGphStrXYM1("5;SPRITE;PRINTED;AGAIN;IN;XOR;MODE", 0, 8*23)
    call rsPrintGphStrXYM1("PRESS;ANY;KEY", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend
    call rsPutSpXOR(sprite, SP.W, SP.H, rsGetScrAddress(100,50))

    call rsPrintGphStrXYM1(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;", 0, 8*23)
    call rsPrintGphStrXYM1("THE;END;;;;;;", 0, 8*24)
    while rsAnyKeyPressed() = 0: wend
    call 0
end

asm "read 'img/sprites.asm'"