' MODULE CPCTELERA/VIDEO

' Functions and Procedures:


' read once all the video macros as they don't consume space if are not used
ASM "read 'asm/cpctelera/video/video_macros.asm'"

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
