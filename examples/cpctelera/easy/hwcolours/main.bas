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
'  but WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------
' Code adapted to ABASC by Javier "Dwayne Hicks" Garcia

CHAIN MERGE "cpctelera/cpctelera.bas"

' MAIN PROGRAM:
'   Do not disable firmware in this example, as we will use PRINT basic command
'
LABEL MAIN
   call cpctClearScreen(0)

   ' Print out a table with the firmware colours and their equivalent
   ' Hardware colour values using cpct_getHWColour

   ' We use Firmware Screen Character Commands to change colour on screen.
   ' Character 15 (&0F in hexadecimal) does the PEN command, and uses immediate next
   ' character as the parameter for PEN. Then, &0F+&03 is equivalent to PEN 3.
   '
   PRINT CHR$(&0F)+CHR$(&03)+"        Hardware Colour values"
   PRINT CHR$(&0F)+CHR$(&02)+"This example shows the equivalence between";
   PRINT " firmware colour values and harwdware colour values. ";
   PRINT CHR$(&0F)+CHR$(&03)+"CPCtelera"+CHR$(&0F)+CHR$(&02)+"'s ";
   PRINT "functions that change colours use hardware ones.": PRINT
   PRINT CHR$(&0F)+CHR$(&03)+"   =================================="
   PRINT "   || ";
   PRINT CHR$(&0F)+CHR$(&02)+"FIRM -- HARD "+CHR$(&0F)+CHR$(&03)+"|| ";
   PRINT CHR$(&0F)+CHR$(&02)+"FIRM -- HARD "+CHR$(&0F)+CHR$(&03)+"||"
   PRINT "   =================================="
   FOR i=0 TO 12
      hwcol = cpctGetHWColour(i)
      PRINT CHR$(&0F)+CHR$(&03)+"   || &"+CHR$(&0F)+CHR$(&01);HEX$(i,2);
      PRINT CHR$(&0F)+CHR$(&03) + "  --  &"+CHR$(&0F)+CHR$(&01);HEX$(hwcol,2);" ";
      PRINT CHR$(&0F)+CHR$(&03)+"|| &"+CHR$(&0F)+CHR$(&01);HEX$(i+13,2);
      hwcol = hwcol + 13
      PRINT CHR$(&0F)+CHR$(&03)+"  --  &"+CHR$(&0F)+CHR$(&01);HEX$(hwcol,2);
      PRINT CHR$(&0F)+CHR$(&03)+" ||"
   NEXT
   PRINT "   =================================="

END