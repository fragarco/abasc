' MODULE CPCTELERA/RANDOM

SUB cpctSRand(seed) ASM
    ASM "ld      l,(ix+0)   ; The parameter is a 32 bits number"
    ASM "ld      h,(ix+1)   ; so we invert the argument"
    ASM "ld      d,(ix+0)   ; a seed = &FFAA will provide the value"
    ASM "ld      e,(ix+1)   ; &AAFFFFAA"
    ASM "call    cpct_setSeed_mxor"
    ASM "jp      cpct_restoreState_mxor_u8"
    ASM "read    'asm/cpctelera/random/cpct_setSeed_mxor.asm'"
    ASM "read    'asm/cpctelera/random/cpct_restoreState_mxor_u8.asm'"
END SUB

FUNCTION cpctRand ASM
    ASM "call    cpct_getRandom_mxor_u8   ; L = generated random number"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read    'asm/cpctelera/random/cpct_getRandom_mxor_u8.asm'"
END FUNCTION