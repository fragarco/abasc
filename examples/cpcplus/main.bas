' **************************************************
' *** MEGA CHASE (LOADER) - AMSTRAD CPC+ VERSION ***
' **************** BY SHAD0WFAX ********************
' Code adapted to ABASC by Javier "Dwayne Hicks" Garcia

CHAIN MERGE "cpcplus/cpcplus.bas"

CONST MUSIC  = &8980
CONST PLAYER = &9600
CONST NOMUSIC= &9603

' GAME STATE VARIABLES
game.playing = 0  ' Set if the music is already playing
game.menuopt = 0  ' Menu current selected option
game.start   = 0  ' Game must start (1)
game.seconds = 0
game.on  	 = 0  ' Tells if the game is running

player.xpos = 0
player.ypos = 0
player.xoff = 2
player.yoff = 1
player.shots= 9

enemy.img  	= 0
enemy.xpos  = 0
enemy.ypos  = 0
enemy.xoff 	= 2
enemy.yoff 	= 1
enemy.warps = 5
enemy.alive = 1
enemy.ticks = 0
enemy.mov   = 0

' Startup
MEMORY &897F: SYMBOL AFTER 97
BORDER 0: INK 0,0: INK 1,0
ENV 1,15,-1,2
ENT -1,4,50,2,4,-50,2

GOSUB game.INIT
GOSUB game.INTRO
LABEL game.MAIN
	WHILE game.start = 0
		GOSUB game.MENU
		IF game.menuopt = 1 THEN game.start = 1
		IF game.menuopt = 2 THEN game.start = 1
		IF game.menuopt = 3 THEN GOSUB game.INSTRUCTIONS
	WEND
	GOSUB game.START
	WHILE game.on = 1: GOSUB game.TICK: WEND
	GOSUB game.END
GOTO game.MAIN

LABEL game.INIT
	game.on = 0
	MODE 1
	GOSUB defineChars
	CALL plusEnableAsic()
	CALL plusDisableFirmwareUpdates()
	' Message and color cycling
	PEN 3
	LOCATE 7,12: PRINT "loading data, please wait..."
	FOR i=0 TO 15
		CALL plusWaitFrames(5)
		color = plusEncodeColor(i, i, i)
		CALL plusSetPalColor(3, color)
	NEXT
	LOAD "music.bin", &8980
	LOAD "player.bin",&9600
	game.playing = 0
	CALL plusSetSpritesData(@LABEL(data.SPRITES), 11)
	FOR i=15 TO 0 step -1
		CALL plusWaitFrames(5)
		color = plusEncodeColor(i, i, i)
		CALL plusSetPalColor(3, color)
	NEXT
RETURN

LABEL game.INTRO
	MODE 0								' The MODE call enables again the Firmware color update callback
	CALL plusDisableFirmwareUpdates()   ' So we have to disable it again
	FOR i=0 to 15
		CALL plusSetPalColor(i, 0)
	NEXT
	LOAD "TITLE.SCR", &C000
	CALL PLAYER, MUSIC, 0
	palrow = @LABEL(color.TITLEFADE) + (15 * 30)
	FOR i=15 TO 0 STEP -1  ' Fade effect has 16 palette rows
		FRAME
		CALL plusSetPalColors(1, palrow, 14)
		palrow = palrow - 30
		FRAME
	NEXT
	CALL plusSetSPriteAttr(1, 232, 180, PLUS.SPMODE1)
	CALL plusSetSPriteAttr(2, 264, 180, PLUS.SPMODE1)
	CALL plusSetSPriteAttr(3, 296, 180, PLUS.SPMODE1)
	CALL plusSetSPriteAttr(4, 328, 180, PLUS.SPMODE1)
	CALL plusSetSPriteAttr(5, 360, 180, PLUS.SPMODE1)
	
	fadedir = 1
	fadestep = 0  ' 10 steps: 0..9
	palrow = @LABEL(color.INTROSPR)
	LABEL loop
		IF JOY(0)>15 OR INKEY(47)=0 THEN GOTO endloop
		CALL plusSetSpriteColors(1, palrow, 7)
		color = plusEncodeColor(fadestep, fadestep, fadestep)
		CALL plusSetPalColor(16, color)
		fadestep = fadestep + fadedir
		IF fadestep MOD 2 = 0 THEN palrow = palrow + (14 * fadedir)  ' 5 rows of 7 colors of 2 bytes
		IF fadestep=9 THEN fadedir = -1
		IF fadestep=1 THEN fadedir = 1
		CALL plusWaitFrames(3)
		GOTO loop
	LABEL endloop
	CALL NOMUSIC: game.playing = 0: CLEAR INPUT
	FOR i=1 TO 31 STEP 2: SOUND 1,0,3,15,0,0,i: NEXT
	FOR i=fadestep TO 15
		color = plusEncodeColor(i, i, i)
		CALL plusSetPalColor(16, color)
		FRAME
	NEXT
	FOR i=15 TO 0 STEP-1
		color = plusEncodeColor(i, i, i)
		CALL plusSetPalColor(16, color)
		FRAME
	NEXT
	FOR i=181 TO 200
		' Animate directly the letters Y position
		FOR j=1 TO 5: CALL plusSetSpritePosY(j,i): NEXT
		FRAME
	NEXT
	palrow = @LABEL(color.TITLEFADE) + 30 ' Lets start in row 2 as we are already in row 1
	FOR v=1 TO 15
		FRAME
		CALL plusSetPalColors(1, palrow, 15)
		palrow = palrow + 30
	NEXT
RETURN

