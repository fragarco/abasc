@echo off
cd src
call mypy . --explicit-package-bases
call python3 -m unittest
cd ..
@echo on
