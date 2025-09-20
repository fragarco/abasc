@echo off
cd src

IF "%1"=="--notest" (
    call mypy . --explicit-package-bases
) ELSE (
    call mypy . --explicit-package-bases
    call python3 -m unittest
)

cd ..
@echo on