LABEL game.MENU
	palrow = @LABEL(color.INTROSPR)
	CALL plusSetSpriteColors(1, palrow, 7)
	game.menuopt = 1					' In this case we use regular Firmware INK calls to control
	MODE 0: CLG: RANDOMIZE TIME: TAG	' colors so we do not stop the Firmware update callback
	FOR i=0 TO 15: INK i,0: NEXT
	FOR i=0 TO 99
		PLOT INT(RND(1)*639), INT(RND(1)*399), 1
	NEXT
	FOR i=0 TO 99
		PLOT INT(RND(1)*639), INT(RND(1)*399), 2
	NEXT
	FOR i=0 TO 60
		PLOT INT(RND(1)*639), INT(RND(1)*399), 7
	NEXT
	MOVE 38,368: GRAPHICS PEN 6,1: PRINT "+++ mega chase +++";
	MOVE 35,370: GRAPHICS PEN 9,1: PRINT"++";: GRAPHICS PEN 10,1: PRINT"+ m";: GRAPHICS PEN 11,1: PRINT "eg";: GRAPHICS PEN 12,1: PRINT "a ch";
	GRAPHICS PEN 11,1: PRINT "as";: GRAPHICS PEN 10,1: PRINT "E ++";: GRAPHICS PEN 9,1: PRINT "+";
	MOVE 222,340: GRAPHICS PEN 15,1: PRINT "-"+CHR$(132)+CHR$(130)+CHR$(132)+CHR$(136)+"-";
	MOVE 16,290:  GRAPHICS PEN 13,1: PRINT "code,gfx & sound by";
	MOVE 180,270: GRAPHICS PEN 14,1: PRINT "shad0wfax";
	MOVE 100,200: GRAPHICS PEN 8:PRINT "select option:";
	MOVE 180,140: GRAPHICS PEN 3:PRINT CHR$(131)+" player";
	MOVE 180,104: GRAPHICS PEN 4:PRINT CHR$(132)+" players";
	MOVE 180,66:  GRAPHICS PEN 5: PRINT "instructions";
	INK 1,26,13:INK 2,13,26:INK 3,26:INK 4,26:INK 5,26:INK 6,13:INK 7,24,22
	INK 8,6,3:INK 9,3:INK 10,6:INK 11,15:INK 12,24:INK 13,18:INK 14,11:INK 15,8
	' Move selection arrow
	FOR i=0 TO 156 STEP 12
		CALL plusSetSpriteAttr(6, i, 129, PLUS.SPMODE1)
		CALL plusWaitFrames(2)
	NEXT
	IF game.playing=0 THEN CALL PLAYER,MUSIC,1: game.playing=1
	lapse!=TIME+50
	WHILE JOY(0)<16 AND INKEY(47)<>0
		IF game.menuopt<3 AND TIME>lapse! AND (JOY(0)=2 OR INKEY(69)=0) THEN game.menuopt=game.menuopt+1: lapse!=TIME+50
		IF game.menuopt>1 AND TIME>lapse! AND (JOY(0)=1 OR INKEY(67)=0) THEN game.menuopt=game.menuopt-1: lapse!=TIME+50
		SELECT CASE game.menuopt
			CASE 1: INK 3,26,0:INK 4,26:  INK 5,26:  CALL plusSetSpritePosY(6,129)
			CASE 2: INK 3,26:  INK 4,26,0:INK 5,26:  CALL plusSetSpritePosY(6,147)
			CASE 3: INK 3,26:  INK 4,26:  INK 5,26,0:CALL plusSetSpritePosY(6,165)
		END SELECT
	WEND
	CALL plusSetSpriteRes(6, PLUS.SPOFF)
RETURN

LABEL game.INSTRUCTIONS
	CALL NOMUSIC: game.playing = 0
	MODE 1: FOR i=0 TO 3: INK i,0: NEXT
	LOAD "INSTR.SCR", &C000
	INK 1,13,26:INK 2,26:INK 3,6,3
	CLEAR INPUT
	CALL &BB18 ' WAIT FOR ONE KEY
RETURN

