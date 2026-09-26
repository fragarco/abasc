@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used directly in Amstrad CPC emulators like WinAPE or RetroVirtualMachine
REM *
REM * USAGE: make [clear][dsk]

@setlocal

set SOURCE=main
set TARGET=mchase

set COMPILE=python3 ../../src/abasc.py
set DSK=python3 ../../src/utils/dsk.py
set DATAADDR=0x8000

IF "%1"=="clear" (
    IF EXIST "*.bpp" del "*.bpp"
    IF EXIST "*.lex" del "*.lex"
    IF EXIST "*.ast" del "*.ast"
    IF EXIST "*.sym" del "*.sym"
    IF EXIST "*.asm" del "*.asm"
    IF EXIST "*.asm" del "*.s"
    IF EXIST "*.lst" del "*.lst"
    IF EXIST "*.map" del "*.map"
    IF EXIST "*.bin" del "*.bin"
    IF EXIST "*.dsk" del "*.dsk"
    IF EXIST "*.cdt" del "*.cdt"
) ELSE IF "%1"=="dsk" (
    call %DSK% %TARGET%.dsk -n --put-raw assets/TITLE.SCR
    call %DSK% %TARGET%.dsk --put-raw assets/INSTR.SCR
    call %DSK% %TARGET%.dsk --put-raw assets/MUSIC.BIN
    call %DSK% %TARGET%.dsk --put-raw assets/PLAYER.BIN
    call %COMPILE% %SOURCE%.bas --data=%DATAADDR% %2 %3 && call %DSK% %TARGET%.dsk --put-bin %SOURCE%.bin --load-addr=0x0040 --start-addr=0x0040
) ELSE (
    call %COMPILE% %SOURCE%.bas --data=%DATAADDR% %*
)

@endlocal
@echo on
