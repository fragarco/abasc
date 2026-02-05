;-----------------------------LICENSE NOTICE------------------------------------
;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;  Copyright (C) 2015 Dardalorth / Fremos / Carlio
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
;------------------------------------------------------------------------------


; Mode 1 palette (firmware colours) for 4-arms monster
sp_palette:
   db &0D, &00, &06, &18

; Death with an oil lamp in Mode 1 Graphics, designed by Dardalorth
sp_death: ; 9*44 bytes
   db &00,&00,&00,&00,&00,&00,&00,&00,&00
   db &00,&00,&00,&80,&00,&00,&00,&00,&00
   db &00,&00,&00,&C0,&00,&00,&00,&00,&00
   db &00,&20,&10,&E0,&00,&00,&00,&00,&00
   db &00,&10,&F0,&F0,&00,&00,&00,&00,&00
   db &00,&10,&F0,&F0,&80,&00,&00,&00,&00
   db &00,&10,&F0,&F0,&C0,&00,&00,&00,&00
   db &00,&10,&F0,&F0,&00,&00,&00,&00,&00
   db &00,&30,&F0,&E0,&00,&00,&00,&00,&00
   db &00,&F0,&F0,&E0,&00,&00,&00,&00,&00
   db &00,&F0,&F0,&E0,&00,&00,&00,&00,&00
   db &00,&70,&F0,&E0,&00,&00,&00,&00,&00
   db &00,&30,&F0,&F0,&90,&C0,&00,&00,&00
   db &00,&10,&F0,&F0,&F0,&E0,&00,&00,&00
   db &00,&00,&D0,&F0,&F0,&5A,&00,&00,&00
   db &00,&00,&50,&F0,&F0,&F0,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&E0,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&C0,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&D0,&00,&00,&00
   db &00,&00,&70,&F0,&F0,&F0,&80,&00,&00
   db &00,&00,&70,&F0,&F0,&F0,&80,&00,&00
   db &00,&00,&70,&F0,&F0,&F0,&80,&00,&00
   db &00,&00,&F0,&F0,&F0,&F0,&C0,&00,&00
   db &00,&00,&F0,&F0,&F0,&A0,&60,&00,&00
   db &00,&00,&F0,&F0,&F0,&C0,&30,&00,&00
   db &00,&10,&F0,&F0,&F0,&C0,&10,&80,&00
   db &00,&10,&F0,&87,&78,&C0,&00,&C0,&00
   db &00,&10,&F0,&C0,&F0,&C0,&00,&60,&00
   db &00,&10,&F0,&00,&30,&C0,&00,&30,&00
   db &00,&10,&F0,&BB,&74,&C0,&00,&10,&00
   db &00,&00,&F0,&00,&30,&C0,&00,&00,&00
   db &00,&00,&F0,&BB,&74,&C0,&00,&00,&00
   db &00,&00,&E0,&00,&10,&80,&00,&00,&00
   db &00,&00,&60,&00,&10,&80,&00,&00,&00
   db &00,&00,&70,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&70,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&70,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&70,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&30,&F0,&F0,&80,&00,&00,&00
   db &00,&00,&00,&00,&00,&00,&00,&00,&00