LABEL game.DRAWBKG
	FOR i=0 TO 99:PLOT INT(RND(1)*639),INT(RND(1)*365)+33,1:NEXT
	FOR i=0 TO 99:PLOT INT(RND(1)*639),INT(RND(1)*365)+33,2:NEXT
	MOVE 4,0:GRAPHICS PEN 6:DRAW 48*4,0:MOVE 49*4,2:DRAW 49*4,2*15:GRAPHICS PEN 8:MOVE 0,2:DRAW 0,2*15:MOVE 4,2*16:DRAW 48*4,2*16
	GRAPHICS PEN 7:FOR i=2 TO 30 STEP 2:MOVE 4,i:DRAW 48*4,i:NEXT
	MOVE 51*4,0:GRAPHICS PEN 9:DRAW 108*4,0:MOVE 109*4,2:DRAW 109*4,15*2:GRAPHICS PEN 11:MOVE 50*4,2:DRAW 50*4,15*2:MOVE 51*4,16*2:DRAW 108*4,16*2
	GRAPHICS PEN 10:FOR i=2 TO 15*2 STEP 2:MOVE 51*4,i:DRAW 108*4,i:NEXT
	MOVE 111*4,0:GRAPHICS PEN 12:DRAW 158*4,0:MOVE 159*4,2:DRAW 159*4,15*2:GRAPHICS PEN 14:MOVE 111*4,16*2:DRAW 158*4,16*2:MOVE 110*4,2:DRAW 110*4,15*2
	GRAPHICS PEN 13:FOR i=2 TO 15*2 STEP 2:MOVE 111*4,i:DRAW 158*4,i:NEXT
	GRAPHICS PEN 0:MOVE 40,14:DRAW 40,22:PLOT 44,14,0:PLOT 48,14,0:PLOT 44,12,5:PLOT 48,12,5:PLOT 52,12,5:PLOT 44,16,5:PLOT 44,18,5:PLOT 44,20,5:'L
	GRAPHICS PEN 0: MOVE 56,14:DRAW 56,22:MOVE 64,14:DRAW 64,22:PLOT 60,22,0:PLOT 60,20,5:PLOT 60,18,5:PLOT 60,16,6:PLOT 60,14,5:PLOT 60,12,5:PLOT 64,12,5
	MOVE 68,12:GRAPHICS PEN 5:DRAW 68,20:GRAPHICS PEN 0:PLOT 60,18,0:'A
	MOVE 72,14:DRAW 80,14:MOVE 72,18:DRAW 80,18:MOVE 72,22:DRAW 80,22:PLOT 72,20,0:PLOT 80,16,0
	MOVE 76,20:GRAPHICS PEN 5:DRAW 84,20:MOVE 76,12:DRAW 84,12:PLOT 76,16,5:PLOT 84,16,5:PLOT 84,14,5:'S
	MOVE 88,14:GRAPHICS PEN 0:DRAW 88,22:DRAW 96,22:MOVE 92,14:DRAW 96,14:PLOT 92,18,0
	MOVE 92,12:GRAPHICS PEN 5:DRAW 100,12:MOVE 92,20:DRAW 100,20:PLOT 92,16,5:PLOT 96,16,5:'E
	GRAPHICS PEN 0:MOVE 104,14:DRAW 104,22:DRAW 112,22:DRAW 112,20:PLOT 108,18,0:PLOT 112,16,0:PLOT 112,14,0
	GRAPHICS PEN 5:MOVE 108,12:DRAW 108,16:PLOT 108,20,5:PLOT 116,20,5:PLOT 116,18,5:PLOT 116,14,5:PLOT 116,12,5:'R
	GRAPHICS PEN 6:MOVE 31*4,8:DRAW 31*4,26:DRAW 40*4,26:GRAPHICS PEN 3:DRAW 40*4,8:DRAW 32*4,8
	GRAPHICS PEN 0:MOVE 63*4,14:DRAW 63*4,22:PLOT 62*4,22,0:PLOT 64*4,22:GRAPHICS PEN 5:MOVE 64*4,20:DRAW 64*4,12:PLOT 65*4,20:'T
	GRAPHICS PEN 0:MOVE 67*4,22:DRAW 67*4,14:PLOT 66*4,22,0:PLOT 68*4,22,0:PLOT 66*4,14,0:PLOT 68*4,14,0:GRAPHICS PEN 5:MOVE 68*4,20:DRAW 68*4,16:PLOT 69*4,20,5:MOVE 67*4,12:DRAW 69*4,12:'I
	GRAPHICS PEN 0:MOVE 70*4,22:DRAW 70*4,14:MOVE 72*4,22:DRAW 72*4,14:PLOT 71*4,20,0:GRAPHICS PEN 5:MOVE 71*4,18:DRAW 71*4,12:MOVE 73*4,20:DRAW 73*4,12:'M
	GRAPHICS PEN 0:MOVE 76*4,22:DRAW 74*4,22:DRAW 74*4,14:DRAW 76*4,14:PLOT 75*4,18,0:GRAPHICS PEN 5:MOVE 75*4,20:DRAW 77*4,20:MOVE  75*4,16:DRAW 76*4,16:MOVE 75*4,12:DRAW 77*4,12:'E
	GRAPHICS PEN 9:MOVE 79*4,8:DRAW 79*4,26:DRAW 95*4,26:GRAPHICS PEN 11:MOVE 96*4,26:DRAW 96*4,8:DRAW 80*4,8
	GRAPHICS PEN 0:MOVE 121*4,22:DRAW 121*4,14:MOVE 123*4,22:DRAW 123*4,14:PLOT 122*4,16,0:PLOT 122*4,20,5:PLOT 122*4,18,5:PLOT 122*4,14,5:PLOT 122*4,12,5:GRAPHICS PEN 5:MOVE 124*4,20:DRAW 124*4,12:'W
	GRAPHICS PEN 0:MOVE 125*4,14:DRAW 125*4,22:DRAW 127*4,22:DRAW 127*4,14:PLOT 126*4,18,0:GRAPHICS PEN 5:PLOT 126*4,20,5:MOVE 126*4,16:DRAW 126*4,12:MOVE 128*4,20:DRAW 128*4,12:'A
	GRAPHICS PEN 0:MOVE 129*4,14:DRAW 129*4,22:DRAW 131*4,22:DRAW 131*4,20:PLOT 130*4,18,0:PLOT 131*4,16,0:PLOT 131*4,14,0
	GRAPHICS PEN 5:PLOT 130*4,20,5:MOVE 130*4,16:DRAW 130*4,12:PLOT 132*4,20,5:PLOT 132*4,18,5:PLOT 132*4,14,5:PLOT 132*4,12,5:'R
	GRAPHICS PEN 0:MOVE 133*4,14:DRAW 133*4,22:DRAW 135*4,22:DRAW 135*4,18:DRAW 132*4,18:GRAPHICS PEN 5: MOVE 136*4,20:DRAW 136*4,16:DRAW 134*4,16:DRAW 134*4,12:PLOT 134*4,20:'P
	GRAPHICS PEN 14:MOVE 147*4,24:DRAW 147*4,8:DRAW 139*4,8:GRAPHICS PEN 12:MOVE 138*4,8:DRAW 138*4,26:DRAW 146*4,26
RETURN

