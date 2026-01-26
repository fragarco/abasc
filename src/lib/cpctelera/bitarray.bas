' MODULE CPCTELERA/BITARRAY

' Functions and Procedures:

FUNCTION cpctGetBit(arrayptr, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "call    cpct_getbit"
    ASM "ld      hl,0"
    ASM "ret     z"
    ASM "inc     hl"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_getbit.asm'"
END FUNCTION

FUNCTION cpctGet2Bits(arrayptr, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "call    cpct_get2bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get2bits.asm'"
END FUNCTION

FUNCTION cpctGet4Bits(arrayptr, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "call    cpct_get4bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get4bits.asm'"
END FUNCTION

FUNCTION cpctGet6Bits(arrayptr, index) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "call    cpct_get6bits"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/bitarray/cpct_get6bits.asm'"
END FUNCTION

SUB cpctSetBit(arrayptr, value, index) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_setbit"
    ASM "read 'asm/cpctelera/bitarray/cpct_setbit.asm'"
END SUB

SUB cpctSet2Bits(arrayptr, value, index) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpctSet2Bits"
    ASM "read 'asm/cpctelera/bitarray/cpctSet2Bits.asm'"
END SUB

SUB cpctSet4Bits(arrayptr, value, index) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpctSet4Bits"
    ASM "read 'asm/cpctelera/bitarray/cpctSet4Bits.asm'"
END SUB

SUB cpctSet6Bits(arrayptr, value, index) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpctSet6Bits"
    ASM "read 'asm/cpctelera/bitarray/cpctSet6Bits.asm'"
END SUB