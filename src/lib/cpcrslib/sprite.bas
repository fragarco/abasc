' MODULE CPCRSLIB/SPRITE

const RSPRITE.SIZE = 14 ' RSPRITE size in bytes

RECORD rssp; sp0, sp1, vmem0, vmem1, cpos, opos, movdir

FUNCTION rsCollSp(sprite1$, sprite2$) ASM
    ASM "ld      e,(ix+0)   ; sprite2 - Address to sprite2 structure"
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)   ; sprite1 - Address to sprite1 structure"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpc_CollideSp ; HL = -1 (true) or HL = 0 (false)"
    ASM "read 'asm/cpcrslib/sprite/collidesp.asm'"
END FUNCTION

SUB rsGetSp(buf, w, h, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Target video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)   ; sprite height"
    ASM "ld      b,(ix+4)   ; sprite width"
    ASM "ld      e,(ix+6)   ; address to the storage memory"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpc_GetSp"
    ASM "read 'asm/cpcrslib/sprite/getsp.asm'"
END SUB

SUB rsGetSpXY(buf, w, h, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y coordinate"
    ASM "ld      l,(ix+2)   ; X coordinate"
    ASM "ld      c,(ix+4)   ; buffer height"
    ASM "ld      b,(ix+6)   ; buffer width"
    ASM "ld      e,(ix+8)   ; address to the storage memory"
    ASM "ld      d,(ix+9)"
    ASM "jp      cpc_GetSpXY"
    ASM "read 'asm/cpcrslib/sprite/getsp.asm'"
END SUB

SUB rsPutSp(sprite, w, h, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)   ; sprite height"
    ASM "ld      b,(ix+4)   ; sprite width"
    ASM "ld      e,(ix+6)   ; address to the sprite definition"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpc_PutSp"
    ASM "read 'asm/cpcrslib/sprite/putsp.asm'"
END SUB

SUB rsPutSpXY(sprite, w, h, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y coordinate"
    ASM "ld      l,(ix+2)   ; X coordinate"
    ASM "ld      c,(ix+4)   ; sprite height"
    ASM "ld      b,(ix+6)   ; sprite width"
    ASM "ld      e,(ix+8)   ; address to the sprite definition"
    ASM "ld      d,(ix+9)"
    ASM "jp      cpc_PutSpXY"
    ASM "read 'asm/cpcrslib/sprite/putsp.asm'"
END SUB

SUB rsPutSpXOR(sprite, w, h, vmem) ASM
    ASM "ld      l,(ix+0)   ; vmem - Destination video memory"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(ix+2)   ; sprite height"
    ASM "ld      b,(ix+4)   ; sprite width"
    ASM "ld      e,(ix+6)   ; address to the sprite definition"
    ASM "ld      d,(ix+7)"
    ASM "jp      cpc_PutSp_XOR"
    ASM "read 'asm/cpcrslib/sprite/putspxor.asm'"
END SUB

SUB rsPutSpXORXY(sprite, w, h, x, y) ASM
    ASM "ld      h,(ix+0)   ; Y coordinate"
    ASM "ld      l,(ix+2)   ; X coordinate"
    ASM "ld      c,(ix+4)   ; sprite height"
    ASM "ld      b,(ix+6)   ; sprite width"
    ASM "ld      e,(ix+8)   ; address to the sprite definition"
    ASM "ld      d,(ix+9)"
    ASM "jp      cpc_PutSpXY_XOR"
    ASM "read 'asm/cpcrslib/sprite/putspxor.asm'"
END SUB