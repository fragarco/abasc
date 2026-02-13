' MODULE BASE/BYTEPOS

FUNCTION BytePosSet(x, y) ASM
    ASM "ld      l,(ix+2)   ; X"
    ASM "ld      h,(ix+0)   ; Y"
    ASM "ret"
END FUNCTION

FUNCTION BytePosGetX(bytepos) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION BytePosGetY(intvalue) ASM
    ASM "ld      l,(ix+1)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION BytePosSetX(bytepos, x) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+3)"
    ASM "ret"    
END FUNCTION

FUNCTION BytePosSetY(intvalue, y) ASM
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+0)"
    ASM "ret"    
END FUNCTION