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

;; Code modified to be used with ABASM by Javier "Dwayne Hicks" Garcia

;;
;; Array: dc_mode0_ct 
;;
;;    Mode 0 Color conversion table (PEN to Screen pixel format)
;;
;;    This table converts PEN values (palette indexes from 0 to 15) into screen pixel format values in mode 0. 
;; In mode 0, each byte has 2 pixels (P0, P1). This table converts to Pixel 1 (P1) format. Getting values for
;; pixel 0 format only requires shifting the bits 1 to the left.
;;
dc_mode0_ct: db &00, &40, &04, &44, &10, &50, &14, &54, &01, &41, &05, &45, &11, &51, &15, &55

