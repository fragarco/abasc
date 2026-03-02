' MODULE BASE/MATH

FUNCTION shiftLeft(number) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "add     hl,hl"
    ASM "ret"
END FUNCTION

FUNCTION shiftLeft2(number) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "add     hl,hl"
    ASM "add     hl,hl"
    ASM "ret"
END FUNCTION

FUNCTION shiftLeftN(number, n) ASM
    ASM "ld      b,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "__shiftleftn:"
    ASM "add     hl,hl"
    ASM "djnz    __shiftleftn"
    ASM "ret"
END FUNCTION

FUNCTION shiftLeft8(number) ASM
    ASM "ld      h,(ix+0)"
    ASM "ld      l,0"
    ASM "ret"
END FUNCTION

FUNCTION shiftRight(number) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "srl     h"
    ASM "rr      l"
    ASM "ret"
END FUNCTION

FUNCTION shiftRight2(number) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "srl     h"
    ASM "rr      l"
    ASM "srl     h"
    ASM "rr      l"
    ASM "ret"
END FUNCTION

FUNCTION shiftRightN(number, n) ASM
    ASM "ld      b,(ix+0)"
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+3)"
    ASM "__shiftrightn:"
    ASM "srl     h"
    ASM "rr      l"
    ASM "djnz    __shiftrightn"
    ASM "ret"
END FUNCTION

FUNCTION shiftRight8(number) ASM
    ASM "ld      l,(ix+1)"
    ASM "ld      h,0"
    ASM "ret"
END FUNCTION
