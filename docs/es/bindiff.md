BINDIFF: MANUAL DEL USUARIO  
===============================

## Descripción

`bindiff.py` es una herramienta sencilla escrita en Python 3.X para comparar dos archivos binarios y visualizar sus diferencias. Las diferencias se muestran por la salida estándar, por lo que, si se desea conservar el resultado, es necesario redirigir la salida a un archivo.

## Uso básico

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
