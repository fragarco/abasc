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

label MAIN
	call rsUseFontNanako()
	call rsDisableFirmware() ' Now, I don't gonna use any firmware routine so I modify interrupts jump to nothing
	call rsClrScr()			 ' Fills scr with ink 0
	call rsSetMode(1)		 ' Hardware call to set mode 1

    call rsSetColour(0, 20)  ' Set background = black
    call rsSetColour(16, 20) ' Set border = black

	' Parameters: pen, text, adress
	call rsPrintGphStrStd(1, "THIS IS A SMALL DEMO", &C050)	
	call rsPrintGphStrStd(2, "OF MODE 1 TEXT WITH", &C0A0)
	call rsPrintGphStrStd(3, "8x8 CHARS WITHOUT FIRMWARE", &C0F0)
	call rsPrintGphStrStdXY(3, "AND A SMALL SOFT SCROLL DEMO", 8, 70)
	call rsPrintGphStrStdXY(2, "CPCRSLIB (C) 2015", 19, 80)
	call rsPrintGphStrStdXY(1, "-- FONT BY ANJUEL  2009  --", 2, 160)
	call rsPrintGphStrStdXY(1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 2, 174)

    z = 0
	while rsAnyKeyPressed() = 0 ' Small scrolling effect
	   	z = z = 0
	   	if z then
	      	call rsRRI(&E000, 40, 79)
	      	call rsRRI(&E4B0, 32, 79)
	   	end if
	   	call rsRLI(&E5F0 + &50 + &50 + 79, 12, 79)
	wend

	while rsAnyKeyPressed() = 0: wend
	call rsEnableFirmware()	' Before exit, firmware jump is restored
	call 0
end


