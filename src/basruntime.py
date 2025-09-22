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
# String management rutines
#
RT_STR = {
    "rt_print_nl": [
        "rt_print_nl:\n",
        "\tld      a,13\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tld      a,10\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tret\n\n"
    ],
    "rt_print_spc": [
        "; HL indicates the number of spaces to print\n",
        "; but 127 is the maximum\n",
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
        "\tret\n\n"
    ],
    "rt_print_str": [
        "; HL = address to the string to print\n",
        "; STR first byte contains the lenght of\n",
        "; the string.\n",
        "rt_print_str:\n",
        "\tld      a,(hl)\n",
        "\tld      b,a",
        "__print_str_loop:",
        "\tinc     hl",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT}\n",
        "\tdjnz    __print_str_loop\n",
        "\tret     \n",
    ],
    "rt_dropspaces": [
        "; HL points to the string\n",
        "; HL ends pointing to string end or character <> ' '\n",
        "rt_dropspaces:\n",
        "\tld      a,(hl)\n",
        "\tld      b,a",
        "__dropspaces_loop:",
        "\tinc     hl",
        "\tld      a,(hl)\n",
        "\tcp      &20     ; white space\n",
        "\tret     nz\n",
        "\tdjnz    __dropspaces_loop\n\n"
    ],
    "rt_strcopy": [
        "; HL = destination\n",
        "; DE = origin\n",
        "; Strings length is limited to 254 characters\n",
        "; First byte contains the string length\n",
        "; HL ends pointing to the beginning of destination string\n",
        "rt_strcopy:\n",
        "\tld      b,0        ; total copied characters\n",
        "\tpush    hl\n",
        "strlib_strcopy_loop:\n",
        "\tld      a,254\n",
        "\tcp      b\n",
        "\tjr      z,strlib_strcopy_end\n",
        "\tinc     b\n",
        "\tld      a,(de)\n",
        "\tld      (hl),a\n",
        "\tinc     hl\n",
        "\tinc     de\n",
        "\tor      a\n",
        "\tjr      nz,strlib_strcopy_loop\n",
        "strlib_strcopy_end:\n",
        "\tpop     hl\n",
        "\tret\n\n",
    ],
    "rt_strlen": [
        "; HL = string\n",
        "; B = total number of valid characters\n",
        "; HL ends pointing to the null termination character of\n",
        "; the input string\n",
        "rt_strlen:\n",
        "\tld       b,0\n",
        "strlib_strlen_loop:\n",
        "\tld       a,(hl)\n",
        "\tor       a\n",
        "\tjr       z,strlib_strlen_end\n",
        "\tinc      b\n",
        "\tinc      hl\n",
        "\tjr       strlib_strlen_loop\n",
        "strlib_strlen_end:\n",
        "\tret\n\n",
    ],
    "rt_strcat": [
        "; HL = destination\n",
        "; DE = string to cat\n",
        "; cat DE into HL with a limit of 255 characters in total\n"
        "st_strcat:\n",
        "\tpush     hl\n",
        "\tcall     strlib_strlen\n",
        "\tjp       strlib_strcopy_loop\n\n",
    ],
    "rt_stradd": [
        "; HL   = destination\n",
        "; IX+0 = second string to cat\n",
        "; IX+2 = first string to cat\n",
        "; string pointed by HL will receive the cat of the\n",
        "; strings pointed by (IX+3, IX+2) and (IX+1, IX+0)\n",
        "rt_stradd:\n",
        "\tld       d,(ix+3)\n",
        "\tld       e,(ix+2)\n",
        "\tcall     strlib_strcopy\n",
        "\tld       d,(ix+1)\n",
        "\tld       e,(ix+0)\n",
        "\tjp       strlib_strcat\n\n",
    ],
    "rt_strcomp": [
        "; HL = second string start\n",
        "; DE = first string start\n",
        "; HL ends being &FFFF if equal or\n",
        "; HL ends being &&000 if non equal\n",
        "; DE is destroyed\n",
        "rt_strcomp:\n",
        "\tld      a,(de)\n",
        "\tcp      (hl)     ; lets keep A untouched\n",
        "\tjr      nz,__strlib_strcomp_false\n",
        "\tor      (hl)\n",
        "\tcp      0\n",
        "\tjr      z,__strlib_strcomp_true\n",
        "\tinc     hl\n",
        "\tinc     de\n",
        "\tjr      strlib_strcomp\n",
        "__strlib_strcomp_true\n",
        "\tld      hl,&FFFF  ; HL =-1 (true) they are equal\n",
        "\tret\n",
        "__strlib_strcomp_false:\n"
        "\tld      hl,0    ; HL = 0 (false) they are different\n", 
        "\tret\n\n"
    ],
    "rt_int2str": [
        "; HL = starts with the number to convert to string\n",
        "; DE = memory address to convertion buffer\n",
        "; HL ends storing the memory address to the buffer\n",
        "; subroutine taken from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Other:DispA\n",
        "rt_int2str:\n",
        "\tld      de,__strlib_int2str_conv\n"
        "\t; Detect sign of HL\n",
        "\tbit     7, h\n",
        "\tjr      z, __strlib_int2str_convert0\n",
        "\t; HL is negative so add '-' to string and negate HL\n"
        '\tld      a,"-"\n',
        "\tld      (de), a\n",
        "\tinc     de\n",
        "\t; Negate HL (using two's complement)\n",
        "\txor     a\n",
        "\tsub     l\n",
        "\tld      l, a\n",
        "\tld      a, 0   ; Note that XOR A or SUB A would disturb CF\n",
        "\tsbc     a, h\n",
        "\tld      h, a\n",
        "__strlib_int2str_convert0:\n",
        "\t; Convert HL to digit characters\n",
        "\tld      b,0    ; B will count character length of number\n",
        "__strlib_int2str_convert1:\n",
        "\tpush    bc\n",
        "\tcall    div16_hlby10 ; HL = HL / A, A = remainder\n",
        "\tpop     bc\n",
        "\tpush    af     ; Store digit in stack\n",
        "\tinc     b\n",
        "\tld      a,h\n",
        "\tor      l      ; End of string?\n",
        "\tjr      nz, __strlib_int2str_convert1\n",
        "__strlib_int2str_convert2:\n",
        "\t; Retrieve digits from stack\n",
        "\tpop     af\n",
        "\tor      &30    ; '0' + A\n",
        "\tld      (de), a\n",
        "\tinc     de\n",
        "\tdjnz    __strlib_int2str_convert2\n",
        "\t; Terminate string with NULL\n",
        "\txor     a      ; clear flags\n",
        "\tld      (de), a\n",
        "\tld      hl,__strlib_int2str_conv\n",
        "\tret\n",
    ],
    "rt_str2int": [
        "; DE points to the string, ends pointing to the next char not processed\n",
        "; HL points to de memory where to store the integer\n",
        "; A is the 8-bit value of the number\n",
        "; Routine based in the library created by Zeda:\n",
        "; https://github.com/Zeda/Z80-Optimized-Routines\n",
        "strlib_str2int:\n",
        "\tpush    hl\n"
        "\tld      hl,0\n",
        "__strlib_str2int_loop:\n",
        "\tld      a,(de)\n",
        "\tsub     &30  ; '0' character\n",
        "\tcp      10\n",
        "\tjr      nc,__strlib_str2int_end\n",
        "\tinc     de\n",
        "\tld      b,h\n",
        "\tld      c,l\n",
        "\tadd     hl,hl  ; x2\n",
        "\tadd     hl,hl  ; x4\n",
        "\tadd     hl,bc  ; x5\n",
        "\tadd     hl,hl  ; x10\n",
        "\tadd     a,l\n",
        "\tld      l,a\n",
        "\tjr      nc,__strlib_str2int_loop\n",
        "\tinc     h\n",
        "\tjp      __strlib_str2int_loop\n"
        "__strlib_str2int_end:\n"
        "\tld      b,h\n",
        "\tld      c,l\n",
        "\tpop     hl\n",
        "\tld      (hl),c\n",
        "\tinc     hl\n",
        "\tld      (hl),b\n",
        "\tret\n",
    ],
    "rt_int2strhex": [
        "; HL = destination memory address\n",
        "; A  = number of characters: 2 or 4\n",
        "; DE = Number to convert to hex string\n",
        "; Routine taken initially from book 'Ready Made Machine Language Routines'\n",
        "rt_int2strhex:\n",
        "\tpush    hl\n",
        "\tcp      2\n",
        "\tjr      z,__strlib_int2hex_low\n",
        "\tld      a,d\n",
        "\tcall    __strlib_a2hex\n",
        "__strlib_int2hex_low:\n",
        "\tld      a,e\n",
        "\tcall    __strlib_a2hex\n",
        "\tpop     hl\n",
        "\tret\n",
        "__strlib_a2hex:\n",
        "\tld      b,2    ; b=0 marks the end\n",
        "\tld      c,a    ; original number\n",
        "\trr      a      ; move high order bits\n",
        "\trr      a      ; into the low part\n",
        "\trr      a\n",
        "\trr      a\n",
        "__strlib_a2hex_conv:\n",
        "\tand     &0F\n",
        "\tcp      &0A    ; check if is greater or equal\n",
        "\tjr      nc,__strlib_a2hex_letter\n",
        "\tadd     a,&30  ; get the number ASCII code\n",
        "\tjr      __strlib_a2hex_store\n",
        "__strlib_a2hex_letter:\n",
        "\tadd     a,&37\n",
        "__strlib_a2hex_store:\n",
        "\tld      (hl),a\n",
        "\tinc     hl\n",
        "\tdec     b\n",
        "\tjr      z,__strlib_a2hex_end\n",
        "\tld      a,c\n",
        "\tjr      __strlib_a2hex_conv\n",
        "__strlib_a2hex_end:\n",
        "\tld      (hl),0\n",
        "\tret\n",
    ],
}

