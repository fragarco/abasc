
SCRVIEW_LEFT:   db  0 	 ; in screen bytes (0-79)
SCRVIEW_TOP:    db  0 	 ; in screen lines (0-199)
SCRVIEW_RIGHT:  db  79   ; in screen bytes (0-79)
SCRVIEW_BOTTOM: db  199  ; in screen lines (0-199)

; SCRCROPSPRITE
; This routines tests the current position and size of one
; sprite against the rectangle set by scrSetClippingView.
; It calculates the sprite's visible area or returns the 
; Carry flag if not area is visible at all.
; Inputs:
;   IX+0,+1      Sprite Y position (16 bits signed integer)
;   IX+2,+3      Sprite X position (16 bits signed integer)
;   B			 Sprite width in bytes
;   C            Sprite height in lines            
; Outputs:
;   Carry flag set if the sprite is not visible.
;   Modifies  AF, HL, DE
scrCropSprite:
__cropsp_offtop:
	ld      a,c
	ld      (__spclipped_h+1),a		; SPCLP.H = SP.H
   	ld      a,(ix+0)				; DE = SP.Y
   	ld      d,(ix+1)
	ld      (__spclipped_y+1),a		; SPCLP.Y = Y (low byte)
	ld      e,a
   	xor     a
   	ld      (__spclipped_topoff+1),a; OFF.TOP = 0
	ld      h,a
	ld      a,(SCRVIEW_BOTTOM)  	; HL = VP.BOTTOM
	ld      l,a
   	sbc     hl,de					; OFF.TOP = VP.BOTTOM - SP.Y
   	jr      nc,__cropsp_offbottom	; OFF.TOP >= 0?
   	ex      de,hl
   	ld      hl,0
   	xor     a
   	sbc     hl,de					; OFF.TOP = 0 - OFF.TOP
   	xor     a
   	ld      d,a
   	ld      e,c						; DE = SP.H
   	sbc     hl,de					; OFF.TOP = OFF.TOP - SP-H
   	jp      nc,__cropsp_allcrop     ; OFF.TOP >= 0?
   	add     hl,de					; restore OFF.TOP
	ld      a,(SCRVIEW_BOTTOM)
   	ld      (__spclipped_y+1),a		; SPCLP.Y = VP.BOTTOM
	ld      a,e
	sub     l						; SPCLP.H = SP.H - OFF.TOP
	ld      (__spclipped_h+1),a		; store SPCLP.H
	ld      a,l
   	ld      (__spclipped_topoff+1),a; store OFF.TOP

__cropsp_offbottom:
   	xor     a
   	ld      l,(ix+0)				; HL = SP.Y
   	ld      h,(ix+1)
   	ld      d,a						; DE = SP.H
   	ld      e,c
   	sbc     hl,de					; HL = SP.Y - SP.H coords go bottom to top
   	xor     a						; clear CF
	ld      d,a
	ld      a,(SCRVIEW_TOP)			; DE = VP.TOP
	ld      e,a
   	sbc     hl,de					; OFF.BOTTOM = (SP.Y - SP.H) - VP.TOP
   	jp      m,$+5					; OFF.BOTTOM >= 0?
   	jr      __cropsp_offleft
   	ex      de,hl
   	ld      hl,0
   	xor     a
   	sbc     hl,de					; OFF.BOTTOM = 0 - OFF.BOTTOM
   	xor     a
   	ld      d,a
   	ld      e,c						; DE = SP.H
   	sbc     hl,de					; OFF.BOTTOM = OFF.BOTTOM - SP.H
   	jr      nc,__cropsp_allcrop     ; OFF.BOTTOM >= 0?
   	add     hl,de					; restore OFF.BOTTOM
	ld      a,(__spclipped_h+1)
	sub     l
	inc     a
	ld      (__spclipped_h+1),a		; SPCLP.H = (SPCLP.H - OFF.BOTTOM) + 1

__cropsp_offleft:
	ld      l,(ix+2)				; HL = SP.X
   	ld      h,(ix+3)
	ld      a,l
	ld      (__spclipped_x+1),a		; SPCLP.X = SP.X
	ld      a,b
	ld      (__spclipped_w+1),a		; SPCLP.W = SP.W
   	xor     a
   	ld      (__spclipped_leftoff+1),a ; OFF.LEFT = 0
	ld      d,a
   	ld      a,(SCRVIEW_LEFT)		; DE = VP.LEFT
	ld      e,a
   	sbc     hl,de					; OFF.LEFT = SP.X - VP.LEFT
   	jp      m,$+5					; OFF.LEFT >= 0?
	jr      __cropsp_right
   	ex      de,hl
   	ld      hl,0
   	xor     a
   	sbc     hl,de					; OFF.LEFT = 0 - OFF.LEFT
   	xor     a
   	ld      d,a
   	ld      e,b
   	sbc     hl,de					; OFF.LEFT = OFF.LEFT - SP.W
   	jr      nc,__cropsp_allcrop		; OFF.LEFT >= 0?
   	add     hl,de					; restore OFF.LEFT
	ld      a,(SCRVIEW_LEFT)
	ld      (__spclipped_x+1),a		; SPCLP.X = VP.LEFT
   	ld      a,b
	sub     l
	ld      (__spclipped_w+1),a		; SPCLP.W = SP.W - OFF.LEFT
	ld      a,l
   	ld      (__spclipped_leftoff+1),a ; store OFF.LEFT

