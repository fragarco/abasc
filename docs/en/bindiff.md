BINDIFF: USER MANUAL  
=========================

## Description

`bindiff.py` is a simple tool written in Python 3.X to compare two binary files and display their differences. The differences are printed to standard output, so if you want to save the result, you need to redirect the output to a file.

## Building the Executables

ABASM and all its related tools are designed to be used alongside the Python interpreter, as this allows them to run faster. However, prebuilt executables are also distributed for the main operating systems since release 1.5.0. In addition, it is possible to build the executables yourself. To do so, you first need to install the PyInstaller Python package using the following command:

```bash
pip install pyinstaller
```

Next, navigate to the `src/build` directory and run `build.bat` on Windows or `build.sh` on macOS or Linux. The resulting binaries will be saved in the `bin` directory, sibling to the `src` directory.

## Basic usage

All the examples assume that you will be using `bindiff.py` directly from Python. If you are using the executable, just drop the use of `python` or `python3` and just remplace `python bindiff.py` by the direct call to the binary.

```
python3 bindiff.py <file1> <file2>
```

## Available Options

- `--version`: Displays the current version of the tool and exits.  
- `--help`: Shows a help message with usage information and exits.

## Example

Compare two binary files and save the result to a text file:

```
python3 bindiff.py file1.bin file2.bin > differences.txt
```

## License

`bindiff.py` is free software; you can redistribute it and/or modify it under the terms of the **GNU General Public License v3**, as published by the **Free Software Foundation**.

`bindiff.py` is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the **GNU General Public License** for more details.