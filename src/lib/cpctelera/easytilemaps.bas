' MODULE CPCTELERA/EASYTILEMAPS

' Functions and Procedures:

SUB cpctetmSetDrawTilemap4x8ag(vieww, viewh, tilemapw, tiles) ASM
    ASM "ld      l,(ix+0)     ; tiles - Pointer to the start of the tileset definition"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)     ; tilemapw - Width in *tiles* of the complete tilemap"
    ASM "ld      d,(ix+3)"
    ASM "ld      b,(ix+4)     ; viewh - Height in *tiles* of the view window to be drawn"
    ASM "ld      c,(ix+6)     ; vieww - Width in *tiles* of the view window to be drawn"
    ASM "jp      cpct_etm_setDrawTilemap4x8_ag"
    ASM "read 'asm/cpctelera/easytilemaps/cpct_etm_setDrawTilemap4x8_ag.asm'"
END SUB

SUB cpctetmDrawTilemap4x8ag(memaddress, tileids) ASM
    ASM "ld      e,(ix+0)     ; tileids - Pointer to the upper-left tile id of the view to be drawn"
    ASM "ld      d,(ix+1)"
    ASM "ld      l,(ix+2)     ; memaddress - Video memory location where to draw the tilemap"
    ASM "ld      h,(ix+3)"
    ASM "jp      cpct_etm_drawTilemap4x8_ag"
    ASM "read 'asm/cpctelera/easytilemaps/cpct_etm_drawTilemap4x8_ag.asm'"
END SUB