"""
BASC compiler z80 runtime functions

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
class RT_FWCALL:
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
    KM_TEST_BREAK       = "&BDEE"
    KM_SCAN_KEYS        = "&BDF4"

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
    MATH_MOVE_REAL      = "&BD3D"
    MATH_INT_TO_REAL    = "&BD40"
    MATH_BIN_TO_REAL    = "&BD43"
    MATH_REAL_TO_INT    = "&BD46"
    MATH_REAL_TO_BIN    = "&BD49"
    MATH_REAL_FIX       = "&BD4C"
    MATH_REAL_INT       = "&BD4F"
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


#
# Temporal memory management rutines
#
RT_MEM = {
    "rt_malloc": [
        "; RT_MALLOC\n",
        "; Returns in HL the address to a temporal free memory block\n",
        "; reserving as many bytes as indicated by A\n",
        "; Inputs:\n",
        ";      A number of bytes to allocate\n",
        "; Outputs:\n",
        ";     HL address to the new reserved memory\n",
        ";     AF, BC and DE are modified\n",
        "rt_malloc:\n",
        "\tld      hl,(_memory_next)\n",
        "\tpush    hl\n",
        "\tadd     a,l\n",
        "\tld      l,a\n",
        "\tadc     a,h\n",
        "\tsub     l\n",
        "\tld      h,a\n",
        "\tld      (_memory_next),hl\n",
        "\tpop     hl\n",
        "\tret\n\n",
    ],        
}

#
# String management rutines
#
RT_STR = {
    "rt_straddlengths": [
        "; RT_STRADDLENGTHS\n",
        "; Returns the addition of two string lenghts.\n",
        "  Final length is cropped to 254 if exceeds.\n",        
        "; Inputs:\n",
        ";    HL address to length1 in memory\n",
        ";    DE address to length2 in memory\n",
        "; Outputs:\n",
        ";     A resulting length (HL) + (DE) truncated to 254 if needed\n",
        ";     B is modified, HL, DE and C are preserved\n",
        "rt_straddlengths:\n",
        "\tld     b,(hl)\n",
        "\tld     a,(de)\n",
        "\tadd    a,b\n",
        "\tjr     nc,__addlen_checkmax\n",
        "\tjr     __addlen_crop\n",
        "__addlen_checkmax:\n",
        "\tcp     255\n",
        "\tret    c\n",
        "__addlen_crop:\n",
        "\tld     a,254\n         ; max allowed\n",
        "\tret\n\n"
    ],
    "rt_strcopy": [
        "; RT_STRCOPY\n",
        "; Strings length is limited to 254 characters\n",
        "; First byte contains the string length\n",       
        "; Inputs:\n",
        ";     HL destination\n",
        ";     DE origin\n",
        "; Outputs:\n",
        ";     HL address to the destination string\n",
        ";     AF, B and DE are modified, C is preservedmake\n",
        "rt_strcopy:\n",
        "\tpush    hl\n",
        "\tld      a,(de)     ; total characters to copy\n",
        "\tld      (hl),a     ; number of copied characters\n",
        "\tld      b,a\n"
        "__strcopy_loop:\n",
        "\tinc     hl         ; reserve first byte for length\n",
        "\tinc     de         ; first character\n",
        "\tld      a,(de)\n",
        "\tld      (hl),a\n",
        "\tdjnz    __strcopy_loop\n",
        "\tpop     hl\n",
        "\tret\n\n",
    ],
    "rt_strcat": [
        "; RT_STRCAT\n",
        "; DE string gets append to the end of HL string\n",
        "; First byte contains the string length\n",
        "; Inputs:\n",
        ";     HL and DE\n",
        "; Outputs:\n",
        ";     HL points to the resulting string (HL+DE)\n",
        ";     AF, BC and DE are modified\n",
        "rt_strcat:\n",
        "\tcall    rt_straddlengths  ; lets get final length\n"
        "\tld      b,(hl)            ; current length\n",
        "\tld      c,(hl)            ; current length backup\n"
        "\tld      (HL),a            ; store final length\n",
        "\tsub     b\n",
        "\tld      b,a               ; B has the number of bytes to copy\n",
        "\tpush    hl\n",
        "\tld      a,c               ; destination string current len\n",
        "\tadd     a,l\n",
        "\tld      l,a\n",
        "\tadc     a,h\n",
        "\tsub     l\n",
        "\tld      h,a               ; HL points to the its string last byte\n",
        "__strcat_loop:\n"
        "\tinc     hl\n",
        "\tinc     de\n",
        "\tld      a,(de)\n",
        "\tld      (hl),a\n",
        "\tdjnz    __strcat_loop\n",
        "\tpop     hl\n",
        "\tret\n\n"
    ],
    "rt_strcmp": [
        "; RT_STRCMP\n",
        "; Compares two strings pointed by HL and DE and sets ZF and CF:\n",
        "; HL=DE ZF=1, HL<DE ZF=0 CF=0, HL>DE ZF=0 CF=1\n",
        "; Inputs:\n",
        ";     HL and DE\n",
        "; Outputs:\n",
        ";     Flags ZF and CF store the result of the comparation\n",
        ";     AF and B are modified\n",
        "rt_strcmp:\n",
        "\tpush    hl\n",
        "\tpush    de\n",
        "\tld      a,(DE)\n",
        "\tcp      (HL)\n",
        "\tjr      c,$+3\n",
        "\tld      a,(hl)\n",
        "\tor      a\n",
        "\tjr      z,__strcmp_end ; empty strings\n",
        "\tld      b,a            ; longer string length\n",
        "__strcmp_loop:\n",
        "\tinc     hl\n",
        "\tinc     de\n",
        "\tld      a,(de)\n",
        "\tcp      (HL)\n",
        "\tjr      nz,__strcmp_end\n",
        "\tdjnz    __strcmp_loop\n",
        "\tpop     de      ; seems equal\n",
        "\tpop     hl      ; lets check again their lengths\n",
        "\tld      a,(de)\n",
        "\tcp      (hl)\n",
        "\tret\n",
        "__strcmp_end:\n",
        "\tpop     de\n",
        "\tpop     hl\n",
        "\tret\n\n"
    ],
    "rt_int2str": [
        "; RT_INT2STR\n",
        "; HL starts containing the number to convert to string\n",
        "; HL ends storing the memory address to the buffer\n",
        "; Subroutine taken from:\n",
        "; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Other:DispA\n",
        "; Inputs:\n",
        ";     HL\n",
        "; Outputs:\n",
        ";     HL points to the temporal address in memory with the string\n",
        ";     HL, BC, DE, AF are modified\n",
        "rt_int2str_buf: defs 8\n",
        "rt_int2str:\n",
        "\tld      de,rt_int2str_buf\n"
        "\tinc     de     ; first byte stores string length"
        "\t; Detect sign of HL\n",
        "\tbit     7,h\n",
        "\tjr      z,__int2str_convert\n",
        "\t; HL is negative so add '-' to string and negate HL\n"
        '\tld      a,"-"\n',
        "\tld      (de),a\n",
        "\tinc     de\n",
        "\t; Negate HL \n",
        "\txor     a\n",
        "\tsub     l\n",
        "\tld      l,a\n",
        "\tld      a,0    ; Note that XOR A or SUB A would disturb CF\n",
        "\tsbc     a,h\n",
        "\tld      h,a\n",
        "__int2str_convert:\n",
        "\t; Convert HL to digit characters\n",
        "\tld      b,0    ; B will count total length\n",
        "__int2str_loop1:\n",
        "\tpush    bc\n",
        "\tcall    rt_div16_by10 ; HL = HL / A, A = remainder\n",
        "\tpop     bc\n",
        "\tpush    af     ; Store digit in stack in reversed order\n",
        "\tinc     b\n",
        "\tld      a,h\n",
        "\tor      l      ; Stop if quotent is 0\n",
        "\tjr      nz, __int2str_loop1\n",
        "\t; Store string length\n",
        "\tld      hl,rt_int2str_buf\n",
        "\tld      a,b\n",
        "\tld      (hl),a\n",
        "__int2str_loop2:\n",
        "\t; Retrieve digits from stack\n",
        "\tpop     af\n",
        "\tor      &30    ; '0' + A\n",
        "\tld      (de), a\n",
        "\tinc     de\n",
        "\tdjnz    __int2str_loop2\n",
        "\tret\n\n",
    ],
    "rt_strz2num": [
        "; RT_STRZ2NUM\n",
        "; Converts a string with an integer, hexadecimal or binary number to\n",
        "; its numerical 16 bits long form\n",
        "; Inputs:\n",
        ";     DE address to the null-terminated string with the number\n",
        "; Outputs:\n",
        ";     HL resulting number\n",
        ";     AF, HL, DE and BC are modified\n",
        "rt_strz2num:\n",
        "\tld      a,(de)\n",
        '\tcp      "&"\n',
        "\tjr      nz,rt_strz2int\n",
        "\tinc     de\n",
        "\tld      a,(de)\n",
        '\rcp      "X"\n',
        "\tjr      z,__strz2num_bin\n",
        '\rcp      "x"\n',
        "\tjr      z,__strz2num_bin\n",
        "\tjp      rt_strz2hex\n",
        "__strz2num_bin:\n",
        "\tinc     de\n"
        "\tjp      z,rt_strz2bin\n",
        "\n",
        "; RT_STRZ2INT\n",
        "; DE address to the null-terminated string, ends pointing to first\n",
        "; char not converted.\n",
        "; Routine based in the library created by Zeda:\n",
        "; https://github.com/Zeda/Z80-Optimized-Routines\n",
        "; Inputs:\n",
        ";     DE address to the source null-terminated string\n",
        "; Outputs:\n",
        ";     HL contains the converted number\n",
        ";     HL, BC, DE, AF are modified\n",
        "rt_strz2int:\n",
        "\tld      hl,0\n",
        "__strz2int_loop:\n",
        "\tld      a,(de)\n",
        "\tsub     &30    ; '0' character\n",
        "\tcp      10\n",
        "\tret     nc     ; some other character > 9\n",
        "\tinc     de\n",
        "\tld      b,h\n",
        "\tld      c,l\n",
        "\tadd     hl,hl  ; x2\n",
        "\tadd     hl,hl  ; x4\n",
        "\tadd     hl,bc  ; x5\n",
        "\tadd     hl,hl  ; x10\n",
        "\tadd     l\n",
        "\tld      l,a\n",
        "\tjr      nc,__strz2int_loop\n",
        "\tinc     h\n",
        "\tjp      __strz2int_loop\n",
        "__strz2int_end:\n",
        "\n",
        "; RT_STRZ2HEX\n",
        "; DE address to the null-terminated string with a hexadecimal number,\n",
        "; ends pointing to first char not converted.\n",
        "; Inputs:\n",
        ";     DE address to the source null-terminated string\n",
        "; Outputs:\n",
        ";     HL contains the converted number\n",
        ";     HL, BC, DE, AF are modified\n",
        "rt_strz2hex:\n",
        "\tld      hl,0\n",
        "__str2hex_next:\n",
        "\tld      a,(de)\n",
        "\tor      a\n",
        "\tret     z\n",
        "\tinc     de\n",
        '\tcp      "&"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "H"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "h"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "0"\n',
        "\tret     c                 ; < 0 end of conversion\n",
        '\tcp      "9"+1             ; < 10\n',
        "\tjr      c,__str2hex_digit ; '0'..'9'\n",
        '\tcp      "A"\n',
        "\tret     c                 ; < A end of conversion\n",
        '\tcp      "F"+1\n',
        "\tjr      c,__str2hex_upper ; 'A'..'F'\n",
        '\tcp      "a"\n',
        "\tret     c                 ; < a end of conversion\n",
        '\tcp      "f"+1\n',
        "\tjr      c,__str2hex_lower\n",
        "\tret                       ; > f end of conversion\n",
        "__str2hex_digit:\n",
        '\tsub     "0"\n',
        "\tld      c,a\n",
        "\tjr      __str2hex_shiftadd\n",
        "__str2hex_upper:\n",
        '\tsub     "A"-10\n',
        "\tld      c,a\n",
        "\tjr      __str2hex_shiftadd\n",
        "__str2hex_lower:\n",
        '\tsub     "a"-10\n',
        "\tld      c,a\n",
        "\tjr      __str2hex_shiftadd\n",
        "__str2hex_shiftadd        ; HL = HL*16 + C\n",
        "\tadd     hl,hl           ; *2\n",
        "\tadd     hl,hl           ; *4\n",
        "\tadd     hl,hl           ; *8\n",
        "\tadd     hl,hl           ; *16\n",
        "\tld      b,0\n",
        "\tld      a,c\n",
        "\tld      c,a\n",
        "\tadd     hl,bc\n",
        "\tjr      __str2hex_next\n",
        "\n",
        "; RT_STRZ2BIN\n",
        "; DE address to the null-terminated string with a binary number,\n",
        "; ends pointing to first char not converted.\n",
        "; Inputs:\n",
        ";     DE address to the source null-terminated string\n",
        "; Outputs:\n",
        ";     HL contains the converted number\n",
        ";     HL, BC, DE, AF are modified\n",
        "rt_strz2bin:\n",
        "\tld      hl,0\n",
        "__str2bin_next:\n",
        "\tld      a,(de)\n",
        "\tor      a\n",
        "\tret     z\n",
        "\tinc     de\n",
        '\tcp      "&"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "X"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "x"\n',
        "\tjr      z,__str2hex_next\n",
        '\tcp      "0"\n',
        "\tret     c                 ; < 0 end\n",
        '\tcp      "2"\n',
        "\tret     nc                ; > 1 end\n",
        '\tsub     "0"\n',
        "\tadd     hl,hl             ; hl = hl *2\n",
        "\tor      l\n",
        "\tld      l,a\n",
        "\tjr      __str2bin_next\n",
    ],
    "rt_int2hex": [
        "; RT_INT2HEX"
        "; Converts a two-byte integer in an string with its hexadecimal\n",
        "; representation. Routine inspired in the one included in\n",
        "; 'Ready Made Machine Language Routines' book\n",
        "; Inputs:\n",
        ";     A min number of characters: 2 or 4\n",
        ";    HL string address\n",
        ";    DE integer to convert\n",
        "; Outputs:\n",
        ";     HL address to the string with the conversion\n",
        ";     BC, AF are modified\n",
        "rt_int2hex:\n",
        "\tpush    hl\n",
        "\tinc     hl\n",
        "\tld      c,2\n",
        "\tcp      3\n",
        "\tjr      c,__int2hex_low\n",
        "__int2hex_high:\n",
        "\tinc     c\n",
        "\tinc     c\n",
        "\tld      a,d\n",
        "\tcall    __a2hex\n",
        "__int2hex_low:\n",
        "\tld      a,e\n",
        "\tcall    __a2hex\n",
        "\tpop     hl\n",
        "\tld      (hl),c\n",
        "\tret\n",
        "__a2hex:\n",
        "\tld      b,2    ; b=0 marks the end\n",
        "\trr      a      ; move high order bits\n",
        "\trr      a      ; into the low part\n",
        "\trr      a\n",
        "\trr      a\n",
        "__a2hex_conv:\n",
        "\tand     &0F\n",
        "\tcp      &0A    ; check if is greater or equal\n",
        "\tjr      nc,__a2hex_letter\n",
        "\tadd     a,&30  ; get the number ASCII code\n",
        "\tjr      __a2hex_store\n",
        "__a2hex_letter:\n",
        "\tadd     a,&37\n",
        "__a2hex_store:\n",
        "\tld      (hl),a\n",
        "\tinc     hl\n",
        "\tdjnz    __a2hex_conv\n",
        "\tret\n\n",
    ],
}

RT_STDIO = {
    "rt_print": [
        "; RT_PRINT_NL\n",
        "; Prints an EOL which in Amstrad is composed\n",
        "; by chraracters 0x0D 0x0A\n",
        "; Inputs:\n",
        ";     None \n",
        "; Outputs:\n",
        ";     None \n",
        ";     AF is modified\n",
        "rt_print_nl:\n",
        "\tld      a,13\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tld      a,10\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tret\n",
        "\n"
        "; RT_PRINT_SPC\n",
        "; L indicates the number of spaces to print\n",
        "; but 127 is the maximum\n",
        ";Inputs:\n",
        ";     L number of spaces to print\n",
        ";Outputs:\n",
        ";     None\n",
        ";     AF and B are modified\n",
        "rt_print_spc:\n",
        "\tld      a,l\n",
        "\tand     &7F\n",
        "\tcp      0\n",
        "\tret     z\n",
        "\tld      b,a\n",
        "\tld      a,32   ; white space\n",
        "__print_spc_loop:"
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tdjnz    __print_spc_loop\n",
        "\tret\n",
        "\n",
        "; RT_PRINT_STR\n",
        "; Prints in the screen the string pointed by HL\n",
        "; using the Amstrad CPC firmware routines\n",
        "; Inputs:\n",
        ";     HL address to the string to print\n",
        "; Outputs:\n",
        ";     C stores the total number of printed chars\n",
        ";     AF, HL and BC are modified\n",
        "rt_print_str:\n",
        "\tld      a,(hl)\n",
        "\tld      c,a        ; total number of printed chars\n",
        "\tor      a\n",
        "\tret     z          ; empty string\n",
        "\tld      b,a\n",
        "__print_str_loop:\n",
        "\tinc     hl\n",
        "\tld      a,(HL)\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tdjnz    __print_str_loop\n",
        "\tret\n\n",
    ],
    "rt_input": [
        "; RT_COUNT_SUBSTRZ\n",
        "; Returns the number of existing substrings separated\n",
        "; by commas in the null-terminated string addessed by HL.\n",
        "; Inputs:\n",
        ";     HL address to the string to scan\n",
        "; Outputs:\n",
        ";      B number of identified substrings\n",
        ";      C total number of quote characters found\n",
        ";     AF, HL and BC are modified\n", 
        "rt_count_substrz:\n",
        "\tld      bc,&0100    ; final number of substrings\n",
        "__count_loop:\n",
        "\tld      a,(hl)\n",
        "\tor      a\n",
        "\tret     z           ; null termination character\n",
        "\tinc     hl\n",
        "\tcp      &22         ; quote?\n",
        "\tjr      z,__count_quote\n",
        "\tcp      &2c         ; comma?\n",
        "\tjr      nz,__count_loop\n",
        "\tinc     b\n",
        "\tjr      __count_loop\n",
        "__count_quote:\n",
        "\tinc     c\n",
        "\tjr      __count_loop\n",
        "\n",
        "; rt_extract_substrz\n",
        "; Returns the number of existing substrings separated\n",
        "; by commas in the string addessed by HL.\n",
        "; Inputs:\n",
        ";     HL address to the string to scan\n",
        "; Outputs:\n",
        ";      B number of identified substrings\n",
        ";      C total number of quote characters found\n",
        ";     AF, HL and BC are modified\n", 
        "rt_substrz_buf:  defs  255     ; temporal memory to store substrings\n",
        "rt_extract_substrz:\n",
        "\tld      de,rt_substrz_buf\n",
        "\tld      c,0\n",
        "\tcall    __strz_lstrip\n",
        "\tcp      &22     ; quote?\n",
        "\tjr      nz,__extract_comma_separated\n",
        "\tcall    __extract_quoted\n",
        "\tinc     de\n",
        "\tinc     hl\n",
        "\txor     a\n",
        "\tld      (de),a\n",
        "\tcall    __strz_lstrip\n",
        "\tcp      &2c     ; comma\n",
        "\tret     nz\n",
        "\tinc     hl\n",
        "\tret\n", 
        "__extract_comma_separated:\n",
        "\tor      a       ; 0?\n",
        "\tjr      z,__extract_end\n",
        "\tinc     hl\n",
        "\tcp      &2c     ; ,?\n",
        "\tjr      z,__extract_end\n",
        "\tinc     c\n",
        "\tld      (de),a\n",
        "\tinc     de\n",
        "\tld      a,(hl)\n",
        "\tjr      __extract_comma_separated\n",
        "__extract_end:\n",
        "\txor     a\n",
        "\tld      (de),a\n",
        "\tld      a,c\n",
        "\tor      c\n",
        "\tret     z     ; empty string\n",
        "\tdec     de    ; last character\n",
        "\tex      de,hl\n",
        "\tcall    __strz_rstrip\n",
        "\tinc     hl\n",
        "\tld      (hl),0\n",
        "\tex      de,hl\n",
        "\tret\n",
        "\n",
        "__strz_lstrip:\n",
        "\tld      a,(hl)\n",
        "\tcp      &20  ; espace\n",
        "\tret     nz\n",
        "\tinc     hl\n",
        "\tjr      __strz_lstrip\n",
        "\n",
        "__strz_rstrip:\n",
        "\tld      a,(hl)\n",
        "\tcp      &20  ; espace\n",
        "\tret     nz\n",
        "\tdec     hl\n",
        "\tdec     c\n",
        "\tjr      __strz_rstrip\n",
        "\n",
        "__extract_quoted:\n",
        "\tinc     hl\n",
        "\tld      c,0\n",
        "__extract_quoted_loop:\n",
        "\tld      a,(hl)\n",
        "\tcp      &22\n",
        "\tret     z\n",
        "\tld      (de),a\n",
        "\tinc     hl\n",
        "\tinc     de\n",
        "\tinc     c\n",
        "\tjr      __extract_quoted_loop\n",
        "\n",
        "; RT_EXTRACT_NUM\n",
        "rt_extract_num:\n",
        "; Converts and string with an integer or hexadecimal number\n",
        "; Inputs:\n",
        ";     DE address to the null-terminated string with the number\n",
        "; Outputs:\n",
        ";     HL resulting number\n",
        ";     AF, HL, DE and BC are modified\n",
        "\tld      a,(de)\n",
        '\tcp      "&"\n',
        "\tjp      nz,rt_strz2int\n",
        "\tinc     de\n",
        "\tjp      rt_strz2hex\n",
        "\n",
        "; RT_INPUT\n",
        "; Camptures the keyboard input in a null-terminated string\n",
        "; using the Amstrad CPC firmware routines.\n",
        "; Returns in B and C some useful values to validate the input.\n",
        "; Inputs:\n",
        ";     None\n",
        "; Outputs:\n",
        ";     rt_input_buf stores the input as a null-terminated string\n",
        ";      B stores the total number substrings (separated by commas)\n",
        ";      C total number of quote characters found\n",
        ";     AF, HL and BC are modified\n",
        'rt_input_question: db 2,"? "\n',
        'rt_input_redo:     db 16,"?Redo from start "\n',
        'rt_input_buf:      defs 255\n',
        "rt_input:\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_ENABLE} ; TXT_CUR_ENABLE\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_ON} ; TXT_CUR_ON\n",
        "\tld      hl,rt_input_buf\n",
        "\tld      (hl),0\n",
        "\tld      bc,0  ; Initialize characters counter\n",
        "__input_enterchar:\n",
        f"\tcall    {RT_FWCALL.KM_WAIT_KEY} ; KM_WAIT_KEY\n",
        "\tcp      &7F  ; KM_WAIT_KEY returns characters in range &00-&7F\n",
        "\tjr      nz,__input_processchar\n",
        "\tld      a,b  ; backspace key\n",
        "\tor      c\n",
        "\tjr      z,__input_enterchar    ; String length is zero\n",
        "\tld      a,8\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT} ; TXT_OUTPUT\n",
        '\tld      a," "\n',
        f"\tcall    {RT_FWCALL.TXT_OUTPUT} ; TXT_OUTPUT\n",
        "\tld      a,8\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT} ; TXT_OUTPUT\n",
        "\tdec     hl\n",
        "\tdec     bc\n",
        "\tjr      __input_enterchar\n",
        "__input_processchar:\n",
        "\tcp      13\n",
        "\tjr      z,__input_end          ; Enter key pressed\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT} ; TXT_OUTPUT\n",
        "\tld      (hl),a\n",
        "\tinc     hl\n",
        "\tinc     bc\n",
        "\tjr      __input_enterchar\n",
        "__input_end:\n",
        "\tinc     hl\n",
        "\tld      (hl),0\n",
        "\tcall    rt_print_nl\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_DISABLE} ; TXT_CUR_DISABLE\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_OFF} ; TXT_CUR_OFF\n",
        "\tld      hl,rt_input_buf\n",
        "\tjp      rt_count_substrz\n\n",      
    ],
}

RT_MATH = {
    "rt_umul16": [
        "; RT_UMULT16"
        "; 16x16 unsigned multplication\n",
        "; HL = HL * DE.\n",
        "; Algorithm from Rodney Zaks, 'Programming the Z80'.\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL and DE\n",
        "; Outputs:\n",
        ";     HL is the HL * DE\n",
        ";     AF, BC and DE are modified\n",
        "rt_umul16:\n",
        "\tld      a,l	    ; transfer HL to CA\n",
        "\tld      c,h\n",
        "\tld      b,16	    ; 16 bits to multiply\n",
        "\tld      hl,0\n",
        "__mul0_unsigned:\n",
        "\tsrl     c		; shift CA right, get low bit\n",
        "\trra\n",
        "\tjr      nc,__mul1_unsigned	; zero fell out, do not add\n",
        "\tadd     hl,de	; else add DE\n",
        "__mul1_unsigned:\n",
        "\tex      de,hl	; DE = DE*2\n",
        "\tadd     hl,hl\n",
        "\tex      de,hl\n",
        "\tdjnz    __mul0_unsigned\n",
        "\tret\n",
    ],
    "rt_udiv16": [
        "; RT_UDIV16\n",
        "; 16/16 unsigned division\n",
        "; HL = HL DIV DE\n",
        "; DE = HL MOD DE\n",
        "; Algorithm from Rodney Zaks, 'Programming the Z80'.\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL, DE\n",
        "; Outputs:\n",
        ";     HL is the quotient\n",
        ";     DE is the remainder\n",
        ";     AF, BC are modified\n",
        "rt_udiv16:\n",
        "\tld      b,h	    ; store HL in BC\n",
	    "\tld      c,l\n",
        "\tld      a,e	    ; transfer DE to AC\n",
	    "\tor      d\n",
	    "\tld      hl,0	    ; intermediate result\n",
	    "\tret     z		; DIV by 0?\n",      
        "\tld      a,b\n",
        "\tld      b,16	    ; 16 bits to divide\n",
        "__div0_unsigned:\n",
        "\trl      c		; get AC high bit, rotate in result bit\n",
        "\trla\n",
        "\tadc     hl,hl	; HL = HL*2, never sets C\n",
        "\tsbc     hl,de	; trial subtract and test DE > HL\n",
        "\tjr      nc,__div1_unsigned\n",
        "\tadd     hl,de	; DE > HL, restore HL\n",
        "__div1_unsigned:\n",
        "\tccf		        ; result bit\n",
        "\tdjnz    __div0_unsigned\n",
        "\tex      de,hl\n",
        "\trl      c		; rotate in last result bit\n",
        "\trla\n",
        "\tld      h,a\n",
        "\tld      l,c\n",
	    "\tret\n",
    ],
    "rt_compute_sign": [
        "; RT_COMPUTE_SIGN\n",
        "; Computes resulting sign between HL and DE integers\n",
        "; returns C=0 (pos) if signs are equal and otherwise C=1 (neg)\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL, DE\n",
        "; Outputs:\n",
        ";     CF carry stores the sign\n",
        ";     AF is modified\n",
        "rt_compute_sign:\n",
        "\tld      a,h\n",
        "\txor     d\n",
        "\trla		; sign to carry\n",
        "\tret\n",
    ],
    "rt_sign_strip": [   
        "; RT_SIGN_STRIP\n", 
        "; Strips signs from HL and DE\n",
        "; performing COMP+2 if they are negative\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL and DE\n",
        "; Outputs:\n",
        ";     HL is the number in possitive\n",
        ";     DE is the number in possitive\n",
        ";     AF is modified\n",
        "rt_sign_strip:\n",
        "\tbit     7,d\n",
        "\tjr      z,__sign_strip_posde\n",
        "\tld      a,d\n",
        "\tcpl\n",
        "\tld      d,a\n",
        "\tld      a,e\n",
        "\tcpl\n",
        "\tld      e,a\n",
        "\tinc     de\n",
        "__sign_strip_posde:\n",
        "\tbit     7,h\n",
        "\tret     z\n",
        "__sign_strip_neghl:\n",
        "\tld      a,h\n",
        "\tcpl\n",
        "\tld      h,a\n",
        "\tld      a,l\n",
        "\tcpl\n",
        "\tld      l,a\n",
        "\tinc     hl\n",
        "\tret\n",
    ],
    "rt_mul16": [
        "; RT_MUL16\n",
        "; 15x15 signed multiplication\n",
        "; HL = HL * DE\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL and DE\n",
        "; Outputs:\n",
        ";     HL is the HL * DE\n",
        ";     AF, BC, DE are modified\n",
        "rt_mul16:\n",	
        "\tcall    rt_compute_sign\n",
        "\tpush    af\n",
        "\tcall    rt_sign_strip\n",
        "\tcall    rt_umul16\n",
        "\tpop     af\n",
        "\tret     nc\n",
        "\tjr      __sign_strip_neghl\n",
    ],
    "rt_div16": [
        "; RT_DIV16\n",
        "; 15/15 signed division\n",
        "; HL = HL DIV DE\n",
        "; DE = HL MOD DE\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "; Inputs:\n",
        ";     HL, DE\n",
        "; Outputs:\n",
        ";     HL is the quotient\n",
        ";     DE is the remainder\n",
        ";     AF, BC are changed\n",
        "rt_div16:\n",
        "\tcall    rt_compute_sign\n",
        "\tpush    af\n",
        "\tcall    rt_sign_strip\n",
        "\tcall    rt_udiv16\n",
        "\tpop     af\n",
        "\tret     nc\n",
        "\tjr      __sign_strip_neghl\n",
    ],
    "rt_comp16": [
        "; RT_COMP16\n",
        "; Signed comparison HL-DE, set Z and C flags,\n",
        "; where C indicates that HL < DE\n",
        "; Inputs:\n",
        ";     HL, DE\n",
        "; Outputs:\n",
        ";     AF Z=1 if HL=DE; Z=0 & C=1 if HL < DE\n"
        ";     HL is modified\n",
        ";     BC, DE are preserved\n",
        "rt_comp16:\n",
        "\txor     a         ; Clear C flag\n",
        "\tsbc     hl,de\n",
        "\tret     z\n",
        "\tjp      m,__comp16_cs1\n",
        "\tor      a\n",
        "\tret\n",
        "__comp16_cs1:\n",
        "\tscf\n",
        "\tret\n",
    ],
    "rt_ucomp16": [
        "; RT_UCOMP16\n",
        "; Unsigned comparison HL-DE, set ZF and CF flags,\n",
        "; where CF indicates that HL < DE\n",
        "; Inputs:\n",
        ";     HL, DE\n",
        "; Outputs:\n",
        ";     AF ZF=1 if HL=DE; ZF=0 & CF=1 if HL < DE\n"
        ";     HL is modified\n",
        ";     BC, DE are preserved\n",
        "rt_cuomp16:\n",
        "\txor     a          ; Clear C flag\n",
        "\tsbc     hl,de\n",
        "\tret\n",
    ],
    "rt_div16_by10": [
        "; RT_DIV16_BY10\n",
        "; Fast integer division by 10\n",
        "; Taken from:\n",
        "; https://learn.cemetech.net/index.php/Z80:Math_Routines&Speed_Optimised_HL_div_10\n",
        "; HL = HL DIV 10\n",
        "; Inputs:\n",
        ";     HL\n",
        "; Outputs:\n",
        ";     HL is the quotient\n",
        ";     A is the remainder\n",
        ";     HL, BC, AF are modified, DE is preserved\n",
        "rt_div16_by10:\n",
        "\tld      bc,&0D0A\n",
        "\txor     a\n",
        "\tadd     hl,hl\n",
        "\trla\n",
        "\tadd     hl,hl\n",
        "\trla\n",
        "\tadd     hl,hl\n",
        "\trla\n",
        "\tadd     hl,hl\n",
        "\trla\n",
        "\tcp      c\n",
        "\tjr      c,$+4\n",
        "\tsub     c\n",
        "\tinc     l\n",
        "\tdjnz    $-7\n",
        "\tret\n",
    ],
    "rt_udiv8": [
        " RT_UDIV8\n",
        "; 8/8 unsigned integer division,\n",
        ";Inputs:\n",
        ";     A  numerator, E denominator\n",
        ";Outputs:\n",
        ";     D  quotient\n",
        ";     A  remainder\n"
        ";     BC, DE are preserved\n",
        "rt_udiv8:\n",
        "\tld d,0           ; Initialize quotient\n",
        "__div8_loop:\n",
        "\tcp e             ; Compare A with E\n",
        "\tjr c,__div8_end  ; If A < E, we're done\n",
        "\tsub e            ; Subtract E from A\n",
        "\tinc d            ; Increment quotient\n",
        "\tjr __div8_loop   ; Continue dividing\n",
        "__div8_end:\n",
        "\tret\n\n",
    ],
}
