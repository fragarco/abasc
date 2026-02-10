' MODULE CPCRSLIB/KEYBOARD

FUNCTION rsAnyKeyPressed ASM
    ASM "jp      cpc_AnyKeyPressed"
    ASM "read 'asm/cpcrslib/keyboard/anykeypressed.asm'"
END FUNCTION
