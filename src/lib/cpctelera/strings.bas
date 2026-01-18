' MODULE CPCTELERA/STRINGS

' Functions and Procedures:

SUB cpctSetDrawCharM2(fg, bg) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "jp      cpct_setDrawCharM2"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM2.asm'"
END SUB

SUB cpctDrawCharM2(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM2"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM2.asm'"
END SUB

SUB cpctSetDrawCharM1(fg, bg) ASM
    ASM "ld      d,(ix+0)"
    ASM "ld      e,(ix+2)"
    ASM "jp      cpct_setDrawCharM1"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM1.asm'"
END SUB

SUB cpctDrawCharM1(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM1"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM1.asm'"
END SUB

SUB cpctSetDrawCharM0(fg, bg) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "jp      cpct_setDrawCharM0"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM0.asm'"
END SUB

SUB cpctDrawCharM0(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM0"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM0.asm'"
END SUB
