
; Rotate strings
; This routine requires the table of symbols to have space for
; the rotate characters.
; Inputs
;     DE - ABASC type string address (len + content)
;      H - X pos
;      L - Y pos
fwRotateStringLeft:
    ld      a,(de)     ; string lenght
    or      a          ; if 0 return
    ret     z
    inc     de
    ld      b,a
__fwrotlstr_nextchr:
    push    bc        ; store remaining chars
    push    hl        ; store X Y position
    call    &BB75     ; TXT_SET_CURSOR
    ld      a,(de)
    call    fwRotCharLeft
    inc     de
    pop     hl
    dec     l         ; self modifying: dec rotleft, inc rotright
    pop     bc
    djnz    __fwrotlstr_nextchr
    ret

; PRIVATE ROUTINE
fwRotCharLeft:
    push    de
    call    &BBA5    ; TXT_GET_MATRIX
    ex      de,hl
    call    &BBAE    ; TXT_GET_M_TABLE
    ld      b, 7
__fwrotleft_add7:
    inc     hl
    djnz    __fwrotleft_add7
    push    af
    call    &B906    ; KL_L_ROM_ENABLE
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
    call    &B909    ; KL_L_ROM_DISABLE
    pop     af
    call    &BB5A    ; TXT_OUTPUT
    pop     de
    ret
