EXAMPLES
====================

## Versión en Español (English Version at the end)

El directorio de `examples` continene varios ejemplos que pueden usarse para probar el compilador. Cada directorio contiene un fichero `make.bat` que permite, en Windows, generar el binario e incluso generar el fichero DSk. En otros sistemas operativos, este fichero `make.bat` aún puede ser de utilidad pues muestra como se invoca el compilador y las utilidades para empaquetar los resultados. Por último, en la ráiz del directorio de ejemplos, hay otro `make.bat` que permite generar todos los ejemplos de una sola pasada.

Cada `make.bat` soporta los siguientes párametros:

* make (sin parámetros) - genera el fichero BIN.
* make clear - limpia todos los ficheros intermedios.
* make dsk - Genera el fichero BIN, crea un DSK y añade el BIN.

## English Version

This directory contains several examples that can be used to test the compiler. Each directory contains a `make.bat` file that, on Windows, allows you to generate the binary and even the DSK file. On other operating systems, this `make.bat` file can still be useful as it shows how to invoke the compiler and the utilities for packaging the results. Finally, in the root of the examples directory, there is another `make.bat` file that generate all the examples at once.

Each `make.bat` file supports the following parameters:

* `make` (no parameters) - generates the BIN file.
* `make clear` - clears all intermediate files.
* `make dsk` - generates the BIN file, creates a DSK file, and appends the BIN file.