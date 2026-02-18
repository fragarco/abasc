' MODULE BASE/SCREEN

SUB ScrInitialize ASM
    ASM "jp      &BBFF    ; SCR INITIALISE"
END SUB

SUB ScrDotPos(x, y) ASM
    ASM "ld      e,(ix+2) ; x-pos"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0) ; y-pos"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC1D    ; SCR_DOT_POSITION"
END SUB

SUB ScrNextByte(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC20    ; SCR NEXT BYTE"
END SUB

SUB ScrPrevByte(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC23    ; SCR PREV BYTE"
END SUB

SUB ScrNextLine(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC26    ; SCR NEXT LINE"
END SUB

SUB ScrPrevLine(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC29    ; SCR PREV LINE"
END SUB

SUB ScrFillBox(x1, y1, x2, y2, npen) ASM
    ASM "ld      a,(ix+0)"
    ASM "call    &BC2C    ; SCR INK ENCODE"
    ASM "ld      e,(ix+2) ; BOTOM LINE"
    ASM "ld      l,(ix+6) ; TOP LINE"
    ASM "ld      d,(ix+4) ; RIGHT COL"
    ASM "ld      h,(ix+8) ; LEFT COL"
    ASM "jp      &BC44    ; SCR FILL BOX"
END SUB

SUB ScrDrawBox(x1, y1, x2, y2) ASM
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "call    &BBC0    ; GRA MOVE ABSOLUTE"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "jp      &BBF6    ; GRA LINE ABSOLUTE"
END SUB

SUB ScrDrawTriangle(x1, y1, x2, y2, x3, y3) ASM
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    &BBC0    ; GRA MOVE ABSOLUTE"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+10)"
    ASM "ld      d,(ix+11)"
    ASM "ld      l,(ix+8)"
    ASM "ld      h,(ix+9)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BBF6    ; GRA LINE ABSOLUTE"
END SUB

SUB ScrDrawPolygon(x1, y1, x2, y2, x3, y3, x4, y4) ASM
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    &BBC0    ; GRA MOVE ABSOLUTE"
    ASM "ld      e,(ix+6)"
    ASM "ld      d,(ix+7)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+10)"
    ASM "ld      d,(ix+11)"
    ASM "ld      l,(ix+8)"
    ASM "ld      h,(ix+9)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+14)"
    ASM "ld      d,(ix+15)"
    ASM "ld      l,(ix+12)"
    ASM "ld      h,(ix+13)"
    ASM "call    &BBF6    ; GRA LINE ABSOLUTE"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BBF6    ; GRA LINE ABSOLUTE"
END SUB

SUB ScrDrawSprite(x, y) ASM
    ' Draws a sprite of W bytes x H lines in the position X,Y'
    ' SPRITE data (including W and H) will be read from the current
    ' DATA pointer so it can be set using RESTORE.
    ' That address is available in the ABASC variable rt_data_ptr.
    ASM "ld      e,(ix+2) ; x-pos"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0) ; y-pos"
    ASM "ld      h,(ix+1)"
    ASM "call    &BC1D    ; SCR_DOT_POSITION"
    ASM "ld      de,(rt_data_ptr)"
    ASM "ld      a,(de)   ; width in bytes"
    ASM "ld      c,a"
    ASM "inc     de"
    ASM "ld      a,(de)   ; height in lines"
    ASM "ld      b,a"
    ASM "inc     de"
    ASM "__draw_sprite_line:"
    ASM "ex      de,hl"
    ASM "push    bc"
    ASM "push    de"
    ASM "ld      b,0"
    ASM "ldir"
    ASM "pop     de"
    ASM "ex      de,hl"
    ASM "call    &BC26    ; SCR_NEXT_LINE"
    ASM "pop     bc"
    ASM "djnz    __draw_sprite_line"
    ASM "ret"
END SUB