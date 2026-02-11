' MODULE CPCRSLIB/PLAYER

SUB rsWyzConfigurePlayer(bitflags) ASM
    ASM "ld      a,(ix+0)               ; b0 = load song on/off, b1 = player on/off"
    ASM "jp      cpc_WyzConfigurePlayer ; b2 = sounds on/of, b3 = sfx on/off"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

SUB rsWyzInitPlayer(songstable, effectstable, rulestable, soundstable) ASM
    ASM "jp      cpc_WyzInitPlayer"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

SUB rsWyzLoadSong(song) ASM
    ASM "ld      a,(ix+0)"
    ASM "jp      cpc_WyzLoadSong"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

SUB rsWyzSetTempo(tempo) ASM
    ASM "ld      a,(ix+0)"
    ASM "jp      cpc_WyzSetTempo"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

SUB rsWyzStartEffect(effect, channel) ASM
    ASM "ld      c,(ix+0)"
    ASM "ld      b,(ix+2)"
    ASM "jp      cpc_WyzStartEffect"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

FUNCTION rsWyzStartEffect ASM
    ASM "jp      cpc_WyzTestPlayer  ; interruptores in L"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END FUNCTION

SUB rsWyzSetPlayerOn ASM
    ASM "jp      cpc_WyzSetPlayerOn"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB

SUB rsWyzSetPlayerOff ASM
    ASM "jp      cpc_WyzSetPlayerOff"
    ASM "read 'asm/cpcrslib/player/wyz.asm'"
END SUB