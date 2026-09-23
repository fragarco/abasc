
CONST PLUS.Black 		= &0000 
CONST PLUS.Blue 		= &0008
CONST PLUS.BrightBlue 	= &000F
CONST PLUS.Red 			= &0080
CONST PLUS.Magenta 		= &0088
CONST PLUS.Mauve 		= &008F
CONST PLUS.BrightRed 	= &00F0
CONST PLUS.Purple 		= &00F8
CONST PLUS.BrightMagenta= &00FF
CONST PLUS.Green 		= &0800 
CONST PLUS.Cyan 		= &0808
CONST PLUS.SkyBlue 		= &080F
CONST PLUS.Yellow 		= &0880
CONST PLUS.White 		= &0888
CONST PLUS.PastelBlue 	= &088F
CONST PLUS.Orange 		= &08F0
CONST PLUS.Pink 		= &08F8
CONST PLUS.PastelMagenta= &08FF
CONST PLUS.BrightGreen 	= &0F00 
CONST PLUS.SeaGreen 	= &0F08
CONST PLUS.BrightCyan 	= &0F0F
CONST PLUS.Lime 		= &0F80
CONST PLUS.PastelGreen 	= &0F88
CONST PLUS.PastelCyan 	= &0F8F
CONST PLUS.BrightYellow = &0FF0
CONST PLUS.PastelYellow = &0FF8
CONST PLUS.BrightWhite 	= &0FFF

CONST PLUS.SPOFF   = 0 	' Sprite Off
CONST PLUS.SPMODE2 = 3	' Sprite Mode 2 scale
CONST PLUS.SPMODE1 = 9	' Sprite Mode 1 scale
CONST PLUS.SPMODE0 = 13	' Sprite Mode 0 Scale
CONST PLUS.SPX2    = 14 ' Sprite Mode 1 2x Scale
CONST PLUS.SPVS    = 15 ' Sprite Vertically stretched

CONST PLUS.PAL 	    = &6400  ' Regular Palette start address
CONST PLUS.SPPAL    = &6422  ' Sprites Palette start address
CONST PLUS.SPDATA   = &4000  ' Sprites Data start address
CONST PLUS.SPDATASZ = &0100  ' Sprites Data block size (256 bytes)
CONST PLUS.SPATTR   = &6000  ' Sprites attributes start address (X, Y, RES)
CONST PLUS.SPATTRSZ = &0008  ' Sprite's attributes block size (8 bytes)

SUB plusEnableAsic ASM
	ASM "; Urusergi version."
	ASM "; Taken from https://www.cpcwiki.eu/index.php/Programming:Unlocking_ASIC"
	ASM "di"
	ASM "ld      bc,&BCFF"
	ASM "out     (c),c"
	ASM "db      &ED,&71 ; out (c),0"
	ASM "ld      a,c"
	ASM "__asic_enableloop:"
	ASM "out     (c),a"
	ASM "ld      h,a	; h = 7654 3210"
	ASM "add     hl,hl	; h = 6543 210*"
	ASM "rra			; a = 7765 4321"
	ASM "add     hl,hl	; h = 5432 10**"
	ASM "xor h:and &F7:xor h	; a = 7765 1321"
	ASM "ld      l,a	; l = 7765 1321"
	ASM "ld      a,h	; a = 5432 10**"
	ASM "rla			; a = 4321 0***"
	ASM "and &88:xor l	; a = (7 xor 4)765 (1 xor 0)321"
	ASM "cp      c"
	ASM "jr      nz,__asic_enableloop"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusDisableFirmwareUpdates ASM
	ASM "; Stop Firmware from updating the colors"
	ASM "; Code by @lightforce6128 (CPCWiki forum)"
	ASM "di"
	ASM "rst     8"
	ASM "dw      &8D55"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusAsicPageIn ASM
	ASM "ld      bc,&7FB8   ; Insert ASIC memory page"
	ASM "out     (c),c      ; in 0x4000-0x7FFF"
	ASM "ret"
END SUB

SUB plusAsicPageOut ASM
	ASM "ld      bc,&7FA0   ; Remove ASIC memory page"
	ASM "out     (c),c      ; from 0x4000-0x7FFF"
	ASM "ret"
END SUB

