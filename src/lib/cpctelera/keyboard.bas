' MODULE CPCTELERA/KEYBOARD

' Functions and Procedures:



CONST KEY.Up            = &0100
CONST KEY.Right         = &0200
CONST KEY.Down          = &0400
CONST KEY.F9           = &0800
CONST KEY.F6           = &1000
CONST KEY.F3           = &2000
CONST KEY.Enter        = &4000
CONST KEY.FDot         = &8000
CONST KEY.Left         = &0101
CONST KEY.Copy         = &0201
CONST KEY.F7           = &0401
CONST KEY.F8           = &0801
CONST KEY.F5           = &1001
CONST KEY.F1           = &2001
CONST KEY.F2           = &4001
CONST KEY.F0           = &8001
CONST KEY.Clr          = &0102
CONST KEY.OpenBracket  = &0202
CONST KEY.Return       = &0402
CONST KEY.CloseBracket = &0802
CONST KEY.F4           = &1002
CONST KEY.Shift        = &2002
CONST KEY.BackSlash    = &4002
CONST KEY.Control      = &8002
CONST KEY.Caret        = &0103
CONST KEY.Hyphen       = &0203
CONST KEY.At           = &0403
CONST KEY.P            = &0803
CONST KEY.SemiColon    = &1003
CONST KEY.Colon        = &2003
CONST KEY.Slash        = &4003
CONST KEY.Dot          = &8003
CONST KEY.0            = &0104
CONST KEY.9            = &0204
CONST KEY.O            = &0404
CONST KEY.I            = &0804
CONST KEY.L            = &1004
CONST KEY.K            = &2004
CONST KEY.M            = &4004
CONST KEY.Comma        = &8004
CONST KEY.8            = &0105
CONST KEY.7            = &0205
CONST KEY.U            = &0405
CONST KEY.Y            = &0805
CONST KEY.H            = &1005
CONST KEY.J            = &2005
CONST KEY.N            = &4005
CONST KEY.Space        = &8005
CONST KEY.6            = &0106
CONST JOY1.Up          = &0106
CONST KEY.5            = &0206
CONST JOY1.Down        = &0206
CONST KEY.R            = &0406
CONST JOY1.Left        = &0406
CONST KEY.T            = &0806
CONST JOY1.Right       = &0806
CONST KEY.G            = &1006
CONST JOY1.Fire1       = &1006
CONST KEY.F            = &2006
CONST JOY1.Fire2       = &2006
CONST KEY.B            = &4006
CONST JOY1.Fire3       = &4006
CONST KEY.V            = &8006
CONST KEY.4            = &0107
CONST KEY.3            = &0207
CONST KEY.E            = &0407
CONST KEY.W            = &0807
CONST KEY.S            = &1007
CONST KEY.D            = &2007
CONST KEY.C            = &4007
CONST KEY.X            = &8007
CONST KEY.1            = &0108
CONST KEY.2            = &0208
CONST KEY.Esc          = &0408
CONST KEY.Q            = &0808
CONST KEY.Tab          = &1008
CONST KEY.A            = &2008
CONST KEY.CapsLock     = &4008
CONST KEY.Z            = &8008
CONST JOY0.Up          = &0109
CONST JOY0.Down        = &0209
CONST JOY0.Left        = &0409
CONST JOY0.Right       = &0809
CONST JOY0.Fire1       = &1009
CONST JOY0.Fire2       = &2009
CONST JOY0.Fire3       = &4009
CONST KEY.Del          = &8009

FUNCTION cpctGetKeypressedAsASCII ASM
    ASM "call    cpct_getKeypressedAsASCII   ; A = ascii code or 0"
    ASM "ld      l,a"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read    'asm/cpctelera/keyboard/cpct_getKeypressedAsASCII.asm'"
END FUNCTION

FUNCTION cpctIsAnyKeyPressedf ASM
    ASM "call    cpct_isAnyKeyPressed_f  ; L = A = key status (0 = FALSE)"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read    'asm/cpctelera/keyboard/cpct_isAnyKeyPressed_f.asm'"
END FUNCTION

FUNCTION cpctIsKeyPressed(keyid) ASM
    ASM "ld      l,(ix+0)"
    ASM "ld      h,(ix+1)"
    ASM "call    cpct_isKeyPressed   ; L = A = key status (0 = FALSE)"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read    'asm/cpctelera/keyboard/cpct_isKeyPressed.asm'"
END FUNCTION

SUB cpctScanKeyboardf ASM
    ASM "jp      cpct_scanKeyboard_f"
    ASM "read    'asm/cpctelera/keyboard/cpct_scanKeyboard_f.asm'"
END SUB