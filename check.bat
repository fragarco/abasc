@echo off
cd src
mypy . --explicit-package-bases
python3 -m unittest
cd ..
@echo on
