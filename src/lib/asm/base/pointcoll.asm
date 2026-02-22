read 'asm/base/collision.asm'

; CHECKPOINTRECT
; Checks if a point is inside a rectangle
; Inputs:
;     Pointed by IX: rh,rw,ry,rx,py,px
; Outputs:
;     HL -1 (true) or 0 (false)
;     AF, HL, DE are modified
checkPointRect:
    ld      e,(ix+0)     ; RH
    ld      d,(ix+1)
    ld      l,(ix+4)     ; RY
    ld      h,(ix+5)
    add     hl,de        ; RY+RH
    ld      e,(ix+8)     ; PY
    ld      d,(ix+9)
    call    check_comp16 ; PY <= (RY + RH) ?
    jr      c,__checkpoint_false
    ld      e,(ix+4)     ; RY
    ld      d,(ix+5)
    ld      l,(ix+8)     ; PY
    ld      h,(ix+9)
    call    check_comp16 ; PY >= RY ?
    jr      c,__checkpoint_false
    ld      e,(ix+2)     ; RW
    ld      d,(ix+3)
    ld      l,(ix+6)     ; RX
    ld      h,(ix+7)
    add     hl,de
    ld      e,(ix+10)
    ld      d,(ix+11)
    call    check_comp16 ; PX <= (RX + RW) ?
    jr      c,__checkpoint_false
    ld      e,(ix+6)     ; RX
    ld      d,(ix+7)
    ld      l,(ix+10)
    ld      h,(ix+11)
    call    check_comp16 ; PX >= RX
    jr      c,__checkpoint_false
    ld      hl,&FFFF
    ret
__checkpoint_false:
    ld      hl,0
    ret
