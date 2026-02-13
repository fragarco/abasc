; Code adapted to ABASM syntax by Javier "Dwayne Hicks" Garcia
; Based on CPCRSLIB:
; Copyright (c) 2008-2015 Raúl Simarro <artaburu@hotmail.com>
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of
; this software and associated documentation files (the "Software"), to deal in the
; Software without restriction, including without limitation the rights to use, copy,
; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
; and to permit persons to whom the Software is furnished to do so, subject to the
; following conditions:
;
; The above copyright notice and this permission notice shall be included in all copies
; or substantial portions of the Software.
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
; PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
; FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
; OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
; DEALINGS IN THE SOFTWARE.

; EXAMPLE 003 - Small Sprite Demo (Tile Map)

org &4000

.main
    ; Set colors and video mode
    ld      a,0
    call    cpc_SetModeFW
    ld      ix,_inks
    ld      b,16
    ld      a,&FF
    __setink_loop:
        push    bc
        ld      b,(ix+0)
        ld      c,b
        inc     a
        push    af
        call    cpc_SetInkFW
        pop     af
        inc     ix
        pop     bc
    djnz    __setink_loop
    ld      bc,0
    call    cpc_SetBorderFW

    call    print_credits
    
    call    cpc_DisableFirmware
    
    ; Init sprite structures
    ld      a,(sprite1_cx)
    ld      h,a
    ld      a,(sprite1_cy)
    ld      l,a
    call    cpc_GetDoubleBufferAddress
    ld      (sprite1_coord0),hl
    ld      a,(sprite2_cx)
    ld      h,a
    ld      a,(sprite2_cy)
    ld      l,a
    call    cpc_GetDoubleBufferAddress
    ld      (sprite2_coord0),hl
    ld      a,(sprite3_cx)
    ld      h,a
    ld      a,(sprite3_cy)
    ld      l,a
    call    cpc_GetDoubleBufferAddress
    ld      (sprite3_coord0),hl


    call    draw_tilemap
    call    cpc_RenderTileMap
    call    cpc_ShowTileMap

__endless_mainloop:
    call    cpc_ResetTouchedTiles
    ; Mark as dirty current sprite positions, so these tiles
    ; can be restored (deleting the sprite in the process)
    ld      hl,sprite1
    call    cpc_PutSpTileMap
    ld      hl,sprite2
    call    cpc_PutSpTileMap
    ld      hl,sprite3
    call    cpc_PutSpTileMap
    call    cpc_RestoreTileMap ; restore original background
    
    ld      hl,sprite1
    call    cpc_DrawMaskSpTileMap
    ld      hl,sprite2
    call    cpc_DrawMaskSpTileMap
    ld      hl,sprite3
    call    cpc_DrawMaskSpTileMap

    call    update_enemypos
    call    update_playerpos
    call    check_collision

    call    cpc_ShowTileMap
jp __endless_mainloop

pause:
    ld      b,80
    pause_loop:
        halt
    djnz pause_loop
    ret

print_credits:
    ld      hl,_font_color
    call    cpc_SetTextColors_M0
    ld      de,string1
    ld      l,9*2+3 ; X
    ld      h,20*8  ; Y
    call    cpc_DrawStrXY_M0
    ld      de,string2
    ld      l,10*2+3; X
    ld      h,21*8  ; Y
    call    cpc_DrawStrXY_M0
    ld      de,string3
    ld      l,10*2+2; X
    ld      h,22*8  ; Y
    call    cpc_DrawStrXY_M0
    ld      de,string4
    ld      l,10*2  ; X
    ld      h,24*8  ; Y
    call    cpc_DrawStrXY_M0
    ret
 
update_enemypos:
    ld      a,(sprite2_move)  ; 0 left, 1 right
    cp      0
    jr      nz,__movsp2_right
    ld      a,(sprite2_cx)
    cp      1
    jr      c,__change_sp2dir
    dec     a
    ld      (sprite2_cx),a
    jr      __update_sp3pos
__change_sp2dir:
    ld      a,1
    ld      (sprite2_move),a
    jr      __update_sp3pos    
