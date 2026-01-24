' MODULE CPCTELERA/VIDEO

' Functions and Procedures:


' read once all the video macros as they don't consume space if are not used
ASM "read 'asm/cpctelera/video/video_macros.asm'"

CONST CPCT.VMEMSTART    = &C000

CONST FWC.BLACK         =  0
CONST FWC.BLUE          =  1
CONST FWC.BRIGHTBLUE    =  2
CONST FWC.RED           =  3
CONST FWC.MAGENTA       =  4
CONST FWC.MAUVE         =  5
CONST FWC.BRIGHTRED     =  6
CONST FWC.PURPLE        =  7
CONST FWC.BRIGHTMAGENTA =  8
CONST FWC.GREEN         =  9
CONST FWC.CYAN          = 10
CONST FWC.SKYBLUE       = 11
CONST FWC.YELLOW        = 12
CONST FWC.WHITE         = 13
CONST FWC.PASTELBLUE    = 14
CONST FWC.ORANGE        = 15
CONST FWC.PINK          = 16
CONST FWC.PASTERMAGENTA = 17
CONST FWC.BRIGHTGREEN   = 18
CONST FWC.SEAGREEN      = 19
CONST FWC.BRIGHTCYAN    = 20
CONST FWC.LIME          = 21
CONST FWC.PASTELGREEN   = 22
CONST FWC.PASTELCYAN    = 23
CONST FWC.BRIGHTYELLOW  = 24
CONST FWC.PASTELYELLOW  = 25
CONST FWC.BRIGHTWHITE   = 26

CONST HWC.BLACK         = 20
CONST HWC.BLUE          =  4
CONST HWC.BRIGHTBLUE    = 21
CONST HWC.RED           = 28
CONST HWC.MAGENTA       = 24
CONST HWC.MAUVE         = 29
CONST HWC.BRIGHTRED     = 12
CONST HWC.PURPLE        =  5
CONST HWC.BRIGHTMAGENTA = 13
CONST HWC.GREEN         = 22
CONST HWC.CYAN          =  6
CONST HWC.SKYBLUE       = 23
CONST HWC.YELLOW        = 30
CONST HWC.WHITE         =  0
CONST HWC.PASTELBLUE    = 31
CONST HWC.ORANGE        = 14
CONST HWC.PINK          =  7
CONST HWC.PASTERMAGENTA = 15
CONST HWC.BRIGHTGREEN   = 18
CONST HWC.SEAGREEN      =  2
CONST HWC.BRIGHTCYAN    = 19
CONST HWC.LIME          = 26
CONST HWC.PASTELGREEN   = 25
CONST HWC.PASTELCYAN    = 27
CONST HWC.BRIGHTYELLOW  = 10
CONST HWC.PASTELYELLOW  =  3
CONST HWC.BRIGHTWHITE   = 11

SUB cpctClearScreen(color) ASM
    ASM "ld      a,(ix+0)"
    ASM "cpctm_clearScreen a"
    ASM "ret"
END SUB

SUB cpctClearScreenf64(color) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      d,(ix+0)"
    ASM "ld      hl,&C000"
    ASM "ld      bc,&4000"
    ASM "jp      cpct_memset_f64"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f64.asm'"
END SUB

SUB cpctFW2HW(paldir, items) ASM
    ASM "ld      c,(ix+0)     ; items"
    ASM "ld      b,(ix+1)"
    ASM "ld      e,(ix+2)     ; palette address"
    ASM "ld      d,(ix+3)"
    ASM "jp      cpct_fw2hw"
    ASM "read 'asm/cpctelera/video/cpct_fw2hw.asm'"
END SUB

FUNCTION cpctGetHWColour(fwcol) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    cpct_getHWColour"
    ASM "ld      h,0 ; L has the result"
    ASM "ret"
    ASM "read 'asm/cpctelera/video/cpct_getHWColour.asm'"
END FUNCTION

FUNCTION cpctGetScreenPtr(vstart, x, y) ASM
    ASM "ld      b,(ix+0)            ; y position - first byte"
    ASM "ld      c,(ix+2)            ; x position - first byte"
    ASM "ld      e,(ix+4)            ; video memory start address"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_getScreenPtr   ; returns in HL the address"
    ASM "read 'asm/cpctelera/video/cpct_getScreenPtr.asm'"
END FUNCTION

SUB cpctSetBorder(hwcolor) ASM
    ASM "ld      h,(ix+0)     ; H = INK"
    ASM "ld      l,16         ; L = BORDER PEN"
    ASM "jp      cpct_setPALColour"
    ASM "read 'asm/cpctelera/video/cpct_setPALColour.asm'"
END SUB

SUB cpctSetPALColour(ipen, hwcolor) ASM
    ASM "ld      h,(ix+0)     ; H = INK"
    ASM "ld      l,(ix+2)     ; L = PEN"
    ASM "jp      cpct_setPALColour"
    ASM "read 'asm/cpctelera/video/cpct_setPALColour.asm'"
END SUB

SUB cpctSetPalette(palptr, items) ASM
    ASM "ld      e,(ix+0)            ; number of colours"
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)            ; array pointer"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_setPalette"
    ASM "read 'asm/cpctelera/video/cpct_setPalette.asm'"
END SUB

SUB cpctSetVideoMode(vmode) ASM
    ASM "ld      c,(ix+0)"
    ASM "jp      cpct_setVideoMode"
    ASM "read 'asm/cpctelera/video/cpct_setVideoMode.asm'"
END SUB

SUB cpctWaitVSYNC ASM
    ASM "jp      cpct_waitVSYNC"
    ASM "read 'asm/cpctelera/video/cpct_waitVSYNC.asm'"
END SUB