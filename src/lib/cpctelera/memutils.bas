' MODULE CPCTELERA/MEMUTILS

' Functions and Procedures:

SUB cpctMemset(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      b,(ix+1)"
    ASM "ld      a,(ix+2)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_memset"
    ASM "read 'asm/cpctelera/memutils/cpct_memset.asm'"
END SUB

SUB cpctWaitHalts(halts) ASM
    ASM "ld      b,(ix+0)"
    ASM "jp      cpct_waitHalts"
    ASM "read 'asm/cpctelera/memutils/cpct_waitHalts.asm'"
END SUB