__movsp2_right:
    ld      a,(sprite2_move)  ; 0 left, 1 right
    cp      1
    jr      nz,__update_sp3pos
    ld      a,(sprite2_cx)
    cp      60
    jr      nc,__change_sp2rdir
    inc     a
    ld      (sprite2_cx),a
    jr      __update_sp3pos
__change_sp2rdir:
    xor     a
    ld      (sprite2_move),a
    jr      __update_sp3pos 

__update_sp3pos:
    ld      a,(sprite3_move)  ; 2 up, 3 down
    cp      2
    jr      nz,__movsp3_down
    ld      a,(sprite3_cy)
    cp      1
    jr      c,__change_sp3dir
    dec     a
    dec     a
    ld      (sprite3_cy),a
    jr      __update_end
__change_sp3dir:
    ld      a,3
    ld      (sprite3_move),a
    jr      __update_end    
__movsp3_down:
    ld      a,(sprite3_move)  ; 2 up, 3 down
    cp      3
    jr      nz,__update_end
    ld      a,(sprite3_cy)
    cp      106
    jr      nc,__change_sp3updir
    inc     a
    inc     a
    ld      (sprite3_cy),a
    jr      __update_end
__change_sp3updir:
    ld      a,2
    ld      (sprite3_move),a
__update_end:
    ret

update_playerpos:
    ; by default, the key assignment table used by cpc_TestKey
    ; has the four first entries assigned to cursor keys
__test_cursor_right:
    xor     a
    ld      l,a
    call    cpc_TestKey
    ld      a,h
    or      l
    jr      z,__test_cursor_left
    ld      a,(sprite1_cx)
    cp      60  ; only if cx < 60
    jr      nc,__test_cursor_left
    inc     a
    ld      (sprite1_cx),a
__test_cursor_left:
    ld      l,1
    call    cpc_TestKey
    ld      a,h
    or      l
    jr      z,__test_cursor_up
    ld      a,(sprite1_cx)
    cp      1   ; only if cx > 0
    jr      c,__test_cursor_up
    dec     a
    ld      (sprite1_cx),a
__test_cursor_up:
    ld      l,2
    call    cpc_TestKey
    ld      a,h
    or      l
    jr      z,__test_cursor_down
    ld      a,(sprite1_cy)
    cp      1  ; only if cy > 0
    jr      c,__test_cursor_down
    dec     a
    dec     a
    ld      (sprite1_cy),a
__test_cursor_down:
    ld      l,3
    call    cpc_TestKey
    ld      a,h
    or      l
    jr      z,__test_cursor_end
    ld      a,(sprite1_cy)
    cp      112  ; only if cy < 112
    jr      nc,__test_cursor_end
    inc     a
    inc     a
    ld      (sprite1_cy),a
__test_cursor_end:
    ret

check_collision:
    ld      hl,sprite1
    ld      de,sprite2
    call    cpc_CollideSp
    ld      a,h
    or      a
    jr      nz,collide    ; does a return

    ld      hl,sprite1
    ld      de,sprite3
    call    cpc_CollideSp
    ld      a,h
    or      a
    jr      nz,collide    ; does a return
    ret

collide:
    ; we cannot use cpc_SetBorderFW because
    ; the firmware interrupt routine is disabled
    ; by cpc_DisableFirmware
    ld      h,16
    ld      l,&40 ; white
    call    cpc_SetColor
    call    pause
    ld      l,&43 ; pastel yellow
    call    cpc_SetColor
    ret

draw_tilemap:
    xor     a
    ld      (dtlocal_y),a
    ld      (dtlocal_x),a
    dt_for_loop1:
        ld      a,(dtlocal_x)
        ld      h,a
        ld      l,0
        ld      c,1
        call    cpc_SetTile
        ld      h,a
        ld      l,15
        ld      c,2
        call    cpc_SetTile
        ; NEXT x
        ld      a,(dtlocal_x)
        cp      31
        jr      nc,dt_for_loop1_end
        inc     a
        ld      (dtlocal_x),a
        jr      dt_for_loop1
    dt_for_loop1_end:
        ld      a,1
        ld      (dtlocal_y),a
    dt_for_loop2:
        xor     a
        ld      (dtlocal_x),a
        dt_for_loop3:
            ld      a,(dtlocal_x)
            ld      h,a
            ld      a,(dtlocal_y)
            ld      l,a
            ld      c,0
            call    cpc_SetTile
            ; cpc_SetTile(x,y,0)
            ; NEXT x
            ld      a,(dtlocal_x)
            cp      31
            jr      nc,dt_for_loop3_end
            inc     a
            ld      (dtlocal_x),a
            jr      dt_for_loop3
        dt_for_loop3_end:
        ; NEXT y
        ld      a,(dtlocal_y)
        cp      14
        jr      nc,dt_for_loop2_end
        inc     a
        ld      (dtlocal_y),a
        jr      dt_for_loop2
    dt_for_loop2_end:
    ret
    dtlocal_x: db 0
    dtlocal_y: db 0

