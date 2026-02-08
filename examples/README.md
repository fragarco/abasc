EXAMPLES
====================

## Versión en Español (English Version at the end)

El directorio de `examples` continene varios ejemplos que pueden usarse para probar el compilador. Cada directorio contiene un fichero `make.bat` (y `make.sh`) que permite generar el binario o, incluso, un fichero DSK listo para su uso con emuladores. En la ráiz del directorio de ejemplos, también hay `make` que permite generar todos los ejemplos a la vez.

El script de `make` soporta los siguientes párametros:

* make (sin parámetros) - genera el fichero BIN.
* make clear - limpia todos los ficheros intermedios.
* make dsk - Genera el fichero BIN, crea un DSK y añade el BIN.

## English Version

This directory contains several examples that can be used to test the compiler. Each directory contains a `make.bat` (and `make.sh`) file that allows you to generate the binary or, even, a DSK file ready to be used in emulators. In the root of the examples directory, there is an extra `make` file that generates all the examples at once.

Each `make` script file supports the following parameters:

* `make` (no parameters) - generates the BIN file.
* `make clear` - clears all intermediate files.
* `make dsk` - generates the BIN file, creates a DSK file, and appends the BIN file.