LABEL game.DRAWVALUES
	GRAPHICS PEN 3,0
	MOVE 32*4,24: PRINT CHR$(130 + player.shots);
	MOVE 139*4,24:PRINT CHR$(130 + enemy.warps);
	MOVE 80*4,24: PRINT CHR$(130 + game.seconds\10) + CHR$(130 + game.seconds MOD 10);
RETURN

LABEL game.DRAWCHARACTERS
	SELECT CASE enemy.img
	CASE 0:
		CALL plusSetSpriteRes(9, PLUS.SPOFF)
		CALL plusSetSpriteRes(10, PLUS.SPOFF)
		CALL plusSetSPriteAttr(8, enemy.xpos, enemy.ypos, PLUS.SPMODE1)
	CASE 1:
		CALL plusSetSpriteRes(8, PLUS.SPOFF)
		CALL plusSetSpriteRes(10, PLUS.SPOFF)
		CALL plusSetSPriteAttr(9, enemy.xpos, enemy.ypos, PLUS.SPMODE1)
	CASE 2:
		CALL plusSetSpriteRes(8, PLUS.SPOFF)
		CALL plusSetSpriteRes(9, PLUS.SPOFF)
		CALL plusSetSPriteAttr(10, enemy.xpos, enemy.ypos, PLUS.SPMODE1)
	END SELECT
	CALL plusSetSPriteAttr(7, player.xpos, player.ypos, PLUS.SPMODE1)
RETURN

LABEL game.START
	BORDER 13
	CALL plusWaitFrames(4): BORDER 26
	CALL plusWaitFrames(4): BORDER 13
	CALL plusWaitFrames(4): BORDER 0
	CALL NOMUSIC: game.playing = 0
	FOR i=1 TO 31 STEP 2: SOUND 1,0,3,j,0,0,i: NEXT
	RANDOMIZE TIME
	game.seconds=60
	game.start = 0
	game.on = 1
	player.shots = 9
	player.xpos = 314: player.ypos=90
	enemy.img = 0
	enemy.xoff = 2
	enemy.yoff = 1
	enemy.warps = 5
	enemy.alive = 1
	enemy.ticks = 0
	LABEL ENEMYPOS:
		enemy.xpos = INT(RND(1)*607): enemy.ypos = INT(RND(1)*170)
	IF ABS(player.xpos-enemy.xpos) < 100 OR ABS(player.ypos-enemy.ypos) < 50 THEN GOTO ENEMYPOS
	' GAME SCREEN
	CLEAR INPUT: CLG: FOR i=0 TO 15:INK i,0: NEXT
	CALL plusSetSpriteColors(1, @LABEL(color.SPRPALETTE2), 15)
	GOSUB game.DRAWBKG
	GOSUB game.DRAWVALUES
	GRAPHICS PEN 4,1:MOVE 160,220:PRINT"get ready!";
	INK 1,13,26:INK 2,26,13:INK 3,26:INK 4,6,0:INK 5,13:INK 6,12:INK 7,24:INK 8,25:INK 9,9:INK 10,18:INK 11,22:INK 12,10:INK 13,20:INK 14,23:INK 15,6
	CALL PLAYER, MUSIC, 2: game.playing = 1
	t!=TIME+1000: WHILE TIME<t!: WEND
	GRAPHICS PEN 0,1: MOVE 160,220: PRINT "get ready!";
	CALL NOMUSIC
RETURN

LABEL game.MOVEPLAYER2
	IF game.menuopt=2 THEN
		enemy.mov=JOY(0) ' Segundo player humano
	ELSE
		IF enemy.ticks > 0 THEN
			enemy.ticks = enemy.ticks - 1
		ELSE
			rndvalue=INT(RND*8) 'Random Direction
			SELECT CASE rndvalue
				CASE 0: enemy.mov=1
				CASE 1: enemy.mov=2
				CASE 2: enemy.mov=4
				CASE 3: enemy.mov=8
				CASE 4: enemy.mov=5
				CASE 5: enemy.mov=6
				CASE 6: enemy.mov=9
				CASE 7: enemy.mov=10
			END SELECT
			IF enemy.warps>0 AND ABS(enemy.xpos-player.xpos)<20 AND ABS(enemy.ypos-player.ypos)<10 THEN
				rndvalue=INT(RND*10)
				IF rndvalue<5 THEN enemy.mov=enemy.mov + 256
			END IF
			enemy.ticks = 10
		END IF
	END IF
	IF enemy.mov=0 THEN enemy.img=0
	IF (enemy.mov AND 1) THEN enemy.ypos=enemy.ypos-enemy.yoff: enemy.img=0
	IF (enemy.mov AND 2) THEN enemy.ypos=enemy.ypos+enemy.yoff: enemy.img=0
	IF (enemy.mov AND 4) THEN enemy.xpos=enemy.xpos-enemy.xoff: enemy.img=1
	IF (enemy.mov AND 8) THEN enemy.xpos=enemy.xpos+enemy.xoff: enemy.img=2
	IF enemy.xpos<0 THEN enemy.xpos=0
	IF enemy.ypos<0 THEN enemy.ypos=0
	IF enemy.xpos>607 THEN enemy.xpos=607
	IF enemy.ypos>169 THEN enemy.ypos=169
	IF enemy.mov>15 AND enemy.warps>0 THEN enemy.ticks=0: GOSUB game.FIREWARP
RETURN

