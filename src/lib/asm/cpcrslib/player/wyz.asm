; Code adapted to ABASM syntax by Javier "Dwayne Hicks" Garcia
; Based on CPCRSLIB:
; Copyright (c) 2008-2015 Raúl Simarro <artaburu@hotmail.com>
; PSG PROPLAYER BY WYZ
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of
; this software and associated documentation files (the "Software"), to deal in the
; Software without restriction, including without limitation the rights to use, copy,
; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
; and to permit persons to whom the Software is furnished to do so, subject to the
; following conditions:
;
; The above copyright notice and this permission notice shall be included in all copies
; or substantial portions of the Software.
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
; PURPOSE and NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
; FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
; OTHERWISE, ARISING FROM, out OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
; DEALINGS IN THE SOFTWARE.


; cpc_WyzConfigurePlayer
; Sets the "interruptores" (switchers) mode. When the values is <> 0: 
; bit 0 = load _WYZ_SONG ON/OFF
; bit 1 = player ON/OFF
; bit 2 = sounds ON/OFF
; bit 3 = SFX ON/OFF
; Inputs:
;     A  Interrupt mode.
; Outputs:
;	  None
;     All registers are preserved
cpc_WyzConfigurePlayer:
	ld      (_WYZ_INTERR),a
	ret

; cpc_WyzInitPlayer
; Sets the tables with all information about songs, effects, etc. The values
; are passed in the stack as follows (first push to last push): 
; - Songs table address
; - Effects table address
; - Rules table address
; - Sounds table address
; Inputs:
;     All values are passed in the stack
; Outputs:
;	  None
;     HL and IX are modified
cpc_WyzInitPlayer:
	ld      ix,2  ; avoid return address
	add     ix,sp 
	ld      l,(ix+6)
	ld      h,(ix+7)
	ld      (_WYZ_TABLA_SONG0),hl
	ld      l,(ix+4)
	ld      h,(ix+5)
	ld      (_WYZ_TABLA_EFECTOS0),hl
	ld      l,(ix+2)
	ld      h,(ix+3)
	ld      (_WYZ_TABLA_PAUTAS0),hl
	ld      l,(ix+0)
	ld      h,(ix+1)
	ld      (_WYZ_TABLA_SONIDOS0),hl
	ret

; cpc_WyzLoadSong
; Sets the selected song number.
; Inputs:
;     A  Song number.
; Outputs:
;	  None
;     AF, HL, DE and IX are modified
cpc_WyzLoadSong:
	jp      _WYZ_CARGA_CANCION_WYZ0

; cpc_WyzSetTempo
; Sets the TEMPO.
; Inputs:
;     A  TEMPO value
; Outputs:
;	  None
;     All registers are preserved
cpc_WyzSetTempo:
	ld      (_wyz_dir_tempo+1),a
	ret

; cpc_WyzStartEffect
; Fires the start of a sound effect.
; Inputs:
;     C  Channel
;     B  Effect number
; Outputs:
;	  None
;     AF is modified
cpc_WyzStartEffect:
	jp      _WYZ_INICIA_EFFECTO_WYZ0

; cpc_WyzTestPlayer
; Returns the current value of "interruptores"
; Inputs:
;     None
; Outputs:
;	  HL  current value of "interruptores" in L
;     A   is modified
cpc_WyzTestPlayer:
	ld      hl,_WYZ_INTERR
	ld      a,(hl)
	ld      l,a
	ld      h,0
	ret

; cpc_WyzSetPlayerOn
; Sets the routine to manage music in the position for the firmware
; routine call. Stores the currrent jump values so they can be restored
; with cpc_WyzSetPlayerOff
; Inputs:
;     None
; Outputs:
;	  None
;     A   is modified
cpc_WyzSetPlayerOn:
	di
	ld      a,(&0038)
	ld      (_wyz_datos_int),a
	ld      (_wyz_salto_int),a
	ld      a,(&0039)
	ld      (_wyz_datos_int+1),a
	ld      (_wyz_salto_int+1),a
	ld      a,(&003a)
	ld      (_wyz_datos_int+2),a
	ld      (_wyz_salto_int+2),a
	ld      a,&C3
	ld      (&0038),a
	ld      hl,WYZ_INICIO
	ld      (&0039),hl
	ei
	ret

; cpc_WyzSetPlayerOff
; Stops all sounding effects and music and removes the
; player interrupt routine.
; Inputs:
;     None
; Outputs:
;	  None
;     AF, HL, DE and BC are modified
cpc_WyzSetPlayerOff:
	;apago todos los sonidos poniendo los registros a 0
	call    _WYZ_PLAYER_OFF
	di
	ld      a,(_wyz_datos_int)
	ld      (&0038),a
	ld      a,(_wyz_datos_int+1)
	ld      (&0039),a
	ld      a,(_wyz_datos_int+2)
	ld      (&003a),a
	ei
	ret

; ----------------------------------------------------------
; WYZ PLAYER
; ----------------------------------------------------------

; Main routine called from interrupt management when the player
; is ON
WYZ_INICIO:
	;primero mira si toca tocar :P
	push    af
	ld      a,(_wyz_contador)
	dec     a
	ld      (_wyz_contador),A
	or      a
	jp      nz,_wyz_termina_int
