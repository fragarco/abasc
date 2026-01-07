;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

;;
;; Array: cpct_firmware2hw_colour
;;    Array that maps any firmware colour value (0-27) to
;; its equivalent hardware colour value, which is used 
;; by <cpct_setPalette> and <cpct_setPALColour> functions
;;
cpct_firmware2hw_colour:
  db &14, &04, &15, &1C, &18, &1D, &0C, &05, &0D
  db &16, &06, &17, &1E, &00, &1F, &0E, &07, &0F
  db &12, &02, &13, &1A, &19, &1B, &0A, &03, &0B
