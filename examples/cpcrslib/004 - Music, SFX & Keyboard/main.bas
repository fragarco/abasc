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


extern char texto00[];
extern char texto01[];
extern char texto02[];
extern char texto03[];
extern char texto04[];
extern char texto05[];
extern char texto06[];
extern char texto07[];
extern char texto08[];
extern char texto09[];
extern char texto10[];
extern char texto11[];


void datos(void) {
	__asm
	_texto00:
	.asciz "SFX & MUSIC DEMO. CPCRSLIB 2012"
	_texto01:
	.asciz "PSG PROPLAYER BY WYZ 2010"
	_texto02:
    .asciz "Press keys 1 to 4 to play SFX"
	_texto03:
	.asciz "ESC to Quit"
	_texto04:
	.asciz "RED;ALERT"
	_texto05:
	.asciz "CANCION;NUEVA"
	_texto06:
	.asciz "GOTHIC"
	_texto07:
	.asciz "MARYJANE"
	_texto08:
	.asciz "MIDNIGHT;XPRES"
	_texto09:
	.asciz ";;;;;;;;;;;;;;;"
	_texto10:
	.asciz "AHORA;SONANDO:"
	_texto11:
	.asciz "Up & Down to change song"
__endasm;
}

label MAIN
	unsigned char tema=0;
	unsigned char nuevotema=0;

   	 char MinX,MinY,MaxX, MaxY,HorzSpd,VertSpd,gravityAccel;
   	char cx,cy,ox,oy;

   	MaxX=60;
   	MaxY=110;
   	MinX=0;
   	MinY=5;
	VertSpd=1;
	HorzSpd=1;
	gravityAccel=2;


	call rsClrScr()

	// Text writting using firmware:
	//cpc_PrintStr();

	cpc_PrintStr(texto00);
	cpc_PrintStr(texto01);
	cpc_PrintStr(texto02);
	cpc_PrintStr(texto11);
	cpc_PrintStr(texto03);


	cpc_DisableFirmware();
	// Assign keys to key number (not numberpad keys)
	cpc_AssignKey(0,0x4801);		// key "1" assigned to 0
	cpc_AssignKey(1,0x4802);		// key "2"
	cpc_AssignKey(2,0x4702);		// key "3"
	cpc_AssignKey(3,0x4701);		// key "4"
	cpc_AssignKey(4,0x4804);		// key "ESC"
	cpc_AssignKey(5,0x4001);		// key "Up"
	cpc_AssignKey(6,0x4004);		// key "Down"




	cpc_WyzInitPlayer(SOUND_TABLE_0, RULE_TABLE_0, EFFECT_TABLE, SONG_TABLE_0);		//initialize data
	cpc_WyzLoadSong(0);	//Select song to play (uncompress it and the start to play)
	cpc_WyzSetPlayerOn();		//start music and sound effects (SFX)
	nuevotema=1;


  	cx=28;

   	cy=20;

	ox=cx;
	oy=cy;


	cpc_ScanKeyboard();			//Reads whole keyboard. It's requiered in order to use cpc_TestKeyF
	while (!cpc_TestKeyF(4)) {	//cpc_TestKeyF is faster when more than 3 keys gonna be tested

			pause();

            if (cx >= MaxX)
            {
                HorzSpd = -HorzSpd;
                cx = MaxX;
            }
            else if (cx <= MinX)
            {
                HorzSpd = -HorzSpd;
                cx = MinX;
            }

            if (cy >= MaxY)
            {
                VertSpd = -VertSpd;
                cy = MaxY;
            }
            else if (cy <= MinY)
            {
                VertSpd = -VertSpd;
                cy = MinY;
            }

            VertSpd += gravityAccel - 1;

            cpc_PutSpXOR(pelota, 11, 3, cpc_GetScrAddress(cx,cy));
            cpc_PutSpXOR(pelota, 11, 3, cpc_GetScrAddress(ox,oy));

			ox=cx;
			oy=cy;


            cx += HorzSpd;
            cy += VertSpd;



		cpc_ScanKeyboard();
		if ((cpc_WyzTestPlayer()&8)==0) {	//test if bit 3 is 0 in order to allow another effect.
			// When a  1-4 key is pressed, a SFX is played
			if (cpc_TestKeyF(0)==1) 	cpc_WyzStartEffect(0,0);	//(Channel, SFX #)
			if (cpc_TestKeyF(1)==1) 	cpc_WyzStartEffect(1,1);
			if (cpc_TestKeyF(2)==1) 	cpc_WyzStartEffect(2,2);
			if (cpc_TestKeyF(3)==1) 	cpc_WyzStartEffect(1,3);
			if (cpc_TestKeyF(5)==1)	{
				if (tema>0) {
					tema--;
					nuevotema=1;
				}
			}
			if (cpc_TestKeyF(6)==1)	{
				if (tema<4) {
					tema++;
					nuevotema=1;
				}
			}
			if (nuevotema==1){
				cpc_WyzSetPlayerOff();
				cpc_PrintGphStrXYM1(texto10,0,0);
				switch (tema) {
					case 0:
						cpc_WyzInitPlayer(SOUND_TABLE_0, RULE_TABLE_0, EFFECT_TABLE, SONG_TABLE_0);	//initialize data
						cpc_PrintGphStrXYM12X(texto09,2,10);
						cpc_PrintGphStrXYM12X(texto04,2,10);
						break;
					case 1:
						cpc_WyzInitPlayer(SOUND_TABLE_1, RULE_TABLE_1, EFFECT_TABLE, SONG_TABLE_1);		//initialize data
						cpc_PrintGphStrXYM12X(texto09,2,10);
						cpc_PrintGphStrXYM12X(texto05,2,10);
						break;
					case 2:
						cpc_WyzInitPlayer(SOUND_TABLE_2, RULE_TABLE_2, EFFECT_TABLE, SONG_TABLE_2);		//initialize data
						cpc_PrintGphStrXYM12X(texto09,2,10);
						cpc_PrintGphStrXYM12X(texto06,2,10);
						break;
					case 3:
						cpc_WyzInitPlayer(SOUND_TABLE_3, RULE_TABLE_3, EFFECT_TABLE, SONG_TABLE_3);		//initialize data
						cpc_PrintGphStrXYM12X(texto09,2,10);
						cpc_PrintGphStrXYM12X(texto07,2,10);
						break;
					case 4:
						cpc_WyzInitPlayer(SOUND_TABLE_4, RULE_TABLE_4, EFFECT_TABLE, SONG_TABLE_4);		//initialize data
						cpc_PrintGphStrXYM12X(texto09,2,10);
						cpc_PrintGphStrXYM12X(texto08,2,10);
						break;
				}
				cpc_WyzLoadSong(0);			//Select song to play
				cpc_WyzSetPlayerOn();		//start music and sound effects (SFX)
				nuevotema=0;


			   	MaxX=60;
			   	MaxY=110;
			   	MinX=0;
			   	MinY=5;
				VertSpd=1;
				HorzSpd=1;
				gravityAccel=2;

				cx=28;
				cy=20;
			}
		}
	}
	//while(1);
	cpc_WyzSetPlayerOff();	//stop music and SFX
	cpc_EnableFirmware();
	return 0;
end

asm "read 'assets/songs.asm'"