_wyz_dir_tempo:
	ld      a,6
 	ld      (_wyz_contador),A
 	push    bc
	push    hl
	push    de
	push    ix
	push    iy
    call    _WYZ_ROUT
    ld	    hl,_WYZ_PSG_REG
    ld	    de,_WYZ_PSG_REG_SEC
    ld	    bc,14
    ldir
    call    _WYZ_PLAY
    call    _WYZ_REPRODUCE_SONIDO
    ld	    hl,_WYZ_PSG_REG_SEC
    ld	    de,_WYZ_PSG_REG_EF
    ld	    bc,14
    ldir
    ; de este modo, prevalece el efecto
    call	_WYZ_REPRODUCE_EFECTO_A
    call	_WYZ_REPRODUCE_EFECTO_B
    call	_WYZ_REPRODUCE_EFECTO_C
    call    _WYZ_ROUT_EF
	pop     iy
	pop     ix
	pop     de
	pop     hl
	pop     bc
_wyz_termina_int:
    pop     af
    ei
_wyz_salto_int:
    db     0,0,0

_wyz_contador:  db 0
_wyz_datos_int: db 0,0,0 ; Se guardan 3 BYTES!!!! (Dedicado a Na_th_an, por los desvelos)

;INICIA EL SONIDO A, B o C dependiendo del valor de C (Channel)
_WYZ_INICIA_EFFECTO_WYZ0:
    ld      a,c
    cp      0
    jp      z,_WYZ_INICIA_EFECTO_A
    cp      1
    jp      z,_WYZ_INICIA_EFECTO_B
    cp      2
    jp	    z,_WYZ_INICIA_EFECTO_C
    ret

; REPRODUCE EFECTOS CANAL A
_WYZ_REPRODUCE_EFECTO_A:
    ld      hl,_WYZ_INTERR
    bit     3,(hl)    ; ESTA ACTIVADO EL EFECTO?
    ret     z
    ld      hl,(_WYZ_PUNTERO_EFECTO_A)
    ld      a,(hl)
    cp      &FF
    jr      z,FIN_EFECTO_A
    call 	_WYZ_BLOQUE_COMUN
    ld      (_WYZ_PUNTERO_EFECTO_A),hl
    ld      (ix+0),b
    ld      (ix+1),c
    ld      (ix+8),a
    ret
FIN_EFECTO_A:
    ld      hl,_WYZ_INTERR
    res     3,(hl)
    xor     A
    ld      (_WYZ_PSG_REG_EF+0),A
    ld      (_WYZ_PSG_REG_EF+1),A
    ld		(_WYZ_PSG_REG_EF+8),A
    ret

; REPRODUCE EFECTOS CANAL B
_WYZ_REPRODUCE_EFECTO_B:
    ld      hl,_WYZ_INTERR
    bit     5,(hl) ;ESTA ACTIVADO EL EFECTO?
    ret     z
    ld      hl,(_WYZ_PUNTERO_EFECTO_B)
    ld      a,(hl)
    cp      &FF
    jr      z,FIN_EFECTO_B
    call 	_WYZ_BLOQUE_COMUN
    ld      (_WYZ_PUNTERO_EFECTO_B),hl
    ld      (ix+2),b
    ld      (ix+3),c
    ld      (ix+9),a
    ret
FIN_EFECTO_B:
    ld      hl,_WYZ_INTERR
    res     5,(hl)
    xor     a
    ld      (_WYZ_PSG_REG_EF+2),a
    ld      (_WYZ_PSG_REG_EF+3),a
    ld		(_WYZ_PSG_REG_EF+9),a
    ret

; REPRODUCE EFECTOS CANAL C
_WYZ_REPRODUCE_EFECTO_C:
    ld      hl,_WYZ_INTERR
    bit     6,(hl)   ;ESTA ACTIVADO EL EFECTO?
    ret     z
    ld      hl,(_WYZ_PUNTERO_EFECTO_C)
    ld      a,(hl)
    cp      &FF
    jr      z,FIN_EFECTO_C
    call 	_WYZ_BLOQUE_COMUN
    ld      (_WYZ_PUNTERO_EFECTO_C),hl
    ld      (ix+4),b
    ld      (ix+5),c
    ld      (ix+10),a
    ret
FIN_EFECTO_C:
    ld      hl,_WYZ_INTERR
    res     6,(hl)
    xor     a
    ld      (_WYZ_PSG_REG_EF+4),a
    ld      (_WYZ_PSG_REG_EF+5),a
    ld		(_WYZ_PSG_REG_EF+10),a
    ret

_WYZ_BLOQUE_COMUN:
    ld      ix,_WYZ_PSG_REG_EF
    ld      b,a
    inc     hl
    ld      a,(hl)
    rrca
    rrca
    rrca
    rrca
    and     0b00001111
    ld      c,a
    ld      a,(hl)
    and     0b00001111
    inc     hl
    ret

_WYZ_INICIA_EFECTO_A:
    ld		a,b
    ld      hl,(_WYZ_TABLA_EFECTOS0)
    call    _WYZ_EXT_WORD
    ld      (_WYZ_PUNTERO_EFECTO_A),hl
    ld      hl,_WYZ_INTERR
    set     3,(hl)
    ret

