;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http:;;www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

;; Code modified to be used with ABASM by Javier "Dwayne Hicks" Garcia

;;#####################################################################
;;### MODULE: Sprites
;;### SUBMODULE: flipping.tables
;;#####################################################################
;;### Macros used to generate pixel and sprite flipping tables
;;#####################################################################
;;

;;----------------------------------------------------------------------------------------
;; Title: Pixel Horizontally Flipping Tables
;;----------------------------------------------------------------------------------------

;;
;; Macro: CPCT_PIXEL_FLIPPING_TABLE_M0
;;    256-table (assembly definition) with pixel values horizontally flipped for mode 0
;;
CPCT_PIXEL_FLIPPING_TABLE_M0:
   db   &00, &02, &01, &03, &08, &0A, &09, &0B, &04, &06, &05, &07, &0C, &0E, &0D, &0F 
   db   &20, &22, &21, &23, &28, &2A, &29, &2B, &24, &26, &25, &27, &2C, &2E, &2D, &2F 
   db   &10, &12, &11, &13, &18, &1A, &19, &1B, &14, &16, &15, &17, &1C, &1E, &1D, &1F 
   db   &30, &32, &31, &33, &38, &3A, &39, &3B, &34, &36, &35, &37, &3C, &3E, &3D, &3F 
   db   &80, &82, &81, &83, &88, &8A, &89, &8B, &84, &86, &85, &87, &8C, &8E, &8D, &8F 
   db   &A0, &A2, &A1, &A3, &A8, &AA, &A9, &AB, &A4, &A6, &A5, &A7, &AC, &AE, &AD, &AF 
   db   &90, &92, &91, &93, &98, &9A, &99, &9B, &94, &96, &95, &97, &9C, &9E, &9D, &9F 
   db   &B0, &B2, &B1, &B3, &B8, &BA, &B9, &BB, &B4, &B6, &B5, &B7, &BC, &BE, &BD, &BF 
   db   &40, &42, &41, &43, &48, &4A, &49, &4B, &44, &46, &45, &47, &4C, &4E, &4D, &4F 
   db   &60, &62, &61, &63, &68, &6A, &69, &6B, &64, &66, &65, &67, &6C, &6E, &6D, &6F 
   db   &50, &52, &51, &53, &58, &5A, &59, &5B, &54, &56, &55, &57, &5C, &5E, &5D, &5F 
   db   &70, &72, &71, &73, &78, &7A, &79, &7B, &74, &76, &75, &77, &7C, &7E, &7D, &7F 
   db   &C0, &C2, &C1, &C3, &C8, &CA, &C9, &CB, &C4, &C6, &C5, &C7, &CC, &CE, &CD, &CF 
   db   &E0, &E2, &E1, &E3, &E8, &EA, &E9, &EB, &E4, &E6, &E5, &E7, &EC, &EE, &ED, &EF 
   db   &D0, &D2, &D1, &D3, &D8, &DA, &D9, &DB, &D4, &D6, &D5, &D7, &DC, &DE, &DD, &DF 
   db   &F0, &F2, &F1, &F3, &F8, &FA, &F9, &FB, &F4, &F6, &F5, &F7, &FC, &FE, &FD, &FF 

