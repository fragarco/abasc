' MODULE CPCTELERA/FIRMWARE

' Functions and Procedures:
'   command   cpctDisableLowerROM()
'   command   cpctDisableUpperROM()
'   command   cpctEnableLowerROM()
'   command   cpctEnableUpperROM()
'
'   function  cpctRemoveInterruptHandler()
'   command   cpctSetInterruptHandler(cbaddress)


SUB cpctDisableLowerROM ASM
    ASM "jp      cpct_disableLowerROM"
    ASM "read 'asm/cpctelera/firmware/cpct_enableDisableROMs.asm'"
END SUB

SUB cpctDisableUpperROM ASM
    ASM "jp      cpct_disableUpperROM"
    ASM "read 'asm/cpctelera/firmware/cpct_enableDisableROMs.asm'"
END SUB

SUB cpctEnableLowerROM ASM
    ASM "jp      cpct_enableLowerROM"
    ASM "read 'asm/cpctelera/firmware/cpct_enableDisableROMs.asm'"
END SUB

SUB cpctEnableUpperROM ASM
    ASM "jp      cpct_enableUpperROM"
    ASM "read 'asm/cpctelera/firmware/cpct_enableDisableROMs.asm'"
END SUB

FUNCTION cpctRemoveInterruptHandler ASM
    ASM "jp      cpct_removeInterruptHandler ; returns in HL current callback address"
    ASM "read 'asm/cpctelera/firmware/cpct_removeInterruptHandler.asm'"
END FUNCTION

SUB cpctSetInterruptHandler(cbaddress) ASM
    ASM "ld      l,(ix+0)   ; address to the routine (callback) that will be called"
    ASM "ld      h,(ix+1)   ; for each interrupt"
    ASM "jp      cpct_setInterruptHandler"
    ASM "read 'asm/cpctelera/firmware/cpct_setInterruptHandler.asm'"
END SUB
