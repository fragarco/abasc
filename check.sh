#!/bin/bash

cd src
if [ "$1" = "--notest" ]; then
    mypy . --explicit-package-bases
else
    mypy . --explicit-package-bases
    python3 -m unittest -b
fi
cd ..

