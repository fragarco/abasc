@echo off
cd src

call mypy . --explicit-package-bases
IF [%~1]==[] call python3 -m unittest

cd ..
@echo on
