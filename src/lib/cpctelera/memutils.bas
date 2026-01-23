' MODULE CPCTELERA/MEMUTILS

' Functions and Procedures:


SUB cpctWaitHalts(halts) ASM
    ASM "ld      b,(ix+0)"
    ASM "jp      cpct_waitHalts"
    ASM "read 'asm/cpctelera/memutils/cpct_waitHalts.asm'"
END SUB