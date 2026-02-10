' MODULE CPCRSLIB/VIDEO

const RSFW.BLUE           = 0
const RSFW.BRIGHTBLUE     = 1
const RSFW.RED            = 2 
const RSFW.MAGENTA        = 3
const RSFW.BLACK          = 4
const RSFW.MAUVE          = 5
const RSFW.BRIGHTRED      = 6
const RSFW.PURPLE         = 7
const RSFW.BRIGHTMAGENTA  = 8
const RSFW.GREEN          = 9
const RSFW.CYAN           = 10
const RSFW.SKYBLUE        = 11
const RSFW.YELLOW         = 12
const RSFW.WHITE          = 13
const RSFW.PASTELBLUE     = 14
const RSFW.ORANGE         = 15
const RSFW.PINK           = 16
const RSFW.PASTELMAGENTA  = 17
const RSFW.BRIGHTGREEN    = 18
const RSFW.SEAGREEN       = 19
const RSFW.BRIGHTCYAN     = 20
const RSFW.LIME           = 21
const RSFW.PASTELGREEN    = 22
const RSFW.PASTELCYAN     = 23
const RSFW.BRIGHTYELLOW   = 24
const RSFW.PASTELYELLOW   = 25
const RSFW.BRIGHTWHITE    = 26

const RSHW.BLUE           = &54 
const RSHW.BRIGHTBLUE     = &44 
const RSHW.RED            = &55 
const RSHW.MAGENTA        = &5C 
const RSHW.BLACK          = &58 
const RSHW.MAUVE          = &5D 
const RSHW.BRIGHTRED      = &4C 
const RSHW.PURPLE         = &45 
const RSHW.BRIGHTMAGENTA  = &4D 
const RSHW.GREEN          = &56 
const RSHW.CYAN           = &46
const RSHW.SKYBLUE        = &57
const RSHW.YELLOW         = &5E
const RSHW.WHITE          = &40
const RSHW.PASTELBLUE     = &5F
const RSHW.ORANGE         = &4E
const RSHW.PINK           = &47
const RSHW.PASTELMAGENTA  = &4F 
const RSHW.BRIGHTGREEN    = &52 
const RSHW.SEAGREEN       = &42 
const RSHW.BRIGHTCYAN     = &53 
const RSHW.LIME           = &5A 
const RSHW.PASTELGREEN    = &59 
const RSHW.PASTELCYAN     = &5B 
const RSHW.BRIGHTYELLOW   = &4A 
const RSHW.PASTELYELLOW   = &43 
const RSHW.BRIGHTWHITE    = &4B 

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
