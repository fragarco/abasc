; LETRAS GIGANTES
; CALL 40000,X,Y,@A$,P1,P2
; P1 Pen for upper side, set by self modifying code
; P2 Pen for bottom side, set by self modifying code
; Inputs:
;   DE - Address to the ABASC type string (len + content)
;    L - Y pos
;    H - X pos
fwBigLetters:
    call    &BB93   ; GET_PEN
    push    af      ; store current PEN
    ld      a,(de)  ; check string lenght
    or      a
    ret     z
    ld      b,a
    inc     de
__bigletter_nextchr:
    push    bc
    push    de
    push    hl
    ld      a, (de)
    ld      b, a
    call    &B906    ; ROM ENABLE
    ld      a, b
    call    fwBigChar
    ld      b, a
    call    &B909    ; ROM DISABLE
    pop     hl
    ld      e, l
    ld      d, h
    call    &BB75    ; SET CURSOR
__bigletter_pen1:
    ld      a,0      ; Self modifying code
    call    &BB90    ; SET PEN
    ld      a,b
    call    &BB5A    ; TXT_OUT
    inc     a
    call    &BB5A    ; TXT_OUT
    ld      l,e
    ld      h,d
    inc     l
    call    &BB75    ; SET CURSOR
__bigletter_pen2:
    ld      a,0      ; Self modifying code
    call    &BB90    ; SET PEN
    ld      a,b
    inc     a
    inc     a
    call    &BB5A    ; TXT_OUT
    inc     a
    call    &BB5A    ; TXT_OUT
    ld      l, e
    ld      h, d
    inc     h
    inc     h
    pop     de
    inc     de
    pop     bc
    djnz    __bigletter_nextchr
    pop     af
    call    &BB90    ; SET PEN
    ret

; PRIVATE ROUTINE
fwBigChar:
    call    &BBA5   ; MATRIX
    ex      de,hl
    call    &BBAE   ; TABLE
    push    af
    ld      c,2
__bigchar_nextset:
    ld      b,4
__bigchar_nextrow:
    push    bc
    ld      a,(de)
    rrca
    rrca
    rrca
    rrca
    ld      b,4
__bigchar_leftbyte:
    rra
    rr      (hl)
    sra     (hl)
    djnz    __bigchar_leftbyte
    ld      a,(hl)
    inc     hl
    ld      (hl),a
    ld      b,7
__bigchar_next1:
    inc     hl
    djnz    __bigchar_next1
    ld      a,(de)
    ld      b,4
__bigchar_rgtbyte:  
    rra
    rr      (hl)
    sra     (hl)
    djnz    __bigchar_rgtbyte
    ld      a,(hl)
    inc     hl
    ld      (hl),a
    ld      b,7
__bigchar_next2:
    dec     hl
    djnz    __bigchar_next2
    inc     de
    pop     bc
    djnz    __bigchar_nextrow
    ld      b,8
__bigchar_next3:
    inc     hl
    djnz    __bigchar_next3
    dec     c
    jr      nz,__bigchar_nextset
    pop     af
    ret
