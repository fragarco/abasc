'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'
'  This program is free software: you can redistribute it and/or modify
'  it under the terms of the GNU Lesser General Public License as published by
'  the Free Software Foundation, either version 3 of the License, or
'  (at your option) any later version.
'
'  This program is distributed in the hope that it will be useful,
'  but WITHOUT ANY WARRANTY without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

chain merge "cpctelera/cpctelera.bas"

' This example is built with data allocated at &8000, so we can use page &4000.
' See the build configuration in make.bat/make.sh
label MAIN
   firstByteInPage = &4000

   call cpctPageMemory(RAM.CFG0 or RAM.BANK0)	 ' Not needed, sets the memory with the first 64kb accesible, in consecutive banks.
   ' firstByteInPage point to address &4000. With this memory 
   ' configuration, that is physical address &4000. 
   poke firstByteInPage, cpctpx2byteM1(1, 1, 1, 1)	' Set the first byte in page to all pixels with colour 1 (yellow by default).

   call cpctPageMemory(RAM.CFG4 or RAM.BANK0)				' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   ' RAM.CFG4: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_4, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
   ' firstByteInPage point to address &4000. With this memory 
   ' configuration, &4000 is the first byte in RAM.BANK0, RAM_4, 
   ' which is physical address &10000. 
   poke firstByteInPage, cpctpx2byteM1(2, 2, 2, 2)	' Set the first byte in page to all pixels with colour 2 (cyan by default ).

   call cpctPageMemory(RAM.CFG5 or RAM.BANK0)				' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   ' RAM.CFG5: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_5, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
   ' firstByteInPage point to address &4000. With this memory 
   ' configuration, &4000 is the first byte in RAM.BANK0, RAM_5, 
   ' which is physical address &14000. 
   poke firstByteInPage, cpctpx2byteM1(3, 3, 3, 3)	' Set the first byte in page to all pixels with colour 3 (red by default ).

   call cpctPageMemory(RAM.CFG6 or RAM.BANK0)				' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   ' RAM.CFG6: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_6, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
   ' firstByteInPage point to address &4000. With this memory 
   ' configuration, &4000 is the first byte in RAM.BANK0, RAM_6, 
   ' which is physical address &18000. 
   poke firstByteInPage, cpctpx2byteM1(1, 1, 2, 2)	' Set the first byte in page to all pixels with colours 1, 2 (yellow, cyan by default ).

   call cpctPageMemory(RAM.CFG7 or RAM.BANK0)				' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   ' RAM.CFG7: 0000-3FFF -> RAM_0, 4000-7FFF -> RAM_7, 8000-BFFF -> RAM_2, C000-FFFF -> RAM_3
   ' firstByteInPage point to address &4000. With this memory 
   ' configuration, &4000 is the first byte in RAM.BANK0, RAM_7, 
   ' which is physical address &1C000. 
   poke firstByteInPage, cpctpx2byteM1(1, 1, 3, 3)	' Set the first byte in page to all pixels with colours 1, 3 (yellow, cyan by default ).

   call cpctPageMemory(RAM.CFG0 or RAM.BANK0) 				' Set the memory again to default state

   ' Clear Screen
   call cpctMemset(CPCT.VMEMSTART, 0, CPCT.VMEMSIZE)

   ' Let's make visible the values we stored.
   call cpctPageMemory(RAM.CFG0 or RAM.BANK0) ' Not needed, sets the memory with the first 64kb accesible, in consecutive banks.
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 0)
   call cpctDrawSolidBox(pvmem, firstByteInPage, 2, 8)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 0)
   call cpctSetDrawCharM1(1, 0)
   call cpctDrawStringM1("RAM.CFG0", pvmem)

   call cpctPageMemory(RAM.CFG4 or RAM.BANK0) ' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 16)
   call cpctDrawSolidBox(pvmem, firstByteInPage, 2, 8)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 16)
   call cpctDrawStringM1("RAM.CFG4", pvmem)

   call cpctPageMemory(RAM.CFG5 or RAM.BANK0) ' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 32)
   call cpctDrawSolidBox(pvmem, firstByteInPage, 2, 8)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 32)
   call cpctDrawStringM1("RAM.CFG5", pvmem)

   call cpctPageMemory(RAM.CFG6 or RAM.BANK0) ' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 48)
   call cpctDrawSolidBox(pvmem, firstByteInPage, 2, 8)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 48)
   call cpctDrawStringM1("RAM.CFG6", pvmem)

   call cpctPageMemory(RAM.CFG7 or RAM.BANK0) ' Set the 4th page (64kb to 80kb) in &4000-&7FFF
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, 64)
   call cpctDrawSolidBox(pvmem, firstByteInPage, 2, 8)
   pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 4, 64)
   call cpctDrawStringM1("RAM.CFG7", pvmem)

   call cpctPageMemory(RAM.DEFAULTCFG) ' Equivalent to RAM.CFG0 or RAM.BANK0 

end   ' Loop forever
