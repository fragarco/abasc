CPCTELERA EXAMPLES
====================

## Versión en Español (English Version at the end)

Este directorio contiene varios ejemplos de la distribución de `cpctelera` convertidos a la sintaxis de ABASC. Cada ejemplo contiene un fichero `make.bat` (y `make.sh`) que permite generar el binario o, incluso, un fichero DSK listo para usar en emuladores.

El script make `make` soporta los siguientes párametros:

* make (sin parámetros) - genera el fichero BIN.
* make clear - limpia todos los ficheros intermedios.
* make dsk - Genera el fichero BIN, crea un DSK y añade el BIN.

Todos los ejemplos incluyen también un fichero DSK cuyo nombre termina en `_test`. Estos DSK son originales de la distribución de `cpctelera` y pueden usarse para comprobar el resultado con `ABASC` y el resultado original con `SDCC`.

## English Version

This directory contains several examples included in the `cpctelera` distribution which have been converted to `ABASC`syntax. Each example contains a `make.bat` (and `make.sh`) file that allows you to generate the binary or even a DSK file.

The `make` script supports the following parameters:

* `make` (no parameters) - generates the BIN file.
* `make clear` - clears all intermediate files.
* `make dsk` - generates the BIN file, creates a DSK file, and appends the BIN file.

All examples include a DSK file which name ends in `_test`. These DSK were generated using the original C code included in the `cpctelera` distribution. They can be used to test the `ABASC` output against the results produced by the `SDCC` compiler.