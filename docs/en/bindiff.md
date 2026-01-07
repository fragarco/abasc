BINDIFF: USER MANUAL  
=========================

## Description

`bindiff.py` is a simple tool written in Python 3.X to compare two binary files and display their differences. The differences are printed to standard output, so if you want to save the result, you need to redirect the output to a file.

## Basic Usage

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
