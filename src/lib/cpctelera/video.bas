' MODULE CPCTELERA/VIDEO

' Functions and Procedures:


' read once all the video macros as they don't consume space if are not used
ASM "read 'asm/cpctelera/video/video_macros.asm'"

CONST CPCT.VMEMSTART    = &C000

CONST FWC.Black         =  0
CONST FWC.Blue          =  1
CONST FWC.BrightBlue    =  2
CONST FWC.Red           =  3
CONST FWC.Magenta       =  4
CONST FWC.Mauve         =  5
CONST FWC.BrightRed     =  6
CONST FWC.Purple        =  7
CONST FWC.BrightMagenta =  8
CONST FWC.Green         =  9
CONST FWC.Cyan          = 10
CONST FWC.SkyBlue       = 11
CONST FWC.Yellow        = 12
CONST FWC.White         = 13
CONST FWC.PastelBlue    = 14
CONST FWC.Orange        = 15
CONST FWC.Pink          = 16
CONST FWC.PasterMagenta = 17
CONST FWC.BrightGreen   = 18
CONST FWC.SeaGreen      = 19
CONST FWC.BrightCyan    = 20
CONST FWC.Lime          = 21
CONST FWC.PastelGreen   = 22
CONST FWC.PastelCyan    = 23
CONST FWC.BrightYellow  = 24
CONST FWC.PastelYellow  = 25
CONST FWC.BrightWhite   = 26

CONST HWC.Black         = 20
CONST HWC.Blue          =  4
CONST HWC.BrightBlue    = 21
CONST HWC.Red           = 28
CONST HWC.Magenta       = 24
CONST HWC.Mauve         = 29
CONST HWC.BrightRed     = 12
CONST HWC.Purple        =  5
CONST HWC.BrightMagenta = 13
CONST HWC.Green         = 22
CONST HWC.Cyan          =  6
CONST HWC.SkyBlue       = 23
CONST HWC.Yellow        = 30
CONST HWC.White         =  0
CONST HWC.PastelBlue    = 31
CONST HWC.Orange        = 14
CONST HWC.Pink          =  7
CONST HWC.PasterMagenta = 15
CONST HWC.BrightGreen   = 18
CONST HWC.SeaGreen      =  2
CONST HWC.BrightCyan    = 19
CONST HWC.Lime          = 26
CONST HWC.PastelGreen   = 25
CONST HWC.PastelCyan    = 27
CONST HWC.BrightYellow  = 10
CONST HWC.PastelYellow  =  3
CONST HWC.BrightWhite   = 11

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

SUB cpctSetBorder(color) ASM
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