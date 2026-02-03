' MODULE CPCTELERA/MEMUTILS

' Functions and Procedures:

SUB cpctMemcpy(toptr, fromptr, bytes) ASM
    ASM "ld      c,(ix+0) ; bytes  - Number of bytes to be set (>= 1)"
    ASM "ld      b,(ix+1)"
    ASM "ld      l,(ix+2) ; fromptr - Pointer to the source (first byte from which bytes will be read)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4) ; toptr - Pointer to the destination (first byte where bytes will be written)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_memcpy"
    ASM "read 'asm/cpctelera/memutils/cpct_memcpy.asm'"
END SUB

SUB cpctMemset(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; size  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      a,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      e,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_memset"
    ASM "read 'asm/cpctelera/memutils/cpct_memset.asm'"
END SUB

SUB cpctMemsetf8(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; bytes  - Number of bytes to be set (>= 8, multiple of 8)"
    ASM "ld      b,(ix+1)"
    ASM "ld      e,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpct_memset_f8"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f8.asm'"
END SUB

SUB cpctMemsetf64(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; size  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      e,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpct_memset_f64"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f64.asm'"
END SUB

SUB cpctPageMemory(bankvalue) ASM
    ASM "ld      a,(ix+0) ; configAndBankValue - RAM pages configuration"
    ASM "jp      cpct_pageMemory"
    ASM "read 'asm/cpctelera/memutils/cpct_pageMemory.asm'"
END SUB

SUB cpctSetStackLocation(halts) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      cpct_setStackLocation"
    ASM "read 'asm/cpctelera/memutils/cpct_setStackLocation.asm'"
END SUB

SUB cpctWaitHalts(halts) ASM
    ASM "ld      b,(ix+0)"
    ASM "jp      cpct_waitHalts"
    ASM "read 'asm/cpctelera/memutils/cpct_waitHalts.asm'"
END SUB
