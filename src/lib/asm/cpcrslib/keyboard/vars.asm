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

; The following information has been extracted from:
; https://cpctech.cpcwiki.de/docs/keyboard.html
; It is important to read the full text there to gain a more deep knowledge about
; the procedure to scan the Amstrad CPC keyboard. Specially, about some special
; effects like the KEYBOARD CRASH.

; Scanning the Keyboard and Joysticks

; The keyboard and joysticks are scanned using the AY-3-8912 PSG and the 8255 PPI.
; The keys on the keyboard, and the joystick directions and buttons, are arranged
; in an 10 by 8 matrix. Each element of the matrix is a switch and represents the
; state of a key or a joystick button.

; The matrix is read a column at a time, each column is read as a byte, and this
; holds the state of 8 switches. When the matrix is read, a switch will be "0" or "1".
;	If the switch is "0" then the key/joystick button corresponding to that bit is pressed,
;   If the switch is "1" then the key/joystick button is not pressed, 

; Joystick 0 occupies it's own space in the matrix and is accessed at line 9. Joystick 1
; shares line 6 with the keyboard. As a result, it is possible to simulate the state of
; joystick 1 by pressing the appropiate keys on the keyboard.

;The position of each key/joystick button in the matrix is shown in the table below:
;                        	Bit (hex value)
; Line 	7 (80)	6 (40)	5 (20)	4 (10)	3 (08)	2 (04)	1 (02)	0 (01)
; &40 	FDot 	FEnter	F3 		F6 		F9 	    DOWN    RIGHT   UP
; &41 	F0 		F2 		F1 		F5 		F8 		F7 	    COPY    LEFT
; &42 	CTRL    \ ` 	SHIFT 	F4 		] }     RETURN  [ { 	CLR
; &43 	. > 	/ ? 	: * 	; + 	P 		@ ¦ 	- = 	^ £
; &44 	, < 	M 		K 		L 		I 		O 		9 ) 	0 _
; &45 	SPACE 	N 		J	 	H 		Y 		U 		7 ' 	8 (
; &46**	V 		B  		F  		G		T		R		5 %		6 &
; &47 	X 		C 		D 		S 		W 		E 		3 # 	4 $
; &48 	Z 	    CAPS 	A 		TAB 	Q 		ESC 	2 " 	1 !
; &49 	DEL 	Jfire3 	Jfire2 	Jfire1 	Jright 	Jleft 	Jdown 	Jup 
;
; ** This line maps the Joy2 keys too:
; B (J2 fire3) F (Joy2 fire2) G (Joy2 fire1) T (Joy2 right) R (Joy2 left) 5 % (Joy2 down) 6 & (Joy2 up)

; Algorithm for reading the keyboard and joysticks

; The matrix is connected to PSG I/O port A, and PPI Port C. (PSG Port A is accessed through PSG
; register 14). Bits 3..0 of PPI Port C are used to define the matrix line to read. The data of
; the selected matrix line will be present at the inputs to PSG Port A.
; The PSG is accessed through PPI Port A and PPI Port C. PPI port A is a databus. PPI Port C bit 7
; and 6 are used to define the PSG access function:
; PSG access function selection:
; PPI Port C Bits 	PSG Function 						Notes
;	7 	6
;	0 	0 			Inactive	
;	0 	1 			Read from selected PSG register.	The data from the PSG register will be present at PPI port A.
;	1 	0 			Write to selected PSG register. 	The data at PPI port A defines the data to write to the PSG register.
;	1 	1 			Select PSG register.				The data at PPI port A defines the PSG register index.

; The following sequence is required to read one or more matrix lines:
;   1. Write 14 to PPI Port A, (This is the index of the I/O Port A register of the PSG)
;   2. Select PSG operation: write register index, by setting bit 7="1" and bit 6="1" of PPI port C.
;   3. Select PSG operation: inactive, by setting bit 7="0" and bit 6="0" of PPI Port C.
;   4. Set Port A of the PPI to input (use PPI Control register),
;   5. Write matrix line into bit 3-0 of PPI Port C.
;   6. Select PSG operation: read register data, by setting bit 7="0 and bit 6="1" of PPI Port C.
;   7. Read matrix data from PPI port A.
;   8. If more lines are to be read go to step 5,
;   9. Set Port A of the PPI to output (use PPI Control register),
;  10. Select PSG operation: inactive, by setting bit 7="0" and bit 6="0" of PPI Port C. 

; Used by the different keyboard routines to save values.
_cpcrslib_keyline: 	db 0
_cpcrslib_keybyte:	db 0
_cpcrslib_keymap:	defs 10  ; 10 lines of 8 bits each (keyboard matrix)

; TABLE OF USER DEFINED KEYS (ASSIGMENT TABLE)
; Initialized with some default values. FFFF if the assignment is empty.
; For each entry: LINE MATRIX VALUE + BYTE MATRIX VALUE
_cpcrslib_keys_table:
key_00_x: 	dw KEY_RIGHT
key_01_x: 	dw KEY_LEFT
key_02_x: 	dw KEY_UP
key_03_x: 	dw KEY_DOWN
key_04_x:	dw KEY_P
key_05_x:  	dw KEY_O
key_06_x:  	dw KEY_Q
key_07_x:  	dw KEY_A
key_08_x:  	dw KEY_SPACE
key_09_x:  	dw KEY_J1RIGHT
key_10_x:  	dw KEY_J1LEFT
key_11_x:  	dw KEY_J1UP
key_12_x:  	dw KEY_J1DOWN
key_13_x:  	dw KEY_J1FIRE1
key_14_x:  	dw KEY_J1FIRE2
key_15_x:  	dw KEY_ESC

; KEY CODE CONSTANTS

KEY_EMPTY   equ &FFFF

KEY_FDOT    equ &4080
KEY_FENTER  equ &4040
KEY_F3      equ &4020
KEY_F6      equ &4010
KEY_F9      equ &4008
KEY_DOWN    equ &4004
KEY_RIGHT   equ &4002
KEY_UP      equ &4001

KEY_F0      equ &4180
KEY_F2      equ &4140
KEY_F1      equ &4120
KEY_F5      equ &4110
KEY_F8      equ &4108
KEY_F7      equ &4104
KEY_COPY    equ &4102
KEY_LEFT    equ &4101

KEY_CTRL    equ &4280
KEY_BSLASH  equ &4240
KEY_SHIFT   equ &4220
KEY_F4      equ &4210
KEY_RSQUARE equ &4208
KEY_RETURN  equ &4204
KEY_LSQUARE equ &4202
KEY_CLR     equ &4201

KEY_DOT     equ &4380
KEY_FSLASH  equ &4340
KEY_COLON   equ &4320
KEY_SCOLON  equ &4310
KEY_P       equ &4308
KEY_AT      equ &4304
KEY_MINUS   equ &4302
KEY_EXP     equ &4301

KEY_COMMA   equ &4480
KEY_M       equ &4440
KEY_K       equ &4420
KEY_L       equ &4410
KEY_I       equ &4408
KEY_O       equ &4404
KEY_9       equ &4402
KEY_0       equ &4401

KEY_SPACE   equ &4580
KEY_N       equ &4540
KEY_J       equ &4520
KEY_H       equ &4510
KEY_Y       equ &4508
KEY_U       equ &4504
KEY_7       equ &4502
KEY_8       equ &4501

KEY_V       equ &4680
KEY_B       equ &4640
KEY_F       equ &4620
KEY_G       equ &4610
KEY_T       equ &4608
KEY_R       equ &4604
KEY_5       equ &4602
KEY_6       equ &4601

KEY_J2FIRE3 equ &4640
KEY_J2FIRE2 equ &4620
KEY_J2FIRE1 equ &4610
KEY_J2RIGHT equ &4608
KEY_J2LEFT  equ &4604
KEY_J2DOWN  equ &4602
KEY_J2UP    equ &4601

KEY_X       equ &4780
KEY_C       equ &4740
KEY_D       equ &4720
KEY_S       equ &4710
KEY_W       equ &4708
KEY_E       equ &4704
KEY_3       equ &4702
KEY_4       equ &4701

KEY_Z       equ &4880
KEY_CAPS    equ &4840
KEY_A       equ &4820
KEY_TAB     equ &4810
KEY_Q       equ &4808
KEY_ESC     equ &4804
KEY_2       equ &4802
KEY_1       equ &4801

KEY_DEL     equ &4980
KEY_J1FIRE3 equ &4940
KEY_J1FIRE2 equ &4920
KEY_J1FIRE1 equ &4910
KEY_J1RIGHT equ &4908
KEY_J1LEFT  equ &4904
KEY_J1DOWN  equ &4902
KEY_J1UP    equ &4901
