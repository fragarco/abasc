
; Rotate strings
; This routine requires the table of symbols to have space for
; the rotate characters.
; Inputs
;     DE - ABASC type string address (len + content)
;      H - X pos
;      L - Y pos
fwRotateString:
    ld      a,(de)     ; string lenght
    or      a          ; if 0 return
    ret     z
    inc     de
    ld      b,a
__fwrotstr_nextchr:
    push    bc        ; store remaining chars
    push    hl        ; store X Y position
    call    &BB75     ; CURSOR
    ld      a,(de)
__fwrotstr_funcb:
    call    &0000     ; self modifying code
    inc     de
    pop     hl
    dec     l
    pop     bc
    djnz    __fwrotstr_nextchr
    ret

; PRIVATE ROUTINE
fwRotChLeft:
    push    de
    call    &BBA5    ; MATRIX
    ex      de,hl
    call    &BBAE    ; TABLE
    ld      b, 7
__fwrotleft_add7:
    inc     hl
    djnz    __fwrotleft_add7
    push    af
    call    &B906    ; ROM ENABLE
    ld      c, 8
__fwrotleft_nextbyte:
    ld      a, (de)
    inc     de
    push    de
    push    hl
    ld      d, &80
    ld      e, &80
    ld      b, 8
__fwrotleft_nextbit:
    add     d
    rl      (hl)
    dec     hl
    or      e
    srl     d
    sra     e
    set     6, e
    djnz    __fwrotleft_nextbit
    pop     hl
    pop     de
    dec     c
    jr      nz, __fwrotleft_nextbyte
    call    &B909    ; ROM DISABLE
    pop     af
    call    &BB5A    ; TXT_OUT
    pop     de
    ret

; PRIVATE ROUTINE
fwRotChRight:
    push    de
    call    &BBA5    ; MATRIX
    ex      de,hl
    call    &BBAE    ; TABLE
    push    af
    call    &B906    ; ROM ENABLE
    ld      c,8
__fwrotright_nextbyte:
    ld      a,(de)
    inc     de
    push    de
    push    hl
    ld      d,80
    ld      e,80
    ld      b,8
__fwrotright_nextbit:
    add     d
    rr      (hl)
    inc     hl
    or      e
    srl     d
    sra     e
    set     6,e
    djnz    __fwrotright_nextbit
    pop     hl
    pop     de
    dec     c
    jr      nz, __fwrotright_nextbyte
    call    &B909    ; ROM DISABLE
    pop     af
    call    &BB5A    ; TXT_OUT
    pop     de
    ret
