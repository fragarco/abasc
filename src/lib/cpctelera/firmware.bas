' MODULE CPCTELERA/FIRMWARE

' Functions and Procedures:


FUNCTION cpctRemoveInterruptHandler ASM
    ASM "jp      cpct_removeInterruptHandler ; returns in HL current callback address"
    ASM "read 'asm/cpctelera/firmware/cpct_removeInterruptHandler.asm'"
END FUNCTION

SUB cpctSetInterruptHandler(cbaddress) ASM
    ASM "ld      l,(ix+0)   ; address to the routine (callback) that will be called"
    ASM "ld      h,(ix+1)   ; for each interrupt"
    ASM "jp      cpct_setInterruptHandler"
    ASM "read 'asm/cpctelera/firmware/cpct_setInterruptHandler.asm'"
END SUB