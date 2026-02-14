' MODULE CPCRSLIB/TEXT

SUB rsPrintGphStrStd(npen, text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type string"
    ASM "ld      d,(ix+3)"
    ASM "ld      a,(ix+4)   ; pen color (1-4)"
    ASM "jp      cpc_Print_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
    ASM "read 'asm/cpcrslib/text/font_nanako.asm'"
END SUB

SUB rsPrintGphStrStdXY(npen, text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+5)"
    ASM "ld      a,(ix+6)   ; pen color (1-4)"
    ASM "jp      cpc_PrintXY_M1"
    ASM "read 'asm/cpcrslib/text/print_m1.asm'"
    ASM "read 'asm/cpcrslib/text/font_nanako.asm'"
END SUB

SUB rsPrintGphStrM0(text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+3)"
    ASM "xor     a"
    ASM "jp      cpc_DrawStr_M0"
    ASM "read 'asm/cpcrslib/text/drawstr_m0.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrXYM0(text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type string"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpc_DrawStrXY_M0"
    ASM "read 'asm/cpcrslib/text/drawstr_m0.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrM0x2(text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+3)"
    ASM "jp      cpc_DrawStr_M0X2"
    ASM "read 'asm/cpcrslib/text/drawstr_m0x2.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrXYM0x2(text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type string"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpc_DrawStrXY_M0X2"
    ASM "read 'asm/cpcrslib/text/drawstr_m0x2.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrM1(text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+3)"
    ASM "xor     a"
    ASM "jp      cpc_DrawStr_M1"
    ASM "read 'asm/cpcrslib/text/drawstr_m1.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrXYM1(text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type string"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpc_DrawStrXY_M1"
    ASM "read 'asm/cpcrslib/text/drawstr_m1.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrM1x2(text$, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; address to the ABASC type strings"
    ASM "ld      d,(ix+3)"
    ASM "jp      cpc_DrawStr_M1X2"
    ASM "read 'asm/cpcrslib/text/drawstr_m1x2.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

SUB rsPrintGphStrXYM1x2(text$, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y position"
    ASM "ld      l,(ix+2)   ; X position"
    ASM "ld      e,(ix+4)   ; address to the ABASC type string"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpc_DrawStrXY_M1X2"
    ASM "read 'asm/cpcrslib/text/drawstr_m1x2.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

const RSTXT0.PEN0  = &00
const RSTXT0.PEN1  = &80
const RSTXT0.PEN2  = &08
const RSTXT0.PEN3  = &88
const RSTXT0.PEN4  = &20
const RSTXT0.PEN5  = &A0
const RSTXT0.PEN6  = &28
const RSTXT0.PEN7  = &A8
const RSTXT0.PEN8  = &02
const RSTXT0.PEN9  = &82
const RSTXT0.PEN10 = &0A
const RSTXT0.PEN11 = &8A
const RSTXT0.PEN12 = &22
const RSTXT0.PEN13 = &A2
const RSTXT0.PEN14 = &2A
const RSTXT0.PEN15 = &AA

SUB rsSetInkGphStrM0(indind, color) ASM
    ASM "ld      hl,_rslib_drawm0_colors"
    ASM "ld      b,0"
    ASM "ld      c,(ix+2)"
    ASM "add     hl,bc"
    ASM "ld      a,(ix+0)"
    ASM "ld      (hl),a"
    ASM "ret"
    ASM "read 'asm/cpcrslib/text/drawstr_m0.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB

const RSTXT1.PEN0 = &00
const RSTXT1.PEN1 = &80
const RSTXT1.PEN2 = &08
const RSTXT1.PEN3 = &88

SUB rsSetInkGphStrM1(indind, color) ASM
    ASM "ld      hl,_rslib_drawm1_colors"
    ASM "ld      b,0"
    ASM "ld      c,(ix+2)"
    ASM "add     hl,bc"
    ASM "ld      a,(ix+0)"
    ASM "ld      (hl),a"
    ASM "ret"
    ASM "read 'asm/cpcrslib/text/drawstr_m1.asm'"
    ASM "read 'asm/cpcrslib/text/font_color.asm'"
END SUB