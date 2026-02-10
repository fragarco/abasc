' MODULE CPCRSLIB/TEXT

SUB rsPrintGphStrStd(npen, text$, vmem) ASM
    ASM "ld      e,(ix+0)   ; address to the null-terminated string"
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)   ; video memory address"
    ASM "ld      h,(ix+3)"
    ASM "ld      a,(ix+4)   ; pen color (1-4)"
    ASM "jp      cpc_Print_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
END SUB

SUB rsPrintGphStrStdXY(npen, text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; address to the null-terminated string"
    ASM "ld      l,(ix+2)"
    ASM "ld      e,(ix+4)   ; video memory address"
    ASM "ld      d,(ix+5)"
    ASM "ld      a,(ix+6)   ; pen color (1-4)"
    ASM "jp      cpc_PrintXY_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
END SUB
