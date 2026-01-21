' MODULE CPCTELERA/VIDEO

' Functions and Procedures:


' read once all the video macros as they don't consume space if are not used
ASM "read 'asm/cpctelera/video/video_macros.asm'"

CONST CPCT.VMEMSTART = &C000

SUB cpctClearScreen(color) ASM
    ASM "ld      a,(ix+0)"
    ASM "cpctm_clearScreen a"
    ASM "ret"
END SUB

SUB cpctSetVideoMode(vmode) ASM
    ASM "ld      c,(ix+0)"
    ASM "jp      cpct_setVideoMode"
    ASM "read 'asm/cpctelera/video/cpct_setVideoMode.asm'"
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

SUB cpctSetPalette(palptr, items) ASM
    ASM "ld      e,(ix+0)            ; number of colours"
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)            ; array pointer"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_setPalette"
    ASM "read 'asm/cpctelera/video/cpct_setPalette.asm'"
END SUB