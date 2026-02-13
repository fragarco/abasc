' MODULE CPCRSLIB/TILEMAP

SUB rsInitTileMap ASM
    ASM "ld      hl,0                  ; pointer to tiles = nullptr"
    ASM "ld      (tiles_tilearray),hl  ; define in tmapdef.asm by the user"
    ASM "ret"
END SUB

SUB rsSetTile(x, y, tile) ASM
    ASM "ld      c,(ix+0)   ; Tile number"
    ASM "ld      l,(ix+2)   ; Y"
    ASM "ld      h,(ix+4)   ; X"
    ASM "jp      cpc_SetTile"
    ASM "read 'asm/cpcrslib/tilemap/settile.asm'"
END SUB

FUNCTION rsReadTile(x, y) ASM
    ASM "ld      e,(ix+0)   ; Y"
    ASM "ld      d,(ix+2)   ; X"
    ASM "jp      cpc_GetTile"
    ASM "read 'asm/cpcrslib/tilemap/gettile.asm'"
END FUNCTION

SUB rsShowTileMap ASM
    ASM "jp      cpc_RenderTileMap"
    ASM "read 'asm/cpcrslib/tilemap/rendertilemap.asm'"
END SUB

SUB rsShowTileMap2 ASM
    ASM "jp      cpc_ShowTileMap"
    ASM "read 'asm/cpcrslib/tilemap/showtilemap.asm'"
END SUB

SUB rsResetTouchedTiles ASM
    ASM "jp      cpc_ResetTouchedTiles"
    ASM "read 'asm/cpcrslib/tilemap/resettouchedtiles.asm'"
END SUB

SUB rsPutSpTileMap(rssprite$) ASM
    ASM "ld      e,(ix+0)   ; pointer to RSPRITE RECORD"
    ASM "ld      d,(ix+1)"
    ASM "jp      cpc_PutSpTileMap"
    ASM "read 'asm/cpcrslib/tilemap/putsptilemap.asm'"
END SUB

SUB rsUpdScr ASM
    ASM "jp      cpc_RestoreTileMap"
    ASM "read 'asm/cpcrslib/tilemap/restoretilemap.asm'"
END SUB

SUB rsPutSpTileMap2b(rssprite$) ASM
    ASM "ld      e,(ix+0)   ; pointer to RSPRITE RECORD"
    ASM "ld      d,(ix+1)"
    ASM "jp      cpc_DrawSpTileMap"
    ASM "read 'asm/cpcrslib/tilemap/drawsptilemap.asm'"
END SUB

SUB rsPutMaskSpTileMap2b(rssprite$) ASM
    ASM "ld      e,(ix+0)   ; pointer to RSPRITE RECORD"
    ASM "ld      d,(ix+1)"
    ASM "jp      cpc_DrawMaskSpTileMap"
    ASM "read 'asm/cpcrslib/tilemap/drawmasksptilemap.asm'"
END SUB

SUB rsUpdTileTable(x, y) ASM
    ASM "ld      e,(ix+0) ; Y"
    ASM "ld      d,(ix+2) ; X"
    ASM "jp      cpc_AddDirtyTile"
    ASM "read 'asm/cpcrslib/tilemap/adddirtytile.asm'"
END SUB

FUNCTION rsGetDoubleBufferAddress(x, y) ASM
    ASM "ld      l,(ix+0)   ; Y"
    ASM "ld      h,(ix+2)   ; X"
    ASM "jp      cpc_GetDoubleBufferAddress"
    ASM "read 'asm/cpcrslib/tilemap/getdblbufferaddress.asm'"
END FUNCTION

SUB rsScrollLeft00 ASM
    ASM "jp      cpc_ScrollLeft00"
    ASM "read 'asm/cpcrslib/tilemap/scrollleft.asm'"
END SUB

SUB rsScrollRight00 ASM
    ASM "jp      cpc_ScrollRight00"
    ASM "read 'asm/cpcrslib/tilemap/scrollright.asm'"
END SUB




