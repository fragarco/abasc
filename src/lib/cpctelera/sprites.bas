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

SUB cpctDrawSpriteMasked(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; vmem - Destination video memory pointer"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+7)"
    ASM "jp      cpct_drawSpriteMasked"
    ASM "read 'asm/cpctelera/sprites/cpct_drawSpriteMasked.asm'"
END SUB

SUB cpctDrawSpriteVFlip(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      a,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+5)"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpct_drawSpriteVFlip"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteVFlip.asm'"
END SUB

SUB cpctDrawTileAligned2x4f(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (8-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned2x4_f"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned2x4_f.asm'"
END SUB

SUB cpctDrawTileAligned2x8(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (16-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned2x8"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned2x8.asm'"
END SUB

SUB cpctDrawTileAligned2x8f(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (16-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned2x8_f"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned2x8_f.asm'"
END SUB

SUB cpctDrawTileAligned4x4f(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (16-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned4x4_f"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned4x4_f.asm'"
END SUB

SUB cpctDrawTileAligned4x8(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (32-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned4x8"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned4x8.asm'"
END SUB

SUB cpctDrawTileAligned4x8f(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (32-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileAligned4x8_f"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileAligned4x8_f.asm'"
END SUB

SUB cpctDrawTileGrayCode2x8af(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (16-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileGrayCode_af"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileGrayCode2x8_af.asm'"
END SUB

SUB cpctDrawTileZigZagGrayCode4x8af(tile, vmem) ASM
    ASM "ld      e,(ix+0)  ; vmem - Pointer (aligned) to the first byte in video memory where the sprite will be copied."
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)  ; tile - Source Sprite Pointer (16-byte array with 8-bit pixel data)"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_drawTileZigZagGrayCode4x8_af"
    ASM "read 'asm/cpctelera/sprites/drawTile/cpct_drawTileZigZagGrayCode4x8_af.asm'"
END SUB

FUNCTION cpctGetBottomLeftPtr(vmem, h) ASM
    ASM "ld      c,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      e,(ix+2)  ; vmem - Video memory pointer to the top-left corner of a sprite"
    ASM "ld      d,(ix+3)"
    ASM "jp      cpct_getBottomLeftPtr"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_getBottomLeftPtr.asm'"
END FUNCTION

SUB cpctGetScreenToSprite(vmem, sprite, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; sprite - Destination Sprite Address (Sprite data array)"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+6)  ; vmem - Source Screen Address (Video memory location)"
    ASM "ld      h,(ix+7)"
    ASM "jp      cpct_getScreenToSprite"
    ASM "read 'asm/cpctelera/sprites/screenToSprite/cpct_getScreenToSprite.asm'"
END SUB

SUB cpctHflipSpriteM0(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM0"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM0.asm'"
END SUB

SUB cpctHflipSpriteM0r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM0r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM0r.asm'"
END SUB

SUB cpctHflipSpriteM1(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM1"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM1.asm'"
END SUB

SUB cpctHflipSpriteM1r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM1r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM1r.asm'"
END SUB

SUB cpctHflipSpriteM2(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM2"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM2.asm'"
END SUB

SUB cpctHflipSpriteM2r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM2r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM2r.asm'"
END SUB

FUNCTION cpctpx2byteM0(px0, px1) ASM
    ASM "ld      l,(ix+0)  ; px1 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "ld      h,(ix+2)  ; px0 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "call    cpct_px2byteM0"
    ASM "ld      h,l"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_px2byteM0.asm'"
END FUNCTION

FUNCTION cpctpx2byteM1(px0, px1, px2, px3) ASM
    ASM "ld      d,(ix+0)  ; px3 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "ld      e,(ix+2)  ; px2 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "ld      b,(ix+4)  ; px1 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "ld      c,(ix+6)  ; px0 - Firmware colour value for left  pixel (pixel 0) [0-15]"
    ASM "push    de"
    ASM "push    bc"
    ASM "call    cpct_px2byteM1"
    ASM "ld      h,l       ; h and l both has the same byte"
    ASM "pop     bc"
    ASM "pop     de"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_px2byteM1.asm'"
END FUNCTION

SUB cpctSetBlendMode(bmode) ASM
    ASM "ld      l,(ix+0)"
    ASM "jp      cpct_setBlendMode"
    ASM "read 'asm/cpctelera/sprites/blending/cpct_setBlendMode.asm'"
END SUB

