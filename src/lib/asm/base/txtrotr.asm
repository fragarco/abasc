
; Rotate strings
; This routine requires the table of symbols to have space for
; the rotate characters.
; Inputs
;     DE - ABASC type string address (len + content)
;      H - X pos
;      L - Y pos
fwRotateStringRight:
    ld      a,(de)     ; string lenght
    or      a          ; if 0 return
    ret     z
    inc     de
    ld      b,a
__fwrotrstr_nextchr:
    push    bc        ; store remaining chars
    push    hl        ; store X Y position
    call    &BB75     ; TXT_SET_CURSOR
    ld      a,(de)
    call    fwRotCharRight
    inc     de
    pop     hl
    inc     l         ; self modifying: dec rotleft, inc rotright
    pop     bc
    djnz    __fwrotrstr_nextchr
    ret

; PRIVATE ROUTINE
fwRotCharRight:
    push    de
    call    &BBA5    ; TXT_GET_MATRIX
    ex      de,hl
    call    &BBAE    ; TXT_GET_M_TABLE
    push    af
    call    &B906    ; KL_L_ROM_ENABLE
    ld      c,8
__fwrotright_nextbyte:
    ld      a,(de)
    inc     de
    push    de
    push    hl
    ld      d,128
    ld      e,128
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
    call    &B909    ; KL_L_ROM_DISABLE
    pop     af
    call    &BB5A    ; TXT_OUTPUT
    pop     de
    ret