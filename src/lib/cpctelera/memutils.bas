' MODULE CPCTELERA/MEMUTILS

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
    ASM "ld      c,(ix+0) ; bytes  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      e,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpct_memset_f64"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f64.asm'"
END SUB

SUB cpctMemsetf64i(arrayptr, value, bytes) ASM
    ASM "ld      c,(ix+0) ; bytes  - Number of bytes to be set (>= 64, multiple of 64)"
    ASM "ld      b,(ix+1)"
    ASM "ld      e,(ix+2) ; value - 16-bit value to be set (Pair of bytes)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+4) ; arrayptr - Pointer to the first byte of the array to be filled up (starting point in memory)"
    ASM "ld      h,(ix+5)"
    ASM "jp      cpct_memset_f64_i"
    ASM "read 'asm/cpctelera/memutils/cpct_memset_f64_i.asm'"
END SUB

const RAM.BANK0 = 0  ' BANK_0: RAM_4 -> 10000-13FFF, RAM_5 -> 14000-17FFF, RAM_6 -> 18000-1BFFF, RAM_7 -> 1C000-1FFFF
const RAM.BANK1 = 8  ' BANK_1: RAM_4 -> 20000-23FFF, RAM_5 -> 24000-27FFF, RAM_6 -> 28000-1BFFF, RAM_7 -> 2C000-1FFFF
const RAM.BANK2 = 16 ' BANK_2: RAM_4 -> 30000-33FFF, RAM_5 -> 34000-37FFF, RAM_6 -> 38000-3BFFF, RAM_7 -> 3C000-3FFFF
const RAM.BANK3	= 24 ' BANK_3: RAM_4 -> 40000-43FFF, RAM_5 -> 44000-47FFF, RAM_6 -> 48000-4BFFF, RAM_7 -> 4C000-4FFFF
const RAM.BANK4	= 32 ' BANK_4: RAM_4 -> 50000-53FFF, RAM_5 -> 54000-57FFF, RAM_6 -> 58000-5BFFF, RAM_7 -> 5C000-5FFFF
const RAM.BANK5 = 40 ' BANK_5: RAM_4 -> 60000-63FFF, RAM_5 -> 64000-67FFF, RAM_6 -> 68000-6BFFF, RAM_7 -> 6C000-6FFFF
const RAM.BANK6	= 48 ' BANK_6: RAM_4 -> 70000-73FFF, RAM_5 -> 74000-77FFF, RAM_6 -> 78000-7BFFF, RAM_7 -> 7C000-7FFFF
const RAM.BANK7	= 56 ' BANK_7: RAM_4 -> 80000-83FFF, RAM_5 -> 84000-87FFF, RAM_6 -> 88000-8BFFF, RAM_7 -> 8C000-8FFFF

const RAM.CFG0 = 0 ' RAMCFG_0: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_1, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
const RAM.CFG1 = 1 ' RAMCFG_1: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_1, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_7
const RAM.CFG2 = 2 ' RAMCFG_2: 0000-3FFF -> RAM_4, 4000-7FFF -> RAM_5, 8000-BFFF -> RAM_6, C000-FFFF -> RAM_7
const RAM.CFG3 = 3 ' RAMCFG_3: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_3, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_7
const RAM.CFG4 = 4 ' RAMCFG_4: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_4, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
const RAM.CFG5 = 5 ' RAMCFG_5: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_5, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
const RAM.CFG6 = 6 ' RAMCFG_6: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_6, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
const RAM.CFG7 = 7 ' RAMCFG_7: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_7, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3

const RAM.DEFAULTCFG = 0 ' RAMCFG_0 | BANK_0

SUB cpctPageMemory(bankvalue) ASM
    ASM "ld      a,(ix+0) ; configAndBankValue - RAM pages configuration"
    ASM "jp      cpct_pageMemory"
    ASM "read 'asm/cpctelera/memutils/cpct_pageMemory.asm'"
END SUB

SUB cpctSetStackLocation(halts) ASM
    ASM "pop     bc                    ; store current return address"
    ASM "pop     hl                    ; get the new stack address"
    ASM "call    cpct_setStackLocation ; change stack position"
    ASM "push    hl                    ; restore the stack memory consummed by the argument"
    ASM "push    bc                    ; restore return address"
    ASM "ret"
    ASM "read 'asm/cpctelera/memutils/cpct_setStackLocation.asm'"
END SUB

SUB cpctWaitHalts(halts) ASM
    ASM "ld      b,(ix+0)"
    ASM "jp      cpct_waitHalts"
    ASM "read 'asm/cpctelera/memutils/cpct_waitHalts.asm'"
END SUB
