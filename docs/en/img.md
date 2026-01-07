IMG: USER MANUAL
================

# Description

`img.py` is a tool written in Python 3 that converts images in common formats such as **PNG** or **JPEG** into formats usable in programming projects for the **Amstrad CPC**. The output formats include:

- Pure binary files (`bin`)
- Source files in **C/C++** (`c`)
- Assembly code for **Abasm** (compatible with **WinAPE/MAXAM**) (`asm`)
- **SCN** files for loading screens (`scn`)
- Source files in **Basic** (`bas`)

The output file will have the same name as the input image but with the appropriate extension for the chosen output format. It generates, as well, a second file with `info` extension that will contain information about the size and palette for the converted image. 

The tool adjusts the image based on the output format and the Amstrad CPC video mode. In the case of **SCN** files, the image is automatically scaled to the correct resolution.

In all cases, if the user doesn't provide a palette definition file, `IMG` will generate a color palette calculated by selecting the most dominant colors in the image and approximating them to the nearest colors available in the Amstrad CPC palette.

## Amstrad CPC Video Modes:

- **Mode 0**: 160x200 pixels, 16 colors
- **Mode 1**: 320x200 pixels, 4 colors
- **Mode 2**: 640x200 pixels, 2 colors

# Installation

To use this tool, you need to have **Python 3.x** installed on your system. Additionally, `img.py` uses the **Pillow** image library (Python's standard image processing library), which can be easily installed using `pip`, the Python package manager, with the following command:

```bash
pip3 install pillow
```

# Basic Usage

The tool runs from the command line, taking an image file (PNG, JPEG, etc.) as input and converting it to the specified format.

```bash
python3 img.py <inimg> [--name NAME] [--format FORMAT] [--mode MODE] [--palette FILE]
```

## Available Options

- **`<inimg>`**: (Required) The input image file. This can be a PNG, JPEG, or other supported format.
- **`--name`**: (Optional) The reference name for the converted image. If not specified, the input file name will be used. This name is used to generate the labels or variables that reference the image in the generated code (C/C++ and ASM options).
- **`--format`**: (Optional) The output format. Valid values are `bin`, `c`, `asm`, `scn`. The default value is `bin`.
- **`--mode`**: (Optional) The Amstrad CPC graphic mode. Possible values are `0`, `1`, `2`. The default value is `0`.
- **`--palette`**: (Optional) A file containing a description of the color palette to be used in the conversion. If it is not provided, the program will compute a palette based on the most prevalent colors in the input image.

## Usage Examples

1. **Convert a PNG image to a binary file without AMSDOS header (default format):**

```bash
python3 img.py imagen.png
```

This command converts `imagen.png` into a binary file (`imagen.bin`) without AMSDOS header, using graphic mode 0 with 16 colors.

2. **Convert a JPEG image to assembly compatible with WinAPE/MAXAM:**

```bash
python3 img.py imagen.jpg --format asm --mode 1
```

This command converts `imagen.jpg` into an assembly file (`imagen.asm`) ready for use in graphic mode 1 of the Amstrad CPC.

3. **Convert a PNG image to a C source file for SDCC:**

```bash
python3 img.py imagen.png --format c --name mi_sprite
```

This command converts `imagen.png` into C source files (`mi_sprite.h` and `mi_sprite.c`) that can be used with the SDCC compiler. The name `mi_sprite` will be used for the variables in the generated code.

4. **Convert an image to an SCN file for loading screens:**

```bash
python3 img.py portada.png --format scn
```

This command converts `portada.png` into an SCN file (`portada.scn`) for use as a loading screen. The image will be scaled to a resolution of 160x200 (graphic mode 0) with a maximum of 16 colors.

# Palettes

If the `--palette` parameter is not used, `IMG` computes a color palette based on the desired graphics mode and the most representative colors of the input image. However, it is very common to work with a single palette shared by several images, especially when converting sprites. `IMG` always generates an additional file with various information for each conversion, using the `.info` extension. From this file, the values of the palette used in the conversion can be extracted, or we can create our own palette file from scratch.

The contents of a palette specification file must be as follows:

```python
{
    'type': 'HW' or 'FW',
    'pal': [list of hardware or firmware values depending on the specified type]
}
```

For example, we can create a file called `paleta.pal` with the following contents:

```python
{
    'type': 'HW',
    'pal': [
        0x0B, 0x00, 0x14, 0x1F,
        0x07, 0x19, 0x06, 0x15,
        0x12, 0x0C, 0x1C, 0x04,
        0x16, 0x1E, 0x1A, 0x18
    ]
}
```

And use it to convert an image as follows:

```bash
python3 img.py imagen.png --format scn --palette paleta.pal
```

# License

`img.py` is free software; you can redistribute it and/or modify it under the terms of the **GNU General Public License v3**, as published by the **Free Software Foundation**.

`img.py` is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the **GNU General Public License** for more details.
