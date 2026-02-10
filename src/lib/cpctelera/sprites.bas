' MODULE CPCTELERA/SPRITES

const CPCTBLEND.XOR = &AE
const CPCTBLEND.AND = &A6
const CPCTBLEND.OR  = &B6
const CPCTBLEND.ADD = &86
const CPCTBLEND.ADC = &8E
const CPCTBLEND.SBC = &9E
const CPCTBLEND.SUB = &96
const CPCTBLEND.LDI = &7E
const CPCTBLEND.NOP = &00

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




SUB cpctDrawSpriteColorizeM0(sprite, vmem, w, h, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+6)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+7)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "jp      cpct_drawSpriteColorizeM0"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M0/cpct_drawSpriteColorizeM0.asm'"
END SUB

SUB cpctDrawSpriteColorizeM1(sprite, vmem, w, h, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+6)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+7)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "jp      cpct_drawSpriteColorizeM1"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M1/cpct_drawSpriteColorizeM1.asm'"
END SUB

SUB cpctDrawSpriteMaskedAlignedColorizeM0(sprite, vmem, w, h, masktable, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+4)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+6)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+8)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+9)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+2)  ; masktable - Pointer to an Aligned Mask Table for transparencies with palette index 0"
    ASM "ld      h,(ix+3)"
    ASM "push    hl        ;    to pass it at the end to IX"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "pop     ix"
    ASM "jp      cpct_drawSpriteMaskedAlignedColorizeM0"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M0/cpct_drawSpriteMaskedAlignedColorizeM0.asm'"
END SUB

SUB cpctDrawSpriteMaskedAlignedColorizeM1(sprite, vmem, w, h, masktable, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+4)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+6)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+8)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+9)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+2)  ; masktable - Pointer to an Aligned Mask Table for transparencies with palette index 0"
    ASM "ld      h,(ix+3)"
    ASM "push    hl        ;    to pass it at the end to IX"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "pop     ix"
    ASM "jp      cpct_drawSpriteMaskedAlignedColorizeM1"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M1/cpct_drawSpriteMaskedAlignedColorizeM1.asm'"
END SUB

SUB cpctDrawSpriteMaskedColorizeM0(sprite, vmem, w, h, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+6)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+7)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "jp      cpct_drawSpriteMaskedColorizeM0"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M0/cpct_drawSpriteMaskedColorizeM0.asm'"
END SUB

SUB cpctDrawSpriteMaskedColorizeM1(sprite, vmem, w, h, rplcpat) ASM
    ASM "ld      e,(ix+0)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+6)  ; vmem - Destination video memory pointer"
    ASM "ld      h,(ix+7)  ;    cpctelera routine has been modified to read it from stack"
    ASM "push    hl        ;    instead of passing it in AF"
    ASM "ld      l,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+9)"
    ASM "jp      cpct_drawSpriteMaskedColorizeM1"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M1/cpct_drawSpriteMaskedColorizeM1.asm'"
END SUB

