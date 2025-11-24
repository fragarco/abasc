
' CPCRSLIB is a C library originally created by
' Raul Simarro (Artaburu) - 2009, 2012
' Modified to be used with BASC by Javier Garcia (Dwayne Hicks)

' MODULE VIDEO:
' cpcClrScr()
' cpcSetMode(mode)

sub cpcClrScr asm
    ' Equivalent to BASIC CLS command. Fills all video memory with 0s
    ' However, screen cursor is NOT moved to the top left corner.
	asm "xor     a"
	asm "ld      hl,&C000"
	asm "ld      de,&C001"
	asm "ld      bc,&3FFF"
	asm "ld      (hl),a"
	asm "ldir"
	asm "ret"
end sub

sub cpcSetColor(i,c) asm
    ' Equivalent to the BASIC call INK
    ' param 1: is the ink number (0-16) bening 16 the border color.
    ' param 2: color in Hardware values - &40 (i.e &14 for &54 black)
    asm "ld      bc,&7F00 ; Gate Array"
    asm "ld      a,(ix+2) ; ink number"
    asm "out     (c),a"
    asm "ld      a,&40"
    asm "ld      e,(ix+0) ; HW color"
    asm "or      e"
    asm "out     (c),a"
 	asm "ret"
end sub

sub cpcSetMode(m) asm
    ' Equivalent to the BASIC command 
    ' param 1: mode (0-2)
    asm "ld      a,(ix+0)"
	asm "ld      bc,&7F00 ; Gate array port"
	asm "Ld      d,&8C    ; Mode and ROM selection"
	asm "add     d        ; Add mode as last 2 bits"
	asm "out     (c),a"
	asm "ret"
end sub
