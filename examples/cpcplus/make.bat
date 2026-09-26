@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used directly in Amstrad CPC emulators like WinAPE or RetroVirtualMachine
REM *
REM * USAGE: make [clear][dsk]

@setlocal

set SOURCE=GAME
set TARGET=GAME

set COMPILE=python3 ../../src/abasc.py
set DSK=python3 ../../src/utils/dsk.py

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
    call %COMPILE% MAIN.BAS --data=0x8000 %2 %3
    IF errorlevel 1 EXIT /b %errorlevel%
    call %DSK% MCHASE.DSK -n --put-bin MAIN.BIN --load-addr=0x0040 --start-addr=0x0040
    call %DSK% MCHASE.DSK --put-raw assets/TITLE.SCR
    call %DSK% MCHASE.DSK --put-bin assets/MUSIC.BIN
    call %DSK% MCHASE.DSK --put-raw assets/INSTR.SCR
    call %DSK% MCHASE.DSK --put-bin assets/PLAYER.BIN
) ELSE (
    call %COMPILE% MAIN.BAS --data=0x8000 %*
)

@endlocal
@echo on