SUB cpctDrawSpriteColorizeM0(rplcpat, size, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; size - Size of the Array/Sprite in bytes (if it is a sprite, width*height) "
    ASM "ld      b,(ix+3)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_spriteColourizeM0"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M0/cpct_spriteColourizeM0.asm'"
END SUB

SUB cpctDrawSpriteColorizeM1(rplcpat, size, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; size - Size of the Array/Sprite in bytes (if it is a sprite, width*height) "
    ASM "ld      b,(ix+3)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_spriteColourizeM1"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M1/cpct_spriteColourizeM1.asm'"
END SUB

SUB cpctDrawSpriteMaskedColorizeM0(rplcpat, size, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; size - Size of the Array/Sprite in bytes (if it is a sprite, width*height) "
    ASM "ld      b,(ix+3)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_spriteMaskedColourizeM0"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M0/cpct_spriteMAskedColourizeM0.asm'"
END SUB

SUB cpctDrawSpriteMaskedColorizeM1(rplcpat, size, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; size - Size of the Array/Sprite in bytes (if it is a sprite, width*height) "
    ASM "ld      b,(ix+3)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+4)  ; rplcpat - Replace Pattern => 1st byte(D)=Pattern to Find, 2nd byte(E)=Pattern to insert instead"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_spriteMaskedColourizeM1"
    ASM "read 'asm/cpctelera/sprites/colorReplace/M1/cpct_spriteMaskedColourizeM1.asm'"
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




SUB cpctDrawToSpriteBuffer(bufferw, buffer, w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+6)  ; buffer - Destination pointer (pointing inside sprite buffer)"
    ASM "ld      d,(ix+7)"
    ASM "ld      a,(ix+8)  ; bufferw - Width in bytes of the Sprite used as Buffer (>0, >=width)"
    ASM "jp      cpct_drawToSpriteBuffer"
    ASM "read 'asm/cpctelera/sprites/drawToSpriteBuffer/cpct_drawToSpriteBuffer.asm'"
END SUB

SUB cpctDrawToSpriteBufferMasked(bufferw, buffer, w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "ld      e,(ix+6)  ; buffer - Destination pointer (pointing inside sprite buffer)"
    ASM "ld      d,(ix+7)"
    ASM "ld      a,(ix+8)  ; bufferw - Width in bytes of the Sprite used as Buffer (>0, >=width)"
    ASM "jp      cpct_drawToSpriteBufferMasked"
    ASM "read 'asm/cpctelera/sprites/drawToSpriteBuffer/cpct_drawToSpriteBufferMasked.asm'"
END SUB

SUB cpctDrawToSpriteBufferMaskedAlignedTable(bufferw, buffer, w, h, sprite, masktable) ASM
    ASM "ld      b,(ix+4)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+6)  ; w - Sprite Width in *bytes* (Beware, *not* in pixels!)"
    ASM "push    bc"
    ASM "ld      l,(ix+0)  ; masktable - Pointer to the aligned mask-table used to create transparency"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      b,(ix+3)"
    ASM "ld      e,(ix+8)  ; buffer - Destination pointer (pointing inside sprite buffer)"
    ASM "ld      d,(ix+9)"
    ASM "ld      a,(ix+10) ; bufferw - Width in bytes of the Sprite used as Buffer (>0, >=width)"
    ASM "pop     ix        ; IXH = h, IXL = w"
    ASM "jp      cpct_drawToSpriteBufferMaskedAlignedTable"
    ASM "read 'asm/cpctelera/sprites/drawToSpriteBuffer/cpct_drawToSpriteBufferMaskedAlignedTable.asm'"
END SUB




SUB cpctDrawSpriteHFlipM0(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)  ; vmem - Destination video memory pointer"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpct_drawSpriteHFlipM0"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteHFlipM0.asm'"
END SUB

SUB cpctDrawSpriteHFlipM1(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)  ; vmem - Destination video memory pointer"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpct_drawSpriteHFlipM1"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteHFlipM1.asm'"
END SUB

SUB cpctDrawSpriteHFlipM2(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)  ; vmem - Destination video memory pointer"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpct_drawSpriteHFlipM2"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteHFlipM2.asm'"
END SUB

SUB cpctDrawSpriteVFlip(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      a,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)  ; vmem - Destination video memory pointer"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpct_drawSpriteVFlip"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteVFlip.asm'"
END SUB

SUB cpctDrawSpriteVFlipMasked(sprite, vmem, w, h) ASM
    ASM "ld      b,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      a,(ix+2)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)  ; vmem - Destination video memory pointer"
    ASM "ld      e,(ix+6)  ; sprite - Source Sprite Pointer (array with pixel data)"
    ASM "ld      d,(ix+7)"
    ASM "ld    ixh,b"
    ASM "jp      cpct_drawSpriteVFlipMasked"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_drawSpriteVFlipMasked.asm'"
END SUB

FUNCTION cpctGetBottomLeftPtr(vmem, h) ASM
    ASM "ld      c,(ix+0)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      e,(ix+2)  ; vmem - Video memory pointer to the top-left corner of a sprite"
    ASM "ld      d,(ix+3)"
    ASM "jp      cpct_getBottomLeftPtr"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_getBottomLeftPtr.asm'"
END FUNCTION

SUB cpctHFlipSpriteM0(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM0"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM0.asm'"
END SUB

SUB cpctHfFlipSpriteM0r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM0r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM0r.asm'"
END SUB

SUB cpctHFlipSpriteM1(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM1"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM1.asm'"
END SUB

SUB cpctHFlipSpriteM1r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM1r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM1r.asm'"
END SUB

SUB cpctHFlipSpriteM2(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipspriteM2"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM2.asm'"
END SUB

SUB cpctHFlipSpriteM2r(sprite, w, h) ASM
    ASM "ld      h,(ix+0)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      l,(ix+2)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "ld      e,(ix+4)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      d,(ix+5)"
    ASM "jp      cpct_hflipspriteM2r"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipspriteM2r.asm'"
END SUB

SUB cpctHFlipSpriteMaskedM0(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipSpriteMaskedM0"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipSpriteMaskedM0.asm'"
END SUB

SUB cpctHFlipSpriteMaskedM1(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipSpriteMaskedM1"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipSpriteMaskedM1.asm'"
END SUB

SUB cpctHFlipSpriteMaskedM2(w, h, sprite) ASM
    ASM "ld      l,(ix+0)  ; sprite - Pointer to the sprite array (first byte of consecutive sprite data"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Height of the sprite in pixels / bytes (both are the same). Must be >= 1"
    ASM "ld      c,(ix+4)  ; w - Width of the sprite in *bytes* (*NOT* in pixels!). Must be >= 1."
    ASM "jp      cpct_hflipSpriteMaskedM2"
    ASM "read 'asm/cpctelera/sprites/flipping/cpct_hflipSpriteMaskedM2.asm'"
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

SUB cpctDrawSpriteMaskedAlignedTable(sprite, vmem, w, h, masktable) ASM
    ASM "ld      l,(ix+0)  ; masktable - Pointer to an Aligned Mask Table for transparencies with palette index 0"
    ASM "ld      h,(ix+1)"
    ASM "ld      b,(ix+2)  ; h - Sprite Height in bytes (>0)"
    ASM "ld      c,(ix+4)  ; w - Sprite Width in *bytes* (>0) (Beware, *not* in pixels!)"
    ASM "push    bc"
    ASM "ld      e,(ix+6)  ; vmem - Destination video memory pointer"
    ASM "ld      d,(ix+7)"
    ASM "ld      c,(ix+8)  ; sprite - Source Sprite Pointer (array with pixel and mask data)"
    ASM "ld      b,(ix+9)"
    ASM "pop     ix        ; IXH = h, IXL = w"
    ASM "jp      cpct_drawSpriteMaskedAlignedTable"
    ASM "read 'asm/cpctelera/sprites/cpct_drawSpriteMaskedAlignedTable.asm'"
END SUB

FUNCTION cpctPen2pixelPatternM0(pnum) asm
    ASM "ld      l,(ix+0)  ; pnum - Pen colour number"
    ASM "ld      h,(ix+1)"
    ASM "call    cpct_pen2pixelPatternM0"
    ASM "ld      h,0"
    ASM "ld      l,a"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_pen2pixelPatternM0.asm'"
END FUNCTION

FUNCTION cpctPen2pixelPatternM1(pnum) asm
    ASM "ld      l,(ix+0)  ; pnum - Pen colour number"
    ASM "ld      h,(ix+1)"
    ASM "call    cpct_pen2pixelPatternM1"
    ASM "ld      h,0"
    ASM "ld      l,a"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_pen2pixelPatternM1.asm'"
END FUNCTION

FUNCTION cpctPen2TwoPixelPatternM0(newpen, oldpen) asm
    ASM "ld      d,(ix+0)  ; oldpen - Pen colour to be found and replaced when used for <cpct_spriteColourizeMO>"
    ASM "ld      e,(ix+2)  ; newpen - Pen colour to be inserted when used for <cpct_spriteColourizeM0>"
    ASM "call    cpct_pens2pixelPatternPairM0"
    ASM "ex      de,hl"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_pens2twoPixelPatternPairM0.asm'"
END FUNCTION

FUNCTION cpctPen2TwoPixelPatternM1(newpen, oldpen) asm
    ASM "ld      d,(ix+0)  ; oldpen - Pen colour to be found and replaced when used for <cpct_spriteColourizeMO>"
    ASM "ld      e,(ix+2)  ; newpen - Pen colour to be inserted when used for <cpct_spriteColourizeM0>"
    ASM "call    cpct_pens2pixelPatternPairM1"
    ASM "ex      de,hl"
    ASM "ret"
    ASM "read 'asm/cpctelera/sprites/cpct_pens2twoPixelPatternPairM1.asm'"
END FUNCTION

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