SUB plusPoke(addr, value) ASM
	ASM "di"
	ASM "ld      e,(ix+0)"
	ASM "ld      h,(ix+3)"
	ASM "ld      l,(ix+2)"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      (hl),e"
	ASM "ld      c,&A0      ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusPokeFast(addr, value) ASM
	ASM "ld      a,(ix+0)"
	ASM "ld      h,(ix+3)"
	ASM "ld      l,(ix+2)"
	ASM "ld      (hl),a"
	ASM "ret"
END SUB

FUNCTION plusPeek(addr) ASM
	ASM "di"
	ASM "ld      l,(ix+0)"
	ASM "ld      h,(ix+1)"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      e,(hl)"
	ASM "inc     hl"
	ASM "ld      d,(hl)"
	ASM "ld      c,&A0      ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ex      de,hl"
	ASM "ei"
	ASM "ret"
END FUNCTION

FUNCTION plusPeekFast(addr) ASM
	ASM "ld      l,(ix+0)"
	ASM "ld      h,(ix+1)"
	ASM "ld      e,(hl)"
	ASM "inc     hl"
	ASM "ld      d,(hl)"
	ASM "ex      de,hl"
	ASM "ret"
END FUNCTION

FUNCTION plusEncodeColor(r, g, b) ASM
	ASM "ld      a,(ix+4)   ; R"
	ASM "sla     a"
	ASM "sla     a"
	ASM "sla     a"
	ASM "sla     a          ; A = RRRR0000"
	ASM "ld      e,a"
	ASM "ld      a,(ix+0)   ; B"
	ASM "or      e"
	ASM "ld      l,a"
	ASM "ld      h,(ix+2)   ; G"
	ASM "ret"
END FUNCTION

