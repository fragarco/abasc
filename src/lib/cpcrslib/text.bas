' MODULE CPCRSLIB/TEXT

SUB rsPrintGphStrStd(npen, text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type string"
    ASM "ld      d,(ix+3)"
    ASM "ld      a,(ix+4)   ; pen color (1-4)"
    ASM "jp      cpc_Print_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
END SUB

SUB rsPrintGphStrStdXY(npen, text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+5)"
    ASM "ld      a,(ix+6)   ; pen color (1-4)"
    ASM "jp      cpc_PrintXY_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
END SUB

SUB rsSelectFontColour ASM
    ASM "ret"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsSelectFontNanako ASM
    ASM "ret"
    ASM "read 'asm/cpcrslib/text/font_nanako.asm'"
END SUB