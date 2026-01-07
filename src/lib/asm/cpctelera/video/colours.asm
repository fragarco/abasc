;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;;  Copyright (C) 2017 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

;; Code modified to be used with ABASM by Javier "Dwayne Hicks" Garcia

;;//////////////////////////////////////////////////////////////////////
;;//////////////////////////////////////////////////////////////////////
;; File: Colours (asm)
;;//////////////////////////////////////////////////////////////////////
;;//////////////////////////////////////////////////////////////////////
;;
;;    Constants and utilities to manage the 27 colours from
;; the CPC Palette comfortably in assembler.
;;
;;

;; Constant: Firmware colour values
;;
;;    Enumerates all 27 firmware colours for assembler programs
;;
;; Values:
;; (start code)
;;   [=================================================]
;;   | Identifier        | Val| Identifier        | Val|
;;   |-------------------------------------------------|
;;   | FW_BLACK          |  0 | FW_BLUE           |  1 |
;;   | FW_BRIGHT_BLUE    |  2 | FW_RED            |  3 |
;;   | FW_MAGENTA        |  4 | FW_MAUVE          |  5 |
;;   | FW_BRIGHT_RED     |  6 | FW_PURPLE         |  7 |
;;   | FW_BRIGHT_MAGENTA |  8 | FW_GREEN          |  9 |
;;   | FW_CYAN           | 10 | FW_SKY_BLUE       | 11 |
;;   | FW_YELLOW         | 12 | FW_WHITE          | 13 |
;;   | FW_PASTEL_BLUE    | 14 | FW_ORANGE         | 15 |
;;   | FW_PINK           | 16 | FW_PASTEL_MAGENTA | 17 |
;;   | FW_BRIGHT_GREEN   | 18 | FW_SEA_GREEN      | 19 |
;;   | FW_BRIGHT_CYAN    | 20 | FW_LIME           | 21 |
;;   | FW_PASTEL_GREEN   | 22 | FW_PASTEL_CYAN    | 23 |
;;   | FW_BRIGHT_YELLOW  | 24 | FW_PASTEL_YELLOW  | 25 |
;;   | FW_BRIGHT_WHITE   | 26 |                   |    |
;;   [=================================================]
;; (end code)

FW_BLACK          equ  0
FW_BLUE           equ  1
FW_BRIGHT_BLUE    equ  2
FW_RED            equ  3
FW_MAGENTA        equ  4
FW_MAUVE          equ  5
FW_BRIGHT_RED     equ  6
FW_PURPLE         equ  7
FW_BRIGHT_MAGENTA equ  8
FW_GREEN          equ  9
FW_CYAN           equ 10
FW_SKY_BLUE       equ 11
FW_YELLOW         equ 12
FW_WHITE          equ 13
FW_PASTEL_BLUE    equ 14
FW_ORANGE         equ 15
FW_PINK           equ 16
FW_PASTEL_MAGENTA equ 17
FW_BRIGHT_GREEN   equ 18
FW_SEA_GREEN      equ 19
FW_BRIGHT_CYAN    equ 20
FW_LIME           equ 21
FW_PASTEL_GREEN   equ 22
FW_PASTEL_CYAN    equ 23
FW_BRIGHT_YELLOW  equ 24
FW_PASTEL_YELLOW  equ 25
FW_BRIGHT_WHITE   equ 26

;; Constant: Hardware colour values
;;
;;    Enumerates all 27 hardware colours for assembler programs
;;
;; Values:
;; (start code)
;;   [=====================================================]
;;   | Identifier        | Value| Identifier        | Value|
;;   |-----------------------------------------------------|
;;   | HW_BLACK          | 0x14 | HW_BLUE           | 0x04 |
;;   | HW_BRIGHT_BLUE    | 0x15 | HW_RED            | 0x1C |
;;   | HW_MAGENTA        | 0x18 | HW_MAUVE          | 0x1D |
;;   | HW_BRIGHT_RED     | 0x0C | HW_PURPLE         | 0x05 |
;;   | HW_BRIGHT_MAGENTA | 0x0D | HW_GREEN          | 0x16 |
;;   | HW_CYAN           | 0x06 | HW_SKY_BLUE       | 0x17 |
;;   | HW_YELLOW         | 0x1E | HW_WHITE          | 0x00 |
;;   | HW_PASTEL_BLUE    | 0x1F | HW_ORANGE         | 0x0E |
;;   | HW_PINK           | 0x07 | HW_PASTEL_MAGENTA | 0x0F |
;;   | HW_BRIGHT_GREEN   | 0x12 | HW_SEA_GREEN      | 0x02 |
;;   | HW_BRIGHT_CYAN    | 0x13 | HW_LIME           | 0x1A |
;;   | HW_PASTEL_GREEN   | 0x19 | HW_PASTEL_CYAN    | 0x1B |
;;   | HW_BRIGHT_YELLOW  | 0x0A | HW_PASTEL_YELLOW  | 0x03 |
;;   | HW_BRIGHT_WHITE   | 0x0B |                   |      |
;;   [=====================================================]
;; (end code)
;;
HW_BLACK          equ 0x14
HW_BLUE           equ 0x04
HW_BRIGHT_BLUE    equ 0x15
HW_RED            equ 0x1C
HW_MAGENTA        equ 0x18
HW_MAUVE          equ 0x1D
HW_BRIGHT_RED     equ 0x0C
HW_PURPLE         equ 0x05
HW_BRIGHT_MAGENTA equ 0x0D
HW_GREEN          equ 0x16
HW_CYAN           equ 0x06
HW_SKY_BLUE       equ 0x17
HW_YELLOW         equ 0x1E
HW_WHITE          equ 0x00
HW_PASTEL_BLUE    equ 0x1F
HW_ORANGE         equ 0x0E
HW_PINK           equ 0x07
HW_PASTEL_MAGENTA equ 0x0F
HW_BRIGHT_GREEN   equ 0x12
HW_SEA_GREEN      equ 0x02
HW_BRIGHT_CYAN    equ 0x13
HW_LIME           equ 0x1A
HW_PASTEL_GREEN   equ 0x19
HW_PASTEL_CYAN    equ 0x1B
HW_BRIGHT_YELLOW  equ 0x0A
HW_PASTEL_YELLOW  equ 0x03
HW_BRIGHT_WHITE   equ 0x0B
