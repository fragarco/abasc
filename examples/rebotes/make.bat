@echo off

IF "%1"=="clear" (
    del *.PP
    del *.LEX
    del *.AST
    del *.SYM
    del *.ASM
    del *.lst
    del *.map
    del *.bin
) ELSE (
    call python3 ..\..\src\basc.py main.bas --verbose
    call python3 ..\..\src\abasm.py MAIN.ASM
)
@echo on