RT_INPUT = {
    "rt_input": [
        "rt_input:\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_ENABLE} ; TXT_CUR_ENABLE\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_ON} ; TXT_CUR_ON\n",
        "\tld      hl,__inputlib_inbuf\n",
        "\tld      bc,0  ; Initialize characters counter\n",
        "__input_enterchar:\n",
        f"\tcall    {RT_FWCALL.KM_WAIT_KEY} ; KM_WAIT_KEY\n",
        "\tcp      127  ; above call returns characters in range &00-&7F\n",
        "\tjr      nz,__input_checkenter\n",
        "\tld      a,b\n",
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
        "__input_checkenter:\n",
        "\tcp      13\n",
        "\tjr      z,__input_end    ; Enter key pressed\n",
        f"\tcall    {RT_FWCALL.TXT_OUTPUT} ; TXT_OUTPUT\n",
        "\tld      (hl),a\n",
        "\tinc     hl\n",
        "\tinc     bc\n",
        "\tjr      __input_enterchar\n",
        "__input_end:\n",
        "\txor     a\n",
        "\tld      (hl),a\n",
        "\tcall    strlib_print_nl  ; Print enter character\n",
        f"\tcall    {RT_FWCALL.TXT_CUR_DISABLE} ; TXT_CUR_DISABLE\n",
        f"\tjp      {RT_FWCALL.TXT_CUR_OFF} ; TXT_CUR_OFF its ret will work as input ret\n",
    ],
}