_WYZ_INICIA_EFECTO_B:
    ld		a,b
    ld      hl,(_WYZ_TABLA_EFECTOS0)
    call    _WYZ_EXT_WORD
    ld      (_WYZ_PUNTERO_EFECTO_B),hl
    ld      hl,_WYZ_INTERR
    set     5,(hl)
    ret

_WYZ_INICIA_EFECTO_C:
    ld		a,b
    ld      hl,(_WYZ_TABLA_EFECTOS0)
    call    _WYZ_EXT_WORD
    ld      (_WYZ_PUNTERO_EFECTO_C),hl
    ld      hl,_WYZ_INTERR
    set     6,(hl)
    ret

_WYZ_INICIA_SONIDO:
    ld       hl,(_WYZ_TABLA_SONIDOS0)
    call    _WYZ_EXT_WORD
    ld      (PUNTERO_SONIDO),hl
    ld      hl,_WYZ_INTERR
    set     2,(hl)
    ret

;PLAYER OFF
_WYZ_PLAYER_OFF:
    ld      hl,_WYZ_INTERR
    res     1,(hl)
    xor     a
    ld      hl,_WYZ_PSG_REG
    ld      de,_WYZ_PSG_REG+1
    ld      bc,14
    ld      (hl),a
    ldir
    ld      hl,_WYZ_PSG_REG_SEC
    ld      de,_WYZ_PSG_REG_SEC+1
    ld      bc,14
    ld      (hl),a
    ldir
    call	_WYZ_ROUT
    call	_WYZ_FIN_SONIDO
    ret

_WYZ_CARGA_CANCION_WYZ0:
    di
    push    af
    call	_WYZ_PLAYER_OFF
	pop     af
    ; MUSICA DATOS INICIALES
    ld		de,&0010		   ; No BYTES RESERVADOS POR CANAL
    ld      hl,_WYZ_BUFFER_DEC ; * RESERVAR MEMORIA PARA BUFFER de SONIDO!!!!!
    ld      (_WYZ_CANAL_A),hl
    add     hl,de
    ld      (_WYZ_CANAL_B),hl
    add     hl,de
    ld      (_WYZ_CANAL_C),hl
    add     hl,de
    ld      (_WYZ_CANAL_P),hl
    call    _WYZ_CARGA_CANCION
    ld      a,6
    ld      (_wyz_contador),a
    ; PANTALLA
    ei
    ret

; CARGA UNA CANCION
; IN:(A)= No de CANCION
_WYZ_CARGA_CANCION:
    ld      hl,_WYZ_INTERR  ; CARGA CANCION
    set     1,(hl)          ; REPRODUCE CANCION
    ld      hl,_WYZ_SONG
    ld      (hl),a          ;No A
    ; DECODIFICAR
    ; IN-> INTERR 0 ON
    ;     _WYZ_SONG
    ;CARGA CANCION SI/NO
_WYZ_DECODE_SONG:
	ld      a,(_WYZ_SONG)
    ; LEE CABECERA de LA CANCION
    ; BYTE 0=_WYZ_TEMPO
    ld      hl,(_WYZ_TABLA_SONG0)
    call    _WYZ_EXT_WORD
    ld      a,(hl)
    ld      (_WYZ_TEMPO),a
    xor     a
    ld      (_WYZ_TTEMPO),a
    ; HEADER BYTE 1
    ; (-|-|-|-|-|-|-|LOOP)
    inc	    hl		;LOOP 1=ON/0=OFF?
    ld	    a,(hl)
    bit	    0,a
    jr      z,NPTJP0
    push    hl
    ld	    hl,_WYZ_INTERR
    set     4,(hl)
    pop     hl
NPTJP0:
    inc	    hl ; 2 BYTES RESERVADOS
    inc	    hl
    inc     hl
    ; BUSCA Y GUARDA WYZ_INICIO de LOS CANALES EN EL MODULO MUS
    ld      (_WYZ_PUNTERO_P_DECA),hl
    ld	    e,&3F	; CODIGO INTRUMENTO 0
    ld	    b,&FF	; EL MODULO DEBE TENER UNA LONGITUD MENOR de &FF00 ... o_O!
BGICMODBC1:
    xor     a		; BUSCA EL BYTE 0
    cpir
    dec     hl
    dec     hl
    ld      a,e		; ES EL INSTRUMENTO 0??
    cp      (hl)
    inc     hl
    inc     hl
    jr      z,BGICMODBC1
	ld      (_WYZ_PUNTERO_P_DECB),hl
BGICMODBC2:
    xor     a		; BUSCA EL BYTE 0
    cpir
    dec     hl
    dec     hl
    ld      a,e
    cp      (hl)	; ES EL INSTRUMENTO 0??
    inc     hl
    inc     hl
    jr      z,BGICMODBC2
    ld      (_WYZ_PUNTERO_P_DECC),hl
