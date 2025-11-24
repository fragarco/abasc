# An Amstrad Locomotive BASIC cross compiler (ABASC)

## Español:

**ABASC (Amstrad BASic cross Compiler)** es un compilador cruzado escrito íntegramente en Python y sin dependencias externas, lo que favorece su portabilidad a cualquier sistema que disponga de una instalación estándar de **Python 3**.

Está diseñado para soportar el dialecto de BASIC creado por **Locomotive Software** para los microordenadores Amstrad CPC, de modo que toda la documentación existente sobre este lenguaje siga siendo plenamente relevante y útil.

Además, al tratarse de un compilador cruzado que se ejecuta en sistemas modernos, ABASC incorpora diversas carácterísticas de **Locomotive BASIC 2 Plus**, lo que permite una experiencia de desarrollo más cercana a los lenguajes actuales sin renunciar al estilo clásico del BASIC original.

Por último, además del compilador propiamente dicho, se incluyen otras utilidades como un ensamblador o empaquetadores para crear archivos DSK o CDT. La documentación completa de cada herramienta se puede consultar en la carpeta `DOCS`, disponible tanto en inglés como en español.

 * [Manual del compilador ABASC](docs/es/abasc.md)
 * [Manual del ensamblador ABASM](docs/es/abasm.md)
 * [Manual de la utilidad DSK](docs/es/dsk.md)
 * [Manual de la utilidad CDT](docs/es/cdt.md)
 * [Manual del conversor de imágenes](docs/es/img.md)

El conjunto de utilidades ABASC, ABASM, IMG, DSK y CDT son software libre; puedes redistribuirlo y/o modificarlo bajo los términos de la General Public License de GNU en su versión 3, tal como fue publicada por la Free Software Foundation.

Este paquete se distribuye con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA; ni siquiera la garantía implícita de COMERCIABILIDAD o IDONEIDAD PARA UN PROPÓSITO PARTICULAR. Consulta la General Public License de GNU para más detalles (en el archivo LICENSE).

## English:

**ABASC (Amstrad BASic cross Compiler)** is a cross-compiler written entirely in Python, with no external dependencies. This makes it highly portable and easy to run on any system that has a standard **Python 3** installation.

It is designed to support the dialect of BASIC created by **Locomotive Software** for the Amstrad CPC series of microcomputers, ensuring that all existing documentation for this language remains fully relevant and useful.

Because ABASC is a cross-compiler that runs on modern systems, it also incorporates several features from **Locomotive BASIC 2 Plus**, offering a development experience closer to that of contemporary programming languages while preserving the classic style of the original BASIC.

In addition to the compiler itself, the ABASC package includes several auxiliary tools, such as an assembler and disk/tape image packers for generating DSK and CDT files. Full documentation for each tool is available in the `DOCS` directory, provided in both English and Spanish.

* [ABASC Compiler Manual](docs/en/abasc.md)
* [ABASM Assembler Manual](docs/en/abasm.md)
* [DSK Utility Manual](docs/en/dsk.md)
* [CDT Utility Manual](docs/en/cdt.md)
* [Image Converter Manual](docs/en/img.md)

The ABASC, ABASM, IMG, DSK, and CDT tools are free software; you may redistribute and/or modify them under the terms of the GNU General Public License version 3, as published by the Free Software Foundation.

This package is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License (included in the LICENSE file) for more details.
