' MODULE MEMORY

' Functions and Procedures:
' MEMCOPY(destination, source, number of bytes)
' MEMSET(destination, number of bytes, value to write)

SUB memCopy(dest, src, size) ASM
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

SUB memSet(dest, size, value) ASM
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


