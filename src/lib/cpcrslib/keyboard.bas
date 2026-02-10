' MODULE CPCRSLIB/KEYBOARD

SUB rsUseFontNanako ASM
    ASM "ret"
    ASM "read 'asm/cpcrslib/text/font_nanako.asm'"
END SUB

FUNCTION rsAnyKeyPressed ASM
    ASM "jp      cpc_AnyKeyPressed"
    ASM "read 'asm/cpcrslib/keyboard/anykeypressed.asm'"
END FUNCTION