__cropsp_right:
   	xor     a
   	ld      (__spclipped_rightoff+1),a ; OFF.RIGTH = 0
   	ld      d,a
   	ld      e,b						; DE = SP.W
   	ld      l,(ix+2)
   	ld      h,(ix+3)				; HL = SP.X
   	add     hl,de					; SP.X + SP.W
   	ex      de,hl
	ld      h,a
   	ld      a,(SCRVIEW_RIGHT)
	inc     a						; next byte to the current seen one
	ld      l,a
   	sbc     hl,de					; OFF.RIGHT = VP.RIGHT - (SP.X + SP.W)
   	ret     nc
   	ex      de,hl
   	ld      hl,0
   	xor     a						; Clear CF
   	sbc     hl,de					; OFF.RIGHT = 0 - OFF.RIGHT
   	ld      d,a
   	ld      e,b
	xor     a						; Clear CF
   	sbc     hl,de					; OFF.RIGHT = OFF.RIGHT - SP.W
   	jr      nc,__cropsp_allcrop		; OFF.RIGHT >= 0?
   	add     hl,de					; restore OFF.RIGHT
	ld      a,(__spclipped_w+1)
	sub     l
	ld      (__spclipped_w+1),a		; SPCLP.W = SPCLP.W - OFF.RIGHT
   	ld      a,l
   	ld      (__spclipped_rightoff+1),a ; store OFF.RIGHT
   	xor     a
   	ret

__cropsp_allcrop:
   	scf
   	ret


; SCRDRAWCLIPPEDSPRITE
;	Draws a clipped sprite using the information stored in
;   memory which is calculated by scrCropSprite. The sprite's
;   data (witdh, height and pixels) are pointed by rt_data_ptr
; Inputs:
;   IX+0,+1      Sprite Y position (16 bits signed integer)
;   IX+2,+3      Sprite X position (16 bits signed integer)
; Outputs:
;	None
;   Modifies AF, HL, DE, IX and IY
scrDrawClippedSprite:
    ld      hl,(rt_data_ptr)
    ld      a,(hl)   ; width in bytes
    ld      b,a
    inc     hl
    ld      a,(hl)   ; height in lines
    ld      c,a
    inc     hl
    push    hl
    push    bc
    call    scrCropSprite
    pop     ix		 ; IXH = SP.W, IXL = SP.H
    pop     iy
    ret     c        ; non visible sprite

	__spclipped_y:
	ld      hl,0		; self-modifying code: clippend y-pos (in lines)
	ld      de,0		; x = 0, we are only interested in the line position
	call    &BC1D    	; SCR_DOT_POSITION
	__spclipped_x:
	ld      de,0		; self-modifying code: clippend x-pos (in bytes)
	add     hl,de		; HL = starting vmem position
	__spclipped_h:
	ld      c,0			; self-modifying code: clippend height (SPCLP.H)
	__spclipped_topoff:
	ld      a,0			; self-modifying code: OFF.TOP
	or      a
	jr      z,__draw_clipsp_line
	ld      b,a
	ld      e,ixh		; DE = SP.W
	ld      d,0
__draw_clipsp_croptop:
	add     iy,de
	djnz    __draw_clipsp_croptop
__draw_clipsp_line:
	__spclipped_leftoff:
	ld      de,0		;  self-modifying code: OFF.LEFT
	add     iy,de
	__spclipped_w:
	ld      b,0			;  self-modifying code: SPCLP.W
	push    hl
__draw_clipsp_ldir:
	ld      a,(iy)
	__spclipped_func:
	xor		(hl)		; self-modifying code: NOP or XOR
	ld      (hl),a
	inc     hl
	inc     iy
	djnz    __draw_clipsp_ldir
	__spclipped_rightoff:
	ld      de,0		; OFF.RIGHT  
	add     iy,de
	pop     hl
	call    &BC26    	; SCR_NEXT_LINE
	dec     c
	jr      nz,__draw_clipsp_line
	ret