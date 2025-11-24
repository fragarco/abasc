
SUB MEMCOPY(dest, src, size) ASM
    ' Copies size bytes from src into dest
    ASM "ld      c,(ix+0)"
    ASM "ld      b,(ix+1)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "ldir"
    ASM "ret"
END SUB

SUB MEMSET(dest, size, value) ASM
    ' Fills size bytes from dest with value (1 byte)
    ASM "ld      a,(ix+0)"
    ASM "ld      c,(ix+2)"
    ASM "ld      b,(ix+3)"
    ASM "ld      e,(ix+4)"
    ASM "ld      d,(ix+5)"
    ASM "ld      l,(ix+4)"
    ASM "ld      h,(ix+5)"
    ASM "ld      (de),a"
    ASM "inc     de"
    ASM "dec     bc"
    ASM "ldir"
    ASM "ret"
END SUB


