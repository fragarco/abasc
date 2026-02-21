' MODULE BASE/SCREEN

SUB scrInitialize ASM
    ASM "jp      &BBFF    ; SCR INITIALISE"
END SUB

FUNCTION scrDotPos(x, y) ASM
    ASM "ld      e,(ix+2) ; x-pos"
    ASM "ld      d,(ix+3)"
    ASM "ld      l,(ix+0) ; y-pos"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC1D    ; SCR_DOT_POSITION"
END FUNCTION

FUNCTION scrNextByte(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC20    ; SCR NEXT BYTE"
END FUNCTION

FUNCTION scrPrevByte(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC23    ; SCR PREV BYTE"
END FUNCTION

FUNCTION scrNextLine(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC26    ; SCR NEXT LINE"
END FUNCTION

FUNCTION scrPrevLine(vmem) ASM
    ASM "ld      l,(ix+0) ; video memory address"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC29    ; SCR PREV LINE"
END FUNCTION

SUB scrFillBox(x1, y1, x2, y2, npen) ASM
    ASM "ld      a,(ix+0)"
    ASM "call    &BC2C    ; SCR INK ENCODE"
    ASM "ld      e,(ix+2) ; BOTOM LINE"
    ASM "ld      l,(ix+6) ; TOP LINE"
    ASM "ld      d,(ix+4) ; RIGHT COL"
    ASM "ld      h,(ix+8) ; LEFT COL"
    ASM "jp      &BC44    ; SCR FILL BOX"
END SUB

SUB scrDrawBox(x1, y1, x2, y2) ASM
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

SUB scrDrawTriangle(x1, y1, x2, y2, x3, y3) ASM
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

SUB scrDrawPolygon(x1, y1, x2, y2, x3, y3, x4, y4) ASM
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

SUB scrDrawSprite(x, y) ASM
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

FUNCTION scrPeekColor(x, y) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "call    &BBF0     ; GRA_TEST_ABSOLUTE"
    ASM "ld      h,0"
    ASM "ld      l,a"
    ASM "ret"
END FUNCTION

SUB scrInitDoubleBuffer ASM
    ASM "ld      a,&40"
    ASM "call    &BC08    ; SCR_SET_BASE"
    ASM "ld      a,&C0"
    ASM "ld      hl,0"
    ASM "call    &BD1F    ; MC_SCREEN_OFFSET"
    ASM "ret"
    ASM "__doublebuf_counter: db  0"
END SUB

SUB scrSwapDoubleBuffer ASM
    ASM "ld      a,(__doublebuf_counter)"
    ASM "or      a"
    ASM "jr      z,__double_buf_swap1"
    ASM "dec     a"
    ASM "ld      (__doublebuf_counter),a"
    ASM "ld      a,&40"
    ASM "call    &BC08    ; SCR_SET_BASE"
    ASM "ld      a,&C0"
    ASM "ld      hl,0"
    ASM "jp      &BD1F    ; MC_SCREEN_OFFSET"
    ASM "__double_buf_swap1:"
    ASM "inc     a"
    ASM "ld      (__doublebuf_counter),a"
    ASM "ld      a,&C0"
    ASM "call    &BC08    ; SCR_SET_BASE"
    ASM "ld      a,&40"
    ASM "ld      hl,0"
    ASM "jp      &BD1F    ; MC_SCREEN_OFFSET"
END SUB

SUB scrSetLocation(memaddr) ASM
    ASM "ld      a,(ix+1)  ; Only &C0 or &40 make sense"
    ASM "jp      &BC08     ; SCR_SET_BASE"
END SUB

FUNCTION scrGetLocation ASM
    ASM "call    &BC0B    ; SCR_GET_LOCATION"
    ASM "ld      l,0"
    ASM "ld      h,a"
    ASM "ret"
END FUNCTION

SUB scrSetOffset(offset) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      &BC05     ; SCR_SET_OFFSET"
END SUB

FUNCTION scrGetOffset ASM
    ASM "jp      &&BC0B    ; SCR_GET_LOCATION (HL=offset)"
END FUNCTION

SUB scrSetVideoLocation(base, offset) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      a,(ix+3)"
    ASM "jp      &BD1F    ; MC_SCREEN_OFFSET"
END SUB

SUB scrScrollUp ASM
    ASM "call    &BB99  ; TXT_GET_PAPER"
    ASM "call    &BC2C  ; SCR_INK_ENCODE"
    ASM "ld      b,1"
    ASM "jp      &BC4D  ; SCR_HW_SCROLL"
END SUB

SUB scrScrollDown ASM
    ASM "call    &BB99   ; TXT_GET_PAPER"
    ASM "call    &BC2C   ; SCR_INK_ENCODE"
    ASM "ld      b,0"
    ASM "jp      &BC4D   ; SCR_HW_SCROLL"
END SUB

