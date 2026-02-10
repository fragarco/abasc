' MODULE CPCTELERA/BITARRAY

FUNCTION cpctGetBit(array$, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "call    cpct_getbit"
    ASM "ld      hl,0"
    ASM "ret     z"
    ASM "inc     hl"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_getBit.asm'"
END FUNCTION

FUNCTION cpctGet2Bits(array$, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "call    cpct_get2bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get2Bits.asm'"
END FUNCTION

FUNCTION cpctGet4Bits(array$, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "call    cpct_get4bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get4Bits.asm'"
END FUNCTION

FUNCTION cpctGet6Bits(array$, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "call    cpct_get6bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get6Bits.asm'"
END FUNCTION

SUB cpctSetBit(array$, value, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "jp      cpct_setbit"
    ASM "read 'asm/cpctelera/bitarray/cpct_setBit.asm'"
END SUB

SUB cpctSet2Bits(array$, value, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "jp      cpct_set2Bits"
    ASM "read 'asm/cpctelera/bitarray/cpct_set2Bits.asm'"
END SUB

SUB cpctSet4Bits(array$, value, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "jp      cpct_set4Bits"
    ASM "read 'asm/cpctelera/bitarray/cpct_set4Bits.asm'"
END SUB

SUB cpctSet6Bits(array$, value, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "inc     de   ; strings use the first byte to store its length"
    ASM "jp      cpctSet6Bits"
    ASM "read 'asm/cpctelera/bitarray/cpct_set6Bits.asm'"
END SUB
