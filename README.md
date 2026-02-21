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
  
### Una prueba rápida

1. Descarga el ZIP con la *release* de `BASC`.
2. Si no tienes Python, obten el instalador de https://www.python.org/
3. Una vez instalado Python, descomprime `ABASC`donde cosideres oportuno.
4. Crear una carpeta *projects* junto a la carpeta *examples*
5. Desde una consola del sistema navega hasta el interior del directorio *projects*
6. Ejecuta el comando: `python ../../src/basprj.py -n test`
7. Entra dentro de la carpeta *test* y ejecuta `make dsk` (Windows) o `./make.sh dsk` (Linux/MacOS)
8. `ABASC` compilará el programa de ejemplo `main.bas` y generará un fichero `dsk` listo para probar en emuladores.

### Licencia 

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

### QuickStart

1.  Download the ZIP with the `BASC` release.
2.  If you don't have Python, get the installer from https://www.python.org/.
3.  Once Python is installed, unzip `ABASC` to an appropriate location.
4.  Create a *projects* folder next to the *examples* folder.
5.  From a system console, navigate into the *projects* directory.
6.  Run the command: `python ../../src/basprj.py -n test`
7.  Go into the *test* folder and run `make dsk` (Windows) or `./make.sh dsk` (Linux/MacOS).
8.  `ABASC` will compile the example program `main.bas` and generate a `dsk` file ready to be tested in emulators.

### License

The ABASC, ABASM, IMG, DSK, and CDT tools are free software; you may redistribute and/or modify them under the terms of the GNU General Public License version 3, as published by the Free Software Foundation.

This package is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License (included in the LICENSE file) for more details.
