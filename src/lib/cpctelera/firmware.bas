' MODULE CPCTELERA/FIRMWARE

' Functions and Procedures:


SUB cpctRemoveInterruptHandler ASM
    ASM "read 'asm/cpctelera/firmware/cpct_removeInterruptHandler.asm'"
END SUB
