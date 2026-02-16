' MODULE SPRITES
' This sprite rendering routines are based on:
' http://www.chibiakumas.com/z80/simplesamples.php#LessonS1

SUB DrawDataSp(X, Y, H) ASM
    ' Draws a sprite of 2 bytes x H lines'
    ' SPRITE data will be read from the current DATA pointer
    ' so it can be set using RESTORE. That address is available
    ' in the ABASC variable rt_data_ptr
    ASM "ld      e,(ix+4) ; x-pos"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+2) ; y-pos"
    ASM "ld      h,(ix+3)"
    ASM "call    &BC1D    ; SCR_DOT_POSITION"
    ASM "ld      de,(rt_data_ptr)"
    ASM "ld      b,(ix+0) ; H - sprite height"
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
    ASM "djnz    draw_sprite_8xB"
    ASM "ret"
END SUB

SUB DrawSp(spaddr, X, Y, H) ASM
    ' Draws a sprite of 2 bytes x H lines'
    ' SPRITE data will be read from the spaddr memory address
    ASM "ld      e,(ix+4) ; x-pos"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+2) ; y-pos"
    ASM "ld      h,(ix+3)"
    ASM "call    &BC1D    ; SCR_DOT_POSITION"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      b,(ix+0) ; H - sprite height"
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
    ASM "djnz    draw_sprite_8xB"
    ASM "ret"
END SUB