LABEL game.MOVEPLAYER1
	IF INKEY(67)=0 THEN player.ypos=player.ypos-player.yoff
	IF INKEY(69)=0 THEN player.ypos=player.ypos+player.yoff
	IF INKEY(34)=0 THEN player.xpos=player.xpos-player.xoff
	IF INKEY(27)=0 THEN player.xpos=player.xpos+player.xoff
	IF player.xpos<0 THEN player.xpos=0
	IF player.ypos<0 THEN player.ypos=0
	IF player.xpos>624 THEN player.xpos=624
	IF player.ypos>175 THEN player.ypos=175
	IF INKEY(47)=0 THEN
		GOSUB game.FIRELASER
		IF player.shots = 0 AND enemy.alive THEN game.on = 0
	END IF
RETURN

LABEL game.TICK
	GOSUB game.DRAWCHARACTERS
	GOSUB game.COUNTDOWN
	CLEAR INPUT
	GOSUB game.MOVEPLAYER1
	GOSUB game.MOVEPLAYER2
	GOSUB game.DRAWVALUES
	IF game.seconds=0 THEN game.on=0
	IF player.shots=0 THEN game.on=0
RETURN

LABEL game.EXPLOSION
	CALL plusSetSPriteRes(7, PLUS.SPOFF)
	CALL plusSetSPriteRes(8, PLUS.SPOFF)
	CALL plusSetSpriteRes(9, PLUS.SPOFF)
	CALL plusSetSpriteRes(10, PLUS.SPOFF)
	CALL plusSetSPriteAttr(11, enemy.xpos, enemy.ypos, PLUS.SPMODE1)
	enemy.alive = 0
	game.on = 0
	FOR i=15 TO 1 STEP-1
		SOUND 2,500,10,i,0,0,31
	NEXT
RETURN

LABEL game.FIRELASER
	BORDER 13
	player.shots = player.shots - 1
	GRAPHICS PEN 3,1: MOVE 0,36: DRAW player.xpos+6, (195-player.ypos)*2
	MOVE 639,36: DRAW player.xpos+6, (195-player.ypos)*2
	i=15
	FOR j=1 TO 31 STEP 2
		SOUND 1,0,3,i,0,0,j: v=v-1
	NEXT
	GRAPHICS PEN 0: MOVE 0,36: DRAW player.xpos+6, (195-player.ypos)*2
	MOVE 639,36: DRAW player.xpos+6, (195-player.ypos)*2
	BORDER 0
	SELECT CASE enemy.img
	CASE 0:
		IF enemy.xpos-(player.xpos+6)>0 THEN RETURN
		IF (player.xpos+6)-enemy.xpos>30 THEN RETURN
		IF (enemy.ypos+3)-(player.ypos+3)>0 THEN RETURN
		IF (player.ypos+3)-enemy.ypos>10 THEN RETURN
	CASE 1:
		IF enemy.xpos-(player.xpos+6)>0 THEN RETURN
		IF (player.xpos+6)-enemy.xpos>24 THEN RETURN
		IF (enemy.ypos+2)-(player.ypos+3)>0 THEN RETURN
		IF (player.ypos+3)-enemy.ypos>12 THEN RETURN
	CASE 2:
		IF (enemy.xpos-6)-(player.xpos-6)>0 THEN RETURN
		IF (player.xpos+6)-enemy.xpos>30 THEN RETURN
		IF (enemy.ypos+2)-(player.ypos+3)>0 THEN RETURN
		IF (player.ypos+2)-enemy.ypos>12 THEN RETURN
	END SELECT
	GOSUB game.EXPLOSION
RETURN

LABEL game.FIREWARP
	REMAIN(1)
	enemy.warps = enemy.warps - 1
	SOUND 2,20,90,15,0,1
	palrow = @LABEL(color.CYCLEWARP)
	FOR i=1 TO 15
		CALL plusSetSpriteColors(1, palrow + i*30, 15)
		FRAME
	NEXT
	LABEL NEWENEMYPOS
		enemy.xpos=INT(RND*614)
		enemy.ypos=INT(RND*169)
	IF ABS(player.xpos-enemy.xpos)<100 OR ABS(player.ypos-enemy.ypos)<50 THEN GOTO NEWENEMYPOS
	GOSUB game.DRAWCHARACTERS
	FOR i=14 TO 0 STEP -1
		CALL plusSetSpriteColors(1, palrow + i*30, 15)
		FRAME
	NEXT
RETURN

LABEL game.END
	CALL plusSetSpriteRes(11, PLUS.SPOFF)
	INK 4,6,0: GRAPHICS PEN 4,1: MOVE 90,220
	IF enemy.alive=0 THEN
		PRINT "player "+CHR$(131)+" wins!!";
	ELSE
		IF game.menuopt=1 THEN PRINT "   cpu wins!!  "; ELSE PRINT "player "+CHR$(132)+" wins!!";
	END IF
	CALL PLAYER,MUSIC,3
	t!=TIME+1100: WHILE TIME<t!: WEND
	CALL NOMUSIC: game.playing=0
	game.start = 0
RETURN

LABEL game.COUNTDOWN
	countdown = countdown + 1
	if countdown = 80 THEN game.seconds = game.seconds - 1: countdown = 0
RETURN

LABEL color.INTROSPR
	ASM "db &f0,&00,&f0,&01,&f0,&02,&f0,&03,&f0,&04,&f5,&05,&f0,&06"
	ASM "db &f0,&02,&f0,&03,&f0,&04,&f0,&05,&f0,&06,&f0,&07,&f0,&08"
	ASM "db &f0,&04,&f0,&05,&f0,&06,&f0,&07,&f0,&08,&f0,&09,&f0,&0a"
	ASM "db &f0,&06,&f0,&07,&f0,&08,&f0,&09,&f0,&0a,&f0,&0b,&f0,&0c"
	ASM "db &f0,&08,&f0,&09,&f0,&0a,&f0,&0b,&f0,&0c,&f0,&0d,&f0,&0e"

