' MODULE BASE/UTILS

SUB utilCallAddr(addr) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      (hl)"
END SUB
