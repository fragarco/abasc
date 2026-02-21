' MODULE BASE/BYTEPOS

FUNCTION bytePosSet(x, y) ASM
    ASM "ld      l,(ix+2)   ; X"
    ASM "ld      h,(ix+0)   ; Y"
    ASM "ret"
END FUNCTION

FUNCTION bytePosGetX(bytepos) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION bytePosGetY(intvalue) ASM
    ASM "ld      l,(ix+1)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION bytePosSetX(bytepos, x) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+3)"
    ASM "ret"    
END FUNCTION

FUNCTION bytePosSetY(intvalue, y) ASM
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+0)"
    ASM "ret"    
END FUNCTION