sprite1:
    sprite1_sp0: dw _sp_1
    sprite1_sp1: dw _sp_1
    sprite1_coord0: dw 0
    sprite1_coord1: dw 0
    sprite1_cx: db 50
    sprite1_cy: db 70
    sprite1_ox: db 50
    sprite1_oy: db 70
    sprite1_move1: db 3
    sprite1_move: db 0

sprite2:
    sprite2_sp0: dw _sp_2
    sprite2_sp1: dw _sp_2
    sprite2_coord0: dw 0
    sprite2_coord1: dw 0
    sprite2_cx: db 50
    sprite2_cy: db 106
    sprite2_ox: db 50
    sprite2_oy: db 106
    sprite2_move1: db 3
    sprite2_move: db 1

sprite3:
    sprite3_sp0: dw _sp_2
    sprite3_sp1: dw _sp_2
    sprite3_coord0: dw 0
    sprite3_coord1: dw 0
    sprite3_cx: db 20
    sprite3_cy: db 100
    sprite3_ox: db 20
    sprite3_oy: db 100
    sprite3_move1: db 3
    sprite3_move: db 2


read 'tilemap_config/example4_def.asm'

read 'cpcrslib/firmware/setmode.asm'
read 'cpcrslib/firmware/setink.asm'
read 'cpcrslib/firmware/setborder.asm'
read 'cpcrslib/firmware/disablefw.asm'

read 'cpcrslib/text/font_color.asm'
read 'cpcrslib/text/drawstr_m0.asm'

read 'cpcrslib/video/setcolor.asm'

read 'cpcrslib/tilemap/getdblbufferaddress.asm'
read 'cpcrslib/tilemap/settile.asm'
read 'cpcrslib/tilemap/rendertilemap.asm'
read 'cpcrslib/tilemap/resettouchedtiles.asm'
read 'cpcrslib/tilemap/putsptilemap.asm'
read 'cpcrslib/tilemap/restoretilemap.asm'
read 'cpcrslib/tilemap/drawmasksptilemap.asm'

read 'cpcrslib/sprite/collidesp.asm'

read 'cpcrslib/keyboard/testkey.asm'

string1: db "SMALL;SPRITE;DEMO",0
string2: db "SDCC;;;CPCRSLIB",0
string3: db "BY;ARTABURU;2015",0
string4: db "ESPSOFT<AMSTRAD<ES",0

_font_color: db TXT0_PEN0,TXT0_PEN4,TXT0_PEN5,TXT0_PEN6

_buffer: db 30
; Sprite data structure:
;   list of data: mask, color, mask, color... (for masked sprites)
;   list of color bytes (for non masked sprites)
; There is a tool called Sprot that allows to generate masked sprites for z88dk.
; ask for it: www.amstrad.es/forum/
_sp_1:
    db 4,15	
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&45,&00,&3C,&00,&3C,&55,&8A
    db &00,&8A,&00,&55,&00,&AA,&00,&45
    db &00,&8A,&00,&20,&00,&00,&00,&65
    db &00,&28,&00,&55,&00,&AA,&00,&14
    db &00,&7D,&00,&BE,&00,&FF,&00,&BE
    db &AA,&14,&00,&FF,&00,&BE,&55,&28
    db &AA,&00,&00,&3C,&00,&79,&55,&00
    db &00,&51,&00,&51,&00,&A2,&55,&A2
    db &00,&F3,&00,&10,&00,&20,&00,&F3
    db &00,&F3,&00,&51,&00,&A2,&00,&F3
    db &55,&28,&00,&0F,&00,&0F,&AA,&14
    db &FF,&00,&55,&0A,&AA,&05,&FF,&00
    db &55,&02,&55,&28,&AA,&14,&AA,&01
    db &00,&03,&55,&02,&AA,&01,&00,&03
