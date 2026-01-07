ASMPRJ: USER MANUAL
====================

## Description

`asmprj.py` is a tool written in Python 3.X to create a basic project structure for use with `ABASM`. It generates a *make* file with the necessary calls to **ABASM** and **DSK**, and also creates an initial `main.asm` file with starter code to verify that the project configuration is correct.

---

## Basic usage

Create a new project:

```
python3 asmprj.py --new <directory>
```

Update an existing project if the project path or the tool paths have changed:

```
python3 asmprj.py --update <directory>
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
  Recalculates and updates the paths of the `ASM` and `DSK` variables in `make.bat` or `make.sh`.

- `--help`  
  Displays a help message with usage information and exits.

- `--version`  
  Displays the current version of `ASMPRJ`.

---

## Generated files

When creating a new project, `asmprj.py` generates the following files:

- `make.bat` (on Windows) or `make.sh` (on Linux/macOS)  
  Project build script.

- `main.asm`  
  Initial Z80 assembly source file with a working example that prints *Hello world!* using Amstrad CPC firmware routines.

The project directory name is used as the value to generate the DSK and the resulting .bin file from the assembly.

---

## Usage examples

Create a new project called `hello`:

```
python3 asmprj.py --new hello
```

Create the project in the current directory:

```
python3 asmprj.py --new .
```

Update a project after moving or renaming it:

```
python3 asmprj.py --update hello
```

Update the project in the current directory:

```
python3 asmprj.py --update .
```

---

## Requirements

- Python 3.6 or higher
- The tools `abasm.py` and `dsk.py` must be located in the same directory as `asmprj.py`

---

## Notes

- The tool does not overwrite `main.asm` if it already exists.
- The `--update` mode only modifies the necessary variables, preserving the rest of the *make* file content.
