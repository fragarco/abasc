' MODULE CPCTELERA/STRINGS

SUB cpctDrawCharM0(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM0"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM0.asm'"
END SUB

SUB cpctDrawCharM1(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM1"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM1.asm'"
END SUB

SUB cpctDrawCharM2(vmem, chnum) ASM
    ASM "ld      e,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawCharM2"
    ASM "read 'asm/cpctelera/strings/cpct_drawCharM2.asm'"
END SUB

SUB cpctDrawStringM0(s$, vmem) ASM
    ASM "ld      l,(ix+0)   ; video memory destination"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; string address"
    ASM "ld      d,(ix+3)"
    ASM "push    de"
    ASM "pop     iy"
    ASM "jp      cpct_drawStringM0"
    ASM "read 'asm/cpctelera/strings/cpct_drawStringM0.asm'"
END SUB

SUB cpctDrawStringM1(s$, vmem) ASM
    ASM "ld      l,(ix+0)   ; video memory destination"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; string address"
    ASM "ld      d,(ix+3)"
    ASM "push    de"
    ASM "pop     iy"
    ASM "jp      cpct_drawStringM1"
    ASM "read 'asm/cpctelera/strings/cpct_drawStringM1.asm'"
END SUB

SUB cpctDrawStringM2(s$, vmem) ASM
    ASM "ld      l,(ix+0)   ; video memory destination"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)   ; string address"
    ASM "ld      d,(ix+3)"
    ASM "push    de"
    ASM "pop     iy"
    ASM "jp      cpct_drawStringM2"
    ASM "read 'asm/cpctelera/strings/cpct_drawStringM2.asm'"
END SUB

SUB cpctSetDrawCharM0(fg, bg) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "jp      cpct_setDrawCharM0"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM0.asm'"
END SUB

SUB cpctSetDrawCharM1(fg, bg) ASM
    ASM "ld      d,(ix+0)"
    ASM "ld      e,(ix+2)"
    ASM "jp      cpct_setDrawCharM1"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM1.asm'"
END SUB

SUB cpctSetDrawCharM2(fg, bg) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "jp      cpct_setDrawCharM2"
    ASM "read 'asm/cpctelera/strings/cpct_setDrawCharM2.asm'"
END SUB
