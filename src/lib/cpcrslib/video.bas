' MODULE CPCRSLIB/VIDEO

CONST RSFW.BLACK         =  0
CONST RSFW.BLUE          =  1
CONST RSFW.BRIGHTBLUE    =  2
CONST RSFW.RED           =  3
CONST RSFW.MAGENTA       =  4
CONST RSFW.MAUVE         =  5
CONST RSFW.BRIGHTRED     =  6
CONST RSFW.PURPLE        =  7
CONST RSFW.BRIGHTMAGENTA =  8
CONST RSFW.GREEN         =  9
CONST RSFW.CYAN          = 10
CONST RSFW.SKYBLUE       = 11
CONST RSFW.YELLOW        = 12
CONST RSFW.WHITE         = 13
CONST RSFW.PASTELBLUE    = 14
CONST RSFW.ORANGE        = 15
CONST RSFW.PINK          = 16
CONST RSFW.PASTERMAGENTA = 17
CONST RSFW.BRIGHTGREEN   = 18
CONST RSFW.SEAGREEN      = 19
CONST RSFW.BRIGHTCYAN    = 20
CONST RSFW.LIME          = 21
CONST RSFW.PASTELGREEN   = 22
CONST RSFW.PASTELCYAN    = 23
CONST RSFW.BRIGHTYELLOW  = 24
CONST RSFW.PASTELYELLOW  = 25
CONST RSFW.BRIGHTWHITE   = 26

CONST RSHW.BLACK         = 20
CONST RSHW.BLUE          =  4
CONST RSHW.BRIGHTBLUE    = 21
CONST RSHW.RED           = 28
CONST RSHW.MAGENTA       = 24
CONST RSHW.MAUVE         = 29
CONST RSHW.BRIGHTRED     = 12
CONST RSHW.PURPLE        =  5
CONST RSHW.BRIGHTMAGENTA = 13
CONST RSHW.GREEN         = 22
CONST RSHW.CYAN          =  6
CONST RSHW.SKYBLUE       = 23
CONST RSHW.YELLOW        = 30
CONST RSHW.WHITE         =  0
CONST RSHW.PASTELBLUE    = 31
CONST RSHW.ORANGE        = 14
CONST RSHW.PINK          =  7
CONST RSHW.PASTERMAGENTA = 15
CONST RSHW.BRIGHTGREEN   = 18
CONST RSHW.SEAGREEN      =  2
CONST RSHW.BRIGHTCYAN    = 19
CONST RSHW.LIME          = 26
CONST RSHW.PASTELGREEN   = 25
CONST RSHW.PASTELCYAN    = 27
CONST RSHW.BRIGHTYELLOW  = 10
CONST RSHW.PASTELYELLOW  =  3
CONST RSHW.BRIGHTWHITE   = 11 

SUB rsClrScr ASM
    ASM "jp      cpc_ClearScr"
    ASM "read 'asm/cpcrslib/video/clearscr.asm'"
END SUB

FUNCTION rsGetScrAddress(x, y) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "jp      cpc_GetScrAddress"
    ASM "read 'asm/cpcrslib/video/getscraddress.asm'"
END FUNCTION

SUB rsRLI(vmem, w, h) ASM
    ASM "ld      d,(ix+0)"
    ASM "ld      e,(ix+2)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpc_RLI"
    ASM "read 'asm/cpcrslib/video/rli.asm'"
END SUB

SUB rsRRI(vmem, w, h) ASM
    ASM "ld      d,(ix+0)"
    ASM "ld      e,(ix+2)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpc_RRI"
    ASM "read 'asm/cpcrslib/video/rri.asm'"
END SUB

SUB rsSetColour(npen, hwcolour) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+2)"
    ASM "jp      cpc_SetColor"
    ASM "read 'asm/cpcrslib/video/setcolor.asm'"
END SUB

SUB rsSetMode(nmode) ASM
    ASM "ld      a,(ix+0)"
    ASM "jp      cpc_SetMode"
    ASM "read 'asm/cpcrslib/video/setmode.asm'"
END SUB
