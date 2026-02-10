' MODULE CPCRSLIB/FIRMWARE

SUB rsDisableFirmware ASM
    ASM "jp      cpc_DisableFirmware"
    ASM "read 'asm/cpcrslib/firmware/disablefw.asm'"
END SUB

SUB rsEnableFirmware ASM
    ASM "jp      cpc_EnableFirmware"
    ASM "read 'asm/cpcrslib/firmware/enablefw.asm'"
END SUB