_sp_2:
    db 4,21
    db &FF,&00,&00,&CC,&00,&CC,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&AA,&44,&55,&88,&FF,&00
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&E5,&00,&DA,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &AA,&45,&00,&CF,&00,&CF,&55,&8A
    db &FF,&00,&00,&CF,&00,&CF,&FF,&00
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &00,&A9,&00,&03,&00,&03,&00,&56
    db &00,&A9,&00,&03,&00,&03,&00,&56
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &AA,&01,&00,&03,&00,&03,&55,&02
    db &AA,&01,&00,&06,&00,&09,&55,&02
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
    db &FF,&00,&00,&0C,&00,&0C,&FF,&00
 ; Firmware inks
 _inks:
    db 0,13,1,6,26,24,15,8,10,22,14,3,18,4,11,25
    
; ORIGINAL EXAMPLE IN C
; #include "cpcrslib.h"
; 
; extern const unsigned char sp_1[];	//masked sprite data
; extern const unsigned char sp_2[];	//masked sprite data
; extern const unsigned char tintas[];	//inks
; extern unsigned char buffer[];	//inks
; 
; struct sprite { 	// minimun sprite structure
;     char *sp0;		//2 bytes 	01
;     char *sp1;		//2 bytes	23
;     int coord0;		//2 bytes	45	current superbuffer address
;     int coord1;		//2 bytes	67  old superbuffer address
;     unsigned char cx, cy;	//2 bytes 89 	current coordinates
;     unsigned char ox, oy;	//2 bytes 1011  old coordinates
;     unsigned char move1;	// los bits 4,3,2 definen el tipo de dibujo!!
;     unsigned char move;		// 	in this example, to know the movement direction of the sprite
; };
; struct sprite sprite00,sprite01,sprite02;
; 
; void data(void) {
;     __asm
; _buffer:
;     .db #30
; _sp_1:
;     .db #4,#15	//sprite dimensions in bytes withd, height
;     .db #0xFF,#0x00,#0x00,#0xCF,#0x00,#0xCF,#0xFF,#0x00	//data: mask, sprite, mask, sprite...
;     .db #0xAA,#0x45,#0x00,#0x3C,#0x00,#0x3C,#0x55,#0x8A
;     .db #0x00,#0x8A,#0x00,#0x55,#0x00,#0xAA,#0x00,#0x45
;     .db #0x00,#0x8A,#0x00,#0x20,#0x00,#0x00,#0x00,#0x65
;     .db #0x00,#0x28,#0x00,#0x55,#0x00,#0xAA,#0x00,#0x14
;     .db #0x00,#0x7D,#0x00,#0xBE,#0x00,#0xFF,#0x00,#0xBE
;     .db #0xAA,#0x14,#0x00,#0xFF,#0x00,#0xBE,#0x55,#0x28
;     .db #0xAA,#0x00,#0x00,#0x3C,#0x00,#0x79,#0x55,#0x00
;     .db #0x00,#0x51,#0x00,#0x51,#0x00,#0xA2,#0x55,#0xA2
;     .db #0x00,#0xF3,#0x00,#0x10,#0x00,#0x20,#0x00,#0xF3
;     .db #0x00,#0xF3,#0x00,#0x51,#0x00,#0xA2,#0x00,#0xF3
;     .db #0x55,#0x28,#0x00,#0x0F,#0x00,#0x0F,#0xAA,#0x14
;     .db #0xFF,#0x00,#0x55,#0x0A,#0xAA,#0x05,#0xFF,#0x00
;     .db #0x55,#0x02,#0x55,#0x28,#0xAA,#0x14,#0xAA,#0x01
;     .db #0x00,#0x03,#0x55,#0x02,#0xAA,#0x01,#0x00,#0x03
;  _sp_2:
;     .db #4,#21
;     .db #0xFF,#0x00,#0x00,#0xCC,#0x00,#0xCC,#0xFF,#0x00
;     .db #0xFF,#0x00,#0xAA,#0x44,#0x55,#0x88,#0xFF,#0x00
;     .db #0xFF,#0x00,#0xAA,#0x44,#0x55,#0x88,#0xFF,#0x00
;     .db #0xFF,#0x00,#0xAA,#0x44,#0x55,#0x88,#0xFF,#0x00
;     .db #0xFF,#0x00,#0x00,#0xCF,#0x00,#0xCF,#0xFF,#0x00
;     .db #0xAA,#0x45,#0x00,#0xCF,#0x00,#0xCF,#0x55,#0x8A
;     .db #0xAA,#0x45,#0x00,#0xE5,#0x00,#0xDA,#0x55,#0x8A
;     .db #0xAA,#0x45,#0x00,#0xCF,#0x00,#0xCF,#0x55,#0x8A
;     .db #0xAA,#0x45,#0x00,#0xCF,#0x00,#0xCF,#0x55,#0x8A
;     .db #0xAA,#0x45,#0x00,#0xCF,#0x00,#0xCF,#0x55,#0x8A
;     .db #0xAA,#0x45,#0x00,#0xCF,#0x00,#0xCF,#0x55,#0x8A
;     .db #0xFF,#0x00,#0x00,#0xCF,#0x00,#0xCF,#0xFF,#0x00
;     .db #0xAA,#0x01,#0x00,#0x03,#0x00,#0x03,#0x55,#0x02
;     .db #0x00,#0xA9,#0x00,#0x03,#0x00,#0x03,#0x00,#0x56
;     .db #0x00,#0xA9,#0x00,#0x03,#0x00,#0x03,#0x00,#0x56
;     .db #0xAA,#0x01,#0x00,#0x03,#0x00,#0x03,#0x55,#0x02
;     .db #0xAA,#0x01,#0x00,#0x03,#0x00,#0x03,#0x55,#0x02
;     .db #0xAA,#0x01,#0x00,#0x06,#0x00,#0x09,#0x55,#0x02
;     .db #0xFF,#0x00,#0x00,#0x0C,#0x00,#0x0C,#0xFF,#0x00
;     .db #0xFF,#0x00,#0x00,#0x0C,#0x00,#0x0C,#0xFF,#0x00
;     .db #0xFF,#0x00,#0x00,#0x0C,#0x00,#0x0C,#0xFF,#0x00
; 
; // There is a tool called Sprot that allows to generate masked sprites for z88dk.
; // ask for it: www.amstrad.es/forum/
; 
; _tintas:  //firmware inks
;     .db #0,#13,#1,#6,#26,#24,#15,#8,#10,#22,#14,#3,#18,#4,#11,#25
;     __endasm;
; }
; 
; void *p_sprites[7];
; 
; void initPointers(){
;     p_sprites[0] = &sprite00;
;     p_sprites[1] = &sprite01;
;     p_sprites[2] = &sprite02;
; }
; 
; void set_colours(void) {
;     unsigned char x;
;     for (x=0; x<16; x++) {
;         cpc_SetInk(x,tintas[x]);
;     }
;     cpc_SetBorder(0);
; }
; 
; void pause(void) {
;     __asm
;     ld b,#80
; pause_loop:
;     halt
;     djnz pause_loop
;     __endasm;
; }
; 
; void collide(void) {
;     cpc_SetColour(16,1);
;     pause();
;     cpc_SetColour(16,9);
; }
; 
; void draw_tilemap(void) {
;     unsigned char x,y;
;     //set the tiles of the map. In this example, the tile map is 32x16 tile
;     //Tile Map configuration file: TileMapConf.asm
;     y=0;
;     for(x=0; x<32; x++) {
;         cpc_SetTile(x,y,1);
;     }
;     for(y=1; y<15; y++) {
;         for (x=0; x<32; x++) {
;             cpc_SetTile(x,y,0);
;         }
;     }
;     y=15;
;     for (x=0; x<32; x++) {
;         cpc_SetTile(x,y,2);
;     }
; }
; 
; void print_credits(void) {
;     cpc_PrintGphStrXY("SMALL;SPRITE;DEMO",9*2+3,20*8);
;     cpc_PrintGphStrXY("SDCC;;;CPCRSLIB",10*2+3,21*8);
;     cpc_PrintGphStrXY("BY;ARTABURU;2015",10*2+2,22*8);
;     cpc_PrintGphStrXY("ESPSOFT<AMSTRAD<ES",10*2+3-3,24*8);
; }
; 
; main() {
;     unsigned char a;
;     initPointers();
;     set_colours();
;     cpc_SetInkGphStr(0,0);
;     cpc_SetModo(0);
; 
;     cpc_DisableFirmware();
;     // All the sprite values are initilized
;     sprite00.sp1=sp_1;
;     sprite00.sp0=sp_1;
;     sprite00.ox=50;
;     sprite00.oy=70;
;     sprite00.cx=50;
;     sprite00.cy=70;
;     sprite00.move1=3;
;     cpc_SuperbufferAddress(p_sprites[0]); //first time it's important to do this
; 
;     sprite01.sp1=sp_2;
;     sprite01.sp0=sp_2;
;     sprite01.ox=50;
;     sprite01.oy=106;
;     sprite01.cx=50;
;     sprite01.cy=106;
;     sprite01.move=1;
;     sprite01.move1=3;
;     cpc_SuperbufferAddress(p_sprites[1]);
; 
;     sprite02.sp1=sp_2;
;     sprite02.sp0=sp_2;
;     sprite02.ox=20;
;     sprite02.oy=100;
;     sprite02.cx=20;
;     sprite02.cy=100;
;     sprite02.move=2;
;     sprite02.move1=3;
;     cpc_SuperbufferAddress(p_sprites[2]);
; 
;     //Drawing the tile map
;     draw_tilemap();
;     cpc_ShowTileMap();	// Show entire tile map in the screen
;     print_credits();
;     cpc_SetTile(0,1,2);
; 
;     cpc_ShowTileMap();	// Show entire tile map in the screen
;     while(1) {
;         //Default number keys for moving one of the sprites:
;         // 0: cursor right
;         // 1: cursor left
;         // 2: cursor up
;         // 3: cursor down
;         //for example., if key 0 is pressed, and the sprite is inside tilemap, then
;         //the sprite is moved one byte to the right:
;         if (cpc_TestKey(0)==1 && sprite00.cx<60) sprite00.cx++;
;         if (cpc_TestKey(1)==1 && sprite00.cx>0) sprite00.cx--;
;         if (cpc_TestKey(2)==1 && sprite00.cy>0) sprite00.cy-=2;
;         if (cpc_TestKey(3)==1 && sprite00.cy<112) sprite00.cy+=2;
; 
;         // The other sprites are automatically moved
;         if (sprite01.move==0) {   // 0 = left, 1 = right
;             if (sprite01.cx>0) sprite01.cx--;
;             else sprite01.move=1;
;         }
;         if (sprite01.move==1) {   // 0 = left, 1 = right
;             if (sprite01.cx<60) sprite01.cx++;
;             else sprite01.move=0;
;         }
; 
;         if (sprite02.move==2) {   // 2 = up, 3 = down
;             if (sprite02.cy>0) sprite02.cy-=2;
;             else sprite02.move=3;
;         }
;         if (sprite02.move==3) {   // 2 = up, 3 = down
;             if (sprite02.cy<106) sprite02.cy+=2;
;             else sprite02.move=2;
;         }
; 
;         cpc_ResetTouchedTiles(); //clear touched tile table
; 
;         //Sprite phase 1
;         cpc_PutSpTileMap(p_sprites[0]);	//search the tiles where is and was the sprite
;         cpc_PutSpTileMap(p_sprites[1]);
;         cpc_PutSpTileMap(p_sprites[2]);
; 
;         cpc_UpdScr(); //Update the screen to new situatio (show the touched tiles)
; 
;         //Sprite phase 2
;         cpc_PutMaskSpTileMap2b(p_sprites[0]); //Requires to move sprite with cpc_SpUpdX or cpc_SpUpdY
;         cpc_PutMaskSpTileMap2b(p_sprites[1]);
;         cpc_PutMaskSpTileMap2b(p_sprites[2]);
; 
;         cpc_ShowTileMap2();	//Show the touched tiles-> show the new sprite situatuion
; 
;         if (cpc_CollSp(p_sprites[0],p_sprites[1])) collide();  //test if there is collision between sprite00 and sprite01
;         if (cpc_CollSp(p_sprites[0],p_sprites[2])) collide();
;     }
; }