;;
;; Macro: CPCT_PIXEL_FLIPPING_TABLE_M1
;;    256-table (assembly definition) with pixel values horizontally flipped for mode 1
;;
CPCT_PIXEL_FLIPPING_TABLE_M1:
   db   &00, &08, &04, &0C, &02, &0A, &06, &0E, &01, &09, &05, &0D, &03, &0B, &07, &0F 
   db   &80, &88, &84, &8C, &82, &8A, &86, &8E, &81, &89, &85, &8D, &83, &8B, &87, &8F 
   db   &40, &48, &44, &4C, &42, &4A, &46, &4E, &41, &49, &45, &4D, &43, &4B, &47, &4F 
   db   &C0, &C8, &C4, &CC, &C2, &CA, &C6, &CE, &C1, &C9, &C5, &CD, &C3, &CB, &C7, &CF 
   db   &20, &28, &24, &2C, &22, &2A, &26, &2E, &21, &29, &25, &2D, &23, &2B, &27, &2F 
   db   &A0, &A8, &A4, &AC, &A2, &AA, &A6, &AE, &A1, &A9, &A5, &AD, &A3, &AB, &A7, &AF 
   db   &60, &68, &64, &6C, &62, &6A, &66, &6E, &61, &69, &65, &6D, &63, &6B, &67, &6F 
   db   &E0, &E8, &E4, &EC, &E2, &EA, &E6, &EE, &E1, &E9, &E5, &ED, &E3, &EB, &E7, &EF 
   db   &10, &18, &14, &1C, &12, &1A, &16, &1E, &11, &19, &15, &1D, &13, &1B, &17, &1F 
   db   &90, &98, &94, &9C, &92, &9A, &96, &9E, &91, &99, &95, &9D, &93, &9B, &97, &9F 
   db   &50, &58, &54, &5C, &52, &5A, &56, &5E, &51, &59, &55, &5D, &53, &5B, &57, &5F 
   db   &D0, &D8, &D4, &DC, &D2, &DA, &D6, &DE, &D1, &D9, &D5, &DD, &D3, &DB, &D7, &DF 
   db   &30, &38, &34, &3C, &32, &3A, &36, &3E, &31, &39, &35, &3D, &33, &3B, &37, &3F 
   db   &B0, &B8, &B4, &BC, &B2, &BA, &B6, &BE, &B1, &B9, &B5, &BD, &B3, &BB, &B7, &BF 
   db   &70, &78, &74, &7C, &72, &7A, &76, &7E, &71, &79, &75, &7D, &73, &7B, &77, &7F 
   db   &F0, &F8, &F4, &FC, &F2, &FA, &F6, &FE, &F1, &F9, &F5, &FD, &F3, &FB, &F7, &FF 

;;
;; Macro: CPCT_PIXEL_FLIPPING_TABLE_M2
;;    256-table (assembly definition) with pixel values horizontally flipped for mode 2
;;
CPCT_PIXEL_FLIPPING_TABLE_M2:
   db   &00, &80, &40, &C0, &20, &A0, &60, &E0, &10, &90, &50, &D0, &30, &B0, &70, &F0 
   db   &08, &88, &48, &C8, &28, &A8, &68, &E8, &18, &98, &58, &D8, &38, &B8, &78, &F8 
   db   &04, &84, &44, &C4, &24, &A4, &64, &E4, &14, &94, &54, &D4, &34, &B4, &74, &F4 
   db   &0C, &8C, &4C, &CC, &2C, &AC, &6C, &EC, &1C, &9C, &5C, &DC, &3C, &BC, &7C, &FC 
   db   &02, &82, &42, &C2, &22, &A2, &62, &E2, &12, &92, &52, &D2, &32, &B2, &72, &F2 
   db   &0A, &8A, &4A, &CA, &2A, &AA, &6A, &EA, &1A, &9A, &5A, &DA, &3A, &BA, &7A, &FA 
   db   &06, &86, &46, &C6, &26, &A6, &66, &E6, &16, &96, &56, &D6, &36, &B6, &76, &F6 
   db   &0E, &8E, &4E, &CE, &2E, &AE, &6E, &EE, &1E, &9E, &5E, &DE, &3E, &BE, &7E, &FE 
   db   &01, &81, &41, &C1, &21, &A1, &61, &E1, &11, &91, &51, &D1, &31, &B1, &71, &F1 
   db   &09, &89, &49, &C9, &29, &A9, &69, &E9, &19, &99, &59, &D9, &39, &B9, &79, &F9 
   db   &05, &85, &45, &C5, &25, &A5, &65, &E5, &15, &95, &55, &D5, &35, &B5, &75, &F5 
   db   &0D, &8D, &4D, &CD, &2D, &AD, &6D, &ED, &1D, &9D, &5D, &DD, &3D, &BD, &7D, &FD 
   db   &03, &83, &43, &C3, &23, &A3, &63, &E3, &13, &93, &53, &D3, &33, &B3, &73, &F3 
   db   &0B, &8B, &4B, &CB, &2B, &AB, &6B, &EB, &1B, &9B, &5B, &DB, &3B, &BB, &7B, &FB 
   db   &07, &87, &47, &C7, &27, &A7, &67, &E7, &17, &97, &57, &D7, &37, &B7, &77, &F7 
   db   &0F, &8F, &4F, &CF, &2F, &AF, &6F, &EF, &1F, &9F, &5F, &DF, &3F, &BF, &7F, &FF 