BGICMODBC3:
    xor	    a		; BUSCA EL BYTE 0
    cpir
    dec     hl
    dec     hl
    ld      a,e
    cp      (hl)	; ES EL INSTRUMENTO 0??
    inc     hl
    inc     hl
    jr      z,BGICMODBC3
    ld      (_WYZ_PUNTERO_P_DECP),hl
    ; LEE DATOS de LAS NOTAS
    ; (|)(|||||) LONGITUD\_WYZ_NOTA
_WYZ_INIT_DECODER:
    ld      de,(_WYZ_CANAL_A)
    ld      (_WYZ_PUNTERO_A),de
    ld      hl,(_WYZ_PUNTERO_P_DECA)
    call    _WYZ_DECODE_CANAL    ; CANAL A
    ld	    (_WYZ_PUNTERO_DECA),hl

    ld      de,(_WYZ_CANAL_B)
    ld      (_WYZ_PUNTERO_B),de
    ld      hl,(_WYZ_PUNTERO_P_DECB)
    call    _WYZ_DECODE_CANAL    ;CANAL B
    ld      (_WYZ_PUNTERO_DECB),hl

    ld      de,(_WYZ_CANAL_C)
    ld      (_WYZ_PUNTERO_C),de
    ld	    hl,(_WYZ_PUNTERO_P_DECC)
    call    _WYZ_DECODE_CANAL    ;CANAL C
    ld	    (_WYZ_PUNTERO_DECC),hl

    ld      de,(_WYZ_CANAL_P)
    ld      (_WYZ_PUNTERO_P),de
    ld	    hl,(_WYZ_PUNTERO_P_DECP)
    call    _WYZ_DECODE_CANAL    ;CANAL P
    ld	    (_WYZ_PUNTERO_DECP),hl
    ret

; DECODIFICA NOTAS de UN CANAL
; IN (de)=DIRECCION DESTINO
; _WYZ_NOTA=0 FIN CANAL
; _WYZ_NOTA=1 SILENCIO
; _WYZ_NOTA=2 PUNTILLO
; _WYZ_NOTA=3 COMANDO I
_WYZ_DECODE_CANAL:
    ld      a,(hl)
    and     a               ;FIN DEL CANAL?
    jr      z,FIN_DEC_CANAL
    call    _WYZ_GETLEN
    cp      0b00000001       ;ES SILENCIO?
    jr      nz,NO_SILENCIO
    set     6,a
    jr      NO_MODIFICA
NO_SILENCIO:
    cp      0b00111110        ;ES PUNTILLO?
    jr      nz,NO_PUNTILLO
    OR      a
    RRC     b
    xor     a
    jr      NO_MODIFICA
NO_PUNTILLO:
    cp      0b00111111      ; ES COMANDO?
    jr      nz,NO_MODIFICA
    bit     0,b             ; COMADO=INSTRUMENTO?
    jr      z,NO_INSTRUMENTO
    ld      a,0b11000001    ; CODIGO de INSTRUMENTO
    ld      (de),a
    inc     hl
    inc     de
    ld      a,(hl)          ; No de INSTRUMENTO
    ld      (de),a
    inc     de
    inc     hl
    jr      _WYZ_DECODE_CANAL
NO_INSTRUMENTO:
    bit     2,b
    jr      z,NO_ENVOLVENTE
    ld      a,0b11000100      ; CODIGO ENVOLVENTE
    ld      (de),a
    inc     de
    inc     hl
    jr      _WYZ_DECODE_CANAL
NO_ENVOLVENTE:
	bit     1,b
    jr      z,NO_MODIFICA
    ld      A,0b11000010      ;CODIGO EFECTO
    ld      (de),a
    inc     hl
    inc     de
    ld      a,(hl)
    call    _WYZ_GETLEN
NO_MODIFICA:
    ld      (de),a
    inc     de
    xor     a
    djnz    NO_MODIFICA
    set     7,a
    set 	0,a
    ld      (de),a
    inc     de
    inc     hl
    ret

FIN_DEC_CANAL:
    set     7,a
    ld      (de),a
    inc     de
    ret

_WYZ_GETLEN:
    ld      b,a
    and     0b00111111
    push    af
    ld      a,b
    and     0b11000000
    rlca
    rlca
    inc     a
    ld      b,a
    ld      a,0b10000000
DCBC0:
	rlca
    djnz    DCBC0
    ld      B,A
    pop     AF
    ret

; _WYZ_PLAY
_WYZ_PLAY:
    ld      hl,_WYZ_INTERR   ; _WYZ_PLAY bit 1 ON?
    bit     1,(hl)
    ret     z
    ; _WYZ_TEMPO
    ld      hl,_WYZ_TTEMPO   ; _wyz_contador _WYZ_TEMPO
    inc     (hl)
    ld      a,(_WYZ_TEMPO)
    cp      (hl)
    jr      nz,PAUTAS
    ld      (hl),0
    ; INTERPRETA
    ld      iy,_WYZ_PSG_REG
    ld      ix,_WYZ_PUNTERO_A
    ld      bc,_WYZ_PSG_REG+8
    call    _WYZ_LOCALIZA_NOTA
    ld      iy,_WYZ_PSG_REG+2
    ld      ix,_WYZ_PUNTERO_B
    ld      bc,_WYZ_PSG_REG+9
    call    _WYZ_LOCALIZA_NOTA
    ld      iy,_WYZ_PSG_REG+4
    ld      ix,_WYZ_PUNTERO_C
    ld      bc,_WYZ_PSG_REG+10
    call    _WYZ_LOCALIZA_NOTA
    ld      ix,_WYZ_PUNTERO_P    ; EL CANAL de EFECTOS ENMASCARA OTRO CANAL
    call    _WYZ_LOCALIZA_EFECTO

