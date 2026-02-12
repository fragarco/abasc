; Code adapted to ABASM syntax by Javier "Dwayne Hicks" Garcia
; Based on CPCTELERA cpct_waitVSYNC:
; Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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
;  along with this program.  If not, see <http://www.gnu.org/licenses/>.

; CPC_WAITVSYNC
; This is an active wait loop for the VSYNC signal.
; Inputs:
;     None
; Outputs:
;	  None  The routine returns when the VSYNC signal is detected 
;     BC and AF are modified.
cpc_waitVSYNC:
   ld  b, &F5         ; aPPI Port B address, where we get information about the VSYNC

__cpcwait_check:
   in  a,(c)
   rra                ; Move bit 0 of A to Carry (bit 0 contains VSYNC status)
   jr  nc, __cpcwait_check
   ret                ; Carry Set, VSYNC Active, Return
