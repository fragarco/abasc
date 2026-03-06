' MODULE BASE/BYTE

FUNCTION byteCompose(b0, b1) ASM
    ASM "ld      l,(ix+2)   ; LOW"
    ASM "ld      h,(ix+0)   ; HIGH"
    ASM "ret"
END FUNCTION

FUNCTION byte0(int16) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION byte1(int16) ASM
    ASM "ld      l,(ix+1)"
    ASM "ld      h,0"
    ASM "ret"    
END FUNCTION

FUNCTION byteSet0(int16, v) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+3)"
    ASM "ret"    
END FUNCTION

FUNCTION byteSet1(int16, v) ASM
    ASM "ld      l,(ix+2)"
    ASM "ld      h,(ix+0)"
    ASM "ret"    
END FUNCTION
