' MODULE BASE/STRING

FUNCTION strLPad$(s$, totaln, padchar)
    lenn = LEN(s$)
    IF totaln > lenn THEN
        strLPad$ = STRING$(totaln-lenn, padchar) + s$
    ELSE
        strLPad$ = s$
    END IF
END FUNCTION

FUNCTION strRPad$(s$, totaln, padchar)
    lenn = LEN(s$)
    IF totaln > lenn THEN
        strRPad$ = s$ + STRING$(totaln-lenn, padchar)
    ELSE
        strRPad$ = s$
    END IF
END FUNCTION

SUB strAppend(dest$, src$) ASM
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      a,(de)"
    ASM "push    de"
    ASM "push    af"
    ASM "add     a,e"
    ASM "ld      e,a"
    ASM "adc     a,d"
    ASM "sub     e"
    ASM "ld      d,a"
    ASM "inc     de"
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      c,(hl)"
    ASM "push    bc"
    ASM "ld      b,0"
    ASM "inc     hl"
    ASM "ldir"
    ASM "pop     bc"
    ASM "pop     af"
    ASM "pop     de"
    ASM "add     c"
    ASM "ld      (de),a"
    ASM "ret"
END SUB

SUB strCopy(dest$, src$) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "ld      e,(ix+2)"
    ASM "ld      d,(ix+3)"
    ASM "ld      a,(hl)"
    ASM "inc     a"
    ASM "ld      c,a"
    ASM "ld      b,0"
    ASM "ldir"
    ASM "ret"
END SUB

SUB strClear(src$) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "xor     a"
    ASM "ld      (hl),a"
    ASM "ret"
END SUB
