"""
ABASC compiler z80 runtime functions

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation in its version 3.

This program is distributed in the hope that it will be useful
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
"""

#
# Addresses for CPC Firmware Rutines
#
class FWCALL:
    LOW_LIMIT           = "&40"      # Starting address for BASIC programs
    HIGH_LIMIT          = "&A6FB"    # Last free position before Firmware variables

    # LOW jumpblock
    
    RESET_ENTRY         = "&0000"
    LOW_JUMP            = "&0008"
    KL_LOW_PCHL         = "&000B"
    PCBC_INSTRUCTION    = "&000E"
    SIDE_CALL           = "&0010"
    KL_SIDE_PCHL        = "&0013"
    PCDE_INSTRUCTION    = "&0016"
    FAR_CALL            = "&0018"
    KL_FAR_PCHL         = "&001B"
    PCHL_INSTRUCTION    = "&001E"
    RAM_LAM             = "&0020"
    KL_FAR_CALL         = "&0023"
    FIRM_JUMP           = "&0028"
    USER_RESTART        = "&0030"
    INTERRUPT_ENTRY     = "&0038"
    EXT_INTERRUPT       = "&003B"

    # HI jumpblock

    KL_U_ROM_ENABLE     = "&B900" 
    KL_U_ROM_DISABLE    = "&B903" 
    KL_L_ROM_ENABLE     = "&B906"
    KL_L_ROM_DISABLE    = "&B909"
    KL_ROM_RESTORE      = "&B90C"
    KL_ROM_SELECT       = "&B90F"
    KL_CURR_SELECTION   = "&B912"
    KL_PROBE_ROM        = "&B915"
    KL_ROM_DESELECT     = "&B918"
    KL_LDIR             = "&B91B"
    KL_LDDR             = "&B91E"
    KL_POLL_SYNCHRONOUS = "&B921"
    KL_SCAN_NEEDED      = "&B92A"

    KM_INITIALISE       = "&BB00"
    KM_RESET            = "&BB03"
    KM_WAIT_CHAR        = "&BB06"
    KM_READ_CHAR        = "&BB09"
    KM_CHAR_RETURN      = "&BB0C"
    KM_SET_EXPAND       = "&BB0F"
    KM_GET_EXPAND       = "&BB12"
    KM_EXP_BUFFER       = "&BB15"
    KM_WAIT_KEY         = "&BB18"
    KM_READ_KEY         = "&BB1B"
    KM_TEST_KEY         = "&BB1E"
    KM_GET_STATE        = "&BB21"
    KM_GET_JOYSTICK     = "&BB24"
    KM_SET_TRANSLATE    = "&BB27"
    KM_GET_TRANSLATE    = "&BB2A"
    KM_SET_SHIFT        = "&BB2D"
    KM_GET_SHIFT        = "&BB30"
    KM_SET_CONTROL      = "&BB33"
    KM_GET_CONTROL      = "&BB36"
    KM_SET_REPEAT       = "&BB39"
    KM_GET_REPEAT       = "&BB3C"
    KM_SET_DELAY        = "&BB3F"
    KM_GET_DELAY        = "&BB42"
    KM_ARM_BREAK        = "&BB45"
    KM_DISARM_BREAK     = "&BB48"
    KM_BREAK_EVENT      = "&BB4B"

    TXT_INITIALISE      = "&BB4E"
    TXT_RESET           = "&BB51"
    TXT_VDU_ENABLE      = "&BB54"
    TXT_VDU_DISABLE     = "&BB57"
    TXT_OUTPUT          = "&BB5A"
    TXT_WR_CHAR         = "&BB5D"
    TXT_RD_CHAR         = "&BB60"
    TXT_SET_GRAPHIC     = "&BB63"
    TXT_WIN_ENABLE      = "&BB66"
    TXT_GET_WINDOW      = "&BB69"
    TXT_CLEAR_WINDOW    = "&BB6C"
    TXT_SET_COLUMN      = "&BB6F"
    TXT_SET_ROW         = "&BB72"
    TXT_SET_CURSOR      = "&BB75"
    TXT_GET_CURSOR      = "&BB78"
    TXT_CUR_ENABLE      = "&BB7B"
    TXT_CUR_DISABLE     = "&BB7E"
    TXT_CUR_ON          = "&BB81"
    TXT_CUR_OFF         = "&BB84"
    TXT_VALIDATE        = "&BB87"
    TXT_PLACE_CURSOR    = "&BB8A"
    TXT_REMOVE_CURSOR   = "&BB8D"
    TXT_SET_PEN         = "&BB90"
    TXT_GET_PEN         = "&BB93"
    TXT_SET_PAPER       = "&BB96"
    TXT_GET_PAPER       = "&BB99"
    TXT_INVERSE         = "&BB9C"
    TXT_SET_BACK        = "&BB9F"
    TXT_GET_BACK        = "&BBA2"
    TXT_GET_MATRIX      = "&BBA5"
    TXT_SET_MATRIX      = "&BBA8"
    TXT_SET_M_TABLE     = "&BBAB"
    TXT_GET_M_TABLE     = "&BBAE"
    TXT_GET_CONTROLS    = "&BBB1"
    TXT_STR_SELECT      = "&BBB4"
    TXT_SWAP_STREAMS    = "&BBB7"

    GRA_INITIALISE      = "&BBBA"
    GRA_RESET           = "&BBBD"
    GRA_MOVE_ABSOLUTE   = "&BBC0"
    GRA_MOVE_RELATIVE   = "&BBC3"
    GRA_ASK_CURSOR      = "&BBC6"
    GRA_SET_ORIGIN      = "&BBC9"
    GRA_GET_ORIGIN      = "&BBCC"
    GRA_WIN_WIDTH       = "&BBCF"
    GRA_WIN_HEIGHT      = "&BBD2"
    GRA_GET_W_WIDTH     = "&BBD5"
    GRA_GET_W_HEIGHT    = "&BBD8"
    GRA_CLEAR_WINDOW    = "&BBDB"
    GRA_SET_PEN         = "&BBDE"
    GRA_GET_PEN         = "&BBE1"
    GRA_SET_PAPER       = "&BBE4"
    GRA_GET_PAPER       = "&BBE7"
    GRA_PLOT_ABSOLUTE   = "&BBEA"
    GRA_PLOT_RELATIVE   = "&BBED"
    GRA_TEST_ABSOLUTE   = "&BBF0"
    GRA_TEST_RELATIVE   = "&BBF3"
    GRA_LINE_ABSOLUTE   = "&BBF6"
    GRA_LINE_RELATIVE   = "&BBF9"
    GRA_WR_CHAR         = "&BBFC"
    GRA_SET_BACK        = "&BD46"  # Overlaps with 464 maths
    GRA_SET_FIRST       = "&BD49"  # Overlaps with 464 maths
    GRA_SET_LINEMASK    = "&BD4C"  # Overlaps with 464 maths
    GRA_FILL            = "&BD52"  # Overlaps with 464 maths

    SCR_INITIALISE      = "&BBFF"
    SCR_RESET           = "&BC02"
    SCR_SET_OFFSET      = "&BC05"
    SCR_SET_BASE        = "&BC08"
    SCR_GET_LOCATION    = "&BC0B"
    SCR_SET_MODE        = "&BC0E"
    SCR_GET_MODE        = "&BC11"
    SCR_CLEAR           = "&BC14"
    SCR_CHAR_LIMITS     = "&BC17"
    SCR_CHAR_POSITION   = "&BC1A"
    SCR_DOT_POSITION    = "&BC1D"
    SCR_NEXT_BYTE       = "&BC20"
    SCR_PREV_BYTE       = "&BC23"
    SCR_NEXT_LINE       = "&BC26"
    SCR_PREV_LINE       = "&BC29"
    SCR_INK_ENCODE      = "&BC2C"
    SCR_INK_DECODE      = "&BC2F"
    SCR_SET_INK         = "&BC32"
    SCR_GET_INK         = "&BC35"
    SCR_SET_BORDER      = "&BC38"
    SCR_GET_BORDER      = "&BC3B"
    SCR_SET_FLASHING    = "&BC3E"
    SCR_GET_FLASHING    = "&BC41"
    SCR_FILL_BOX        = "&BC44"
    SCR_FLOOD_BOX       = "&BC17"
    SCR_CHAR_INVERT     = "&BC4A"
    SCR_HW_ROLL         = "&BC4D"
    SCR_SW_ROLL         = "&BC50"
    SCR_UNPACK          = "&BC53"
    SCR_REPACK          = "&BC56"
    SCR_ACCESS          = "&BC59"
    SCR_PIXELS          = "&BC5C"
    SCR_HORIZONTAL      = "&BC5F"
    SCR_VERTICAL        = "&BC62"
    
    CAS_INITIALISE      = "&BC65"
    CAS_SET_SPEED       = "&BC68"
    CAS_NOISY           = "&BC6B"
    CAS_START_MOTOR     = "&BC6E"
    CAS_STOP_MOTOR      = "&BC71"
    CAS_RESTORE_MOTOR   = "&BC74"
    CAS_IN_OPEN         = "&BC77"
    CAS_IN_CLOSE        = "&BC7A"
    CAS_IN_ABANDON      = "&BC7D"
    CAS_IN_CHAR         = "&BC80"
    CAS_IN_DIRECT       = "&BC83"
    CAS_RETURN          = "&BC86"
    CAS_TEST_EOF        = "&BC89"
    CAS_OUT_OPEN        = "&BC8C"
    CAS_OUT_CLOSE       = "&BC8F"
    CAS_OUT_ABANDON     = "&BC92"
    CAS_OUT_CHAR        = "&BC95"
    CAS_OUT_DIRECT      = "&BC98"
    CAS_CATALOG         = "&BC9B"
    CAS_WRITE           = "&BC9E"
    CAS_READ            = "&BCA1"
    CAS_CHECK           = "&BCA4"

    SOUND_RESET         = "&BCA7"
    SOUND_QUEUE         = "&BCAA"
    SOUND_CHECK         = "&BCAD"
    SOUND_ARM_EVENT     = "&BCB0"
    SOUND_RELEASE       = "&BCB3"
    SOUND_HOLD          = "&BCB6"
    SOUND_CONTINUE      = "&BCB9"
    SOUND_AMPL_ENVELOPE = "&BCBC"
    SOUND_TONE_ENVELOPE = "&BCBF"
    SOUND_A_ADDRESS     = "&BCC2"
    SOUND_T_ADDRESS     = "&BCC5"

    KL_CHOKE_OFF        = "&BCC8"
    KL_ROM_WALK         = "&BCCB"
    KL_INIT_BACK        = "&BCCE"
    KL_LOG_EXT          = "&BCD1"
    KL_FIND_COMMAND     = "&BCD4"
    KL_NEW_FRAME_FLY    = "&BCD7"
    KL_ADD_FRAME_FLY    = "&BCDA"
    KL_DEL_FRAME_FLY    = "&BCDD"
    KL_NEW_FAST_TICKER  = "&BCE0"
    KL_ADD_FAST_TICKER  = "&BCE3"
    KL_DEL_FAST_TICKER  = "&BCE6"
    KL_ADD_TICKER       = "&BCE9"
    KL_DEL_TICKER       = "&BCEC"
    KL_INIT_EVENT       = "&BCEF"
    KL_EVENT            = "&BCF2"
    KL_SYNC_RESET       = "&BCF5"
    KL_DEL_SYNCHRONOUS  = "&BCF8"
    KL_NEXT_SYNC        = "&BCFB"
    KL_DO_SYNC          = "&BCFE"
    KL_DONE_SYNC        = "&BD01"
    KL_EVENT_DISABLE    = "&BD04"
    KL_EVENT_ENABLE     = "&BD07"
    KL_DISARM_EVENT     = "&BD0A"
    KL_TIME_PLEASE      = "&BD0D"
    KL_TIME_SET         = "&BD10"

    MC_BOOT_PROGRAM     = "&BD13"
    MC_START_PROGRAM    = "&BD16"
    MC_WAIT_FLYBACK     = "&BD19"
    MC_SET_MODE         = "&BD1C"
    MC_SCREEN_OFFSET    = "&BD1F"
    MC_CLEAR_INKS       = "&BD22"
    MC_SET_INKS         = "&BD25"
    MC_RESET_PRINTER    = "&BD28"
    MC_PRINT_TRANSLATION= "&BD58"
    MC_PRINT_CHAR       = "&BD2B"
    MC_BUSY_PRINTER     = "&BD2E"
    MC_SEND_PRINTER     = "&BD31"
    MC_SOUND_REGISTER   = "&BD34"

    # WATCH OUT: this are 464 addresses
    # 6128 are the same plus 36 bytes
    MATH_MOVE_REAL      = "&BD3D"
    MATH_INT_TO_REAL    = "&BD40"
    MATH_BIN_TO_REAL    = "&BD43"
    MATH_REAL_TO_INT    = "&BD46"
    MATH_REAL_TO_BIN    = "&BD49"
    MATH_REAL_FIX       = "&BD4C"
    MATH_REAL_INT       = "&BD4F"
    MATH_REAL_PREPARE   = "&BD52"
    MATH_REAL_10A       = "&BD55"
    MATH_REAL_ADD       = "&BD58"
    MATH_REAL_REV_SUBS  = "&BD5E"
    MATH_REAL_MULT      = "&BD61"
    MATH_REAL_DIV       = "&BD64"
    MATH_REAL_COMP      = "&BD6A"
    MATH_REAL_UMINUS    = "&BD6D"
    MATH_REAL_SIGNUM    = "&BD70"
    MATH_SET_ANGLE_MODE = "&BD73"
    MATH_REAL_PI        = "&BD76"
    MATH_REAL_SQR       = "&BD79"
    MATH_REAL_POWER     = "&BD7C"
    MATH_REAL_LOG       = "&BD7F"
    MATH_REAL_LOG_10    = "&BD82"
    MATH_REAL_EXP       = "&BD85"
    MATH_REAL_SINE      = "&BD88"
    MATH_REAL_COSINE    = "&BD8B"
    MATH_REAL_TANGENT   = "&BD8E"
    MATH_REAL_ARCTANGENT= "&BD91"

    KM_TEST_BREAK       = "&BDEE"
    KM_SCAN_KEYS        = "&BDF4"

