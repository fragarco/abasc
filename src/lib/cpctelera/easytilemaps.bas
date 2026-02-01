' MODULE CPCTELERA/EASYTILEMAPS

' Functions and Procedures:

SUB cpctetmDrawTileBox2x4(x, y, w, h, mapw, videomem, timemap) ASM
    ASM "ld      l,(ix+0)     ; tilemap - Pointer to the start of the tilemap"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)     ; videomem - Pointer to upper left corner of the *tilemap* in video memory"
    ASM "ld      d,(ix+3)"
    ASM "push    hl"
    ASM "push    de"
    ASM "ld      a,(ix+4)     ; Width in tiles of a complete row of the tilemap"
    ASM "ld      d,(ix+6)     ; Height in tiles of the tile-box to be redrawn"
    ASM "ld      e,(ix+8)     ; Width in tiles of the tile-box to be redrawn"
    ASM "ld      b,(ix+10)    ; y tile-coordinate of the starting tile inside the tilemap"
    ASM "ld      c,(ix+12)    ; x tile-coordinate of the starting tile inside the tilemap"
    ASM "call    cpct_etm_drawTileBox2x4"
    ASM "ret"
    ASM "read 'asm/cpctelera/easytilemaps/cpct_etm_drawTileBox2x4.asm'"
END SUB

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

SUB cpctetmSetTileset2x4(tileset) ASM
    ASM "ld      l,(ix+0)     ; tileset - Pointer to the start of the tileset (array of pointers to tile definitions)"
    ASM "ld      h,(ix+1)"
    ASM "jp      cpct_etm_setTileset2x4"
    ASM "read 'asm/cpctelera/easytilemaps/cpct_etm_setTileset2x4.asm'"
END SUB
