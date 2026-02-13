.module tilemap

.include "tilemap.s"
.include "tilemapC.h"


; Define your tile data at the end of this file


_TileMapConf:


;------------------------------------------------------------------------------------
; Table for the screen position of the tiles (Left Column)
_posiciones_pantalla:
.DW #posicion_inicial_area_visible+#0x50*0
.DW #posicion_inicial_area_visible+#0x50*1
.DW #posicion_inicial_area_visible+#0x50*2
.DW #posicion_inicial_area_visible+#0x50*3
.DW #posicion_inicial_area_visible+#0x50*4
.DW #posicion_inicial_area_visible+#0x50*5
.DW #posicion_inicial_area_visible+#0x50*6
.DW #posicion_inicial_area_visible+#0x50*7
.DW #posicion_inicial_area_visible+#0x50*8
.DW #posicion_inicial_area_visible+#0x50*9
.DW #posicion_inicial_area_visible+#0x50*10
.DW #posicion_inicial_area_visible+#0x50*11
.DW #posicion_inicial_area_visible+#0x50*12
.DW #posicion_inicial_area_visible+#0x50*13
.DW #posicion_inicial_area_visible+#0x50*14
.DW #posicion_inicial_area_visible+#0x50*15
.DW #posicion_inicial_area_visible+#0x50*16
.DW #posicion_inicial_area_visible+#0x50*17
.DW #posicion_inicial_area_visible+#0x50*18
.DW #posicion_inicial_area_visible+#0x50*19

;------------------------------------------------------------------------------------
; Table for the Supperbuffer position of the tiles (Left Column)
_posiciones_super_buffer:			
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*0
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*1
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*2
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*3
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*4
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*5
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*6
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*7
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*8
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*9
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*10
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*11
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*12
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*13
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*14
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*15
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*16
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*17
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*18
.DW #posicion_inicial_superbuffer+8*ancho_pantalla_bytes*19


;------------------------------------------------------------------------------------
_pantalla_actual: .DW #0
_pantalla_juego:  ;en tiles
.ds T_WIDTH*T_HEIGHT
.DB #0xFF	;Este byte es importante, marca el fin de la pantalla.
_tiles_tocados:		; this table controls the tiles to be redrawn in the screen. 
.ds 150				; It requires 2bytes per tile
;------------------------------------------------------------------------------------
_tabla_y_ancho_pantalla:	; table for internal use to make faster calculations
.dw #_pantalla_juego + #0
.dw #_pantalla_juego + #1*T_WIDTH
.dw #_pantalla_juego + #2*T_WIDTH
.dw #_pantalla_juego + #3*T_WIDTH
.dw #_pantalla_juego + #4*T_WIDTH
.dw #_pantalla_juego + #5*T_WIDTH
.dw #_pantalla_juego + #6*T_WIDTH
.dw #_pantalla_juego + #7*T_WIDTH
.dw #_pantalla_juego + #8*T_WIDTH
.dw #_pantalla_juego + #9*T_WIDTH
.dw #_pantalla_juego + #10*T_WIDTH
.dw #_pantalla_juego + #11*T_WIDTH
.dw #_pantalla_juego + #12*T_WIDTH
.dw #_pantalla_juego + #13*T_WIDTH
.dw #_pantalla_juego + #14*T_WIDTH
.dw #_pantalla_juego + #15*T_WIDTH
.dw #_pantalla_juego + #16*T_WIDTH
.dw #_pantalla_juego + #17*T_WIDTH
.dw #_pantalla_juego + #18*T_WIDTH
.dw #_pantalla_juego + #19*T_WIDTH


;------------------------------------------------------------------------------------
; TILE DATA. TILES MUST BE DEFINED HERE!
;------------------------------------------------------------------------------------

_tiles: ;Son de 2x8 bytes
;tile 0
.db #0x00,#0x00
.db #0x40,#0x00
.db #0x40,#0x00
.db #0x40,#0x00
.db #0x40,#0x00
.db #0x40,#0x00
.db #0x40,#0xC0
.db #0x00,#0x00
;tile 1
.db #0x3C,#0x00
.db #0x3C,#0x00
.db #0x00,#0x3C
.db #0x00,#0x3C
.db #0x3C,#0x00
.db #0x3C,#0x00
.db #0x00,#0x3C
.db #0x00,#0x3C
;tile 2
.db #0x00,#0x00
.db #0x15,#0x00
.db #0x00,#0x2A
.db #0x15,#0x00
.db #0x00,#0x2A
.db #0x15,#0x00
.db #0x00,#0x00
.db #0x00,#0x00

;tile 2
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
.db #0xFF,#0xFF
