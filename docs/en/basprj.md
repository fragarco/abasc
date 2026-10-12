BASPRJ: USER MANUAL
====================

## Description

`basprj.py` is a tool written in Python 3.X to create a basic project structure for use with `ABASC`. It generates a *make* file with the necessary calls to **ABASC** and **DSK**, and also creates an initial `main.bas` file with starter code to verify that the project configuration is correct.

---

## Building the Executables

ABASC and all its related tools are designed to be used alongside the Python interpreter, as this allows them to run faster. However, prebuilt executables are also distributed for the main operating systems since release 1.5.0. In addition, it is possible to build the executables yourself. To do so, you first need to install the PyInstaller Python package using the following command:

```bash
pip install pyinstaller
```

Next, navigate to the `src/build` directory and run `build.bat` on Windows or `build.sh` on macOS or Linux. The resulting binaries will be saved in the `bin` directory, sibling to the `src` directory.

## Using the Compiler

All the examples assume that you will be using `abasc.py` directly from Python. If you are using the executable, just drop the use of `python` or `python3` and just remplace `python abasc.py` by the direct call to the binary.

Create a new project:

```
python3 basprj.py --new <directory>
```

Update an existing project if the project path or the tool paths have changed:

```
python3 basprj.py --update <directory>
```

You can also use `.` to indicate the current directory.

---

## Available options

- `--new <directory>`  
  Creates a new project in the specified directory.  
  If the directory does not exist, it will be created automatically.  
  If `.` is used, the current directory is assumed.

- `--update <directory>`  
  Updates an existing project.  
  Recalculates and updates the paths of the `BASC` and `DSK` variables in `make.bat` or `make.sh`.

- `--help`  
  Displays a help message with usage information and exits.

- `--version`  
  Displays the current version of `BASPRJ`.

---

## Generated files

When creating a new project, `basprj.py` generates the following files:

- `make.bat` (on Windows) or `make.sh` (on Linux/macOS)  
  Project build script.

- `main.bas`  
  Initial Locomotive BASIC 2 source file with a working example that prints *Hello world!* in loop.

The project directory name is used as the value to generate the DSK and the resulting .bin file from the compilation process.

---

## Usage examples

Create a new project called `hello`:

```
python3 basprj.py --new hello
```

Create the project in the current directory:

```
python3 basprj.py --new .
```

Update a project after moving or renaming it:

```
python3 basprj.py --update hello
```

Update the project in the current directory:

```
python3 basprj.py --update .
```

---

## Requirements

- Python 3.6 or higher
- The tools `abasc.py` and `utils/dsk.py` must be located in the same directory as `basprj.py`

---

## Notes

- The tool does not overwrite `main.bas` if it already exists.
- The `--update` mode only modifies the necessary variables, preserving the rest of the *make* file content.

## License

`basprj.py` is free software; you can redistribute it and/or modify it under the terms of the **GNU General Public License v3**, as published by the **Free Software Foundation**.

`basprj.py` is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the **GNU General Public License** for more details.