PAUTAS:
    ld      iy,_WYZ_PSG_REG+0
    ld      ix,PUNTERO_P_A
    ld      hl,_WYZ_PSG_REG+8
    call    _WYZ_PAUTA           ; _WYZ_PAUTA CANAL A
    ld      iy,_WYZ_PSG_REG+2
    ld      ix,PUNTERO_P_B
    ld      hl,_WYZ_PSG_REG+9
    call    _WYZ_PAUTA           ; _WYZ_PAUTA CANAL B
    ld      iy,_WYZ_PSG_REG+4
    ld      ix,PUNTERO_P_C
    ld      hl,_WYZ_PSG_REG+10
    call    _WYZ_PAUTA           ; _WYZ_PAUTA CANAL C
    ret

; REPRODUCE EFECTOS de SONIDO
_WYZ_REPRODUCE_SONIDO:
    ld      hl,_WYZ_INTERR
    bit     2,(hl)          ; ESTA ACTIVADO EL EFECTO?
    ret     z
    ld      hl,(PUNTERO_SONIDO)
    ld      a,(hl)
    cp      &FF
    jr      z,_WYZ_FIN_SONIDO
    ld      (_WYZ_PSG_REG_SEC+4),a
    inc     hl
    ld      a,(hl)
    rrca
    rrca
    rrca
    rrca
    and     0b00001111
    ld      (_WYZ_PSG_REG_SEC+5),A
    ld      a,(hl)
    and     0b00001111
    ld      (_WYZ_PSG_REG_SEC+10),A
    inc     hl
    ld      a,(hl)
    and     a
    jr      z,NO_RUIDO
    ld      (_WYZ_PSG_REG_SEC+6),A
    ld      a,0b10011000
    jr      SI_RUIDO
NO_RUIDO:
	ld      a,0b10111000
SI_RUIDO:
	ld      (_WYZ_PSG_REG_SEC+7),a
    inc     hl
    ld      (PUNTERO_SONIDO),hl
    ret

_WYZ_FIN_SONIDO:
    ld      hl,_WYZ_INTERR
    res     2,(hl)
FIN_NOPLAYER:
    ld      a,0b10111000 		; 2 BITS ALTOS PARA MSX / AFECTA AL CPC???
    ld      (_WYZ_PSG_REG+7),a
    ret

;VUELCA BUFFER de SONIDO AL PSG
_WYZ_ROUT:
    xor 	a
	ld 	hl,_WYZ_PSG_REG_SEC
LOUT:
    call 	_WYZ_WRITEPSGHL
    inc 	a
    cp      13
    jr 	    nz,LOUT
    ld	    a,(hl)
    and 	a
    ret 	z
    ld	    a,13
    call 	_WYZ_WRITEPSGHL
    xor	    a
    ld      (_WYZ_PSG_REG+13),a
    ld      (_WYZ_PSG_REG_SEC+13),a
    ret

_WYZ_ROUT_EF:
    xor 	a
	ld 	    hl,_WYZ_PSG_REG_EF
LOUT_EF:
    call 	_WYZ_WRITEPSGHL
    inc 	a
    cp      13
    jr 	    nz,LOUT_EF
    ld	    a,(hl)
    and 	a
    ret 	z
    ld      a,13
    call 	_WYZ_WRITEPSGHL
    xor     a
    ld      (_WYZ_PSG_REG_EF+13),a
    ret

; A = REGISTER
; (hl) = VALUE
_WYZ_WRITEPSGHL:
    ld      b,&F4
    out 	(c),a
    ld 	    bc,&F6C0
    out 	(c),c
    db 	    &ED
    db 	    &71
    ld 	    b,&F5
    outi
    ld      bc,&F680
    out 	(c),c
    db 	    &ED
    db 	    &71
    ret

; LOCALIZA _WYZ_NOTA CANAL A
; IN (_WYZ_PUNTERO_A)
_WYZ_LOCALIZA_NOTA:
    ld      l,(ix+0)     ; HL = (PUNTERO_A_C_B)
    ld      h,(ix+1)
    ld      a,(hl)
    and     0b11000000   ; COMANDO?
    cp      0b11000000
    jr      nz,LNJP0
    ; bit(0)=INSTRUMENTO
COMANDOS:
    ld      a,(hl)
    bit     0,a          ; INSTRUMENTO
    jr      z,COM_EFECTO

    inc     hl
    ld      a,(hl)       ; No de _WYZ_PAUTA
    inc     hl
    ld      (ix+0),l
    ld      (ix+1),h
    ld      hl,(_WYZ_TABLA_PAUTAS0)
    call    _WYZ_EXT_WORD
    ld      (ix+18),l
    ld      (ix+19),h
    ld      (ix+12),l
    ld      (ix+13),h
    ld      l,c
    ld      h,b
    res     4,(hl)       ; APAGA EFECTO ENVOLVENTE
    xor     a
    ld      (_WYZ_PSG_REG_SEC+13),a
    ld      (_WYZ_PSG_REG+13),a
    jr      _WYZ_LOCALIZA_NOTA