LABEL color.CYCLEWARP	
	ASM "db &dd,&0d,&bb,&0b,&99,&09,&77,&07,&55,&05,&f0,&0d,&f0,&09,&f0,&06,&0f,&0f,&0d,&0d,&0b,&0b,&70,&00,&b0,&00,&f0,&00,&f0,&00"
	ASM "db &cc,&0c,&aa,&0a,&88,&08,&66,&06,&44,&04,&e0,&0c,&e0,&08,&e0,&05,&0e,&0e,&0c,&0c,&0a,&0a,&60,&00,&a0,&00,&e0,&00,&e0,&00"
	ASM "db &bb,&0b,&99,&09,&77,&07,&55,&05,&33,&03,&d0,&0b,&d0,&07,&d0,&04,&0d,&0d,&0b,&0a,&09,&09,&50,&00,&90,&00,&d0,&00,&d0,&00"
	ASM "db &aa,&0a,&88,&08,&66,&06,&44,&04,&22,&02,&c0,&0a,&c0,&06,&c0,&03,&0c,&0c,&0a,&09,&08,&08,&40,&00,&80,&00,&c0,&00,&c0,&00"
	ASM "db &99,&09,&77,&07,&55,&05,&33,&03,&11,&01,&b0,&09,&b0,&05,&b0,&02,&0b,&0b,&09,&08,&07,&07,&30,&00,&70,&00,&b0,&00,&b0,&00"
	ASM "db &88,&08,&66,&06,&44,&04,&22,&02,&00,&00,&a0,&08,&a0,&04,&a0,&01,&0a,&0a,&08,&07,&06,&06,&20,&00,&60,&00,&a0,&00,&a0,&00"
	ASM "db &77,&07,&55,&05,&33,&03,&11,&01,&00,&00,&90,&07,&90,&03,&90,&00,&09,&09,&07,&06,&05,&05,&10,&00,&50,&00,&90,&00,&90,&00"
	ASM "db &66,&06,&44,&04,&22,&02,&00,&00,&00,&00,&80,&06,&80,&02,&80,&00,&08,&08,&06,&05,&04,&04,&00,&00,&30,&00,&80,&00,&80,&00"
	ASM "db &55,&05,&33,&03,&11,&01,&00,&00,&00,&00,&70,&05,&70,&01,&70,&00,&07,&07,&05,&04,&03,&03,&00,&00,&20,&00,&70,&00,&70,&00"
	ASM "db &44,&04,&22,&02,&00,&00,&00,&00,&00,&00,&60,&04,&60,&00,&60,&00,&06,&06,&04,&03,&02,&02,&00,&00,&10,&00,&60,&00,&60,&00"
	ASM "db &33,&03,&11,&01,&00,&00,&00,&00,&00,&00,&50,&03,&50,&00,&50,&00,&05,&05,&03,&02,&01,&01,&00,&00,&00,&00,&50,&00,&50,&00"
	ASM "db &22,&02,&00,&00,&00,&00,&00,&00,&00,&00,&40,&02,&40,&00,&40,&00,&04,&04,&02,&01,&00,&00,&00,&00,&00,&00,&40,&00,&40,&00"
	ASM "db &22,&01,&00,&00,&00,&00,&00,&00,&00,&00,&30,&01,&30,&00,&30,&00,&03,&03,&01,&00,&00,&00,&00,&00,&00,&00,&30,&00,&30,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&20,&00,&20,&00,&20,&00,&02,&02,&00,&00,&00,&00,&00,&00,&00,&00,&20,&00,&20,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&10,&00,&10,&00,&10,&00,&01,&01,&00,&00,&00,&00,&00,&00,&00,&00,&10,&00,&10,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00"

LABEL color.TITLEFADE
	ASM "db &3A,&02,&B6,&06,&61,&05,&C6,&0D,&7A,&04,&FF,&0F,&7D,&07,&92,&05,&83,&03,&AA,&0A,&6B,&0B,&88,&08,&55,&05,&A7,&0D,&02,&00"
	ASM "db &29,&01,&a5,&05,&50,&04,&d5,&0c,&69,&03,&ee,&0e,&6c,&06,&81,&04,&72,&02,&99,&09,&5a,&0a,&77,&07,&44,&04,&96,&0c,&01,&00"
	ASM "db &18,&00,&94,&04,&40,&03,&c4,&0b,&58,&02,&dd,&0d,&5b,&05,&70,&03,&61,&01,&88,&08,&49,&09,&66,&06,&33,&03,&85,&0b,&00,&00"
	ASM "db &07,&00,&83,&03,&30,&02,&b3,&0a,&47,&01,&cc,&0c,&4a,&04,&60,&02,&50,&00,&77,&07,&38,&08,&55,&05,&22,&02,&74,&0a,&00,&00"
	ASM "db &06,&00,&72,&02,&20,&01,&a2,&09,&36,&00,&bb,&0b,&39,&03,&50,&01,&40,&00,&66,&06,&27,&07,&44,&04,&11,&01,&63,&09,&00,&00"
	ASM "db &05,&00,&61,&01,&10,&00,&91,&08,&25,&00,&aa,&0a,&28,&02,&40,&00,&30,&00,&55,&05,&16,&06,&33,&03,&00,&00,&52,&08,&00,&00"
	ASM "db &04,&00,&50,&00,&00,&00,&80,&07,&14,&00,&99,&09,&17,&01,&30,&00,&20,&00,&44,&04,&05,&05,&22,&02,&00,&00,&41,&07,&00,&00"
	ASM "db &03,&00,&40,&00,&00,&00,&70,&06,&03,&00,&88,&08,&06,&00,&20,&00,&10,&00,&33,&03,&03,&04,&11,&01,&00,&00,&30,&06,&00,&00"
	ASM "db &02,&00,&30,&00,&00,&00,&60,&05,&02,&00,&77,&07,&05,&00,&10,&00,&00,&00,&22,&02,&02,&03,&00,&00,&00,&00,&20,&05,&00,&00"
	ASM "db &01,&00,&20,&00,&00,&00,&50,&04,&01,&00,&66,&06,&04,&00,&00,&00,&00,&00,&11,&01,&01,&02,&00,&00,&00,&00,&10,&04,&00,&00"
	ASM "db &00,&00,&10,&00,&00,&00,&40,&03,&00,&00,&55,&05,&03,&00,&00,&00,&00,&00,&00,&00,&00,&01,&00,&00,&00,&00,&00,&03,&00,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&30,&02,&00,&00,&44,&04,&02,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&02,&00,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&20,&01,&00,&00,&33,&03,&01,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&01,&00,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&10,&00,&00,&00,&22,&02,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&11,&01,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00"
	ASM "db &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00"

