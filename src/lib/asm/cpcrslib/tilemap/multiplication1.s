		LD	  HL,#ancho_pantalla_bytes*256       
        LD    D, L
        LD    B, #8

MULT2:   ADD   HL, HL
        JR    NC, NOADD2
        ADD   HL, DE
NOADD2:  DJNZ  MULT2