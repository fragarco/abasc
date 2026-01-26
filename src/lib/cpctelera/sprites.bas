' MODULE CPCTELERA/SPRITES

' Functions and Procedures:

const CPCTBLEND.XOR = &AE
const CPCTBLEND.AND = &A6
const CPCTBLEND.OR  = &B6
const CPCTBLEND.ADD = &86
const CPCTBLEND.ADC = &8E
const CPCTBLEND.SBC = &9E
const CPCTBLEND.SUB = &96
const CPCTBLEND.LDI = &7E
const CPCTBLEND.NOP = &00

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
    ASM "jp      cpct_drawSprite"
    ASM "read 'asm/cpctelera/sprites/cpct_drawSprite.asm'"
END SUB

' Blending

SUB cpctDrawSpriteBlended(vmem, w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      b,(ix+4)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)  ; vmem - Destination video memory pointer"
    ASM "jp      cpct_drawSpriteBlended"
    ASM "read 'asm/cpctelera/sprites/blending/cpct_drawSpriteBlended.asm'"
END SUB

SUB cpctSetBlendMode(bmode) ASM
    ASM "ld      l,(ix+0)"
    ASM "jp      cpct_setBlendMode"
    ASM "read 'asm/cpctelera/sprites/blending/cpct_setBlendMode.asm'"
END SUB

