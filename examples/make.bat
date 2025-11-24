@echo off

REM *
REM * This file is just an example of how ABASC and DSK/CDT utilities can be called to compile programs
REM * and generate files that can be used directly in Amstrad CPC emulators like WinAPE or RetroVirtualMachine
REM *
REM * USAGE: make [clear][dsk]

@setlocal
for /d %%i in (".\*") do (
    echo ----------------------------------------
    echo Calling %%i\make.bat
    cd %%i
    call make.bat %*
    @echo off
    cd ..
)
@endlocal
@echo on
