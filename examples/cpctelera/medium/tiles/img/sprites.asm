;-----------------------------LICENSE NOTICE------------------------------------
;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU Lesser General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU Lesser General Public License for more details.
;
;  You should have received a copy of the GNU Lesser General Public License
;  along with this program.  If not, see <http:;www.gnu.org/licenses/>.
;------------------------------------------------------------------------------

;
; Sprite definitions used in this example
;

; Waves sprite, 2x4 bytes size (4x4 mode 0 pixels)
waves_2x4: ;8bytes
  db &E0,&E0
  db &D0,&D0
  db &58,&58
  db &A4,&A4


; Waves sprite, 2x8 bytes size (4x8 mode 0 pixels)
waves_2x8: ;16bytes
  db &E0,&E0
  db &D0,&D0
  db &58,&58
  db &A4,&A4
  db &D8,&D8
  db &E4,&E4
  db &F2,&F2
  db &F1,&F1

; F sprite, 2x8 bytes size (4x8 mode 0 pixels)
F_2x8: ;16bytes
  db &0C,&3C
  db &4C,&9C
  db &4C,&3C
  db &6C,&8C
  db &6C,&0C
  db &6C,&58
  db &3C,&58
  db &F0,&F0 
        
; Waves sprite, 4x4 bytes size (8x4 mode 0 pixels)
waves_4x4: ;16bytes       
  db &03,&C3,&0C,&C0
  db &47,&E1,&4C,&60
  db &52,&CB,&18,&C8
  db &47,&E1,&4C,&60

; Waves sprite, 4x8 bytes size (8x8 mode 0 pixels)
waves_4x8: ;32bytes       
  db &03,&C3,&0C,&C0
  db &47,&E1,&4C,&60
  db &52,&CB,&18,&C8
  db &47,&E1,&4C,&60
  db &52,&CB,&18,&C8
  db &47,&E1,&4C,&60
  db &52,&CB,&18,&C8
  db &03,&C3,&0C,&C0


; Inverted waves sprite, 4x8 bytes size (8x8 mode 0 pixels)
FF_4x8: ;32bytes
  db &61,&C3,&C3,&92
  db &61,&33,&33,&72
  db &61,&72,&F0,&F0
  db &61,&33,&32,&30
  db &61,&33,&72,&30
  db &61,&72,&F0,&30
  db &61,&72,&30,&30
  db &30,&F0,&30,&30  
 