COM_EFECTO:
    bit     1,a          ; EFECTO de SONIDO
    jr      z,COM_ENVOLVENTE

    inc     hl
    ld      a,(hl)
    inc     hl
    ld      (ix+0),l
    ld      (ix+1),h
    call    _WYZ_INICIA_SONIDO
    ret
COM_ENVOLVENTE:
    bit     2,a
    ret     z            ; IGNORA - ERROR

    inc     hl
    ld      (ix+0),l
    ld      (ix+1),h
    ld      l,c
    ld      h,b
    ld	    (hl),0b00010000  ; ENCIENDE EFECTO ENVOLVENTE
    jr      _WYZ_LOCALIZA_NOTA
LNJP0:
    ld      a,(hl)
    inc     hl
    bit     7,a
    jr      z,NO_FIN_CANAL_A	;
    bit     0,a
    jr	    z,FIN_CANAL_A
FIN_NOTA_A:
    ld      E,(ix+6)
    ld	    D,(ix+7)	; PUNTERO BUFFER AL WYZ_INICIO
    ld	    (ix+0),E
    ld	    (ix+1),D
    ld	    l,(ix+30)	; CARGA PUNTERO DECODER
    ld	    h,(ix+31)
	push    bc
    call    _WYZ_DECODE_CANAL    ; DECODIFICA CANAL
    pop	    bc
    ld	    (ix+30),l	; GUARDA PUNTERO DECODER
    ld	    (ix+31),h
    jp      _WYZ_LOCALIZA_NOTA
FIN_CANAL_A:
    ld	    hl,_WYZ_INTERR	;LOOP?
    bit	    4,(hl)
    jr      nz,FCA_CONT
    call	_WYZ_PLAYER_OFF
    ret

FCA_CONT:
    ld      l,(ix+24)	; CARGA PUNTERO INICIAL DECODER
    ld      h,(ix+25)
    ld      (ix+30),l
    ld      (ix+31),h
    jr      FIN_NOTA_A
NO_FIN_CANAL_A:
    ld      (ix+0),l    ; (PUNTERO_A_B_C)=hl GUARDA PUNTERO
    ld      (ix+1),h
    and     a           ; NO REPRODUCE _WYZ_NOTA SI _WYZ_NOTA=0
    jr      z,FIN_RUTINA
    bit     6,a         ; SILENCIO?
    jr      z,NO_SILENCIO_A
    ld	    a,(bc)
    and     0b00010000
    jr      nz,SILENCIO_ENVOLVENTE
    xor     a
    ld      (bc),a	   ; RESET VOLUMEN
    ld      (iy+0),a
    ld      (iy+1),a
    ret

SILENCIO_ENVOLVENTE:
    ld      a,&FF
    ld      (_WYZ_PSG_REG+11),a
    ld      (_WYZ_PSG_REG+12),a
    xor     a
    ld      (_WYZ_PSG_REG+13),a
    ld      (iy+0),a
    ld      (iy+1),a
    ret

NO_SILENCIO_A:
    call    _WYZ_NOTA   ; REPRODUCE _WYZ_NOTA
    ld      l,(ix+18)   ; hl = (PUNTERO_P_A0) RESETEA _WYZ_PAUTA
    ld      h,(ix+19)
    ld      (ix+12),l   ; (PUNTERO_P_A)=hl
    ld      (ix+13),h
FIN_RUTINA:
	ret

; LOCALIZA EFECTO
; IN hl = (_WYZ_PUNTERO_P)
_WYZ_LOCALIZA_EFECTO:
    ld      l,(ix+0)    ; hl = (_WYZ_PUNTERO_P)
    ld      h,(ix+1)
    ld      a,(hl)
    cp      0b11000010
    jr      nz,LEJP0

    inc     hl
    ld      a,(hl)
    inc     hl
    ld      (ix+0),l
    ld      (ix+1),h
    call    _WYZ_INICIA_SONIDO
    ret
LEJP0:
    inc     hl
    bit     7,a
    jr      z,NO_FIN_CANAL_P
    bit     0,a
    jr      z,FIN_CANAL_P
FIN_NOTA_P:
    ld      de,(_WYZ_CANAL_P)
    ld      (ix+0),e
    ld      (ix+1),d
    ld      hl,(_WYZ_PUNTERO_DECP)	; CARGA PUNTERO DECODER
    push	bc
    call    _WYZ_DECODE_CANAL    	; DECODIFICA CANAL
    pop     bc
    ld      (_WYZ_PUNTERO_DECP),hl	; GUARDA PUNTERO DECODER
    jp      _WYZ_LOCALIZA_EFECTO
FIN_CANAL_P:
    ld      hl,(_WYZ_PUNTERO_P_DECP); CARGA PUNTERO INICIAL DECODER
    ld      (_WYZ_PUNTERO_DECP),hl
    jr      FIN_NOTA_P