#
# RUNTIME rutines
# "rutine id": ([], "variables for data area", """routine code"""),...
# 
RT = {
#
# RUNTIME VARIABLES
#
    "rt_error": ([],"",
"""
; RT_ERROR
; Variable, can be set by ERROR and read by ERR
rt_error: db 0
"""
),
    "rt_rsx_setstring": ([],"",
"""
; RT_RSX_SETSTRING
; RSX commands expect strings in a specific format where
; a header of 3 bytes defines the string as follows:
; <1: string len><2-3: string address> -> "string"
; Inputs:
;     HL address to a regular ABASC string
;     DE address to one of the RSX string placeholders
; Outputs:
;     HL address to the filled placeholder
;     A, HL and DE are modified
rt_rsx_string1: defs 3
rt_rsx_string2: defs 3
rt_rsx_setstring:
    push    de
    ex      de,hl
    ld      a,(de)
    inc     de
    ld      (hl),a
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     hl
    ret
"""
),
#
# MEM AND CALLS
# 
    "rt_malloc": (["rt_free_all"],"",
"""
; RT_MALLOC
; Returns in HL the address to a heap free memory block
; reserving as many bytes as indicated by BC
; Inputs:
;     BC number of bytes to allocate
; Outputs:
;     HL address to the new reserved memory
;     HL and Flags are modified
rt_malloc:
    ld      hl,(rt_heapmem_next)
    push    hl
    add     hl,bc
    ld      (rt_heapmem_next),hl
    pop     hl
    ret
"""
),
    "rt_malloc_de": (["rt_free_all"],"",
"""
; RT_MALLOC_DE
; Returns in DE the address to a heap free memory block
; reserving as many bytes as indicated by BC
; Inputs:
;     BC number of bytes to allocate
; Outputs:
;     DE address to the new reserved memory
;     DE and Flags are modified
rt_malloc_de:
    ld      de,(rt_heapmem_next)
    push    de
    ex      de,hl
    add     hl,bc
    ld      (rt_heapmem_next),hl
    ex      de,hl
    pop     de
    ret
"""
),
    "rt_free_all": ([],"",
"""
; RT_FREE_ALL
; Resets the position of the next available heap memory block
; to its initial position
; Inputs:
;     None
; Outputs:
;     None
;     DE gets modified
rt_free_all:
    ld      de,(rt_heapmem_start)
    ld      (rt_heapmem_next),de
    ret
"""
),
    "rt_call": ([],"",
"""
; RT_CALL
; Jumps to the address passed in HL and uses the RET from the
; callee to return to the original caller.
; Inputs:
;      A number of additional parameters in the stack
;     IX address to the last parameter in the stack
;     HL address to call to
; Outputs:
;     Depends on the callee
rt_call:
    jp      (hl)
"""
),
    "rt_math_call": ([],
"""
rt_math_accum1: db  0,0,0,0,0  ; float values to use with firmware call must be over first 4k
rt_math_accum2: db  0,0,0,0,0  ; float values to use with firmware call must be over first 4k
rt_math_offset: dw  0
""",
f"""
; RT_MATH_CALL
; Jumps to the address passed in DE but it adjusts the address
; so in 664 and 6128 machines it adds 36 bytes which is the shift
; in the math jumpblock between these machines and the 464.
; Inputs:
;     IX call address as per 464 firmware jumpblock
; Outputs:
;     Depends on the callee
;     BC and IX are directly modified
rt_math_call:
    ld      bc,(rt_math_offset)  ; adjutst for non 464 machines
    add     ix,bc
    jp      (ix)
; RT_MATH_SETOFFSET
; Checks the Amstrad CPC model and sets the value of rt_math_offset
; so rt_math_call can find the right jumpblock addres.
; Inputs:
;     None
; Outputs:
;     None
;     AF, BC and DE are directly modified
rt_math_setoffset:
    ld      c,0     ; ROM select address
    call    {FWCALL.KL_PROBE_ROM}   ; KL_PROBE_ROM
    ld      a,h     ; 0 = CPC464, 1 = CPC664, 2 = CPC6128, 4 = Plus)
    or      a
    ret     z
    ld      a,&24   ; offset for 664 and 6128
    ld      (rt_math_offset),a
    ret
"""
),
    "rt_move_real": ([],"",
"""
; RT_MOVE_REAL
; Copies the real number 5 bytes pointed by HL into de
; memory pointed by DE
; so rt_math_call can find the right jumpblock addres.
; Inputs:
;     HL address to the real number to copy
;     DE address to the destination memory
; Outputs:
;     HL points to the destination memory
;     HL and DE are modified
rt_move_real:
    push    bc
    push    de
    ld      bc,5
    ldir
    pop     hl
    pop     bc
    ret
"""
),
    "rt_scratch_pad": ([],
"""
; Free memory for temporal use
rt_scratch_pad:  defs  255
""",
""
),
#
# STRINGS
#      
    "rt_stradd_len": ([],"",
"""
; RT_STRADD_LEN
; Returns the addition of two string lenghts.
; Final length is cropped to 254 if exceeds.
; Inputs:
;    HL address to length1 in memory
;    DE address to length2 in memory
; Outputs:
;     A resulting length (HL) + (DE) truncated to 254 if needed
;     B and Flags are modified
rt_stradd_len:
    ld     b,(hl)
    ld     a,(de)
    add    a,b
    jr     c,__addlen_crop
    cp     255
    ret    c
__addlen_crop:
    ld     a,254  ; max allowed
    ret
"""
),
    "rt_strcopy": ([],"",
"""
; RT_STRCOPY
; Strings length is limited to 254 characters
; First byte contains the string length       
; Inputs:
;     HL destination
;     DE origin
; Outputs:
;     HL address to the destination string
;     AF, BC and DE are modified
rt_strcopy:
    push    hl
    ex      hl,de
    ld      a,(hl)     ; total characters to copy
    inc     a          ; plus length byte
    ld      c,a
    ld      b,0
    ldir
    pop     hl
    ret
"""
),
    "rt_strzcopy": ([],"",
"""
; RT_STRZCOPY
; Copies a null-terminated string into a regular string which
; stores its length in the first byte       
; Inputs:
;     HL destination string
;     DE null-terminated string origin
; Outputs:
;     HL address to the destination string
;     AF, B and DE are modified, C is preserved
rt_strzcopy:
    push    hl
    ld      b,0
__strzcopy_loop:
    ld      a,(de)
    or      a
    jr      z,__strzcopy_end
    inc     de
    inc     hl
    ld      (hl),a
    inc     b
    jr      __strzcopy_loop
__strzcopy_end:
    pop     hl
    ld      (hl),b
    ret
"""
),
    "rt_strcat": (["rt_stradd_len"],"",
"""
; RT_STRCAT
; DE string gets append to the end of HL string
; First byte contains the string length
; Inputs:
;     HL target string
;     DE source string that will be append at the end of HL
; Outputs:
;     HL points to the resulting string (HL+DE)
;     AF, BC and DE are modified
rt_strcat:
    call    rt_stradd_len     ; lets get final length
    ld      c,(hl)            ; current length
    ld      (hl),a            ; final length
    sub     c
    ld      b,a               ; number of bytes to copy
    push    hl                ; address to return
    ld      a,c               ; go to destination current last char
    add     a,l               ; doing HL + current length
    ld      l,a
    adc     a,h
    sub     l
    ld      h,a
__strcat_loop:
    inc     hl
    inc     de
    ld      a,(de)
    ld      (hl),a
    djnz    __strcat_loop
    pop     hl
    ret
"""
),
    "rt_strcmp": ([],"",
"""
; RT_STRCMP
; Compares two strings pointed by HL and DE and sets ZF and CF:
; HL=DE ZF=1, HL<DE ZF=0 CF=0, HL>DE ZF=0 CF=1
; Inputs:
;     HL and DE
; Outputs:
;     Flags ZF and CF store the result of the comparation
;     AF and B are modified
rt_strcmp:
    ld      a,(de)
    cp      (hl)
    jr      nc,$+3
    ld      a,(hl)
    or      a
    ret     z              ; empty strings
    push    hl
    push    de
    ld      b,a            ; longer string length
__strcmp_loop:
    inc     hl
    inc     de
    ld      a,(de)
    cp      (hl)
    jr      nz,__strcmp_end
    djnz    __strcmp_loop
    pop     de            ; seems equal
    pop     hl            ; lets check again their lengths
    ld      a,(de)
    cp      (hl)
    ret
__strcmp_end:
    pop     de
    pop     hl
    ret
"""
),
    "rt_strreplace": ([],"",
"""
; RT_STRREPLACE
; Replaces part of the string pointed by HL with the substring
; pointed by DE. BC indicates the insertion position and the number
; of original chars to drop.
; Inputs:
;   HL address to the target string
;   DE address to the substring to be inserted
;    B insertion point (1 to length)
; Outputs:
;   None
;   AF, DE and BC are modified
rt_strreplace:
    ld      a,(hl)      ; max characters
    or      a
    ret     z
    push    hl
__replace_insertpos:
    inc     hl
    dec     a
    jr      c,___replace_end
    djnz    __replace_insertpos
    ld      c,a         ; remaining chars
    ld      a,(de)
    ld      b,a
    inc     de
__replace__copy:
    ld      a,(de)
    ld      (hl),a
    dec     c
    jr      c,___replace_end
    inc     hl
    inc     de
    djnz    __replace__copy
___replace_end:
    pop     hl
    ret
"""
),
    "rt_int2str": (["rt_div16_by10"],
"""
rt_int2str_buf: defs 8
""",
"""
; RT_INT2STR
; HL starts containing the number to convert to string
; HL ends storing the memory address to the buffer
; Subroutine taken from:
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Other:DispA
; Inputs:
;     HL number to convert to string
; Outputs:
;     HL points to the temporal address in memory with the string
;      C indicates if the number is negative (C=1) or positive (C=0)
;     HL, BC, DE, AF are modified
rt_int2str:
    ld      de,rt_int2str_buf
    inc     de     ; first byte stores string length
    ld      bc,0   ; B will count total numbers and C indicates negative
    ; Detect sign of HL
    bit     7,h
    jr      z,__int2str_loop1
    ; HL is negative so add '-' to string and negate HL
    ld      a,"-"
    ld      (de),a
    inc     de
    inc     c
    ; Negate HL 
    xor     a
    sub     l
    ld      l,a
    ld      a,0    ; Note that XOR A or SUB A would disturb CF
    sbc     a,h
    ld      h,a
__int2str_loop1:
    push    bc
    call    rt_div16_by10 ; HL = HL / 10, A = remainder
    pop     bc
    push    af     ; Store digit in stack in reversed order
    inc     b
    ld      a,h
    or      l      ; Stop if quotent is 0
    jr      nz, __int2str_loop1
    ; Store string length
    ld      hl,rt_int2str_buf
    ld      a,b
    add     c
    ld      (hl),a
__int2str_loop2:
    ; Retrieve digits from stack
    pop     af
    or      &30    ; '0' + A
    ld      (de), a
    inc     de
    djnz    __int2str_loop2
    ret
"""
),
    "rt_long2str": (["rt_div32_by10"],"",
"""
; RT_LONG2STR
; HL points to the number (32 bits) to convert to string
; HL ends containing the memory address to the string
; Inputs:
;     HL points to an area of 4 bytes with the number to convert to string
; Outputs:
;     HL points to the temporal address in memory with the string
;      C indicates if the number is negative (C=1) or positive (C=0)
;     HL, BC, DE, AF are modified
rt_long2str_buf: defs 10
rt_long2str:
    push    hl
    pop     ix
    ld      l,(ix+0)
    ld      h,(ix+1)
    ld      e,(ix+2)
    ld      d,(ix+3)
    ld      bc,0
__long2str_loop1:
    push    bc
    call    rt_div32_by10 ; DEHL = DEHL / 10, A = remainder
    pop     bc
    push    af            ; store digit in stack in reversed order
    inc     b
    ld      a,l
    or      h
    or      e
    or      d
    jr      nz, __long2str_loop1
    ld      hl,rt_long2str_buf
    ld      de,rt_long2str_buf
    ld      a,b
    ld      (de),a
    inc     de
__long2str_loop2:
    pop     af            ; retrieve digits from stack
    or      &30           ; '0' + A
    ld      (de),a
    inc     de
    djnz    __long2str_loop2
    ret
"""
),
    "rt_real2strz": (["rt_math_call", "rt_div32_by10", "rt_udiv8"],
"""
rt_r2str_conv_buf: defs 10
rt_real2strz_buf: defs 12
""",
f"""
; RT_REAL2STRZ
; Converts a 5-bytes floating point number into a string
; Inputs:
;   HL pointer to the float acumulator where the float number is
;  Outputs
;   Leaves the converted string in the rt_real2strz_buf memory area
;   AF, BC, DE, HL and IX are modified
rt_real2strz:
    ld      ix,{FWCALL.MATH_REAL_PREPARE}  ; MATH_REAL_PREPARE
    call    rt_math_call
    ld      a,b
    cp      0
    jr      z, __real2str_0
    call    __r2str_calculate_digits
    ld      (hl),0
    ret
__real2str_0:
    ld      hl,rt_real2strz_buf
    ld      (hl),"0"
    inc     hl
    ld      (hl),0
    ret
__r2str_calculate_digits
    push    de
    ld      l,(ix+0) ; Copy to DEHL the normed mantissa
    ld      H,(ix+1)
    ld      e,(ix+2)
    ld      d,(ix+3)
    ld      b,9      ; lets calculate the actual digits diving by 10 9 times
    ld      c,9      ; lets store in C the significant digits (no trailing 0s)
    ld      ix,rt_r2str_conv_buf+8 ; digits are stored here from back to front
__r2str_calculate_digits_loop:
    push    bc
    call    rt_div32_by10
    pop     bc
    bit     7,c      ; check MSb, are we still removing traling 0?
    jr      nz,__r2str_calculate_digits_next
    or      a        ; is this a 0?
    jr      nz,__r2str_calculate_digits_not0
    dec     c
    jr      __r2str_calculate_digits_next
__r2str_calculate_digits_not0:
    set     7,c      ; set MSb to 1 so we don't look for more trailing 0s
__r2str_calculate_digits_next:
    add     "0"
    ld      (ix+0),a
    dec     ix
    djnz    __r2str_calculate_digits_loop
    res     7,c    ; leave in C just the number of significant digits
    pop     de
    ld      hl,rt_real2strz_buf  ; address of our text buffer
    ld      a,d      ; A is now the sign: 01 for + and FF for -
    sub     1        ; A = 0 if possitive
    jr      z,__float_check_exp
    ld      (hl),"-" ; Lets write the negative sign
    inc     hl
__float_check_exp:
    ld      b,0      ; total number of written digits
    ld      ix,rt_r2str_conv_buf+5 ; position for E notation
    ld      a,e
    add     9        ; restore decimal position
    cp      &80      ; EXP > 0? is a big number else small one
    jr      c,__float_check_E_big
    push    af
    sub     c        ; check if decimal position plus digits is too much
    cp      &F8
    jr      c,__float_write_E_small ; restores af
    pop     af                       ; restores af if didn't jump
    jr      __float_check_exp_end
__float_write_E_small:
    pop     af
    ld      (ix+0),"E"
    ld      (ix+1),"-"
    neg              ; make exponent positive (it was negative)
    inc     a
    jr      __float_write_exp
__float_check_E_big:
    cp      10         ; EXP > 10? then we need E notation
    jr      c,__float_check_exp_end
    ld      (ix+0),"E"
    ld      (ix+1),"+" ; continue directly into _float_write_exp
    dec     a
__float_write_exp:
    ; At this point we have written E+ or E- in the buffer
    ld      e,10      ; divide by 10 to get first digit
    call    rt_udiv8
    add     "0"
    ld      (ix+3),a  ; store ones digit
    ld      a,d
    add     "0"
    ld      (ix+2),a  ; store tens digit
    ld      a,1       ; set decimal position to 1
    ld      c,1
    jr      __float_copy_numbers ; ends doing a ret
__float_check_exp_end:
    ld      c,a      ; keep in C the decimal position + 9
    call    __float_write_numbers
    jr      __float_remove_trailing_0s ; ends doing a ret
; A and C hold the decimal point position
; B number of current written digits
; HL text buffer
__float_write_numbers:
    cp      1        ; only if A <=0 we need leading 0s
    jp      p,__float_copy_numbers
    ld      (hl),"0"
    inc     hl
    ld      (hl),"."
    inc     hl
__put_leading_0s_loop:
    or      a
    jr      z,__float_copy_numbers ; ends doing a ret
    ld      (hl),"0"
    inc     hl
    inc     a
    inc     b
    jr      __put_leading_0s_loop
; HL points to the text buffer next position
; In B we have the digits already written
; In C we have the decimal position
__float_copy_numbers:
    ld      de,rt_r2str_conv_buf
    ld      a,9
    sub     b   
    ld      b,a      ; B = max number of digits that we can still print
__float_copy_numbers_loop:
    ld      a,(de)
    ld      (hl),a
    inc     hl
    inc     de
    dec     b
    ret     z
    dec     c
    jr      nz,__float_copy_numbers_loop
    ld      (hl),"."    ; add . in the correct position
    inc     hl          ; if number is >0
    jr      __float_copy_numbers_loop
; C contains again original decimal point position (biased -9)
; HL points to the end of text buffer
__float_remove_trailing_0s:
    bit     7,c      ; if A is negative we remove trailing 0s
    ret     z        ; no traling 0s
    dec     hl       ; point to the last digit
__float_remove_trailing_loop:
    ld      a,(hl)
    cp      "0"
    jr      z,__float_remove_trailing_char
    cp      "."
    jr      z,__float_remove_decimal_char
    inc     hl
    ret    
__float_remove_trailing_char:
    ld      (hl),0
    dec     hl
    jr      __float_remove_trailing_loop
__float_remove_decimal_char:
    ld      (hl),0
    ret
"""
),
    "rt_strz2num": ([],"",
"""
; RT_STRZ2NUM
; Converts a string with an integer, hexadecimal or binary number to
; its numerical 16 bits long form
; Inputs:
;     DE address to the null-terminated string with the number
; Outputs:
;     HL resulting number
;     AF, HL, DE and BC are modified
rt_strz2num:
    ld      a,(de)
    cp      "&"
    jr      nz,rt_strz2int
    inc     de
    ld      a,(de)
    cp      "X"
    jr      z,__strz2num_bin
    cp      "x"
    jr      z,__strz2num_bin
    jp      rt_strz2hex
__strz2num_bin:
    inc     de
    jp      z,rt_strz2bin

; RT_STRZ2INT
; DE address to the null-terminated string, ends pointing to first
; char not converted.
; Routine based in the library created by Zeda:
; https://github.com/Zeda/Z80-Optimized-Routines
; Inputs:
;     DE address to the source null-terminated string
; Outputs:
;     HL contains the converted number
;     HL, BC, DE, AF are modified
rt_strz2int:
    ld      hl,0
__strz2int_loop:
    ld      a,(de)
    or      a
    ret     z      ; end of string
    sub     &30    ; '0' character
    cp      10
    ret     nc     ; some other character > 9
    inc     de
    ld      b,h
    ld      c,l
    add     hl,hl  ; x2
    add     hl,hl  ; x4
    add     hl,bc  ; x5
    add     hl,hl  ; x10
    add     l
    ld      l,a
    jr      nc,__strz2int_loop
    inc     h
    jr      __strz2int_loop

; RT_STRZ2HEX
; DE address to the null-terminated string with a hexadecimal number,
; ends pointing to first char not converted.
; Inputs:
;     DE address to the source null-terminated string
; Outputs:
;     HL contains the converted number
;     HL, BC, DE, AF are modified
rt_strz2hex:
    ld      hl,0
__str2hex_next:
    ld      a,(de)
    or      a
    ret     z
    inc     de
    cp      "&"
    jr      z,__str2hex_next
    cp      "H"
    jr      z,__str2hex_next
    cp      "h"
    jr      z,__str2hex_next
    cp      "0"
    ret     c                 ; < 0 end of conversion
    cp      "9"+1             ; < 10
    jr      c,__str2hex_digit ; '0'..'9'
    cp      "A"
    ret     c                 ; < A end of conversion
    cp      "F"+1
    jr      c,__str2hex_upper ; 'A'..'F'
    cp      "a"
    ret     c                 ; < a end of conversion
    cp      "f"+1
    jr      c,__str2hex_lower
    ret                       ; > f end of conversion
__str2hex_digit:
    sub     "0"
    ld      c,a
    jr      __str2hex_shiftadd
__str2hex_upper:
    sub     "A"-10
    ld      c,a
    jr      __str2hex_shiftadd
__str2hex_lower:
    sub     "a"-10
    ld      c,a
    jr      __str2hex_shiftadd
__str2hex_shiftadd          ; HL = HL*16 + C
    add     hl,hl           ; *2
    add     hl,hl           ; *4
    add     hl,hl           ; *8
    add     hl,hl           ; *16
    ld      b,0
    ld      a,c
    ld      c,a
    add     hl,bc
    jr      __str2hex_next

; RT_STRZ2BIN
; DE address to the null-terminated string with a binary number,
; ends pointing to first char not converted.
; Inputs:
;     DE address to the source null-terminated string
; Outputs:
;     HL contains the converted number
;     HL, BC, DE, AF are modified
rt_strz2bin:
    ld      hl,0
__str2bin_next:
    ld      a,(de)
    or      a
    ret     z
    inc     de
    cp      "&"
    jr      z,__str2hex_next
    cp      "X"
    jr      z,__str2hex_next
    cp      "x"
    jr      z,__str2hex_next
    cp      "0"
    ret     c                 ; < 0 end
    cp      "2"
    ret     nc                ; > 1 end
    sub     "0"
    add     hl,hl             ; hl = hl *2
    or      l
    ld      l,a
    jr      __str2bin_next
"""
),
    "rt_int2hex": ([],"",
"""
; RT_INT2HEX"
; Converts a two-bytes integer in an string with its hexadecimal
; representation. Routine inspired by the one included in
; 'Ready Made Machine Language Routines' book
; Inputs:
;     A min number of characters: 2 or 4
;    HL string address
;    DE integer to convert
; Outputs:
;     HL address to the string with the conversion
;     BC, AF are modified
rt_int2hex:
    push    hl
    inc     hl
    ld      c,2
    cp      3
    jr      c,__int2hex_low
__int2hex_high:
    inc     c
    inc     c
    ld      a,d
    call    __a2hex
 __int2hex_low:
    ld      a,e
    call    __a2hex
    pop     hl
    ld      (hl),c
    ret
__a2hex:
    push    bc
    ld      b,2    ; b=0 marks the end
    ld      c,a    ; keep number so we can restore it
    rr      a      ; move high order bits
    rr      a      ; into the low part
    rr      a
    rr      a
__a2hex_conv:
    and     &0F
    cp      &0A    ; check if is greater or equal
    jr      nc,__a2hex_letter
    add     a,&30  ; get the number ASCII code
    jr      __a2hex_store
__a2hex_letter:
    add     a,&37
__a2hex_store:
    ld      (hl),a
    inc     hl
    ld      a,c    ; restore number for next loop
    djnz    __a2hex_conv
    pop     bc
    ret
"""
),
    "rt_int2bin": ([],"",
"""
    ; RT_INT2BIN"
    ; Converts a two-bytes integer in an string with its binary
    ; representation. Routine inspired by the one included in
    ; 'Ready Made Machine Language Routines' book
    ; Inputs:
    ;     A min number of characters: 8 or 16
    ;    HL string address
    ;    DE integer to convert
    ; Outputs:
    ;     HL address to the string with the conversion
    ;     BC, AF are modified
    rt_int2bin:
    push    hl
    inc     hl
    ld      c,8
    cp      9
    jr      c,__int2bin_low
__int2bin_high:
    ld      c,16
    ld      a,d
    call    __a2bin
__int2bin_low:
    ld      a,e
    call    __a2bin
    pop     hl
    ld      (hl),c
    ret
__a2bin:
    ld      b,8
__a2bin_loop:
    rla
    jr      c,$+6
    ld      (hl),&30
    jr      $+4
    ld      (hl),&31
    inc     hl
    djnz    __a2bin_loop
    ret
"""
),
    "rt_strz2real": ([],"",
f"""
; RT_STRZ2REAL
; DE address to the null-terminated string, ends pointing to first
; char not converted.
; Inputs:
;     DE address to the source null-terminated string
; Outputs:
;     HL ponts to rt_strz2real_buf with the 5-bytes real
;     HL, BC, DE, IX, IY and AF are modified
rt_strz2real_buf: defs 5
__strz2real_0: db &00,&00,&00,&28,&00
__strz2real_1: db &00,&00,&00,&00,&81
__strz2real_2: db &00,&00,&00,&00,&82
__strz2real_3: db &00,&00,&00,&40,&82
__strz2real_4: db &00,&00,&00,&00,&83
__strz2real_5: db &00,&00,&00,&20,&83
__strz2real_6: db &00,&00,&00,&40,&83
__strz2real_7: db &00,&00,&00,&60,&83
__strz2real_8: db &00,&00,&00,&00,&84
__strz2real_9: db &00,&00,&00,&10,&84
rt_strz2real:
    push    de
    ld      de,rt_strz2real_buf
    push    de
    ld      hl,__strz2real_0
    ld      bc,5
    ldir             ; set result to 0.0
    pop     hl
    pop     de
    xor     a
    ld      b,a
    ld      c,a
    ld      a,(de)    ; check sign
    cp      "-"
    jr      nz,__strz2real_loop
    inc     de
    inc     c
__strz2real_loop:
    ld      a,(de)
    or      a
    jr      z,__strz2real_end
    inc     de
    bit     7,c
    jr      z,$+5    ; do not increase B no '.' found yet 
    inc     b
    jr      $+10     ; do not check for '.' it was already found
    cp      "."
    jr      nz,$+6   ; it's not '.' so jump to number processing
    set     7,c
    jr      __strz2real_loop
    sub     &30      ; convert char to number substracting '0' character
    cp      10
    jr      nc,__strz2real_end  ; some other character > 9
    push    de
    push    bc
    push    af
    ld      a,1
    ld      ix,{FWCALL.MATH_REAL_10A}  ; MATH_REAL_A10
    call    rt_math_call
    pop     af
    ld      de,__strz2real_0
    ld      b,a       ; index inside the table of real numbers
    add     a
    add     a
    add     b
    add     e
    ld      e,a
    ld      a,0
    adc     d
    ld      d,a
    ld      ix,{FWCALL.MATH_REAL_ADD}  ; MATH_REAL_ADD
    call    rt_math_call
    pop     bc
    pop     de
    jr      __strz2real_loop
__strz2real_end:
    push    bc
    xor     a
    sub     b
    jr      z,$+9
    ld      ix,{FWCALL.MATH_REAL_10A}  ; MATH_REAL_A10
    call    rt_math_call
    pop     bc
    bit     0,c
    ret     z
    ld      ix,{FWCALL.MATH_REAL_UMINUS}  ; MATH_REAL_UMINUS
    jp      rt_math_call
"""
),
    "rt_copychrs": ([],"",
f"""
; RT_COPYCHRS
; Returns the character in the current cursor position for the
; stream given in A.
; Inputs:
;      A souce stream (0-9)
;     HL destination string
; Outputs:
;     HL  points to the resulting string (may be 0 len)
;     AF and B are modified
rt_copychrs:
    ld      (hl),0
    ex      de,hl   ; TXT_STR_SELECT destroys HL
    call    {FWCALL.TXT_STR_SELECT}   ; TXT_STR_SELECT
    ld      b,a     ; save current selected stream
    call    {FWCALL.TXT_RD_CHAR}   ; TXT_RD_CHAR
    jr      nc,__copychrs_end
    ld      h,d
    ld      l,e
    ld      (hl),1
    inc     hl
    ld      (hl),a
__copychrs_end:
    ld      a,b
    call    {FWCALL.TXT_STR_SELECT}   ; TXT_STR_SELECT 
    ex      de,hl
    ret
"""
),
    "rt_findstr": ([],"",
"""
; RT_FINDSTR
; Search the string pointed by HL looking for
; substring pointed by DE. Returns in A 0
; if the substring wasn't found or the position
; Inputs:
;     HL address to the main string
;     DE address to the substring
;      B starting position in HL (starting from 1)
; Outputs:
;     HL  0 no match found or the position of first ocurrence
;     HL, BC, DE and AF are modified
rt_findstr:
    ld      a,(hl)  ; main string len
    push    hl
    sub     b       ; apply starting position
    jr      c,__findstr_nomatch+1
    inc     a       ; bacause starting pos starts in 1
    inc     hl
    djnz    $-1
    ld      b,a
__findstr_find1st:
    ld      a,(de)  ; substring len
    ld      c,a
    push    de
    inc     de
    ld      a,(de)  ; first substr char
__findstr_loop1:
    cp      (hl)
    jr      z,__findstr_loop2
    inc     hl
    djnz    __findstr_loop1
__findstr_nomatch:
    pop     de
    pop     hl
    ld      hl,0
    ret
__findstr_loop2:
    dec     c
    jr      z,__findstr_match
    dec     b
    jr      z,__findstr_nomatch
    inc     de
    inc     hl
    ld      a,(de)
    cp      (hl)
    jr      z,__findstr_loop2
    pop     de
    jr      __findstr_find1st
__findstr_match:
    pop     de
    ld      a,(de)  ; len substr
    dec     a
    ld      b,0
    ld      c,a
    sbc     hl,bc   ; HL = current HL - (len DE - 1)
    pop     de
    sbc     hl,de   ; HL = HL - original HL
    ret
"""
),
    "rt_substr": ([],"",
"""
; RT_SUBSTR
; Returns part of a string (a substring) of the string pointed by HL
; and places them in the string pointed by DE. The starting position to
; copy is in C and B has the number of characters to copy (0 to copy
; to the end).
; Inputs:
;     HL address to the source string
;     DE address to the destintion string
;      C starting position in source string
;      B number of characters to copy, 0 copies to the end
; Outputs:
;     HL  points to the destination string
;     HL, BC, DE and AF are modified
rt_substr:
    ld      a,b
    or      a
    jr      nz,$+3
    ld      b,(hl)  ; by default all chars from start to the end
    ld      a,(hl)  ; main string len
    ex      de,hl
    ld      (hl),0
    sub     c
    ret     c
    inc     a
    cp      b
    jr      nc,$+3
    ld      b,a
    ld      (hl),b
    ex      de,hl
    inc     hl
    dec     c
    jr      nz,$-2
    push    de
    inc     de
    ld      c,b
    ld      b,0
    ldir
    pop     hl
    ret
"""
),
    "rt_strleft": ([],"", 
"""
; RT_STRLEFT
; Extracts characters to the left of the string pointed by HL
; and places them in the string pointed by DE. The number of
; characters to copy are in C
; Inputs:
;     HL address to the source string
;     DE address to the destintion string
;      C number of characters to copy
; Outputs:
;     HL  points to the destination string
;     HL, BC, DE and AF are modified
rt_strleft:
    ld      a,(hl)  ; main string len
    cp      c       ; more chars than the len of source string
    ret     c
    push    de
    ld      (de),a  ; destination length
    inc     hl
    inc     de
    ld      b,0
    ldir
    pop     hl
    ret
"""
),
    "rt_strright": ([],"",
"""
; RT_STRRIGHT
; Extracts characters to the right of the string pointed by HL
; and places them in the string pointed by DE. The number of
; characters to copy are in C
; Inputs:
;     HL address to the source string
;     DE address to the destintion string
;      C number of characters to copy
; Outputs:
;     HL  points to the destination string
;     HL, BC, DE and AF are modified
rt_strright:
    ld      a,(hl)  ; main string len
    sub     c       ; more chars than the len of source string
    ret     c
    ret     z
    ld      b,a
    ld      a,c
    ld      (de),a
    push    de
    inc     b
    inc     de
    inc     hl
    djnz    $-1
    ldir
    pop     hl
    ret
"""
),
    "rt_strfill": ([],"",
"""
; RT_STRFILL
; Fills the string pointed by DE with the character in C
; as may times as indicated by HL, returs in HL de address to DE
; Inputs:
;     DE target string address
;      L number of repetitions (0-255)
;      C character to print
; Outputs:
;     HL points to string
;     AF, HL, DE and B are modified
rt_strfill:
    ld      a,l
    ld      b,a
    ld      (de),a
    push    de
    ld      a,c
    inc     de
    ld      (de),a
    djnz    $-2
    pop     hl
    ret
"""
),
    "rt_upper": ([],"",
"""
; RT_UPPER
; Copies to address in DE a new string the same as the input string
; pointed by HL but in which all lower case characters are converted
; to upper case.
; Inputs:
;     DE target string address
;     HL source string address
; Outputs:
;     HL points to the target string
;     AF, HL, DE and B are modified
rt_upper:
    ld      a,(hl)
    ld      (de),a
    or      a
    ret     z
    ld      b,a
    push    de  ; Save string address
    inc     hl 
    inc     de  
__upper_loop:                    
    ld      a,(hl)
    cp      "a"  ; check if it is in the lower case range
    jr      c,__upper_next
    cp      "z"+1
    jr      nc,__upper_next
    sub     "a"-"A"
__upper_next:
    ld      (de),a
    inc     hl
    inc     de
    djnz    __upper_loop
    pop     hl
    ret  
"""
),
        "rt_lower": ([],"",
"""
; RT_LOWER
; Copies to address in DE a new string the same as the input string
; pointed by HL but in which all upper case characters are converted
; to lower case.
; Inputs:
;     DE target string address
;     HL source string address
; Outputs:
;     HL points to the target string
;     AF, HL, DE and B are modified
rt_lower:
    ld      a,(hl)
    ld      (de),a
    or      a
    ret     z
    ld      b,a
    push    de  ; Save string address
    inc     hl 
    inc     de  
__lower_loop:                    
    ld      a,(hl)
    cp      "A"  ; check if it is in the upper case range
    jr      c,__lower_next
    cp      "Z"+1
    jr      nc,__lower_next
    add     "a"-"A"
__lower_next:
    ld      (de),a                    
    inc     hl
    inc     de
    djnz    __lower_loop
    pop     hl
    ret  
"""
),
#
# DATA BLOCKS
# 
    "rt_datablock": ([],"",
"""
rt_data_ptr: dw  _data_datablock_
"""
),
    "rt_read_int": (["rt_datablock"],"",
"""
; RT_READ_INT
; Copies into HL the next INTEGER in the DATA block
; Inputs:
;     HL address to the integer variable
; Outputs:
;     None, the read value is copied into the integer variable
;     HL and DE are modified
rt_read_int:
    push    hl
    ld      hl,(rt_data_ptr)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      (rt_data_ptr),hl
    pop     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ret
"""
),
    "rt_read_real": (["rt_datablock"],"",
"""
; RT_READ_REAL
; Copies into the real pointed by HL the next REAL in the DATA block
; Inputs:
;     HL address to the target real number
; Outputs:
;     HL address to the real number
;     HL, BC and DE are modified
rt_read_int:
    push    hl
    ld      de,(rt_data_ptr)
    ld      bc,5
    ex      de,hl
    ldir
    inc     hl
    ld      (rt_data_ptr),hl
    pop     hl
    ret
"""
),
    "rt_read_str": (["rt_datablock"],"",
"""
; RT_READ_STR
; Copies into the string pointed by HL the next STRING in DATA block
; Inputs:
;     HL address to the target string
; Outputs:
;     HL address to the string
;     HL, DE and BC are modified
rt_read_str:
    push    hl
    ld      de,(rt_data_ptr)
    ex      de,hl
    ld      b,0
    ld      c,(hl)    ; string length
    inc     c
    ldir
    ld      (rt_data_ptr),hl
    pop     hl
    ret
"""
),
#
# INPUT/OUTPUT
#
    "rt_print_zone": ([],"",
"""
; RT_PRINT_ZONE
; Variable that stores the zone size (13 by default)
rt_print_zone: db 13
"""
),
    "rt_print_nextzone": (["rt_print_zone"],"",
f"""
; RT_PRINT_NEXTZONE
; Moves the text cursor to the start of the next zone
; considering that each zone has RT_PRINT_ZONE characters
; Inputs:
;     None
; Outputs:
;     None
;     AF, HL and B are modified
rt_print_nextzone:
    call    {FWCALL.TXT_GET_CURSOR}  ; TXT_GET_CURSOR
    ld      a,(rt_print_zone)
__nextzone_shift:
    cp      h
    jr      nc,__nextzone_end
    add     a
    jr      __nextzone_shift
__nextzone_end:
    ld      h,a
    jp      {FWCALL.TXT_SET_CURSOR}  ; TXT_SET_CURSOR
"""
),
    "rt_print_nl": ([],"",
f"""
; RT_PRINT_NL
; Prints an EOL which in Amstrad is composed
; by chraracters 0x0D 0x0A
; Inputs:
;     None 
; Outputs:
;     None 
;     AF is modified
rt_print_nl:
    ld      a,13
    call    {FWCALL.TXT_OUTPUT}  ; TXT_OUTPUT
    ld      a,10
    jp      {FWCALL.TXT_OUTPUT}  ; TXT_OUTPUT
"""
),
    "rt_print_spc": ([],"",
f"""
; RT_PRINT_SPC
; L indicates the number of spaces to print
; but 127 is the maximum
; Inputs:
;     L number of spaces to print
; Outputs:
;     None
;     AF and B are modified
rt_print_spc:
    ld      a,l
    and     &7F
    cp      0
    ret     z
    ld      b,a
    ld      a,32   ; white space
__print_spc_loop:"
    call    {FWCALL.TXT_OUTPUT}
    djnz    __print_spc_loop
    ret
"""
),
    "rt_print_str": ([],"",
f"""
; RT_PRINT_STR
; Prints in the screen the string pointed by HL
; using the Amstrad CPC firmware routines
; Inputs:
;     HL address to the string to print
; Outputs:
;     AF, HL and BC are modified
rt_print_str:
    ld      a,(hl)
    or      a
    ret     z          ; empty string
    ld      b,a
__print_str_loop:
    inc     hl
    ld      a,(hl)
    call    {FWCALL.TXT_OUTPUT}  ; TXT_OUTPUT
    djnz    __print_str_loop
    ret
"""
),
    "rt_print_strz": ([],"",
f"""
; RT_PRINT_STRZ
; Prints in the screen the null-terminated string pointed by HL
; using the Amstrad CPC firmware routines
; Inputs:
;     HL address to the null-terminated string
; Outputs:
;     None
;     AF and HL are modified
rt_print_strz:
    ld      a,(hl)
    or      a
    ret     z
    inc     hl
    call    {FWCALL.TXT_OUTPUT}
    djnz    rt_print_strz
    ret
"""
),
    "rt_print_int": (["rt_print_str", "rt_int2str"],"",
f"""
; RT_PRINT_INT
; Prints an Integer number which in Amstrad is composed
; by chraracters two bytes.
; Inputs:
;     HL holds the number to be printed 
; Outputs:
;     None 
;     HL, BC, DE and AF are modified
rt_print_int:
    call    rt_int2str
    xor     a     ; leave the '-' space in positive numbers
    or      c
    jr      nz,$+7
    ld      a,32
    call    {FWCALL.TXT_OUTPUT}  ; TXT_OUTPUT
    call    rt_print_str
    ld      a,32   ; trailing space
    jp      {FWCALL.TXT_OUTPUT}  ; TXT_OUTPUT
"""
),
    "rt_print_real": (["rt_math_call", "rt_real2strz", "rt_print_strz"],"",
"""
; RT_PRINT_REAL
; Prints a Real number which in Amstrad is a
; five bytes floating-point representation.
; Inputs:
;     HL address to the real number 
; Outputs:
;     None 
;     HL, BC, DE, IX and AF are modified
rt_print_real:
    call    rt_real2strz
    ld      hl,rt_real2strz_buf
    jp      rt_print_strz
"""
),
    "rt_count_substrz": ([],"",
"""
; RT_COUNT_SUBSTRZ
; Returns the number of existing substrings separated
; by commas in the null-terminated string addessed by HL.
; Inputs:
;     HL address to the string to scan
; Outputs:
;      B number of identified substrings
;      C total number of quote characters found
;     AF, HL and BC are modified 
rt_count_substrz:
    ld      bc,&0100    ; final number of substrings
__count_loop:
    ld      a,(hl)
    or      a
    ret     z           ; null termination character
    inc     hl
    cp      &22         ; quote?
    jr      z,__count_quote
    cp      &2c         ; comma?
    jr      nz,__count_loop
    inc     b
    jr      __count_loop
__count_quote:
    inc     c
    jr      __count_loop
"""
),
    "rt_extract_substrz": (["rt_scratch_pad"],"",
"""
; RT_EXTRACT_SUBSTRZ
; Returns the number of existing substrings separated
; by commas in the string addessed by HL.
; Inputs:
;     HL address to the string to scan
; Outputs:
;      B number of identified substrings
;      C total number of quote characters found
;     AF, HL and BC are modified 
rt_extract_substrz:
    ld      de,rt_scratch_pad
    ld      c,0
    call    rt_strz_lstrip   ; remove spaces leaves char in A
    cp      &22              ; quote?
    jr      nz,__extract_comma_separated
    call    rt_remove_quotes
    inc     de
    inc     hl
    xor     a
    ld      (de),a
    call    rt_strz_lstrip   ; remove spaces after final quote
    cp      &2c              ; comma
    ret     nz
    inc     hl
    ret 
__extract_comma_separated:
    or      a                ; 0?
    jr      z,__extract_end
    inc     hl
    cp      &2c              ; ,?
    jr      z,__extract_end
    inc     c
    ld      (de),a
    inc     de
    ld      a,(hl)
    jr      __extract_comma_separated
__extract_end:
    xor     a
    ld      (de),a
    ld      a,c
    or      c
    ret     z                ; empty string
    dec     de               ; last character
    ex      de,hl
    call    rt_strz_rstrip
    inc     hl
    ld      (hl),0
    ex      de,hl
    ret
"""
),
    "rt_strz_lstrip": ([],"",
"""
; RT_STRZ_LSTRIP
; Scans the zero-terminated string pointed by HL from the left
; until if finds a character different from an empty space.
; Inputs:
;     HL address to the zero-terminated string to scan
; Outputs:
;     HL address to the resulting zero-terminated string
;      A first character different to an empty space
;     AF and HL are modified
rt_strz_lstrip:
    ld      a,(hl)
    cp      &20  ; espace
    ret     nz
    inc     hl
    jr      rt_strz_lstrip
"""
),
    "rt_strz_rstrip": ([],"",
"""
; RT_STRZ_RSTRIP
; Scans the zero-terminated string pointed by HL from the right
; until if finds a character different from an empty space.
; Inputs:
;     HL address to the zero-terminated string to scan
; Outputs:
;     HL address to the resulting zero-terminated string
;      A first character different to an empty space
;     AF and HL are modified 
rt_strz_rstrip:
    ld      a,(hl)
    cp      &20  ; espace
    ret     nz
    dec     hl
    dec     c
    jr      rt_strz_rstrip
"""
),
    "rt_remove_quotes": ([],"",
"""
; RT_REMOVE_QUOTES
; Scans the zero-terminated string pointed by HL and
; returs the substring between quotes. Assumes that first
; character of HL string is already a quote.
; Inputs:
;     HL address to the zero-terminated string to scan
;     DE address to the resulting string
; Outputs:
;     DE address to the resulting string
;      C length of DE
;     AF, DE, HL and C are modified 
rt_remove_quotes:
    inc     hl
    ld      c,0
__remove_quotes_loop:
    ld      a,(hl)
    cp      &22
    ret     z
    ld      (de),a
    inc     hl
    inc     de
    inc     c
    jr      __remove_quotes_loop
"""
),
    "rt_extract_num": (["rt_strz2num"],"",
"""
; RT_EXTRACT_NUM
; Converts and string with an integer or hexadecimal number
; Inputs:
;     DE address to the null-terminated string with the number
; Outputs:
;     HL resulting number
;     AF, HL, DE and BC are modified
rt_extract_num:
    ld      a,(de)
    cp      "&"
    jp      nz,rt_strz2int
    inc     de
    jp      rt_strz2hex
"""
),
    "rt_input": (["rt_print_nl", "rt_print_str", "rt_count_substrz", "rt_extract_substrz", "rt_strz_lstrip", "rt_strz_rstrip", "rt_remove_quotes"],
"""
rt_input_question: db 2,"? "
rt_input_redo:     db 16,"?Redo from start "
rt_input_buf:      defs 255
""",
f"""
; RT_INPUT
; Camptures the keyboard input in a null-terminated string
; using the Amstrad CPC firmware routines.
; Returns in B and C some useful values to validate the input.
; Inputs:
;     None
; Outputs:
;     rt_input_buf stores the input as a null-terminated string
;      B stores the total number substrings (separated by commas)
;      C total number of quote characters found
;     AF, HL and BC are modified
rt_input:
    call    {FWCALL.TXT_CUR_ENABLE} ; TXT_CUR_ENABLE
    call    {FWCALL.TXT_CUR_ON} ; TXT_CUR_ON
    ld      hl,rt_input_buf
    ld      (hl),0
    ld      bc,0  ; Initialize characters counter
__input_enterchar:
    call    {FWCALL.KM_WAIT_KEY} ; KM_WAIT_KEY
    cp      &7F  ; KM_WAIT_KEY returns characters in range &00-&7F
    jr      nz,__input_processchar
    ld      a,b  ; backspace key
    or      c
    jr      z,__input_enterchar    ; String length is zero
    ld      a,8
    call    {FWCALL.TXT_OUTPUT} ; TXT_OUTPUT
    ld      a," "
    call    {FWCALL.TXT_OUTPUT} ; TXT_OUTPUT
    ld      a,8
    call    {FWCALL.TXT_OUTPUT} ; TXT_OUTPUT
    dec     hl
    dec     bc
    jr      __input_enterchar
__input_processchar:
    cp      13
    jr      z,__input_end          ; Enter key pressed
    call    {FWCALL.TXT_OUTPUT} ; TXT_OUTPUT
    ld      (hl),a
    inc     hl
    inc     bc
    jr      __input_enterchar
__input_end:
    ld      (hl),0
    call    {FWCALL.TXT_CUR_DISABLE} ; TXT_CUR_DISABLE
    call    {FWCALL.TXT_CUR_OFF} ; TXT_CUR_OFF
    ld      hl,rt_input_buf
    jp      rt_count_substrz      
"""
),
    "rt_writestr": ([],"",
f"""
; RT_WRITESTR
; Writes a quoted string to an already open file (with OPENIN)
; Inputs:
;     HL address to the input string
; Outputs:
;     A, B and HL are modified
rt_writestr:
    ld      a,&22
    call    {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
    ld      b,(hl)
    __writestr_loop:
    inc     hl
    ld      a,(hl)
    call    {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
    djnz    __writestr_loop
    ld      a,&22
    jp      {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
"""
),
    "rt_writeint": (["rt_int2str"],"",
f"""
; RT_WRITEINT
; Writes the integer hold in HL to an already open file (with OPENIN)
; Inputs:
;     HL signed integer value
; Outputs:
;     A, B and HL are modified
rt_writeint:
    call    rt_int2str
    ld      b,(hl)
    __writeint_loop:
    inc     hl
    ld      a,(hl)
    call    {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
    djnz    __writestr_loop
    ret     
"""
),
    "rt_writenl": (["rt_int2str"],"",
f"""
; RT_WRITENL
; Writes an EOL to an already open file (with OPENIN)
; Inputs:
;     None
; Outputs:
;     AF is modified
rt_writenl:
    ld      a,13
    call    {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
    ld      a,10
    jp      {FWCALL.CAS_OUT_CHAR}  ; CAS_OUT_CHAR
"""
),
    "rt_readstr": (["rt_readnext"],"",
f"""
; RT_READSTR
; Reads a quoted string from an already open file (with OPENIN).
; Ends trying to read the comma that separates data in the file.
; Inputs:
;     HL address to the destination string
; Outputs:
;     HL contains the address to the destination string
;     A, B and HL are modified
rt_readstr:
    ld      (hl),0
    call    {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
    cp      &22
    ret     nz
    ld      b,0
    push    hl
__readstr_loop:
    inc     hl
    call    {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
    jr      nc,__readstr_end  ; if error jump to end
    cp      &22
    jr      z,__readstr_end
    ld      (hl),a
    inc     b
    jr      __readstr_loop
__readstr_end:
    pop     hl
    ld      (hl),b
    jp      rt_readnext   ; consume comma or new-line
"""
),
    "rt_readint": (["rt_strz2num", "rt_readnext"],"",
f"""
; RT_READINT
; Reads an integer from an already open file (with OPENIN).
; It consumes any comma used to separate values.
; Inputs:
;     None
; Outputs:
;     HL contains the integer value
;     A, B and HL are modified
rt_readint_bufz: defs 19     ; space for 16 bits integers (including hex and bin formats)
rt_readint:
    ld      hl,0
    ld      b,18    ; max buffer length for numbers
    ld      de,rt_readint_bufz
__readint_loop:
    call    {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
    jr      nc,__readint_end  ; if error jump to end
    cp      &2c
    jr      z,__readint_end
    cp      &0d
    jr      z,__readint_end
    cp      &0a
    jr      z,__readint_end
    ld      (de),a
    djnz    __readint_loop
__readint_end:
    inc     de
    xor     a
    ld      (de),a   ; zero-terminated string
    ld      de,rt_readint_bufz
    call    rt_strz2num
    jp      rt_readnext
"""
),
    "rt_readnext": ([],"",
f"""
; RT_READNEXT
; Consume chars until it consumes a comma or a new-line
; Inputs:
;     None
; Outputs:
;     None
;     AF is modified
rt_readnext:
    call    {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
    ret     nc    ; error reading
    cp      &2c   ; comma?
    ret     z
    cp      &0a   ; end of new-line?
    ret     z
    cp      &0d   ; new-line (0xd,0xa)?
    jr      nz,rt_readnext
    jp      {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
"""
),
    "rt_freadstr": ([],"",
f"""
; RT_FREADSTR
; Reads a string from an already open file (with OPENIN).
; Reads up to 254 characters or until it finds a EOL (0xD,0xA).
; Inputs:
;     HL address to the destination string
; Outputs:
;     HL contains the address to the destination string
;     A, B and HL are modified
rt_freadstr:
    ld      (hl),0
    ld      b,254
    push    hl
__freadstr_loop:
    inc     hl
    call    {FWCALL.CAS_IN_CHAR}  ; CAS_IN_CHAR
    jr      nc,__freadstr_end
    cp      &0a
    jr      z,__freadstr_end
    cp      &0d
    jr      z,__freadstr_loop
    ld      (hl),a
    dec     b
    jr      z,__freadstr_end
    jr      __freadstr_loop
__freadstr_end:
    pop     hl
    ld      a,254
    sub     b
    ld      (hl),a
    ret
"""
),
#
# MATH
# 
    "rt_umul16": ([],"",
"""
; RT_UMULT16"
; 16x16 unsigned multplication
; HL = HL * DE.
; Algorithm from Rodney Zaks, 'Programming the Z80'.
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL and DE
; Outputs:
;     HL is the HL * DE
;     AF, BC and DE are modified
rt_umul16:
    ld      a,l	    ; transfer HL to CA
    ld      c,h
    ld      b,16	; 16 bits to multiply
    ld      hl,0
__mul0_unsigned:
    srl     c		; shift CA right, get low bit
    rra
    jr      nc,__mul1_unsigned	; zero fell out, do not add
    add     hl,de	; else add DE
__mul1_unsigned:
    ex      de,hl	; DE = DE*2
    add     hl,hl
    ex      de,hl
    djnz    __mul0_unsigned
    ret
"""
),
    "rt_udiv16": ([],"",
"""
; RT_UDIV16
; 16/16 unsigned division
; HL = HL DIV DE
; DE = HL MOD DE
; Algorithm from Rodney Zaks, 'Programming the Z80'.
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL, DE
; Outputs:
;     HL is the quotient
;     DE is the remainder
;     AF, BC are modified
rt_udiv16:
    ld      b,h	    ; store HL in BC
    ld      c,l
    ld      a,e	    ; transfer DE to AC
    or      d
    ld      hl,0	    ; intermediate result
    ret     z		; DIV by 0?      
    ld      a,b
    ld      b,16	    ; 16 bits to divide
    __div0_unsigned:
    rl      c		; get AC high bit, rotate in result bit
    rla
    adc     hl,hl	; HL = HL*2, never sets C
    sbc     hl,de	; trial subtract and test DE > HL
    jr      nc,__div1_unsigned
    add     hl,de	; DE > HL, restore HL
    __div1_unsigned:
    ccf		        ; result bit
    djnz    __div0_unsigned
    ex      de,hl
    rl      c		; rotate in last result bit
    rla
    ld      h,a
    ld      l,c
    ret
"""
),
    "rt_compute_sign": ([],"",
"""
; RT_COMPUTE_SIGN
; Computes resulting sign between HL and DE integers
; returns C=0 (pos) if signs are equal and otherwise C=1 (neg)
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL, DE
; Outputs:
;     CF carry stores the sign
;     AF is modified
rt_compute_sign:
    ld      a,h
    xor     d
    rla		; sign to carry
    ret
"""
),
    "rt_abs": ([],"",
"""   
; RT_ABS 
; Strips sign from HL
; performing COMP+2 if it is negative
; Inputs:
;     HL
; Outputs:
;     HL is the number in possitive
;     AF is modified
rt_abs:
    bit     7,h
    ret     z
    ld      a,h
    cpl
    ld      h,a
    ld      a,l
    cpl
    ld      l,a
    inc     hl
    ret
"""
),
    "rt_sign_strip": ([],"",
"""   
; RT_SIGN_STRIP 
; Strips signs from HL and DE
; performing COMP+2 if they are negative
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL and DE
; Outputs:
;     HL is the number in possitive
;     DE is the number in possitive
;     AF is modified
rt_sign_strip:
    bit     7,d
    jr      z,__sign_strip_posde
    ld      a,d
    cpl
    ld      d,a
    ld      a,e
    cpl
    ld      e,a
    inc     de
__sign_strip_posde:
    bit     7,h
    ret     z
__sign_strip_neghl:
    ld      a,h
    cpl
    ld      h,a
    ld      a,l
    cpl
    ld      l,a
    inc     hl
    ret
"""
),
    "rt_mul16": (["rt_compute_sign", "rt_sign_strip", "rt_umul16"],"",
"""
; RT_MUL16
; 15x15 signed multiplication
; HL = HL * DE
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL and DE
; Outputs:
;     HL is the HL * DE
;     AF, BC, DE are modified
rt_mul16:	
    call    rt_compute_sign
    push    af
    call    rt_sign_strip
    call    rt_umul16
    pop     af
    ret     nc
    jr      __sign_strip_neghl
"""
),
    "rt_div16": (["rt_compute_sign", "rt_sign_strip", "rt_udiv16"],"",
"""
; RT_DIV16
; 15/15 signed division
; HL = HL DIV DE
; DE = HL MOD DE
; Developed by Nils M. Holm (cc0)
; Inputs:
;     HL, DE
; Outputs:
;     HL is the quotient
;     DE is the remainder
;     AF, BC are changed
rt_div16:
    call    rt_compute_sign
    push    af
    call    rt_sign_strip
    call    rt_udiv16
    pop     af
    ret     nc
    jr      __sign_strip_neghl
"""
),
    "rt_comp16": ([],"",
"""
; RT_COMP16
; Signed comparison HL-DE, set Z and C flags,
; where C indicates that HL < DE
; Inputs:
;     HL, DE
; Outputs:
;     AF Z=1 if HL=DE; Z=0 & C=1 if HL < DE
;     HL is modified
;     BC, DE are preserved
rt_comp16:
    xor     a
    sbc     hl,de
    ret     z
    jp      m,__comp16_cs1
    or      a
    ret
__comp16_cs1:
    scf
    ret
"""
),
    "rt_ucomp16": ([],"",
"""
; RT_UCOMP16
; Unsigned comparison HL-DE, set ZF and CF flags,
; where CF indicates that HL < DE
; Inputs:
;     HL, DE
; Outputs:
;     AF ZF=1 if HL=DE; ZF=0 & CF=1 if HL < DE
;     HL is modified
;     BC, DE are preserved
rt_cuomp16:
    xor     a          ; clear CF
    sbc     hl,de
    ret
"""
),
    "rt_div32_by10": ([],"",
"""
; RT_DIV32_BY10
; Fast integer (32 bits) division by 10
; Inputs:
;     DEHL 32 bits integer
; Outputs:
;     DEHL is the quotient
;      A is the remainder
;     BC is 10
rt_div32_by10:
    ld      bc,&0D0A
    xor     a
    ex      de,hl
    add     hl,hl
    rla
    add     hl,hl
    rla
    add     hl,hl
    rla
    add     hl,hl
    rla
    cp      c
    jr      c,$+4
    sub     c
    inc     l
    djnz    $-7
    ex      de,hl
    ld      b,16
    add     hl,hl
    rla
    cp      c
    jr      c,$+4
    sub     c
    inc     l
    djnz    $-7
    ret
"""
),
    "rt_div16_by10": ([],"",
"""
; RT_DIV16_BY10
; Fast integer division by 10
; Taken from:
; https://learn.cemetech.net/index.php/Z80:Math_Routines&Speed_Optimised_HL_div_10
; HL = HL DIV 10
; Inputs:
;     HL
; Outputs:
;     HL is the quotient
;     A is the remainder
;     HL, BC, AF are modified, DE is preserved
rt_div16_by10:
    ld      bc,&0D0A
    xor     a
    add     hl,hl
    rla
    add     hl,hl
    rla
    add     hl,hl
    rla
    add     hl,hl
    rla
    cp      c
    jr      c,$+4
    sub     c
    inc     l
    djnz    $-7
    ret
"""
),
    "rt_udiv8": ([],"",
"""
; RT_UDIV8
; 8/8 unsigned integer division,
; Inputs:
;     A  numerator, E denominator
; Outputs:
;     D  quotient
;     A  remainder
;     BC, DE are preserved
rt_udiv8:
    ld d,0           ; Initialize quotient
__div8_loop:
    cp e             ; Compare A with E
    jr c,__div8_end  ; If A < E, we're done
    sub e            ; Subtract E from A
    inc d            ; Increment quotient
    jr __div8_loop   ; Continue dividing
__div8_end:
    ret
"""
),
    "rt_mul16_255": ([],"",
"""
; RT_MUL16_255
; Multiplies HL by 255 and leaves the result in HL
; HL * 255 = HL * (256 - 1) = (HL << 8) - HL
; Inputs:
;     HL  number to be multiplied
; Outputs:
;     HL  result of HL * 255
;     AF, DE and HL are modified
rt_mul16_255:
    ld      d,h      ; keep HL so we can sub later
    ld      e,l
    ld      a,h
    ld      h,l      ; HL << 8
    ld      l,0
    or      a        ; clear CF
    sbc     hl,de    ; HL = (HL << 8) - DE
    ret
"""
),
    "rt_mul16_A": ([],"",
"""
; RT_MUL16_A
; Multiplies HL by A and leaves the result in HL
; Routine taken from:
; https://learn.cemetech.net/index.php/Z80:Math_Routines
; Inputs:
;     HL  number to be multiplied
;      A  number to by multiplied by
; Outputs:
;     HL  result of HL * A
;     B, Flags, DE and HL are modified
rt_mul16_A:
    ex      de,hl
    ld      b,8
    ld      hl,0
__mult16_a_loop:
    add     hl,hl
    rlca
    jr      nc,$+3
    add     hl,de
    djnz    __mult16_a_loop
    ret
"""
),
#
# runtime for BASIC commands support
#
    "rt_real2int": (["rt_math_call"],"", 
f"""
; RT_REAL2INT
; Converts a 5-bytes float value into a 16-bits integer
; Inputs:
;     HL  address to the 5-bytes float number
; Outputs:
;     HL  16 bits integer
;     AF, HL, DE and IX are modified
rt_real2int:
    ld      ix,{FWCALL.MATH_REAL_TO_INT}  ; MATH_REAL_TO_INT
    call    rt_math_call
    jp      p,$+9
    xor     a       ; HL = - HL
    sub     l       ; one byte less then HL = 0 - HL
    ld      l,a
    sbc     a,h
    sub     l
    ld      h,a
    ret
"""
),
    "rt_int2real": (["rt_math_call"],"",
f"""
; RT_INT2REAL
; Converts a 16-bits integer in a 5-bytes floating point number
; Inputs:
;     HL  integer to convert
; Outputs:
;     rt_math_accum1 holds the converted number pointed by HL
;     AF, HL, DE and IX are modified
rt_int2real:
    xor     a
    ld      a,h    ; bit 7 sets the sign
    bit     7,a
    jr      z,$+8
    ex      de,hl
    ld      hl,0
    sbc     hl,de
    ld      de,rt_math_accum1
    ld      ix,{FWCALL.MATH_INT_TO_REAL}  ; MATH_INT_TO_REAL
    jp      rt_math_call
"""
),
    "rt_real2fix": (["rt_math_call", "rt_real2int"],"",
f"""
; RT_REAL2FIX
; Removes the decimal part of a floating point number rounding
; the integer part towards 0
; Inputs:
;     HL  address to the 5-bytes floating point number
; Outputs:
;     rt_math_accum1 holds the converted number pointed by HL
;     AF, BC, HL, DE and IX are modified
rt_real2fix:
    ld      ix,{FWCALL.MATH_REAL_FIX}  ; MATH_REAL_FIX
    call    rt_math_call
    ld      a,b   ; sign (bit 7)
    ld      ix,{FWCALL.MATH_BIN_TO_REAL}  ; MATH_BIN_TO_REAL
    call    rt_math_call
    jp      rt_real2int
"""
),
    "rt_real_int": (["rt_math_call", "rt_real2int"],"",
f"""
; RT_REAL_INT
; Removes the decimal part of a floating point number rounding
; the integer part towards 0, like FIX, but returning a lower result
; when working with negative decimal inputs.
; Inputs:
;     HL  address to the 5-bytes floating point number
; Outputs:
;     rt_math_accum1 holds the converted number pointed by HL
;     AF, HL, DE and IX are modified
rt_real_int:
    ld      ix,{FWCALL.MATH_REAL_INT}  ; MATH_REAL_INT
    call    rt_math_call
    ld      a,b   ; sign (bit 7)
    ld      ix,{FWCALL.MATH_BIN_TO_REAL}  ; MATH_BIN_TO_REAL
    call    rt_math_call
    jp      rt_real2int
"""
),
    "rt_real_round": (["rt_math_call", "rt_move_real"],"",
f"""
; RT_REAL_ROUND
; Rounds the real value pointed by HL to de number of decimal places
; indicated by A. If A is negative, increases the number adding that
; amount of ceros at the end of the result.
; Inputs:
;     HL address to the 5-bytes real value
;      B decimal required precision
; Outputs:
;     HL points to the result (the rounded real number)
;     HL, AF, BC, DE and IX are modified
rt_real_round:
    push    bc
    ld      de,rt_math_accum1
    call    rt_move_real      ; REAL to rt_math_accum1
    ld      ix,{FWCALL.MATH_REAL_SIGNUM}  ; MATH_REAL_SIGNUM
    call    rt_math_call
    pop     bc
    push    af
    push    bc
    ld      a,b
    bit     7,a    ; Check negative numbers
    jr      nz,__real_round_toint
    cp      0
    jr      z,__real_round_toint
    ld      ix,{FWCALL.MATH_REAL_10A}  ; MATH_REAL_A10
    call    rt_math_call
__real_round_toint:
    ld      ix,{FWCALL.MATH_REAL_TO_BIN}  ; MATH_REAL_TO_BIN
    call    rt_math_call
    ld      ix,{FWCALL.MATH_BIN_TO_REAL}  ; MATH_BIN_TO_REAL
    call    rt_math_call
    pop     bc
    xor     a
    sub     b
    jr      z,$+9
    ld      ix,{FWCALL.MATH_REAL_10A}  ; MATH_REAL_A10
    call    rt_math_call
    pop     af    ; check original sign
    ret     nc    ; positive number
    ld      ix,{FWCALL.MATH_REAL_UMINUS}  ; MATH_REAL_UMINUS
    jp      rt_math_call
"""
),
    "rt_timer": ([],
"""
rt_timer_blocks: defs 13*4 ; 4 tick blocks (event timer structure is 13 bytes)
""",
"""
; RT_TIMER_GET
; Retrieves a AFTER/EVERY data block (tick block). Each tick block has
; a size of 13 bytes. The las 7 bytes are the event block contained
; inside the tick block
; Inputs:
;     B  timer number (0-3)
; Outputs:
;     HL address to the timer block
rt_timer_get:
    ld      hl,rt_timer_blocks
    ld      de,13       ; Block size
__timerget_loop:
    add     hl,de
    djnz    __timerget_loop
    ret
"""
),
    "rt_fill": ([],
"""
rt_fill_buffer: defs 70
""",
f"""
; RT_FILL
; Wrapper for the GRA FILL firmware call in the 664 and 6128
; Inputs:
;      L  INK index
; Outputs:
;     None
;     AF, BC, DE and HL are modified
rt_fill:
    ld      a,l
    ld      hl,rt_fill_buffer
    ld      de,70
    jp      {FWCALL.GRA_FILL}  ; GRA_FILL
"""
),
    "rt_inkey": ([],"",
f"""
; RT_INKEY
; Wrapper for the KEY TEST firmware call
; Inputs:
;      HL  Key numeric value to test
; Outputs:
;     HL  -1 no pressed, 0, 32, 128 and 160 as per INKEY doc
;     AF, C, and HL are modified
rt_inkey:
    ld      a,l
    call    {FWCALL.KM_TEST_KEY}  ; KM_TEST_KEY
    ld      hl,&FFFF  ; -1 (the key is not pressed)
    jr      z,$+4
    inc     h
    ld      l,c
    ret
"""
),
    "rt_inkeys": ([],"",
f"""
; RT_INKEYS
; Wrapper for the READ CHAR firmware call
; Inputs:
;     HL  address to the string that will receive the pressed char
; Outputs:
;     HL  -1 no pressed, 0, 32, 128 and 160 as per INKEY doc
;     AF, C, and HL are modified
rt_inkeys:
    ld      (hl),0
    call    {FWCALL.KM_READ_CHAR}  ; KM_READ_CHAR
    jr      nc,$+7  ; if CF we have a character
    ld      (hl),1
    inc     hl
    ld      (hl),a
    dec     hl
    ret
"""
),
    "rt_gettime": (["rt_math_call"],"",
f"""
; RT_GETTIME
; Wrapper for the KL TIME PLEASE firmware call
; It captures the bin number and casts it to real
; Leaving the result in rt_math_accum1
; Inputs:
;     None
; Outputs:
;     HL points to rt_math_accum1
;     AF, HL, BC, DE and IX are modified
rt_gettime:
    call     {FWCALL.KL_TIME_PLEASE}  ; KL_TIME_PLEASE
    ld      ix,rt_math_accum1
    ld      (ix+0),l
    ld      (ix+1),h
    ld      (ix+2),e
    ld      (ix+3),d
    xor     a
    ld      hl,rt_math_accum1
    ld      ix,{FWCALL.MATH_BIN_TO_REAL}  ; MATH_BIN_TO_REAL
    jp      rt_math_call
"""
),
    "rt_settime": ([],"",
f"""
; RT_SETTIME
; Wrapper for the KL TIME SET firmware call
; Inputs:
;     HL integer value to set as new time
; Outputs:
;     None
;     AF and DE are modified
rt_settime:
    xor      a
    ld       e,a
    ld       d,a
    jp      {FWCALL.KL_TIME_SET}  ; KL_TIME_SET
"""
),
    "rt_randomize": ([],
"""
rt_rnd_seed1: db &6c,&07       ; some initial value just in case
rt_rnd_seed2: db &70,&c6
rt_old_seed1: db &6c,&07       ; to retrieve again last number
rt_old_seed2: db &07,&6c
""",
"""
; RT_RANDOMIZE
; Sets rt_rnd_seed1 and rt_rnd_seed2 which are used by rt_rnd
; Inputs:
;   HL address to a buffer with at least 4 bytes
; Outputs:
;   rt_rnd_seed1 gets the value of HL
;   rt_rnd_seed2 gets the value of DE
;   HL is modified
rt_randomize:
    ld      a,(hl)
    ld      (rt_rnd_seed1),a
    inc     hl
    ld      a,(hl)
    ld      (rt_rnd_seed1+1),a
    inc     hl
    ld      a,(hl)
    ld      (rt_rnd_seed2),a
    inc     hl
    ld      a,(hl)
    ld      (rt_rnd_seed2+1),a
    ret
"""
),
    "rt_rnd": (["rt_randomize"],
"""
rt_rnd_32767: db &00,&00,&FE,&7F,&8F
""",
f"""
; RT_RND
; This is a very fast, quality pseudo-random number generator.
; It combines a 16-bit Linear Feedback Shift Register and a 16-bit LCG.
; Taken from:
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random
; Inputs:
;   (rt_rnd_seed1) contains a 16-bit seed value
;   (rt_rnd_seed2) contains a NON-ZERO 16-bit seed value
; Outputs:
;   HL address to the REAL result
;   BC is the result of the LCG, so not that great of quality
;   AF, BC, HL, DE, and IX are modified
rt_rnd:
    ld      hl,(rt_rnd_seed1)
    ld      (rt_old_seed1),hl
    ld      b,h
    ld      c,l
    add     hl,hl
    add     hl,hl
    inc     l
    add     hl,bc
    ld      (rt_rnd_seed1),hl
    ld      hl,(rt_rnd_seed2)
    ld      (rt_old_seed2),hl
    add     hl,hl
    sbc     a,a
    and     %00101101
    xor     l
    ld      l,a
    ld      (rt_rnd_seed2),hl
    add     hl,bc
    res     7,h
    ld      de,rt_math_accum1  ; lests convert the number to REAL
    xor     a                  ; always positive
    ld      ix,{FWCALL.MATH_INT_TO_REAL}           ; MATH_INT_TO_REAL
    call    rt_math_call
    ld      de,rt_rnd_32767    ; max number that can be generated
    ld      ix,{FWCALL.MATH_REAL_DIV}           ; MATH_REAL_DIV
    jp      rt_math_call
    
; RT_RND0
; Depending on the value of HL it returns the last generated number.
; a new one in the sequence
; Inputs:
;   HL 0 to get the latest generated number
; Outputs:
;   HL is the address to the REAL result
;   BC is the result of the LCG, so not that great of quality
;   AF is modified, DE is preserved
rt_rnd0:
    ld      a,l
    or      a
    jr      nz,rt_rnd
    ld      hl,rt_old_seed1
    call    rt_randomize
    jr      rt_rnd
"""
),
    "rt_fileinbuf": (["rt_error", "rt_restoreroms"],
"""
; Buffer for content read from files through OPENIN or CAT
rt_fileinbuf: defs 2048
""",
""
),
    "rt_fileoutbuf": (["rt_error", "rt_restoreroms"],
"""
; Buffer for content written to files through OPENOUT
rt_fileoutbuf: defs 2048
""",
""
),
    "rt_sound": (["rt_error"],
"""
rt_sound_buf: defs 9
""",
f"""
; Adds a new sound to one of the available Amstrad CPC
; sound queues. The data must be kept in a buffer placed
; somewhere in the 32k central memory area.
; Inputs:
;   HL address to the sound buffer with the data.
; Outputs:
;   CF if sound was added to the queue.
;   AF, BC, DE, IX and HL are modified.
rt_sound:
    ld      hl,rt_sound_buf
    jp      {FWCALL.SOUND_QUEUE} ; SOUND_QUEUE
"""
),
    "rt_load": (["rt_restoreroms"],"",
f"""
; RT_LOAD
; Reads an AMSDOS file (with header) and extracts length and
; target address, loading there the content.
; Inputs:
;   HL address to the file name
; Outputs:
;   None
;   AF, HL, BC, DE and IX are modified
rt_load:
    ld      de,0   ; 2K buffer not needed with disks
    ld      b,(hl) ; filename length
    inc     hl
    call    {FWCALL.CAS_IN_OPEN}  ; CAS_IN_OPEN
    ret     nc     ; Error
    ex      de,hl
    call    {FWCALL.CAS_IN_DIRECT}  ; CAS_IN_DIRECT
    jp      {FWCALL.CAS_IN_CLOSE}  ; CAS_IN_CLOSE
"""
),
    "rt_loadaddr": (["rt_restoreroms"],"",
f"""
; RT_LOADADDR
; Reads an AMSDOS file (with header) and extracts its length.
; The content is loaded into the address stored in DE.
; Inputs:
;   HL address to the file name
;   DE address where content must be loaded
; Outputs:
;   CF if no error
;   AF, HL, BC, DE and IX are modified
rt_loadaddr:
    push    de
    ld      de,0   ; 2K buffer not needed with CAS_IN_DIRECT
    ld      b,(hl) ; filename length
    inc     hl
    call    {FWCALL.CAS_IN_OPEN}  ; CAS_IN_OPEN
    ret     nc     ; Error
    pop     hl
    call    {FWCALL.CAS_IN_DIRECT}  ; CAS_IN_DIRECT
    jp      {FWCALL.CAS_IN_CLOSE}  ; CAS_IN_CLOSE
"""
),
    "rt_save": (["rt_restoreroms"],"",
f"""
; RT_SAVE
; Dumps a memory region as an AMSDOS binary file (with header)
; Inputs:
;   HL address to the file name
;   IX address to the first param in memory
;      IX + 0: Memory address
;      IX + 2: Entry point
;      IX + 4: Memory block length
; Outputs:
;   CF  if no error
;   AF, HL, BC, DE and IX are modified
rt_save:
    ld      de,0     ; 2K buffer not needed with CAS_OUT_DIRECT
    ld      b,(hl)   ; filename length
    inc     hl
    call    {FWCALL.CAS_OUT_OPEN}  ; CAS_OUT_OPEN
    ret     nc       ; Error
    ld      e,(ix+0) ; length
    ld      d,(ix+1)
    ld      c,(ix+2) ; entry point
    ld      b,(ix+3)
    ld      l,(ix+4) ; address
    ld      h,(ix+5)
    ld      a,2
    call    {FWCALL.CAS_OUT_DIRECT}  ; CAS_OUT_DIRECT
    jp      {FWCALL.CAS_OUT_CLOSE}  ; CAS_OUT_CLOSE
"""
),
    "rt_onjump": ([],"",
"""
; RT_ONJUMP
; Given a number in A, this routine jumps to the corresponding
; address stored in memory and pointed by HL
; Inputs:
;   DE address to the list of addresses in memory
;    A number to select one of the addresses, starting in 1
;    B number of options
; Outputs:
;   None
;   AF, DE and HL are modified
rt_onjump:
    or      a
    ret     z      ; do nothing if index is 0
    ld      l,a
    ld      a,b
    cp      l
    ret     c
    dec     l
    ld      h,0
    add     hl,hl
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    jp      (hl)
"""
),
    "rt_speedwrite": ([],"",
f"""
; RT_SPEEDWRITE
; HL must be 0 or 1 and indicates the desired speed.
; Inputs:
;   HL integer value (0 or 1)
; Outputs:
;   None
;   AF and HL are modified
rt_speedwrite:
    xor     a
    add     l
    jr      nz,__speedwrite_1
    ld      hl,333
    ld      a,25
    jp      {FWCALL.CAS_SET_SPEED}
__speedwrite_1
    ld      hl,107
    ld      a,50
    jp      {FWCALL.CAS_SET_SPEED}
"""
),
    "rt_reset_vars": ([],"",
"""
; RT_RESET_VARS
; Fills with 0 all memory area between the labels
; _data_variables_ and _data_variables_end_
; Inputs:
;   None
; Outputs:
;   None
;   AF, HL, DE and BC are modified
rt_reset_vars:
    ld      bc,_data_variables_end_ - _data_variables_ - 1
    ld      hl,_data_variables_
    ld      de,_data_variables_ + 1
    ld      (hl),0
    ldir
    ret
"""
),
    "rt_restoreroms": ([],"",
f"""
; RT_RESTOREROMS
; Based on https://www.cpcmania.com/Docs/Programming/Ficheros.htm
; This rutine initializes again all ROMs, enabling, for example,
; the AMSDOS rom so commands related to disc/tape work.
; Inputs:
;   None
; Outputs:
;   None
;   AF, HL, DE and BC are modified
rt_restoreroms:
    ld      hl,(&be7d)             ; store the drive number the program was run from
    ld      a,(hl)                 ; usually that is in &a700 
    ld      (__restore_drive+1),a  ; self-modifying code
    ld      c,&ff                  ; disable all roms
    ld      hl, __restore_start    ; execution address for program
    call    {FWCALL.MC_START_PROGRAM}                  ; MC_START_PROGRAM
__restore_start: db 0
    call    {FWCALL.KL_ROM_WALK}                  ; KL_ROM_WALK to initialize all roms 
__restore_drive: 
    ld      a, &00                 ; restore the drive number
    ld      hl,(&be7d)             ; because when eneabling AMSDOS the drive
    ld      (hl),a                 ; reverts to 0
    jp      _restoreroms_end       ; jump back without a ret as the stack is empty
"""
),
    "rt_onsq": ([],
"""
rt_onsq_event: defs 7
""",
f"""
; RT_ONSQ
; This rutine calls the Firmware to duplicate the effect of the BASIC
; command ON SQ
; Inputs:
;   A sound queue identifier
;  DE address where to jump to when the event happens
; Outputs:
;   None
;   AF, HL, DE and BC are modified
rt_onsq:
    ld      b,&81
    ld      hl,rt_onsq_event
    call    {FWCALL.KL_INIT_EVENT}  ; HL_INIT_EVENT
    ld      hl,rt_onsq_event
    jp      {FWCALL.SOUND_ARM_EVENT}  ; SOUND_ARM_EVENT
"""
),
    "rt_max": ([],"",
"""
; RT_MAX
; This rutine checks HL and DE and returns in HL the max number
; Inputs:
;   HL first integer
;   DE second integer
; Outputs:
;   HL max number
;   DE min number
;   AF, HL and DE are modified
rt_max:
    push    hl
    xor     a
    sbc     hl,de
    jp      m,__max_de
    pop     hl
    ret
__max_de:
    ex      de,hl
    pop     de
    ret
"""
),
    "rt_maxreal": (["rt_math_call"],
"""
rt_maxreal_buf: defs 5
""",
f"""
; RT_MAXREAL
; This rutine checks REAL numbers in accum1 and accum2 and
; leaves en accum1 the mayor of them
; Inputs:
;   The float numbers stored in accum1 and accum2
; Outputs:
;   accum1 contains the mayor number and accum2 the minor
;   AF, HL, DE, BC and IX are modified
rt_maxreal:
    ld      hl,rt_math_accum1
    ld      de,rt_math_accum2
    ld      ix,{FWCALL.MATH_REAL_COMP}
    call    rt_math_call
    cp      1
    ret     z
    ld      bc,5
    ld      de,rt_maxreal_buf
    ldir
    ld      bc,5
    ld      hl,rt_math_accum2
    ld      de,rt_math_accum1
    ldir
    ld      bc,5
    ld      hl,rt_maxreal_buf
    ld      de,rt_math_accum2
    ldir
    ret
"""
),
    "rt_intsgn": ([],"",
"""
; RT_INTSGN
; Checks the sign of the integer in HL and returns
; -1 (negative), 0 or 1 (positive) in HL
; Inputs:
;   HL integer number
; Outputs:
;   HL -1, 0 or 1
;   AF, HL and DE are modified
rt_intsgn:
    ex      de,hl
    ld      hl,0
    ld      a,d
    or      e
    ret     z
    inc     hl
    bit     7,d
    ret     z
    dec     hl
    dec     hl
    ret
"""
),
    "rt_realsgn": (["rt_math_call"],"",
f"""
; RT_INTSGN
; Checks the sign of the float pointed by accum1 and returns
; -1 (negative), 0 or 1 (positive) in HL
; Inputs:
;   accum1 float number
; Outputs:
;   HL -1, 0 or 1
;   AF, HL and DE are modified
rt_realsgn:
    ld      ix,{FWCALL.MATH_REAL_SIGNUM}  ; MATH_REAL_SIGNUM
    ld      hl,0
    or      a
    ret     z
    dec     hl
    cp      1
    ret     c
    inc     hl
    inc     hl
    ret
"""
),
}
