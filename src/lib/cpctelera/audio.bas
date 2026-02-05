' MODULE CPCTELERA/AUDIO

' Functions and Procedures:

CONST AY.CHANNELA   = 1
CONST AY.CHANNELB   = 2
CONST AY.CHANNELC   = 4
CONST AY.CHANNELALL = 7

SUB cpctakpMusicInit(songdata) ASM
    ASM "ld      e,(ix+0) ; songdata - Pointer to the start of the array"
    ASM "ld      d,(ix+1) ; containing song's data in AKS binary format"
    ASM "jp      cpct_akp_musicInit"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END SUB

SUB cpctakpMusicPlay ASM
    ASM "jp      cpct_akp_musicPlay"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END SUB

FUNCTION cpctakpSFXGetInstrument(channel) ASM
    ASM "ld      a,(ix+0) ; channel (A = 001 (1), B = 010 (2), C = 100 (4))."
    ASM "jp      cpct_akp_SFXGetInstrument"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END FUNCTION

SUB cpctakpSFXInit(songdata) ASM
    ASM "ld      e,(ix+0) ; songdata - Pointer to the start of a song file"
    ASM "ld      d,(ix+1) ; containing instrument data for SFX"
    ASM "jp      cpct_akp_SFXInit"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END SUB

SUB cpctakpSFXPlay(sfxnum, vol, note, nspeed, invertedpitch, channelbitmask) ASM
    ASM "ld      a,(ix+0)  ; Bitmask representing channels to use for reproducing the sound (A = 001 (1), B = 010 (2), C = 100 (4))"
    ASM "ld      c,(ix+2)  ; Inverted Pitch (-0xFFFF -> 0xFFFF). 0 is no pitch."
    ASM "ld      b,(ix+3)  ; The higher the pitch, the lower the sound."
    ASM "ld      d,(ix+4)  ; Speed (0 = As original, [1-255] = new Speed (1 is fastest))"
    ASM "ld      e,(ix+6)  ; Note to be played with the given instrument [0-143]"
    ASM "ld      h,(ix+8)  ; Volume [0-15], 0 = off, 15 = maximum volume."
    ASM "ld      l,(ix+10) ; Number of the instrument in the SFX Song (>0), same as the number given to the instrument in Arkos Tracker."
    ASM "jp      cpct_akp_SFXPlay"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END SUB

FUNCTION cpctakpSongLoopTimes ASM
    ASM "ld      a,(cpct_akp_songLoopTimes)"
    ASM "ld      l,a"
    ASM "ld      h,0"
    ASM "ret"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END FUNCTION

SUB cpctakpStop ASM
    ASM "jp      cpct_akp_stop"
    ASM "read 'asm/cpctelera/audio/arkostracker.asm'"
END SUB