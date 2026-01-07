ASMPRJ: MANUAL DEL USUARIO
=========================

## Descripción

`asmprj.py` es una herramienta escrita en Python 3.X para crear una estructura básica de proyecto para su uso con `ABASM`. Genera un fichero *make* con las llamadas oportunas a **ABASM** y **DSK**, además de generar un fichero inicial `main.asm` con algo de código inicial con el que probar que la configuración del proyecto es correcta.

---

## Uso básico

Creación de un nuevo proyecto:

```
python3 asmprj.py --new <directorio>
```

Actualización de un proyecto existente si la ruta del proyecto o de las herramientas ha cambiado:

```
python3 asmprj.py --update <directorio>
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
  Recalcula y actualiza las rutas de las variables `ASM` y `DSK` en el fichero `make.bat` o `make.sh`.

- `--help`  
  Muestra un texto de ayuda con información sobre el uso de la herramienta y finaliza la ejecución.

- `--version`
  Muestra la versión actual de `ASMPRJ`.

---

## Archivos generados

Al crear un proyecto nuevo, `asmprj.py` genera los siguientes archivos:

- `make.bat` (en Windows) o `make.sh` (en Linux/macOS)  
  Script de construcción del proyecto.

- `main.asm`  
  Archivo fuente inicial en ensamblador Z80 con un ejemplo funcional que imprime el texto *Hello world!* usando rutinas del firmware del Amstrad CPC.

El nombre del directorio del proyecto se utiliza como valor para generar el DSK y nombre del fichero .bin resultado del ensamblado.

---

## Ejemplos de uso

Crear un proyecto nuevo llamado `hello`:

```
python3 asmprj.py --new hello
```

Crear el proyecto en el directorio actual:

```
python3 asmprj.py --new .
```

Actualizar un proyecto después de moverlo o renombrarlo:

```
python3 asmprj.py --update hello
```

Actualizar el proyecto del directorio actual:

```
python3 asmprj.py --update .
```

---

## Requisitos

- Python 3.6 o superior
- Las herramientas `abasm.py` y `dsk.py` deben encontrarse en el mismo directorio que `asmprj`

---

## Notas

- La herramienta no sobrescribe `main.asm` si ya existe.
- El modo `--update` solo modifica las variables necesarias, preservando el resto del contenido del fichero *make*.
