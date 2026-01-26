' MODULE CPCTELERA/KEYBOARD

' Functions and Procedures:



CONST KEY.UP            = &0100
CONST KEY.RIGHT         = &0200
CONST KEY.DOWN          = &0400
CONST KEY.F9           = &0800
CONST KEY.F6           = &1000
CONST KEY.F3           = &2000
CONST KEY.ENTER        = &4000
CONST KEY.FDOT         = &8000
CONST KEY.LEFT         = &0101
CONST KEY.COPY         = &0201
CONST KEY.F7           = &0401
CONST KEY.F8           = &0801
CONST KEY.F5           = &1001
CONST KEY.F1           = &2001
CONST KEY.F2           = &4001
CONST KEY.F0           = &8001
CONST KEY.CLR          = &0102
CONST KEY.OPENBRACKET  = &0202
CONST KEY.RETURN       = &0402
CONST KEY.CLOSEBRACKET = &0802
CONST KEY.F4           = &1002
CONST KEY.SHIFT        = &2002
CONST KEY.BACKSLASH    = &4002
CONST KEY.CONTROL      = &8002
CONST KEY.CARET        = &0103
CONST KEY.HYPHEN       = &0203
CONST KEY.AT           = &0403
CONST KEY.P            = &0803
CONST KEY.SEMICOLON    = &1003
CONST KEY.COLON        = &2003
CONST KEY.SLASH        = &4003
CONST KEY.DOT          = &8003
CONST KEY.0            = &0104
CONST KEY.9            = &0204
CONST KEY.O            = &0404
CONST KEY.I            = &0804
CONST KEY.L            = &1004
CONST KEY.K            = &2004
CONST KEY.M            = &4004
CONST KEY.COMMA        = &8004
CONST KEY.8            = &0105
CONST KEY.7            = &0205
CONST KEY.U            = &0405
CONST KEY.Y            = &0805
CONST KEY.H            = &1005
CONST KEY.J            = &2005
CONST KEY.N            = &4005
CONST KEY.SPACE        = &8005
CONST KEY.6            = &0106
CONST JOY1.UP          = &0106
CONST KEY.5            = &0206
CONST JOY1.DOWN        = &0206
CONST KEY.R            = &0406
CONST JOY1.LEFT        = &0406
CONST KEY.T            = &0806
CONST JOY1.RIGHT       = &0806
CONST KEY.G            = &1006
CONST JOY1.FIRE1       = &1006
CONST KEY.F            = &2006
CONST JOY1.FIRE2       = &2006
CONST KEY.B            = &4006
CONST JOY1.FIRE3       = &4006
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
CONST KEY.ESC          = &0408
CONST KEY.Q            = &0808
CONST KEY.TAB          = &1008
CONST KEY.A            = &2008
CONST KEY.CAPSLOCK     = &4008
CONST KEY.Z            = &8008
CONST JOY0.UP          = &0109
CONST JOY0.DOWN        = &0209
CONST JOY0.LEFT        = &0409
CONST JOY0.RIGHT       = &0809
CONST JOY0.FIRE1       = &1009
CONST JOY0.FIRE2       = &2009
CONST JOY0.FIRE3       = &4009
CONST KEY.DEL          = &8009

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

SUB cpctScanKeyboard ASM
    ASM "jp      cpct_scanKeyboard"
    ASM "read    'asm/cpctelera/keyboard/cpct_scanKeyboard.asm'"
END SUB

SUB cpctScanKeyboardf ASM
    ASM "jp      cpct_scanKeyboard_f"
    ASM "read    'asm/cpctelera/keyboard/cpct_scanKeyboard_f.asm'"
END SUB