; 
; Tile definitions generated from file character.png
;
; Palette created using hardware values
g_palette:
; HW Value  | FW Value | Colour name
;-------------------------------------
   db &14  ; |    0     | Black
   db &15  ; |    2     | Bright Blue
   db &13  ; |   20     | Bright Cyan
   db &16  ; |    9     | Green
   db &0E  ; |   15     | Orange

; Character sprite (16x24 pixels mode 0)
g_character: ; 8*24 bytes
   db &00, &00, &C0, &C0, &C0, &80, &00, &00
   db &00, &40, &C0, &C0, &C0, &C0, &00, &00
   db &00, &C0, &C0, &C0, &C0, &C0, &80, &00
   db &40, &C0, &C0, &C0, &C0, &C0, &C0, &00
   db &C0, &0C, &0C, &0C, &0C, &0C, &48, &80
   db &84, &0C, &0C, &0C, &0C, &0C, &0C, &80
   db &84, &4C, &CC, &CC, &CC, &CC, &0C, &80
   db &84, &4C, &CC, &CC, &CC, &CC, &0C, &80
   db &84, &0C, &0C, &0C, &0C, &0C, &0C, &80
   db &C0, &0C, &0C, &0C, &0C, &0C, &48, &80
   db &40, &C0, &C0, &C0, &C0, &C0, &C0, &00
   db &00, &C0, &48, &C0, &C0, &48, &80, &00
   db &00, &40, &84, &C0, &84, &C0, &00, &00
   db &00, &00, &C0, &0C, &48, &80, &00, &00
   db &00, &00, &40, &C0, &C0, &00, &00, &00
   db &00, &00, &10, &C0, &90, &00, &00, &00
   db &60, &30, &30, &C0, &90, &30, &60, &20
   db &60, &C0, &C0, &C0, &C0, &C0, &C0, &20
   db &60, &30, &30, &C0, &90, &30, &60, &20
   db &00, &00, &10, &C0, &90, &00, &00, &00
   db &00, &00, &10, &C0, &90, &00, &00, &00
   db &00, &30, &30, &C0, &90, &30, &20, &00
   db &10, &60, &C0, &C0, &C0, &C0, &30, &00
   db &10, &C0, &C0, &C0, &C0, &C0, &90, &00