SUB plusSetPalColor(pindex, color) ASM
	ASM "di                 ; Colors use GRB format. Each component 0-F"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&6400   ; Screen Palette start address"
	ASM "ld      a,(ix+2)   ; pen index (0-15). 16 = Border"
	ASM "add     a          ; each position is 2 bytes"
	ASM "ld      l,a"
	ASM "ld      a,(ix+0)   ; color low byte"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+1)   ; color high byte"
	ASM "ld      (hl),a"
	ASM "ld      c,&A0      ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetPalColors(istart, colorarray, colors) ASM
	ASM "di                 ; Let's copy more than one color"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      d,&64      ; Screen Palette start address is &6400"
	ASM "ld      a,(ix+4)   ; start index (0-15). 16 = Border"
	ASM "add     a          ; each position is 2 bytes"
	ASM "ld      e,a"
	ASM "ld      h,(ix+3)"
	ASM "ld      l,(ix+2)"
	ASM "ld      b,0"
	ASM "ld      a,(ix+0)   ; number of colors to copy"
	ASM "add     a          ; two bytes per color"
	ASM "ld      c,a"
	ASM "ldir"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; "
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpriteColor(pindex, color) ASM
	ASM "di                 ; Colors use GRB format. Each component 0-F"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&6422   ; Sprite Palette start address"
	ASM "ld      a,(ix+2)   ; pen index (1-15). 0 = transparent"
	ASM "dec     a          ; index to 0-14"
	ASM "add     a          ; each position is 2 bytes"
	ASM "ld      l,a"
	ASM "ld      a,(ix+0)   ; color low byte"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+1)   ; color high byte"
	ASM "ld      (hl),a"
	ASM "ld      c,&A0      ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpriteColors(istart, colorarray, colors) ASM
	ASM "di                 ; Let's copy more than one color"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      d,&64      ; Sprite Palette start address is &6422"
	ASM "ld      a,(ix+4)   ; start index (1-15). 0 = always transparent"
	ASM "dec     a          ; index to 0-14"
	ASM "add     a          ; each position is 2 bytes"
	ASM "add     &22"
	ASM "ld      e,a"
	ASM "ld      h,(ix+3)"
	ASM "ld      l,(ix+2)"
	ASM "ld      b,0"
	ASM "ld      a,(ix+0)   ; number of colors to copy"
	ASM "add     a          ; two bytes per color"
	ASM "ld      c,a"
	ASM "ldir"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; "
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpriteData(spindex, dataaddr) ASM
	ASM "di                 ; Each sprite is 16x16"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&3F00   ; Sprites data start address is &4000 (&3F00 + &100)"
	ASM "ld      b,(ix+2)   ; Sprite index (1-16)"
	ASM "ld      de,&100    ; Sprite length (256 bytes)"
	ASM "__plusspdata_loop:"
	ASM "add     hl,de"
	ASM "djnz    __plusspdata_loop"
	ASM "ex      de,hl"
	ASM "ld      h,(ix+1)"
	ASM "ld      l,(ix+0)"
	ASM "ld      bc,&100"
	ASM "ldir"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpritesData(dataaddr, sprites) ASM
	ASM "di                 ; Each sprite is 16x16"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; "
	ASM "ld      de,&100    ; Each sprite length"
	ASM "ld      hl,0       ; Total bytes to copy"
    ASM "ld      b,(ix+0)   ; Sprites to copy"
	ASM "__plusspsdata_loop:"
	ASM "add     hl,de"
	ASM "djnz    __plusspsdata_loop"
	ASM "ld      b,h"
	ASM "ld      c,l"
	ASM "ld      h,(ix+3)"
	ASM "ld      l,(ix+2)"
	ASM "ld      de,&4000   ; Sprites data start address"
	ASM "ldir"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpritePos(spindex, x, y) ASM
	ASM "di                 ; Each coord is two bytes"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&5FF8   ; Sprites attributes start address is &6000"
	ASM "ld      de,8       ; Attribute block size"
	ASM "ld      b,(ix+4)   ; sp index (1-15)"
	ASM "__plussppos_loop:"
	ASM "add     hl,de      ; sp1 = &6000, sp2 = &6008 ..."
	ASM "djnz    __plussppos_loop"
	ASM "ld      a,(ix+2)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+3)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+0)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+1)"
	ASM "ld      (hl),a"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpritePosX(spindex, x) ASM
	ASM "di                 ; X coord is two bytes"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&5FF8   ; Sprites attributes start address is &6000"
	ASM "ld      de,8       ; Attribute block size"
	ASM "ld      b,(ix+2)   ; sp index (1-15)"
	ASM "__plusspposx_loop:"
	ASM "add     hl,de      ; sp1 = &6000, sp2 = &6008 ..."
	ASM "djnz    __plusspposx_loop"
	ASM "ld      a,(ix+0)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+1)"
	ASM "ld      (hl),a"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpritePosY(spindex, y) ASM
	ASM "di                 ; Y coord is two bytes"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&5FFA   ; Sprites Y attribute start address is &6002"
	ASM "ld      de,8       ; Attribute block size"
	ASM "ld      b,(ix+2)   ; sp index (1-15)"
	ASM "__plusspposy_loop:"
	ASM "add     hl,de      ; sp1 = &6002, sp2 = &600A ..."
	ASM "djnz    __plusspposy_loop"
	ASM "ld      a,(ix+0)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+1)"
	ASM "ld      (hl),a"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpriteRes(spindex, res) ASM
	ASM "di                 ; Resolution is just one byte"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&5FFC   ; Sprites resolution byte starts at &6004"
	ASM "ld      de,8       ; Attribute block size"
	ASM "ld      b,(ix+2)   ; sp index (1-15)"
	ASM "__plusspres_loop:"
	ASM "add     hl,de      ; sp1 = &6004, sp2 = &600C ..."
	ASM "djnz    __plusspres_loop"
	ASM "ld      a,(ix+0)"
	ASM "ld      (hl),a"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusSetSpriteAttr(spindex, x, y, res) ASM
	ASM "di                 ; Coords are two bytes and resolution one"
	ASM "ld      bc,&7FB8   ; Insert ASIC memory block"
	ASM "out     (c),c      ; " 
	ASM "ld      hl,&5FF8   ; Sprites attributes start address is &6000"
	ASM "ld      de,8       ; Attribute block size"
	ASM "ld      b,(ix+6)   ; sp index (1-15)"
	ASM "__plusspattr_loop:"
	ASM "add     hl,de      ; sp1 = &6000, sp2 = &6008 ..."
	ASM "djnz    __plusspattr_loop"
	ASM "ld      a,(ix+4)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+5)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+2)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+3)"
	ASM "ld      (hl),a"
	ASM "inc     hl"
	ASM "ld      a,(ix+0)"
	ASM "ld      (hl),a"
	ASM "ld      bc,&7FA0   ; Release ASIC memory block"
	ASM "out     (c),c      ; BC = &7FA0"
	ASM "ei"
	ASM "ret"
END SUB

SUB plusWaitFrames(frames) ASM
	ASM "ld      b,(ix+0)"
	ASM "_pluswaitloop:"
	ASM "call    &BD19 ; MC_WAIT_FLYBACK"
	ASM "djnz    _pluswaitloop"
	ASM "ret"
END SUB