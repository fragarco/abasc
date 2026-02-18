

SUB txtRotateLeft(text$, x, y) ASM
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

SUB txtPrintBig(text$, x, y) ASM
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+2)"
    ASM "jp      fwBigLetters"
    ASM "read 'asm/base/txtbig.asm'"
END SUB