RT_MATH = {
    "rt_mul16_unsigned": [
        "; 16x16 unsigned multplication\n",
        "; HL = HL * DE.\n",
        "; Algorithm from Rodney Zaks, 'Programming the Z80'.\n",
        "; Developed by Nils M. Holm (cc0)\n",
        ";Inputs:\n",
        ";     HL and DE\n",
        ";Outputs:\n",
        ";     HL is the HL * DE\n",
        ";     AF, BC and DE are modified\n",
        "rt_mul16_unsigned:\n",
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
    "rt_div16_unsigned": [
        "; 16/16 unsigned division\n",
        "; HL = HL DIV DE\n",
        "; DE = HL MOD DE\n",
        "; Algorithm from Rodney Zaks, 'Programming the Z80'.\n",
        "; Developed by Nils M. Holm (cc0)\n",
        ";Inputs:\n",
        ";     HL, DE\n",
        ";Outputs:\n",
        ";     HL is the quotient\n",
        ";     DE is the remainder\n",
        ";     AF, BC are modified\n",
        "rt_div16_unsigned:\n",
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
        "; Computes resulting sign between HL and DE integers\n",
        "; returns C=0 (pos) if signs are equal and otherwise C=1 (neg)\n",
        "; Developed by Nils M. Holm (cc0)\n",
        ";Inputs:\n",
        ";     HL, DE\n",
        ";Outputs:\n",
        ";     F Carry stores the sign\n",
        ";     A is modified\n",
        "rt_compute_sign:\n",
        "\tld      a,h\n",
        "\txor     d\n",
        "\trla		; sign to carry\n",
        "\tret\n",
    ],
    "rt_sign_strip": [    
        "; Strips signs from HL and DE\n",
        "; performing COMP+2 if they are negative\n",
        "; Developed by Nils M. Holm (cc0)\n",
        "rt_sign_strip:\n",
        ";Inputs:\n",
        ";     HL and DE\n",
        ";Outputs:\n",
        ";     HL is the number in possitive\n",
        ";     DE is the number in possitive\n",
        ";     AF is modified\n",
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
    "rt_mul16_signed": [
        "; 15x15 signed multiplication\n",
        "; HL = HL * DE\n",
        "; Developed by Nils M. Holm (cc0)\n",
        ";Inputs:\n",
        ";     HL and DE\n",
        ";Outputs:\n",
        ";     HL is the HL * DE\n",
        ";     AF, BC, DE are modified\n",
        "rt_mul16_signed:\n",	
        "\tcall    rt_compute_sign\n",
        "\tpush    af\n",
        "\tcall    rt_sign_strip\n",
        "\tcall    rt_mul16_unsigned\n",
        "\tpop     af\n",
        "\tret     nc\n",
        "\tjr      __sign_strip_neghl\n",
    ],
    "rt_div16_signed": [
        "; 15/15 signed division\n",
        "; HL = HL DIV DE\n",
        "; DE = HL MOD DE\n",
        "; Developed by Nils M. Holm (cc0)\n",
        ";Inputs:\n",
        ";     HL, DE\n",
        ";Outputs:\n",
        ";     HL is the quotient\n",
        ";     DE is the remainder\n",
        ";     AF, BC are changed\n",
        "rt_div16_signed:\n",
        "\tcall    rt_compute_sign\n",
        "\tpush    af\n",
        "\tcall    rt_sign_strip\n",
        "\tcall    rt_div16_unsigned\n",
        "\tpop     af\n",
        "\tret     nc\n",
        "\tjr      __sign_strip_neghl\n",
    ],
    "rt_comp16_signed": [
        "; Signed comparison HL-DE, set Z and C flags,\n",
        "; where C indicates that HL < DE\n",
        "rt_comp16_signed:\n",
        ";Inputs:\n",
        ";     HL, DE\n",
        ";Outputs:\n",
        ";     AF Z=1 if HL=DE; Z=0 & C=1 if HL < DE\n"
        ";     HL is modified\n",
        ";     BC, DE are preserved\n",
        "\txor     a\n",
        "\tsbc     hl,de\n",
        "\tret     z\n",
        "\tjp      m,__comp16_cs1\n",
        "\tor      a\n",
        "\tret\n",
        "__comp16_cs1:\n",
        "\tscf\n",
        "\tret\n",
    ],
    "rt_comp16_unsigned": [
        "; Unsigned comparison HL-DE, set Z and C flags,\n",
        "; where C indicates that HL < DE\n",
        "rt_comp16_signed:\n",
        ";Inputs:\n",
        ";     HL, DE\n",
        ";Outputs:\n",
        ";     AF Z=1 if HL=DE; Z=0 & C=1 if HL < DE\n"
        ";     HL is modified\n",
        ";     BC, DE are preserved\n",
        "rt_comp16_unsigned:\n",
        "\txor     a\n",
        "\tsbc     hl,de\n",
        "\tret\n",
    ],
    "rt_div16_hlby10": [
        ";Taken from https://learn.cemetech.net/index.php/Z80:Math_Routines&Speed_Optimised_HL_div_10\n",
        "; HL = HL DIV 10\n",
        ";Inputs:\n",
        ";     HL\n",
        ";Outputs:\n",
        ";     HL is the quotient\n",
        ";     A is the remainder\n",
        ";     BC is 10\n",
        ";     DE is preserved\n",
        "rt_div16_hlby10:\n",
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
}