NO_FIN_CANAL_P:
    ld      (ix+0),l                ; (PUNTERO_A_B_C)=hl GUARDA PUNTERO
    ld      (ix+1),h
    ret

; _WYZ_PAUTA de LOS 3 CANALES
; IN:(ix):PUNTERO de LA _WYZ_PAUTA
;    (hl):REGISTRO de VOLUMEN
;    (iy):REGISTROS de FRECUENCIA
; FORMATO _WYZ_PAUTA
;	    7    6     5     4   3-0                     3-0
; BYTE 1 (LOOP|OCT-1|OCT+1|SLIDE|VOL) - BYTE 2 ( | | | |PITCH)
_WYZ_PAUTA:
    bit     4,(hl)   ; SI LA ENVOLVENTE ESTA ACTIVADA NO ACTUA _WYZ_PAUTA
    ret     nz
    ld      a,(iy+0)
    ld      b,(iy+1)
    or      b
    ret     z
    push    hl
SLIDE_POS:
PCAJP4:
    ld      l,(ix+0)
    ld      h,(ix+1)
	ld      a,(hl)
	bit     7,a		    ; LOOP / EL RESTO de BITS NO AFECTAN
    jr      z,PCAJP0
    and     0b00011111  ; LOOP _WYZ_PAUTA (0,32)X2!!!-> PARA ORNAMENTOS
    rlca			    ; X2
    ld      d,0
    ld      e,a
    SBC     hl,de
    ld      a,(hl)
PCAJP0:
    bit     6,a		    ; OCTAVA -1
    jr	    z,PCAJP1
    ld	    e,(iy+0)
    ld	    d,(iy+1)
    and     a
    rrc     d
    rr      e
    ld      (iy+0),e
    ld      (iy+1),d
    jr      PCAJP2
PCAJP1:
    bit     5,a		   ; OCTAVA +1
    jr	    z,PCAJP2
    ld      e,(iy+0)
    ld      d,(iy+1)
    and     a
    rlc     e
    rl      d
    ld      (iy+0),e
    ld      (iy+1),d
PCAJP2:
    inc     hl
    push	hl
    ld	    e,a
    ld	    a,(hl)		; PITCH de FRECUENCIA
    ld      l,a
    and     a
    ld      a,e
    jr      z,ORNMJP1
    ld      a,(iy+0)	; SI LA FRECUENCIA ES 0 NO HAY PITCH
    add     a,(iy+1)
    and     a
    ld      a,e
    jr      z,ORNMJP1
    bit     7,l
    jr      z,ORNNEG
    ld      h,&FF
    jr      PCAJP3
ORNNEG:
	ld      h,0
PCAJP3:
	ld	    e,(iy+0)
	ld      d,(iy+1)
	adc     hl,de
	ld      (iy+0),l
	ld      (iy+1),h
ORNMJP1:
	pop     hl
	inc     hl
    ld      (ix+0),l
    ld      (ix+1),h
PCAJP5:
    pop     hl
    and     0b00001111 	; VOLUMEN FINAL
    ld      (hl),a
    ret

; _WYZ_NOTA : REPRODUCE UNA _WYZ_NOTA
; IN (A)=CODIGO de LA _WYZ_NOTA
; (iy) = REGISTROS de FRECUENCIA
_WYZ_NOTA:
	ld      l,c
    ld      h,b
    bit     4,(hl)
    ld      b,a
    jr      nz,EVOLVENTES
    ld      a,b
    ld      hl,_WYZ_DATOS_NOTAS
    rlca           ; x2
    ld      d,0
    ld      e,a
    add     hl,de
    ld      a,(hl)
    ld      (iy+0),a
    inc     hl
    ld      a,(hl)
    ld      (iy+1),a
    ret

; IN (A) = CODIGO de LA ENVOLVENTE
; (iy) = REGISTRO de FRECUENCIA
EVOLVENTES:
    push	af
    call	_WYZ_ENV_RUT1
    ld      de,&0000
    ld      (iy+0),e
    ld      (iy+1),d
    pop     af
    add     a,48
    call	_WYZ_ENV_RUT1
	ld      a,e
    ld      (_WYZ_PSG_REG+11),a
    ld      a,d
    ld      (_WYZ_PSG_REG+12),a
    ld      a,&0E
    ld      (_WYZ_PSG_REG+13),a
    ret

;IN(A) _WYZ_NOTA
_WYZ_ENV_RUT1:
	ld      hl,_WYZ_DATOS_NOTAS
	rlca           ; X2
    ld      d,0
    ld      e,a
    add     hl,de
    ld      e,(hl)
    inc     hl
	ld      d,(hl)
    ret

_WYZ_EXT_WORD:
    ld      d,0
    sla     a        ; x2
    ld      e,a
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    ret


_WYZ_TABLA_PAUTAS0:  dw 0
_WYZ_TABLA_SONIDOS0: dw 0
_WYZ_DATOS_NOTAS:
    dw &0000,&0000
    dw 1711,1614,1524,1438,1358,1281,1210,1142,1078,1017
    dw 960,906,855,807,762,719,679,641,605,571
    dw 539,509,480,453,428,404,381,360,339,320
    dw 302,285,269,254,240,227,214,202,190,180
    dw 170,160,151,143,135,127,120,113,107,101
    dw 95,90,85,80,76,71,67,64,60,57

