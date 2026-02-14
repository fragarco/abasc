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
   	const MaxX = 60
   	const MaxY = 110
   	const MinX = 0
   	const MinY = 5
	const GravityAccel = 2

	call rsClrScr()
	' Text writting using firmware:
	print "SFX & MUSIC DEMO. CPCRSLIB 2012"
	print "PSG PROPLAYER BY WYZ 2010"
	print "Press keys 1 to 4 to play SFX"
	print "Up & Down to change song"
	print "ESC to Quit"

	call rsDisableFirmware()
	' Assign keys to key number (not numberpad keys)
	call rsAssignKey(0, RSKEY.1)
	call rsAssignKey(1, RSKEY.2)
	call rsAssignKey(2, RSKEY.3)
	call rsAssignKey(3, RSKEY.4)
	call rsAssignKey(4, RSKEY.ESC)
	call rsAssignKey(5, RSKEY.UP)
	call rsAssignKey(6, RSKEY.DOWN)

	' Initialize player data
	' Lets retrieve the addresses for the estuctures defined in songs.asm
	' which is imported and the end of this file with the command ASM
	sounds  = @LABEL("_SOUND_TABLE_0")
	rules   = @LABEL("_RULE_TABLE_0")
	effects = @LABEL("_EFFECT_TABLE")
	songs   = @LABEL("_SONG_TABLE_0")
	call rsWyzInitPlayer(songs, effects, rules, sounds)
	call rsWyzLoadSong(0)	' Select song to play (uncompress it and the start to play)
	call rsWyzSetPlayerOn() ' Start music and sound effects (SFX)
	
	tema = 0
	nuevotema = 1
  	cx = 28
   	cy = 20
	ox = cx
	oy = cy
	VertSpd = 1
	HorzSpd = 1
	pelota  = @LABEL("_pelota")' Retrieve address to the sprite defined in sprites.asm
	const SP.W = 3
	const SP.H = 11

	call rsScanKeyboard()	  ' Reads whole keyboard. It's requiered in order to use rsTestKey
	while rsTestKey(4) = 0	  ' rsTestKey is faster when more than 3 keys are gonna be tested
		call rsWaitVSync()
		
		if cx >= MaxX then HorzSpd = -HorzSpd: cx = MaxX
		if cx <= MinX then HorzSpd = -HorzSpd: cx = MinX
		if cy >= MaxY then VertSpd = -VertSpd: cy = MaxY
		if cy <= MinY then VertSpd = -VertSpd: cy = MinY

		VertSpd = VertSpd + GravityAccel - 1
		call rsPutSpXOR(pelota, SP.W, SP.H, rsGetScrAddress(cx,cy))
		call rsPutSpXOR(pelota, SP.W, SP.H, rsGetScrAddress(ox,oy))
		ox = cx
		oy = cy
		cx = cx + HorzSpd
		cy = cy + VertSpd

		call rsScanKeyboard()
		' Test if bit 3 is 0 in order to allow another effect.
		if (rsWyzTestPlayer() and 8) = 0 then
			' When a  1-4 key is pressed, a SFX is played
			if rsTestKey(0) then call rsWyzStartEffect(RSCH.A,0)	' Channel, SFX #
			if rsTestKey(1) then call rsWyzStartEffect(RSCH.B,1)
			if rsTestKey(2) then call rsWyzStartEffect(RSCH.A,2)
			if rsTestKey(3) then call rsWyzStartEffect(RSCH.B,3)
			if rsTestKey(5) then 
				if tema > 0 then tema = tema - 1: nuevotema = 1
			end if
			if rsTestKey(6) then
				if tema < 4 then tema = tema + 1: nuevotema = 1
			end if
			if nuevotema = 1 then
				call rsWyzSetPlayerOff()
				call rsPrintGphStrXYM1("AHORA;SONANDO:", 2, 130)
				select case tema
					case 0
						sounds = @LABEL("_SOUND_TABLE_0")
						rules  = @LABEL("_RULE_TABLE_0")
						songs  = @LABEL("_SONG_TABLE_0")
						call rsPrintGphStrXYM1x2(";;;;;;;;;;;;;;;", 2, 140)
						call rsPrintGphStrXYM1x2("RED;ALERT", 2, 140)
					case 1
						sounds = @LABEL("_SOUND_TABLE_1")
						rules  = @LABEL("_RULE_TABLE_1")
						songs  = @LABEL("_SONG_TABLE_1")
						call rsPrintGphStrXYM1x2(";;;;;;;;;;;;;;;", 2, 140)
						call rsPrintGphStrXYM1x2("CANCION;NUEVA", 2, 140)
					case 2
						sounds = @LABEL("_SOUND_TABLE_2")
						rules  = @LABEL("_RULE_TABLE_2")
						songs  = @LABEL("_SONG_TABLE_2")
						call rsPrintGphStrXYM1x2(";;;;;;;;;;;;;;;", 2, 140)
						call rsPrintGphStrXYM1x2("GOTHIC", 2, 140)
					case 3
						sounds = @LABEL("_SOUND_TABLE_3")
						rules  = @LABEL("_RULE_TABLE_3")
						songs  = @LABEL("_SONG_TABLE_3")
						call rsPrintGphStrXYM1x2(";;;;;;;;;;;;;;;", 2, 140)
						call rsPrintGphStrXYM1x2("MARYJANE", 2, 140)
					case 4
						sounds = @LABEL("_SOUND_TABLE_4")
						rules  = @LABEL("_RULE_TABLE_4")
						songs  = @LABEL("_SONG_TABLE_4")
						call rsPrintGphStrXYM1x2(";;;;;;;;;;;;;;;", 2, 140)
						call rsPrintGphStrXYM1x2("MIDNIGHT;XPRES", 2, 140)
				end select
				call rsWyzInitPlayer(songs, effects, rules, sounds)
				call rsWyzLoadSong(0)
				call rsWyzSetPlayerOn()
		
				nuevotema = 0
				VertSpd = 1: HorzSpd = 1
				cx = 28: cy = 20
			end if
		end if
	wend

	call rsWyzSetPlayerOff() ' Stop music and SFX
	call rsEnableFirmware()
	call 0 ' machine restart
end

asm "read 'assets/songs.asm'"
asm "read 'assets/sprites.asm'"