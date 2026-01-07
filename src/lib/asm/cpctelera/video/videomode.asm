;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------
;#####################################################################
;### MODULE: SetVideoMode                                          ###
;#####################################################################
;### Routines to establish and control video modes                 ###
;#####################################################################
;

;; Code modified to be used with ABASM by Javier "Dwayne Hicks" Garcia

;;
;; Constant values
;;
GA_port        equ &7F00  ;; 16-bit Port of the Gate Array (for the use with BC register)
GA_port_byte   equ &7F    ;; 8-bit Port of the Gate Array
PAL_PENR       equ &00    ;; Command to select a PEN register in the PAL chip
PAL_INKR       equ &40    ;; Command to set the INK of a previously selected PEN register in the PAL chip
PPI_PORT_B     equ &F5    ;; Port B of the PPI, used to read Vsync/Jumpers/PrinterBusy/CasIn/Exp information
CRTC_SELECTREG equ &BC    ;; CRTC Select Register value
CRTC_SETVAL    equ &BD    ;; CRTC Set Register value
