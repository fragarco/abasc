' MODULE CPCRSLIB/KEYBOARD

const RSKEY.EMPTY   = &FFFF  ' Key constants (line + key position) for use
const RSKEY.FDOT    = &4080  ' with rsAssignKey
const RSKEY.FENTER  = &4040
const RSKEY.F3      = &4020
const RSKEY.F6      = &4010
const RSKEY.F9      = &4008
const RSKEY.DOWN    = &4004
const RSKEY.RIGHT   = &4002
const RSKEY.UP      = &4001
const RSKEY.F0      = &4180
const RSKEY.F2      = &4140
const RSKEY.F1      = &4120
const RSKEY.F5      = &4110
const RSKEY.F8      = &4108
const RSKEY.F7      = &4104
const RSKEY.COPY    = &4102
const RSKEY.LEFT    = &4101
const RSKEY.CTRL    = &4280
const RSKEY.BSLASH  = &4240
const RSKEY.SHIFT   = &4220
const RSKEY.F4      = &4210
const RSKEY.RSQUARE = &4208
const RSKEY.RETURN  = &4204
const RSKEY.LSQUARE = &4202
const RSKEY.CLR     = &4201
const RSKEY.DOT     = &4380
const RSKEY.FSLASH  = &4340
const RSKEY.COLON   = &4320
const RSKEY.SCOLON  = &4310
const RSKEY.P       = &4308
const RSKEY.AT      = &4304
const RSKEY.MINUS   = &4302
const RSKEY.EXP     = &4301
const RSKEY.COMMA   = &4480
const RSKEY.M       = &4440
const RSKEY.K       = &4420
const RSKEY.L       = &4410
const RSKEY.I       = &4408
const RSKEY.O       = &4404
const RSKEY.9       = &4402
const RSKEY.0       = &4401
const RSKEY.SPACE   = &4580
const RSKEY.N       = &4540
const RSKEY.J       = &4520
const RSKEY.H       = &4510
const RSKEY.Y       = &4508
const RSKEY.U       = &4504
const RSKEY.7       = &4502
const RSKEY.8       = &4501
const RSKEY.V       = &4680
const RSKEY.B       = &4640
const RSKEY.F       = &4620
const RSKEY.G       = &4610
const RSKEY.T       = &4608
const RSKEY.R       = &4604
const RSKEY.5       = &4602
const RSKEY.6       = &4601
const RSKEY.J2FIRE3 = &4640
const RSKEY.J2FIRE2 = &4620
const RSKEY.J2FIRE1 = &4610
const RSKEY.J2RIGHT = &4608
const RSKEY.J2LEFT  = &4604
const RSKEY.J2DOWN  = &4602
const RSKEY.J2UP    = &4601
const RSKEY.X       = &4780
const RSKEY.C       = &4740
const RSKEY.D       = &4720
const RSKEY.S       = &4710
const RSKEY.W       = &4708
const RSKEY.E       = &4704
const RSKEY.3       = &4702
const RSKEY.4       = &4701
const RSKEY.Z       = &4880
const RSKEY.CAPS    = &4840
const RSKEY.A       = &4820
const RSKEY.TAB     = &4810
const RSKEY.Q       = &4808
const RSKEY.ESC     = &4804
const RSKEY.2       = &4802
const RSKEY.1       = &4801
const RSKEY.DEL     = &4980
const RSKEY.J1FIRE3 = &4940
const RSKEY.J1FIRE2 = &4920
const RSKEY.J1FIRE1 = &4910
const RSKEY.J1RIGHT = &4908
const RSKEY.J1LEFT  = &4904
const RSKEY.J1DOWN  = &4902
const RSKEY.J1UP    = &4901

const RSKB.LINE1    = &40  ' Keyboard line constants for rsTestKeyboard
const RSKB.LINE2    = &41
const RSKB.LINE3    = &42
const RSKB.LINE4    = &43
const RSKB.LINE5    = &44
const RSKB.LINE6    = &45
const RSKB.LINE7    = &46
const RSKB.LINE8    = &47
const RSKB.LINE9    = &48
const RSKB.LINE10   = &49

FUNCTION rsAnyKeyPressed ASM
    ASM "jp      cpc_AnyKeyPressed"
    ASM "read 'asm/cpcrslib/keyboard/anykeypressed.asm'"
END FUNCTION

SUB rsAssignKey(entry, keyid) ASM
    ASM "ld      c,(ix+0)     ; Byte value in the line row"
    ASM "ld      b,(ix+1)     ; Line id in the keyboard matrix"
    ASM "ld      e,(ix+2)     ; Entry in the assigment table"
    ASM "jp      cpc_AssignKey"
    ASM "read 'asm/cpcrslib/keyboard/assignkey.asm'"
END SUB

FUNCTION rsCheckKey(entry) ASM
    ASM "ld      l,(ix+0)     ; Entry in the assigment table"
    ASM "jp      cpc_CheckKey ; HL = -1 (true) or 0 (false)"
    ASM "read 'asm/cpcrslib/keyboard/checkkey.asm'"
END FUNCTION

SUB rsDeleteKeys ASM
    ASM "jp      cpc_DeleteKeys"
    ASM "read 'asm/cpcrslib/keyboard/deletekeys.asm'"
END SUB

SUB rsRedefineKey(entry) ASM
    ASM "ld      l,(ix+0)        ; Entry in the assigment table"
    ASM "jp      cpc_RedefineKey ; Waits until a key is pressed"
    ASM "read 'asm/cpcrslib/keyboard/redefinekey.asm'"
END SUB

SUB rsScanKeyboard ASM
    ASM "jp      cpc_ScanKeyboard"
    ASM "read 'asm/cpcrslib/keyboard/scankeyboard.asm'"
END SUB

FUNCTION rsTestKey(entry) ASM
    ASM "ld      l,(ix+0)     ; Entry in the assigment table"
    ASM "jp      cpc_TestKey  ; HL = -1 (true) HL = 0 (false)"
    ASM "read 'asm/cpcrslib/keyboard/testkey.asm'"
END FUNCTION

FUNCTION rsTestKeyboard(kbline) ASM
    ASM "ld      l,(ix+0)         ; Keyboard matrix line (&40 .. &49)"
    ASM "call    cpc_TestKeyboard ; Status of the 8 keys in the line in A"
    ASM "ld      l,a"
    ASM "ld      0"
    ASM "ret"
    ASM "read 'asm/cpcrslib/keyboard/testkeyboard.asm'"
END FUNCTION

