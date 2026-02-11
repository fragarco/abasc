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
	mode 1
	' Lets remove all default assignments and
	' assign ESC key to exit
	call rsDeleteKeys()
	call rsAssignKey(4, RSKEY.ESC)
	
	print "Welcome to cpcrslib keyboard utilities."
	print "Press a Key to redefine as #1"
	' redefine key. There are 12 available keys (0..11)
	call  rsRedefineKey(0)		
	print "Done!"


	print "Now, press any key to continue"
	while rsAnyKeyPressed() = 0: wend

	print "Well done! Let's do it again"

	print "Press any key to continue"
	while rsAnyKeyPressed() = 0: wend

	print "Press a Key to redefine as #3"
	call rsRedefineKey(3)		'redefine key. There are 12 available keys (0..11)
	print "Done!"
    call rsPause(200)

	mode 1
	border 3
	print "Now let's test the selected keys. Press ESC to EXIT"
	
	print "Press a Key to test it.."
	while rsTestKey(4) = 0
		' Test if the key has been pressed.
		if rsTestKey(0) <> 0 then print "OK Key #1"
		' Test if the key has been pressed.
		if rsTestKey(3) <> 0 then print "OK Key #2"
	wend
	call 0
end
