BINDIFF: MANUAL DEL USUARIO  
===============================

## Descripción

`bindiff.py` es una herramienta sencilla escrita en Python 3.X para comparar dos archivos binarios y visualizar sus diferencias. Las diferencias se muestran por la salida estándar, por lo que, si se desea conservar el resultado, es necesario redirigir la salida a un archivo.

## Construir los ejecutables

ABASM y sus herramientas asociadas están pensadas para utilizarse junto con el intérprete de Python, ya que así su ejecución es más rápida. No obstante, también se distribuyen ejecutables de ABASM y de sus herramientas para los principales sistemas operativos. Además, es posible generar los ejecutables por cuenta propia. Para ello, primero hay que instalar el paquete PyInstaller de Python mediante el siguiente comando:

```bash
pip install pyinstaller
```

A continuación, basta con acceder al directorio `src/build` y ejecutar `build.bat` en Windows o `build.sh` en macOS o Linux. Los binarios resultantes se guardarán en la carpeta `bin`, al lado de la carpeta `src`.

## Uso básico

Todos los ejemplos de uso asumen que se está usando `bindiff.py` junto al intérprete de Python. Si se está utilizando el ejecutable, basta con obviar la llamada a `python` o `python3` y remplazar `python bindiff.py` por la llamada directa al ejecutable.

```
python3 bindiff.py <archivo1> <archivo2>
```

## Opciones disponibles

- `--version`: Muestra la versión actual de la herramienta y finaliza la ejecución.  
- `--help`: Muestra un texto de ayuda con información sobre el uso de la herramienta y finaliza la ejecución.

## Ejemplo de uso

Comparar dos archivos binarios y guardar el resultado en un archivo de texto:

```
python3 bindiff.py archivo1.bin archivo2.bin > diferencias.txt
```

## Licencia

`bindiff.py` es software libre; puedes redistribuirlo y/o modificarlo bajo los términos de la **GNU General Public License v3**, publicada por la **Free Software Foundation**.

`bindiff.py` se distribuye con la esperanza de que sea útil, pero **SIN NINGUNA GARANTÍA**; ni siquiera la garantía implícita de **COMERCIABILIDAD** o **IDONEIDAD PARA UN PROPÓSITO PARTICULAR**. Consulta la **GNU General Public License** para más detalles.
