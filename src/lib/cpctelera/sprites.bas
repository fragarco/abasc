' MODULE CPCTELERA/SPRITES

' Functions and Procedures:

FUNCTION cpctpx2byteM1(px0, px1, px2, px3) ASM
    ' parameters in the stack are just downside so we have to
    ' reorder them
    ASM "pop     iy"
    ASM "pop     hl"
    ASM "pop     de"
    ASM "pop     bc"
    ASM "pop     ix"
    ASM "push    ix"
    ASM "push    bc"
    ASM "push    de"
    ASM "push    hl"
    ASM "push    iy"
    ASM "read 'asm/cpctelera/sprites/cpct_px2byteM1.asm'"
END FUNCTION

SUB cpctDrawSolidBox(address, cpattern, w, h) ASM
    ASM "ld      b,(ix+0)"
    ASM "ld      c,(ix+2)"
    ASM "ld      l,(ix+4)"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "read 'asm/cpctelera/sprites/cpct_drawSolidBox.asm'"
END SUB