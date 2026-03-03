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
;    256-table (assembly definition) with mask values for mode 1 using pen 2 as transparent
;
masktable_pen2M1:
      db &00, &00, &00, &00, &00, &00, &00, &00 
      db &00, &00, &00, &00, &00, &00, &00, &00 
      db &11, &00, &11, &00, &11, &00, &11, &00 
      db &11, &00, &11, &00, &11, &00, &11, &00 
      db &22, &22, &00, &00, &22, &22, &00, &00 
      db &22, &22, &00, &00, &22, &22, &00, &00 
      db &33, &22, &11, &00, &33, &22, &11, &00 
      db &33, &22, &11, &00, &33, &22, &11, &00 
      db &44, &44, &44, &44, &00, &00, &00, &00 
      db &44, &44, &44, &44, &00, &00, &00, &00 
      db &55, &44, &55, &44, &11, &00, &11, &00 
      db &55, &44, &55, &44, &11, &00, &11, &00 
      db &66, &66, &44, &44, &22, &22, &00, &00 
      db &66, &66, &44, &44, &22, &22, &00, &00 
      db &77, &66, &55, &44, &33, &22, &11, &00 
      db &77, &66, &55, &44, &33, &22, &11, &00 
      db &88, &88, &88, &88, &88, &88, &88, &88 
      db &00, &00, &00, &00, &00, &00, &00, &00 
      db &99, &88, &99, &88, &99, &88, &99, &88 
      db &11, &00, &11, &00, &11, &00, &11, &00 
      db &AA, &AA, &88, &88, &AA, &AA, &88, &88 
      db &22, &22, &00, &00, &22, &22, &00, &00 
      db &BB, &AA, &99, &88, &BB, &AA, &99, &88 
      db &33, &22, &11, &00, &33, &22, &11, &00 
      db &CC, &CC, &CC, &CC, &88, &88, &88, &88 
      db &44, &44, &44, &44, &00, &00, &00, &00 
      db &DD, &CC, &DD, &CC, &99, &88, &99, &88 
      db &55, &44, &55, &44, &11, &00, &11, &00 
      db &EE, &EE, &CC, &CC, &AA, &AA, &88, &88 
      db &66, &66, &44, &44, &22, &22, &00, &00 
      db &FF, &EE, &DD, &CC, &BB, &AA, &99, &88 
      db &77, &66, &55, &44, &33, &22, &11, &00