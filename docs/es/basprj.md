BASPRJ: MANUAL DEL USUARIO
=========================

## Descripción

`basprj.py` es una herramienta escrita en Python 3.X para crear una estructura básica de proyecto para su uso con `ABASC`. Genera un fichero *make* con las llamadas oportunas a **ABASC** y **DSK**, además de generar un fichero inicial `main.bas` con algo de código inicial con el que probar que la configuración del proyecto es correcta.

---

## Construir los ejecutables

ABASC y sus herramientas asociadas están pensadas para utilizarse junto con el intérprete de Python, ya que así su ejecución es más rápida. No obstante, también se distribuyen ejecutables de ABASC y de sus herramientas para los principales sistemas operativos. Además, es posible generar los ejecutables por cuenta propia. Para ello, primero hay que instalar el paquete PyInstaller de Python mediante el siguiente comando:

```bash
pip install pyinstaller
```

A continuación, basta con acceder al directorio `src/build` y ejecutar `build.bat` en Windows o `build.sh` en macOS o Linux. Los binarios resultantes se guardarán en la carpeta `bin`, al lado de la carpeta `src`.

## Uso básico

Todos los ejemplos de uso asumen que se está usando `basprj.py` junto al intérprete de Python. Si se está utilizando el ejecutable, basta con obviar la llamada a `python` o `python3` y remplazar `python basmprj.py` por la llamada directa al ejecutable.

Creación de un nuevo proyecto:

```
python3 basprj.py --new <directorio>
```

Actualización de un proyecto existente si la ruta del proyecto o de las herramientas ha cambiado:

```
python3 basprj.py --update <directorio>
```

También puede utilizarse `.` para indicar el directorio actual.

---

## Opciones disponibles

- `--new <directorio>`  
  Crea un nuevo proyecto en el directorio indicado.  
  Si el directorio no existe, se crea automáticamente.  
  Si se usa `.` se asume el directorio actual.

- `--update <directorio>`  
  Actualiza un proyecto existente.  
  Recalcula y actualiza las rutas de las variables `BASC` y `DSK` en el fichero `make.bat` o `make.sh`.

- `--help`  
  Muestra un texto de ayuda con información sobre el uso de la herramienta y finaliza la ejecución.

- `--version`
  Muestra la versión actual de `BASPRJ`.

---

## Archivos generados

Al crear un proyecto nuevo, `basprj.py` genera los siguientes archivos:

- `make.bat` (en Windows) o `make.sh` (en Linux/macOS)  
  Script de construcción del proyecto.

- `main.bas`  
  Archivo fuente inicial en Locomotive BASIC 2 con un ejemplo funcional que imprime el texto *Hello world!* en bucle.

El nombre del directorio del proyecto se utiliza como valor para generar el DSK y nombre del fichero .bin resultado de la compilación.

---

## Ejemplos de uso

Crear un proyecto nuevo llamado `hello`:

```
python3 basprj.py --new hello
```

Crear el proyecto en el directorio actual:

```
python3 basprj.py --new .
```

Actualizar un proyecto después de moverlo o renombrarlo:

```
python3 basprj.py --update hello
```

Actualizar el proyecto del directorio actual:

```
python3 basprj.py --update .
```

---

## Requisitos

- Python 3.6 o superior
- Las herramientas `abasc.py` y `utils/dsk.py` deben encontrarse en el mismo directorio que `basprj`

---

## Notas

- La herramienta no sobrescribe `main.bas` si ya existe.
- El modo `--update` solo modifica las variables necesarias, preservando el resto del contenido del fichero *make*.

## License

`basprj.py` is free software; you can redistribute it and/or modify it under the terms of the **GNU General Public License v3**, as published by the **Free Software Foundation**.

`basprj.py` is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the **GNU General Public License** for more details.