LABEL color.SPRPALETTE1
	ASM "db &f0,&03,&f0,&05,&f0,&07,&f0,&09,&f0,&0b,&f0,&0d,&f0,&0f,&f0,&08,&f0,&09,&f0,&0a,&f0,&0b,&f0,&0c,&f0,&0d,&f0,&0e"

LABEL color.SPRPALETTE2
	ASM "db &dd,&0d,&bb,&0b,&99,&09,&77,&07,&55,&05,&f0,&0d,&f0,&09,&f0,&06,&0f,&0f,&0d,&0d,&0b,&0b,&70,&00,&b0,&00,&f0,&00,&f0,&00"

LABEL color.SPREXPLOSION
	ASM "db &ff,&0f,&fc,&0f,&f9,&0f,&f6,&0f,&f3,&0f,&f0,&0f,&f0,&0d,&f0,&0b,&f0,&09,&f0,&07,&f0,&05,&f0,&03,&f0,&00,&c0,&00,&80,&00"

LABEL data.SPRITES
LABEL data.SPRITE1
	ASM "db 0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0"
	ASM "db 0,2,0,0,0,0,2,0,0,2,0,0,0,0,2,0"
	ASM "db 0,3,0,0,0,0,3,0,0,3,0,0,0,0,3,0"
	ASM "db 4,4,4,4,4,4,0,0,4,4,4,4,4,4,0,0"
	ASM "db 5,5,0,0,0,0,0,0,5,5,0,0,5,0,0,0"
	ASM "db 6,6,0,0,0,0,0,0,6,6,0,0,0,6,0,0"
	ASM "db 7,7,0,0,0,0,0,0,7,7,0,0,0,0,7,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE2
	ASM "db 0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0"
	ASM "db 0,2,0,0,0,0,2,0,2,0,0,0,0,0,2,0"
	ASM "db 0,3,0,0,0,0,0,0,3,0,0,0,0,0,0,0"
	ASM "db 4,4,4,4,4,0,0,0,0,4,4,4,4,4,0,0"
	ASM "db 5,5,0,0,0,0,0,0,0,0,0,0,0,5,5,0"
	ASM "db 6,6,0,0,0,0,6,0,6,0,0,0,0,6,6,0"
	ASM "db 7,7,7,7,7,7,7,0,7,7,7,7,7,7,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE3
	ASM "db 0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0"
	ASM "db 2,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0"
	ASM "db 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0"
	ASM "db 6,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0"
	ASM "db 7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE4
	ASM "db 0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0"
	ASM "db 2,0,0,0,0,0,2,0,0,0,0,2,0,0,0,0"
	ASM "db 3,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0"
	ASM "db 4,4,4,4,4,4,0,0,0,0,4,4,0,0,0,0"
	ASM "db 5,5,0,0,0,0,0,0,0,0,5,5,0,0,0,0"
	ASM "db 6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0"
	ASM "db 7,7,0,0,0,0,0,0,7,7,7,7,7,7,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE5
	ASM "db 0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0"
	ASM "db 0,2,0,0,0,0,2,0,0,2,0,0,0,0,2,0"
	ASM "db 3,0,0,0,0,0,3,0,0,3,0,0,0,0,0,0"
	ASM "db 4,4,4,4,4,4,0,0,4,4,4,4,0,0,0,0"
	ASM "db 5,5,0,0,5,0,0,0,5,0,0,0,0,0,0,0"
	ASM "db 6,6,0,0,0,6,0,0,6,0,0,0,0,0,6,0"
	ASM "db 7,7,0,0,0,0,7,0,7,7,7,7,7,7,7,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE6
	ASM "db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE7
	ASM "db 0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 12,13,0,14,0,13,12,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE8
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,6,0,0,0,0,6,0,0,0,0,0"
	ASM "db 0,0,0,0,0,6,0,0,0,0,6,0,0,0,0,0"
	ASM "db 0,0,0,0,0,7,11,10,10,11,7,0,0,0,0,0"
	ASM "db 0,0,0,0,1,7,9,9,9,9,7,1,0,0,0,0"
	ASM "db 0,0,0,1,2,8,10,9,9,10,8,2,1,0,0,0"
	ASM "db 0,0,1,2,3,8,4,12,12,4,8,3,2,1,0,0"
	ASM "db 0,2,3,4,5,7,13,15,15,13,7,5,4,3,2,0"
	ASM "db 2,3,3,4,5,7,5,12,12,5,7,5,4,3,3,2"
	ASM "db 3,4,5,0,0,6,0,0,0,0,6,0,0,5,4,3"
	ASM "db 15,5,0,0,0,0,0,0,0,0,0,0,0,0,5,15"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE9
	ASM "db 0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,7,1,1,1,2,3,4,4,0,0,0"
	ASM "db 6,0,0,0,10,11,7,1,2,3,4,5,5,15,0,0"
	ASM "db 0,6,0,10,9,9,10,8,3,4,5,0,0,0,0,0"
	ASM "db 0,0,7,11,9,9,15,13,7,5,0,0,0,0,0,0"
	ASM "db 0,0,1,7,0,15,13,15,5,6,0,0,0,0,0,0"
	ASM "db 0,0,1,1,8,13,15,5,0,0,0,0,0,0,0,0"
	ASM "db 0,0,1,2,3,7,5,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,2,3,4,5,6,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,3,4,5,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,4,5,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,4,5,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE10
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0"
	ASM "db 0,0,0,4,4,3,2,1,1,1,7,0,0,0,0,0"
	ASM "db 0,0,15,5,5,4,3,2,1,7,11,10,0,0,0,6"
	ASM "db 0,0,0,0,0,5,4,3,8,10,9,9,10,0,6,0"
	ASM "db 0,0,0,0,0,0,5,7,13,15,9,9,11,7,0,0"
	ASM "db 0,0,0,0,0,0,6,5,15,13,15,10,7,1,0,0"
	ASM "db 0,0,0,0,0,0,0,0,5,15,13,8,1,1,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,5,7,3,2,1,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,6,5,4,3,2,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,5,4,3,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	ASM "db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
