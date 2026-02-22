read 'asm/base/collision.asm'

; CHECKRECTRECT
; Checks if two rectangles collide
; Inputs:
;     Pointed by IX: rh2,rw2,ry2,rx2,rh1,rw1,ry1,rx1
; Outputs:
;     HL -1 (true) or 0 (false)
;     AF, HL, DE are modified
checkRectRect:
    ld      e,(ix+0)   ; RH2
    ld      d,(ix+1)
    ld      l,(ix+4)   ; RY2
    ld      h,(ix+5)
    add     hl,de
    ld      e,(ix+12)  ; RY1
    ld      d,(ix+13)
    call    check_comp16  ;  RY1 <= (RY2 + RH2)
    jr      c,__checkrect_false
    ld      e,(ix+8)   ; RH1
    ld      d,(ix+9)
    ld      l,(ix+12)  ; RY1
    ld      h,(ix+13)
    add     hl,de
    ld      e,(ix+4)   ; RY2
    ld      d,(ix+5)
    call    check_comp16  ; (RY1 + RH1) >= RY2
    jr      c,__checkrect_false
    ld      e,(ix+2)   ; RW2
    ld      d,(ix+3)
    ld      l,(ix+6)   ; RX2
    ld      h,(ix+7)
    add     hl,de
    ld      e,(ix+14)
    ld      d,(ix+15)
    call    check_comp16  ; RX1 <= (RX2 + RW2)
    jr      c,__checkrect_false
    ld      e,(ix+10)  ; RW1
    ld      d,(ix+11)
    ld      l,(ix+14)  ; RX1
    ld      h,(ix+15)
    add     hl,de
    ld      e,(ix+6)   ; RX2
    ld      d,(ix+7)
    call    check_comp16  ; (r1x + r1w) >= r2x
    jr      c,__checkrect_false
    ld      hl,&FFFF
    ret
__checkrect_false:
    ld      hl,0
    ret
