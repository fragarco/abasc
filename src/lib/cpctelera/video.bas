' MODULE CPCTELERA/VIDEO

' Functions and Procedures:


' read once all the video macros as they don't consume space if are not used
ASM "read 'asm/cpctelera/video/video_macros.asm'"

SUB cpctClearScreen(color) ASM
    ASM "ld      a,(ix+0)"
    ASM "cpctm_clearScreen a"
    ASM "ret"
END SUB
