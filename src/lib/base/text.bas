' MODULE BASE/TEXT

FUNCTION txtReadAsc(x, y) ASM
    ASM "call    &BB78     ; TXT_GET_CURSOR"
    ASM "push    hl"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+2)"
    ASM "call    &BB75     ; TXT_SET_CURSOR"
    ASM "call    &BB60     ; TXT_RD_CHAR"
    ASM "ld      e,a"
    ASM "ld      d,0"
    ASM "pop     hl"
    ASM "call    &BB75     ; TXT_SET_CURSOR"
    ASM "ex      de,hl"
    ASM "ret"
END FUNCTION

SUB txtRotateLeft(text$, x, y) ASM
    ASM "ld      hl,__fwrotstr_incdec"
    ASM "ld      (hl),&2D    ; dec l"
    ASM "ld      hl,__fwrotstr_funcb+1"
    ASM "ld      de,fwRotChLeft"
    ASM "ld      (hl),e"
    ASM "inc     hl"
    ASM "ld      (hl),d"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+2)"
    ASM "jp      fwRotateString"
    ASM "read 'asm/base/txtrotate.asm'"
END SUB

SUB txtRotateRight(text$, x, y) ASM
    ASM "ld      hl,__fwrotstr_incdec"
    ASM "ld      (hl),&2C    ; inc l"
    ASM "ld      hl,__fwrotstr_funcb+1"
    ASM "ld      de,fwRotChRight"
    ASM "ld      (hl),e"
    ASM "inc     hl"
    ASM "ld      (hl),d"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+2)"
    ASM "jp      fwRotateString"
    ASM "read 'asm/base/txtrotate.asm'"
END SUB

SUB txtPrintBig(text$, x, y, pen1, pen2) ASM
    ASM "ld      a,(ix+0)"
    ASM "ld      hl,__bigletter_pen2+1"
    ASM "ld      (hl),a"
    ASM "ld      a,(ix+2)"
    ASM "ld      hl,__bigletter_pen1+1"
    ASM "ld      (hl),a"
    ASM "ld      e,(ix+8)"
    ASM "ld      d,(ix+9)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+6)"
    ASM "jp      fwBigLetters"
    ASM "read 'asm/base/txtbig.asm'"
END SUB