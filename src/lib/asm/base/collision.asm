
; PRIVATE
check_comp16:
    xor     a
    sbc     hl,de
    ret     z
    jp      m,__chkcomp16_cs1
    or      a
    ret
__chkcomp16_cs1:
    scf
    ret