; ----------------- VARIABLES ----------------- 

; INTERRUPTORES 1=ON 0=OF
; bit 0=CARGA CANCION ON/OFF
; bit 1=PLAYER ON/OFF
; bit 2=SONIDOS ON/OFF
; bit 3=EFECTOS ON/OFF
_WYZ_INTERR: db 0            			
                                        
; MUSICA **** EL ORDEN de LAS VARIABLES ES FIJO ******
_WYZ_TABLA_SONG0:    dw 0
_WYZ_TABLA_EFECTOS0: dw 0

db "PSG PROPLAYER BY WYZ-10"

_WYZ_SONG:       db   00    ; DB No de CANCION
_WYZ_TEMPO:      db   00    ; DB TEMPO
_WYZ_TTEMPO:     db   00    ; dB CONTADOR TEMPO
_WYZ_PUNTERO_A:  dw   00    ; DW PUNTERO DEL CANAL A
_WYZ_PUNTERO_B:  dw   00    ; DW PUNTERO DEL CANAL B
_WYZ_PUNTERO_C:  dw   00    ; DW PUNTERO DEL CANAL C

BUFFER_MUSICA:
_WYZ_CANAL_A:    dw   _WYZ_BUFFER_DEC  ; DW DIRECION de WYZ_INICIO de LA MUSICA A
_WYZ_CANAL_B:    dw   00               ; DW DIRECION de WYZ_INICIO de LA MUSICA B
_WYZ_CANAL_C:    dw   00               ; DW DIRECION de WYZ_INICIO de LA MUSICA C

PUNTERO_P_A:     dw   00               ; DW PUNTERO _WYZ_PAUTA CANAL A
PUNTERO_P_B:     dw   00               ; DW PUNTERO _WYZ_PAUTA CANAL B
PUNTERO_P_C:     dw   00               ; DW PUNTERO _WYZ_PAUTA CANAL C

PUNTERO_P_A0:    dw   00               ; DW INI PUNTERO _WYZ_PAUTA CANAL A
PUNTERO_P_B0:    dw   00               ; DW INI PUNTERO _WYZ_PAUTA CANAL B
PUNTERO_P_C0:    dw   00               ; DW INI PUNTERO _WYZ_PAUTA CANAL C

_WYZ_PUNTERO_P_DECA:  dw   00		; DW PUNTERO de WYZ_INICIO DEL DECODER CANAL A
_WYZ_PUNTERO_P_DECB:  dw   00		; DW PUNTERO de WYZ_INICIO DEL DECODER CANAL B
_WYZ_PUNTERO_P_DECC:  dw   00		; DW PUNTERO de WYZ_INICIO DEL DECODER CANAL C

_WYZ_PUNTERO_DECA:	  dw   00		; DW PUNTERO DECODER CANAL A
_WYZ_PUNTERO_DECB:	  dw   00		; DW PUNTERO DECODER CANAL B
_WYZ_PUNTERO_DECC:	  dw   00		; DW PUNTERO DECODER CANAL C

; CANAL de EFECTOS - ENMASCARA OTRO CANAL
_WYZ_PUNTERO_P:       dw   00       ; DW PUNTERO DEL CANAL EFECTOS
_WYZ_CANAL_P:         dw   00       ; DW DIRECION de WYZ_INICIO de LOS EFECTOS
_WYZ_PUNTERO_P_DECP:  dw   00		; DW PUNTERO de WYZ_INICIO DEL DECODER CANAL P
_WYZ_PUNTERO_DECP:    dw   00		; DW PUNTERO DECODER CANAL P

_WYZ_PSG_REG:         db   00,00,00,00,00,00,00,0b10111000 ,00,00,00,00,00,00,00    ; DB(11) BUFFER de REGISTROS DEL PSG
_WYZ_PSG_REG_SEC:     db   00,00,00,00,00,00,00,0b10111000 ,00,00,00,00,00,00,00    ; DB(11) BUFFER SECUNDARIO de REGISTROS DEL PSG

_WYZ_PSG_REG_EF:      db   00,00,00,00,00,00,00,0b10111000 ,00,00,00,00,00,00,00    ; DB(11) BUFFER de REGISTROS DEL PSG

; EFECTOS de SONIDO
N_SONIDO:       db      0     ; DB  NUMERO de SONIDO
PUNTERO_SONIDO: dw      0     ; DW  PUNTERO DEL SONIDO QUE SE REPRODUCE

; EFECTOS
N_EFECTO:       db      0     ; DB  NUMERO de SONIDO

_WYZ_PUNTERO_EFECTO_A: dw  0  ; DW : PUNTERO DEL SONIDO QUE SE REPRODUCE
_WYZ_PUNTERO_EFECTO_B: dw  0  ; DW : PUNTERO DEL SONIDO QUE SE REPRODUCE
_WYZ_PUNTERO_EFECTO_C: dw  0  ; DW : PUNTERO DEL SONIDO QUE SE REPRODUCE

_WYZ_BUFFER_DEC: ; defs &40
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		; 16 bytes
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		; 32 bytes
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		; 48 bytes
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		; 64 bytes
