' MODULE MEMORY
' Some this sprite rendering routines are based on:
' http://www.chibiakumas.com/z80/simplesamples.php#LessonS1

' Functions and Procedures:
' DRAWSPRITE(x-pos, y-pos, sprite height)

SUB DRAWSPRITE(X, Y, SZY) ASM
    ' Draws a sprite of 8xSZY pixels'
    ' SPRITE data will be read from the current DATA pointer
    ' so it can be set using RESTORE. That address is available
    ' in the ABASC variable rt_data_ptr
    ASM "ld      e,(ix+4) ; x-pos"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+2) ; y-pos"
    ASM "ld      h,(ix+3)"
    ASM "call    &BC1D    ; SCR_DOT_POSITION"
    ASM "ld      de,(rt_data_ptr)"
    ASM "ld      b,(ix+0) ; sprite height"
    ASM "draw_sprite_8xB:"
    ASM "push    hl"
    ASM "ld      a,(de)"
    ASM "ld      (hl),a"
    ASM "inc     de"
    ASM "inc     hl"
    ASM "ld      a,(de)"
    ASM "ld      (hl),a"
    ASM "inc     de"
    ASM "pop     hl"
    ASM "call    &BC26    ; SCR_NEXT_LINE"
    ASM "djnz draw_sprite_8xB"
    ASM "ret"
END SUB

