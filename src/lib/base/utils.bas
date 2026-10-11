' MODULE BASE/UTILS

SUB utilCallAddr(addr) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "jp      (hl)"
END SUB

SUB utilPause(ticks) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "halt"
    ASM "dec     hl"
    ASM "ld      a,h"
    ASM "or      l"
    ASM "ret     z"
    ASM "jr      $-7"
END SUB
