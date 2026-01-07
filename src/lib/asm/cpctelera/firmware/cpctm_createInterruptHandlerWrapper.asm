;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;;  Copyright (C) 2021 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;  Copyright (C) 2021 Nestornillo (https://github.com/nestornillo)
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

;;  cpctm_createInterruptHandlerWrapper_asm
;;    Macro that creates a custom interrupt handler wrapper function.
;;    See file firmware_macros.h.s for help.

;; Code modified to be used with ABASM by Javier "Dwayne Hicks" Garcia

mdelete cpct_checkReg_
macro cpct_checkReg_
endm

mdelete cpct_checkReg_alt
macro cpct_checkReg_alt
  cpct_altDetected equ 1
endm

mdelete cpct_checkReg_af
macro cpct_checkReg_af
  IF cpct_altDetected
    cpct_altAFdetected equ 1
  ENDIF
endm

mdelete cpct_checkReg_bc
macro cpct_checkReg_bc
  IF cpct_altDetected
    cpct_altBCDEHLdetected equ 1
  ENDIF
endm

mdelete cpct_checkReg_de
macro cpct_checkReg_de
  IF cpct_altDetected
    cpct_altBCDEHLdetected equ 1
  ENDIF
endm

mdelete cpct_checkReg_hl
macro cpct_checkReg_hl
  IF cpct_altDetected
    cpct_altBCDEHLdetected equ 1
  ENDIF
endm

mdelete cpct_checkReg_ix
macro cpct_checkReg_ix
endm

mdelete cpct_checkReg_iy
macro cpct_checkReg_iy
endm

mdelete cpct_saveReg_
macro cpct_saveReg_
endm

mdelete cpct_saveReg_alt
macro cpct_saveReg_alt
  IF cpct_altAFdetected
    ex af, af' ;; [1]
  ENDIF
  IF cpct_altBCDEHLdetected
    exx        ;; [1]
  ENDIF
endm

mdelete cpct_saveReg_af
macro cpct_saveReg_af
  push af      ;; [4]
endm

mdelete cpct_saveReg_bc
macro cpct_saveReg_bc
  push bc      ;; [4]
endm

mdelete cpct_saveReg_de
macro cpct_saveReg_de
  push de      ;; [4]
endm

mdelete cpct_saveReg_hl
macro cpct_saveReg_hl
  push hl      ;; [4]
endm

mdelete cpct_saveReg_ix
macro cpct_saveReg_ix
  push ix      ;; [5]
endm

mdelete cpct_saveReg_iy
macro cpct_saveReg_iy
  push iy      ;; [5]
endm

mdelete cpct_restoreReg_
macro cpct_restoreReg_
endm

mdelete cpct_restoreReg_alt
macro cpct_restoreReg_alt
  IF cpct_altBCDEHLdetected
    exx        ;; [1]
  ENDIF
  IF cpct_altAFdetected
    ex af, af' ;; [1]
  ENDIF
endm

mdelete cpct_restoreReg_af
macro cpct_restoreReg_af
  pop af       ;; [3]
endm

mdelete cpct_restoreReg_bc
macro cpct_restoreReg_bc
  pop bc       ;; [3]
endm

mdelete cpct_restoreReg_de
macro cpct_restoreReg_de
  pop de       ;; [3]
endm

mdelete cpct_restoreReg_hl
macro cpct_restoreReg_hl
  pop hl       ;; [3]
endm

mdelete cpct_restoreReg_ix
macro cpct_restoreReg_ix
  pop ix       ;; [4]
endm

mdelete cpct_restoreReg_iy
macro cpct_restoreReg_iy
  pop iy       ;; [4]
endm

mdelete cpctm_createInterruptHandlerWrapper_asm
macro cpctm_createInterruptHandlerWrapper_asm WrapperName, intHandAddress, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11
  cpct_altAFdetected equ 0
  cpct_altBCDEHLdetected equ 0
  cpct_altDetected equ 0
  cpct_checkReg_R1
  cpct_checkReg_R2
  cpct_checkReg_R3
  cpct_checkReg_R4
  cpct_checkReg_R5
  cpct_checkReg_R6
  cpct_checkReg_R7
  cpct_checkReg_R8
  cpct_checkReg_R9
  cpct_checkReg_R10
  cpct_checkReg_R11

  WrapperName:
  _WrapperName:

  cpct_saveReg_R1
  cpct_saveReg_R2
  cpct_saveReg_R3
  cpct_saveReg_R4
  cpct_saveReg_R5
  cpct_saveReg_R6
  cpct_saveReg_R7
  cpct_saveReg_R8
  cpct_saveReg_R9
  cpct_saveReg_R10
  cpct_saveReg_R11

  call intHandAddress ;; [5] Call Interrupt Handler

  cpct_restoreReg_R11
  cpct_restoreReg_R10
  cpct_restoreReg_R9
  cpct_restoreReg_R8
  cpct_restoreReg_R7
  cpct_restoreReg_R6
  cpct_restoreReg_R5
  cpct_restoreReg_R4
  cpct_restoreReg_R3
  cpct_restoreReg_R2
  cpct_restoreReg_R1
  
  ei         ;; [1] Reenable interrupts
  reti       ;; [4] Return to main program
endm
