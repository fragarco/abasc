@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used in emulators or real hardware for the Amstrad CPC
REM *
REM * USAGE: make [clear | dsk]

@setlocal

set BASC=python3 "..\..\..\..\src\abasc.py"
set DSK=python3 "..\..\..\..\src\utils\dsk.py"

set SOURCE=main
set TARGET=maskedsp

set LOADADDR=0x0040

set RUNBAS=%BASC% %SOURCE%.bas
set RUNDSK=%DSK% %TARGET%.dsk --new --put-bin %SOURCE%.bin --load-addr %LOADADDR% --start-addr %LOADADDR%

IF "%1"=="clear" (
    IF EXIST "%SOURCE%.bpp" del "%SOURCE%.bpp"
    IF EXIST "%SOURCE%.lex" del "%SOURCE%.lex"
    IF EXIST "%SOURCE%.ast" del "%SOURCE%.ast"
    IF EXIST "%SOURCE%.sym" del "%SOURCE%.sym"
    IF EXIST "%SOURCE%.asm" del "%SOURCE%.asm"
    IF EXIST "%SOURCE%.s"   del "%SOURCE%.s"
    IF EXIST "%SOURCE%.lst" del "%SOURCE%.lst"
    IF EXIST "%SOURCE%.map" del "%SOURCE%.map"
    IF EXIST "%SOURCE%.bin" del "%SOURCE%.bin"
    IF EXIST "%TARGET%.dsk" del "%TARGET%.dsk"
    IF EXIST "%TARGET%.cdt" del "%TARGET%.cdt"
) ELSE IF "%1"=="dsk" (
    call %RUNBAS% %2 %3 && call %RUNDSK% 
) ELSE (
    call %RUNBAS% %*
)

@endlocal
@echo on
