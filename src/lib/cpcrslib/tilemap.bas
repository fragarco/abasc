' MODULE CPCRSLIB/TILEMAP

SUB rsAddDirtyTile(x, y) ASM
    ASM "ld      e,(ix+0) ; Y"
    ASM "ld      d,(ix+2) ; X"
    ASM "jp      cpc_AddDirtyTile"
    ASM "read 'asm/cpcrslib/tilemap/adddirtytile.asm'"
END SUB

SUB rsDrawMaskSpTileMap(rssprite$) ASM
    ASM "ld      l,(ix+0)   ; pointer to RSPRITE RECORD"
    ASM "ld      h,(ix+1)"
    ASM "jp      cpc_DrawMaskSpTileMap"
    ASM "read 'asm/cpcrslib/tilemap/drawmasksptilemap.asm'"
END SUB

FUNCTION rsGetDoubleBufferAddress(x, y) ASM
    ASM "ld      l,(ix+0)   ; Y"
    ASM "ld      h,(ix+2)   ; X"
    ASM "jp      cpc_GetDoubleBufferAddress"
    ASM "read 'asm/cpcrslib/tilemap/getdoublebufferaddress.asm'"
END FUNCTION

SUB rsPutSpTileMap(rssprite$) ASM
    ASM "ld      l,(ix+0)   ; pointer to RSPRITE RECORD"
    ASM "ld      h,(ix+1)"
    ASM "jp      cpc_PutSpTileMap"
    ASM "read 'asm/cpcrslib/tilemap/putsptilemap.asm'"
END SUB

SUB rsRenderTileMap ASM
    ASM "jp      cpc_RenderTileMap"
    ASM "read 'asm/cpcrslib/tilemap/rendertilemap.asm'"
END SUB

SUB rsResetTouchedTiles ASM
    ASM "jp      cpc_ResetTouchedTiles"
    ASM "read 'asm/cpcrslib/tilemap/resettouchedtiles.asm'"
END SUB

SUB rsRestoreTileMap ASM
    ASM "jp      cpc_RestoreTileMap"
    ASM "read 'asm/cpcrslib/tilemap/restoretilemap.asm'"
END SUB

SUB rsScrollLeft00 ASM
    ASM "jp      cpc_ScrollLeft00"
    ASM "read 'asm/cpcrslib/tilemap/scrollleft.asm'"
END SUB

SUB rsScrollRight00 ASM
    ASM "jp      cpc_ScrollRight00"
    ASM "read 'asm/cpcrslib/tilemap/scrollright.asm'"
END SUB

SUB rsSetTile(tile, x, y) ASM
    ASM "ld      l,(ix+0)   ; Y"
    ASM "ld      h,(ix+2)   ; X"
    ASM "ld      c,(ix+4)   ; Tile number"
    ASM "jp      cpc_SetTile"
    ASM "read 'asm/cpcrslib/tilemap/settile.asm'"
END SUB

SUB rsShowTileMap ASM
    ASM "jp      cpc_ShowTileMap"
    ASM "read 'asm/cpcrslib/tilemap/showtilemap.asm'"
END SUB
