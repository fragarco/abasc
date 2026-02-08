@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used in emulators or real hardware for the Amstrad CPC
REM *
REM * USAGE: make [clear | dsk]

@setlocal

set BASC=python3 "C:\Users\javi\workspace\github\abasc\src\abasc.py"
set DSK=python3 "C:\Users\javi\workspace\github\abasc\src\utils\dsk.py"
set CDT=python3 "C:\Users\javi\workspace\github\abasc\src\utils\cdt.py"
set IMG=python3 "C:\Users\javi\workspace\github\abasc\src\utils\img.py"
set ASM=python3 "C:\Users\javi\workspace\github\abasc\src\utils\abasm.py"

set SOURCE=main
set TARGET=retropoli

set LOADADDR=0x0040

set RUNBAS=%BASC% %SOURCE%.bas
set RUNDSK=%DSK% %TARGET%.dsk --new --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR%
set RUNCDT=%CDT% %TARGET%.cdt -n --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR% --name %TARGET%
set RUNIMG=%IMG% --format scn --mode 0 img/*.jpg 
set ADDIMG=%DSK% %TARGET%.dsk --put-bin

IF "%1"=="clear" (
    IF EXIST "%SOURCE%.bpp" del "%SOURCE%.bpp"
    IF EXIST "%SOURCE%.lex" del "%SOURCE%.lex"
    IF EXIST "%SOURCE%.ast" del "%SOURCE%.ast"
    IF EXIST "%SOURCE%.sym" del "%SOURCE%.sym"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.asm"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.s"
    IF EXIST "%SOURCE%.lst" del "%SOURCE%.lst"
    IF EXIST "%SOURCE%.map" del "%SOURCE%.map"
    IF EXIST "%SOURCE%.bin" del "%SOURCE%.bin"
    IF EXIST "%TARGET%.dsk" del "%TARGET%.dsk"
    IF EXIST "%TARGET%.cdt" del "%TARGET%.cdt"
    IF EXIST "img\*.scn"    del "img\*.scn"
    IF EXIST "img\*.info"   del "img\*.info"
) ELSE IF "%1"=="dsk" (
    call %RUNIMG% && %RUNBAS% %2 %3 && call %RUNDSK%
    call %ADDIMG% img/poli1.scn && call %ADDIMG% img/poli2.scn 
) ELSE (
    call %RUNBAS% %*
)

@endlocal
@echo on
