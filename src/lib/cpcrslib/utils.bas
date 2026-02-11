' MODULE CPCRSLIB/UTILS

SUB rsPause(halts) ASM
    ASM "ld      l,(ix+0)    ; Number of interrupts"
    ASM "ld      h,(ix+1)    ; 6 interrupts per frame in PAL systems"
    ASM "jp      cpc_Pause"
    ASM "read 'asm/cpcrslib/utils/pause.asm'"
END SUB

FUNCTION rsRandom ASM
    ASM "jp      cpc_Random  ; integer value in the range 0-255"
    ASM "read 'asm/cpcrslib/utils/random.asm'"
END FUNCTION