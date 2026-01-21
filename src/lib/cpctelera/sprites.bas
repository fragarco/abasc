' MODULE CPCTELERA/SPRITES

' Functions and Procedures:

FUNCTION cpctpx2byteM1(px0, px1, px2, px3) ASM
    ASM "pop     iy ; parameters in the stack are just downside"
    ASM "pop     hl ; so we have to reorder them"
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
    ASM "ld      b,(ix+0)   ; h - first byte"
    ASM "ld      c,(ix+2)   ; w - first byte"
    ASM "ld      l,(ix+4)   ; pattern - first byte"
    ASM "ld      e,(ix+6)   ; video memory destination"
    ASM "ld      d,(ix+7)"
    ASM "read 'asm/cpctelera/sprites/cpct_drawSolidBox.asm'"
END SUB

SUB cpctDrawSprite(sprite, videopos, spwidth, spheight) ASM
    ASM "ld      b,(ix+0)           ; sprite height"
    ASM "ld      c,(ix+2)           ; sprite width"
    ASM "ld      e,(ix+4)           ; destination video memory"
    ASM "ld      d,(ix+5)           ; address"
    ASM "ld      l,(ix+6)           ; sprite data address"
    ASM "ld      h,(ix+7)"
    ASM "jp      cpct_getScreenPtr"
    ASM "read 'asm/cpctelera/video/cpct_getScreenPtr.asm'"
END SUB