;-----------------------------LICENSE NOTICE------------------------------------
;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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
;-------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
; Transparency Table for Mode 1
;----------------------------------------------------------------------------------------
;    256-table (assembly definition) with mask values for mode 1 using pen 1 as transparent
;
masktable_pen1M1:
      db &00, &11, &22, &33, &44, &55, &66, &77 
      db &88, &99, &AA, &BB, &CC, &DD, &EE, &FF 
      db &00, &00, &22, &22, &44, &44, &66, &66 
      db &88, &88, &AA, &AA, &CC, &CC, &EE, &EE 
      db &00, &11, &00, &11, &44, &55, &44, &55 
      db &88, &99, &88, &99, &CC, &DD, &CC, &DD 
      db &00, &00, &00, &00, &44, &44, &44, &44 
      db &88, &88, &88, &88, &CC, &CC, &CC, &CC 
      db &00, &11, &22, &33, &00, &11, &22, &33 
      db &88, &99, &AA, &BB, &88, &99, &AA, &BB 
      db &00, &00, &22, &22, &00, &00, &22, &22 
      db &88, &88, &AA, &AA, &88, &88, &AA, &AA 
      db &00, &11, &00, &11, &00, &11, &00, &11 
      db &88, &99, &88, &99, &88, &99, &88, &99 
      db &00, &00, &00, &00, &00, &00, &00, &00 
      db &88, &88, &88, &88, &88, &88, &88, &88 
      db &00, &11, &22, &33, &44, &55, &66, &77 
      db &00, &11, &22, &33, &44, &55, &66, &77 
      db &00, &00, &22, &22, &44, &44, &66, &66 
      db &00, &00, &22, &22, &44, &44, &66, &66 
      db &00, &11, &00, &11, &44, &55, &44, &55 
      db &00, &11, &00, &11, &44, &55, &44, &55 
      db &00, &00, &00, &00, &44, &44, &44, &44 
      db &00, &00, &00, &00, &44, &44, &44, &44 
      db &00, &11, &22, &33, &00, &11, &22, &33 
      db &00, &11, &22, &33, &00, &11, &22, &33 
      db &00, &00, &22, &22, &00, &00, &22, &22 
      db &00, &00, &22, &22, &00, &00, &22, &22 
      db &00, &11, &00, &11, &00, &11, &00, &11 
      db &00, &11, &00, &11, &00, &11, &00, &11 
      db &00, &00, &00, &00, &00, &00, &00, &00 
      db &00, &00, &00, &00, &00, &00, &00, &00