LABEL data.SPRITE11
	ASM "db 15,0,0,15,0,0,0,12,0,13,0,0,15,0,0,15"
	ASM "db 0,0,14,0,0,0,0,0,0,10,0,0,0,14,0,0"
	ASM "db 0,13,9,10,11,9,0,0,0,0,9,11,10,9,13,0"
	ASM "db 0,0,11,13,12,0,0,8,6,0,0,12,13,11,0,0"
	ASM "db 0,0,0,9,10,8,5,4,4,5,8,10,9,0,0,0"
	ASM "db 0,0,12,0,7,5,4,3,3,4,5,7,0,12,0,0"
	ASM "db 0,0,0,0,6,4,3,2,2,3,4,6,0,0,0,0"
	ASM "db 0,12,9,0,0,3,2,1,1,2,3,0,0,9,12,0"
	ASM "db 15,0,11,7,5,3,2,1,1,2,3,5,7,11,0,15"
	ASM "db 0,13,10,8,6,4,3,2,2,3,4,6,8,10,13,0"
	ASM "db 14,0,11,7,6,5,4,3,3,4,5,6,7,11,0,14"
	ASM "db 0,0,9,0,7,6,5,4,4,5,6,7,0,9,0,0"
	ASM "db 0,12,0,9,8,7,0,6,8,0,7,8,9,0,12,0"
	ASM "db 0,0,11,10,9,11,9,0,0,9,11,9,10,11,0,0"
	ASM "db 0,12,13,14,13,12,0,0,10,0,12,13,14,13,12,0"
	ASM "db 15,0,0,15,0,0,0,13,0,12,0,0,15,0,0,15"

LABEL defineChars
	' To save memory we redefine lower case letters because they are placed
	' higher in the character table. For number, we use 130 = 0, 131 = 1,
	' 132 = 2, ... 139 = 9
	SYMBOL 130,30,35,39,107,113,97,30,0
	SYMBOL 131,4,4,4,12,12,12,12,0
	SYMBOL 132,63,33,1,31,96,96,127,0
	SYMBOL 133,127,65,1,31,3,67,127,0
	SYMBOL 134,33,33,33,63,3,3,3,0
	SYMBOL 135,63,32,32,63,3,3,127,0
	SYMBOL 136,63,32,32,127,97,97,127,0
	SYMBOL 137,127,97,2,4,8,16,32,0
	SYMBOL 138,63,33,34,28,97,97,127,0
	SYMBOL 139,127,65,65,127,3,3,3,0
	SYMBOL 97,62,34,34,127,99,99,99,0
	SYMBOL 98,124,34,34,127,97,97,127,0
	SYMBOL 99,63,33,32,96,96,97,127,0
	SYMBOL 100,126,33,33,99,99,99,127,0
	SYMBOL 101,63,33,32,126,96,97,127,0
	SYMBOL 102,63,33,32,126,96,96,96,0
	SYMBOL 103,63,33,32,103,97,97,127,0
	SYMBOL 104,33,33,33,127,97,97,97,0
	SYMBOL 105,62,8,8,24,24,24,62,0
	SYMBOL 106,62,34,2,6,102,102,126,0
	SYMBOL 107,33,34,36,56,100,98,97,0
	SYMBOL 108,32,32,32,96,96,97,127,0
	SYMBOL 109,33,51,45,97,97,97,97,0
	SYMBOL 110,33,49,41,101,99,99,99,0
	SYMBOL 111,63,33,33,97,97,97,127,0
	SYMBOL 112,62,33,33,127,96,96,96,0
	SYMBOL 113,30,33,33,97,105,100,26,0
	SYMBOL 114,62,33,33,126,100,98,97,0
	SYMBOL 115,63,33,32,30,1,97,127,0
	SYMBOL 116,127,73,8,24,24,24,24,0
	SYMBOL 117,33,33,33,99,99,99,127,0
	SYMBOL 118,33,33,33,35,50,28,24,0
	SYMBOL 119,33,33,33,105,105,105,127,0
	SYMBOL 120,34,34,20,8,20,99,99,0
	SYMBOL 121,65,34,20,8,24,24,24,0
	SYMBOL 122,126,66,4,8,48,97,127,0
RETURN

