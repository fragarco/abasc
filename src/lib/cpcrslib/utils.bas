
' CPCRSLIB is a C library originally created by
' Raul Simarro (Artaburu) - 2009, 2012
' Modified to be used with BASC by Javier Garcia (Dwayne Hicks)

' MODULE UTILS:
' cpcDisableFirmware()
' cpcEnableFirmware()
' cpcRandom()

sub cpcDisableFirmware asm
	' Inserts the code EI:RET in the jump block used by the Firmware when an
	' interrupt happens (300 times per second/ 6 times per frame).
	asm "di"
	asm "ld      hl,(&0038)"
	asm "ld      (cpcfwbackup),hl"
	asm "ld      hl,&c9fb"
	asm "ld      (&0038),hl"
	asm "ei"
	asm "ret"
	asm "cpcfwbackup: dw 0"
end sub

sub cpcEnableFirmware asm
	' Restores the jumpblock used by the Firmware when a hardware interrupt occurs.
	asm "di"
	asm "ld      hl,(cpcfwbackup)"
	asm "ld      (&0038),hl"
	asm "ei"
	asm "ret"
end sub

function cpcRandom asm
	' Returns a random number in the range 0-255
	asm "ld      a,(cpcprevrnd)"
	asm "ld      l,a"
	asm "ld      a,r"
	asm "add     l"
	asm "ld      (cpcprevrnd),a"
	asm "ld      l,a"
	asm "ld      h,0"
	asm "ret"
	asm "cpcprevrnd: db &FF"
end function