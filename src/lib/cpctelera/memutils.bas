' MODULE CPCTELERA/MEMUTILS

' Functions and Procedures:

SUB cpctMemset(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; size  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      a,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      e,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_memset"
    ASM "read 'asm/cpctelera/memutils/cpct_memset.asm'"
END SUB

SUB cpctMemsetf64(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; size  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      a,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      e,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_memset_f64"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f64.asm'"
END SUB

SUB cpctWaitHalts(halts) ASM
    ASM "ld      b,(ix+0)"
    ASM "jp      cpct_waitHalts"
    ASM "read 'asm/cpctelera/memutils/cpct_waitHalts.asm'"
END SUB
