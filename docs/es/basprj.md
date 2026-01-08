BASPRJ: MANUAL DEL USUARIO
=========================

## Descripción

`basprj.py` es una herramienta escrita en Python 3.X para crear una estructura básica de proyecto para su uso con `ABASC`. Genera un fichero *make* con las llamadas oportunas a **ABASC** y **DSK**, además de generar un fichero inicial `main.bas` con algo de código inicial con el que probar que la configuración del proyecto es correcta.

---

## Uso básico

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
