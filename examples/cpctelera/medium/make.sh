#!/bin/bash

# *
# * This file is just an example of how ABASC and DSK/CDT utilities can be called
# * to compile programs and generate files that can be used directly in
# * Amstrad CPC emulators like WinAPE or RetroVirtualMachine
# *
# * USAGE: ./make.sh [clear] [dsk]

for dir in */ ; do
    if [ -d "$dir" ]; then
        echo "----------------------------------------"
        echo "Calling ${dir}make.sh"
        (
            cd "$dir" || exit
            ./make.sh "$@"
        )
    fi
done
