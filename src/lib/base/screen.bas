' MODULE BASE/SCREEN

SUB ScrInitialize ASM
    ASM "jp      &BBFF    ; SCR INITIALISE"
END SUB

SUB ScrDotPos(X, Y) ASM
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

SUB ScrFillBox(lcol, rcol, tline, bline, npen) ASM
    ASM "ld      a,(ix+0)"
    ASM "call    &BC2C    ; SCR INK ENCODE"
    ASM "ld      e,(ix+2) ; BOTOM LINE"
    ASM "ld      l,(ix+4) ; TOP LINE"
    ASM "ld      d,(ix+6) ; RIGHT COL"
    ASM "ld      h,(ix+8) ; LEFT COL"
    ASM "jp      &BC44    ; SCR FILL BOX"
END SUB

SUB ScrDrawBox(lpos, tpos, rpos, bpos) ASM
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