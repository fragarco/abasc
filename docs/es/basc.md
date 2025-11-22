# BASC: MANUAL DEL USUARIO

**Un compilador cruzado de BASIC para los Amstrad CPC**

# Introducción

**BASC (BASic Compiler)** es un compilador cruzado escrito íntegramente en Python y sin dependencias externas, lo que favorece su portabilidad a cualquier sistema que disponga de una instalación estándar de **Python 3**.

Está diseñado para soportar el dialecto de BASIC creado por **Locomotive Software** para los microordenadores Amstrad CPC, de modo que toda la documentación existente sobre este lenguaje siga siendo plenamente relevante y útil.

Además, al tratarse de un compilador cruzado que se ejecuta en sistemas modernos, BASC incorpora diversas carácterísticas de **Locomotive BASIC 2 Plus**, lo que permite una experiencia de desarrollo más cercana a los lenguajes actuales sin renunciar al estilo clásico del BASIC original.

## Un recorrido por las distintas versiones de Locomotive BASIC

### Versión 1.0

La primera versión de este BASIC apareció con los Amstrad CPC 464. Era un lenguaje relativamente rápido en comparación con otros BASIC de la época. Entre sus ventajas principales contaba con un acceso amplio a las funcionalidades del chip de audio. Utilizaba números de línea como etiquetas para las sentencias `GOTO` y `GOSUB`.

### Versión 1.1

Introducida con los CPC 664 y 6128, esta versión corregía diversos fallos e incorporaba nuevas funciones, como `FRAME`, `COPYCHR$` o `FILL`. Aun así, seguía requiriendo el uso de números de línea.

### Versión 2

Lanzada en 1987 para los Amstrad PC 1512 y 1640, esta versión eliminaba la necesidad de numerar líneas gracias al comando `LABEL` y permitía crear aplicaciones para el entorno gráfico GEM, aunque todavía no ofrecía mecanismos avanzados de estructuración del código.

### Versión 2 Plus

Aparecida en 1989, esta revisión añadía `FUNCTION`, `SUB`, sentencias `IF` de varias líneas y otras mejoras orientadas a facilitar el desarrollo de programas más estructurados.

# Referencias

Este manual no trata de ser una guía exhaustiva de programación en BASIC. Como material de consulta sobre la programación en Locomotive BASIC es más recomendable consultar los siguientes textos:

* Amstrad CPC464 - Manual del Usuario (I. Spital, R. Perry, W. Poel and C. Lawson)
* Manual de Referencia BASIC para el Programador (Amsoft)
* Amstrad CPC6128 - Manual del Usuario (I. Spital, R. Perry, W. Poel and C. Lawson)
* BASIC 2 User Guide (Locomotive Software ltd.)
* BASIC 2 PLUS Language Reference (Locomotive Software ltd.)
* Using Locomotive BASIC 2 on the Amstrad 1512 (Robert Ransom)

Para ampliar conocimientos sobre el Firmware del Amstrad CPC464 y CPC6128, o sobre programación en ensablador para el procesador Z80, se recomiendan los siguientes libros de consulta:

* CPC464/664/6128 FIRMWARE, ROM rutines and explanations (B. Godden, P. Overell, D. Radisic) 
* The Amstrad CPC Firnware Guide (Bob Taylor)
* Z80 Assembly Langauge Programming (Lance A. Leventhal)
* Ready Made Machine Language Routines For the Amstrad CPC (Joe Pritchard)
* Código máquina para principantes con Amstrad (Steve Kramer)

# Sintaxis soportada por BASC

1.  No es necesario usar números de línea.\
2.  Se pueden definir etiquetas para saltos mediante `LABEL`.\
3.  Bloques `IF ... THEN ... ELSE ... END IF` de varias líneas.\
4.  Definición de procedimientos con `FUNCTION` y `SUB`.\
5.  Inclusión de código ensamblador mediante `ASM`.\
6.  Inclusión de código BASIC externo con `CHAIN MERGE`.\
7.  Definición de estructuras de datos con `RECORD`.

### Ejemplo 1 (sintaxis compatible con BASIC 1.0 y 1.1)

``` basic
10 MODE 1
20 BORDER 0
30 PAPER 3
40 INK 0,1,2
50 PEN 0
60 PRINT "Hello world"
70 END
```

### Ejemplo 2 (sintaxis incluyendo varias de las mejoras de BASIC 2)

``` basic
RECORD person; name$ FIXED 10, age, birth
DIM records$(5) FIXED 14

CLS
FOR I=0 TO 5
    READ records$(i).person.name$, records$(i).person.age, records$(i).person.birth
    PRINT "Customer:", records$(i).person.name$
    PRINT "Age:", records$(i).person.age
    PRINT "Born in:", records$(i).person.birth
NEXT
END

DATA "Xavier", 49, 1976
DATA "Ross", 47, 1978
DATA "Gada", 12, 2013
DATA "Anabel", 51, 1974
DATA "Rachel", 45, 1980
DATA "Elvira", 20, 2005
```

# Uso del compilador

    python basc.py [opciones] archivo.bas [-o archivo]

### Opciones

-   `--version` --- muestra la versión del compilador.
-   `-O <n>` --- nivel de optimización (0 = ninguna, 1 = peephole, 2 = completa).\
-   `-W <n>` --- nivel de las advertencias (warnings) a mostrar (0 = ninguna, 1 = solo importantes, 2 = importantes y de media importancia, 3 = todas).\
-   `-v`, `--verbose` --- genera archivos auxiliares del proceso de compilación (resultado del preproceso, tabla de símbolos, arbol de sintáxis, etc.).\
-   `-o`, `--out` --- nombre de salida sin extensión.\

# Herramientas adicionales

-   `abasm.py` --- ensamblador compatible con WinAPE y RVM.\
-   `img.py` --- conversión de imágenes al formato CPC.\
-   `dsk.py` --- creación de disquetes `.DSK`.\
-   `cdt.py` --- creación de cintas `.CDT`.

# Peculiaridades del compilador

Aunque el objetivo de BASC es permitir la compilación, sin apenas cambios, de programas escritos para BASIC 1.0 o 1.1, la propia naturaleza de un compilador —frente a un intérprete— introduce ciertas diferencias. En esta sección exploramos esos aspectos particulares que pueden tomar por sorpresa al programador acostumbrado al uso del intérprete de BASIC.

## Tipos y variables

BASC utiliza un sistema de tipado algo más estricto que el proporcionado por el intérprete original de BASIC. Para empezar, todas las variables son de tipo **entero** por defecto, salvo que se utilice un sufijo para indicar otro tipo de dato.

| Tipo   | Sufijo       | Notas                                                                         |
| ------ | ------------ | ----------------------------------------------------------------------------- |
| Entero | % (opcional) | Valores enteros en el rango -32768...32767                                    |
| Real   | !            | Números en coma flotante de 5 bytes (4 para la mantisa y 1 para el exponente) |
| Texto  | $            | Cadenas de hasta 254 carácteres (ver siguiente sección)     

### Cadenas de texto

En la implementación original de Locomotive BASIC para los Amstrad CPC, las cadenas utilizaban una estructura de **doble indirección**. Una variable de tipo texto ocupaba inicialmente 3 bytes:

* byte 1: longitud
* bytes 2 y 3: dirección al contenido de la cadena

La longitud máxima era de 255 carácteres.

En BASC, el contenido de la cadena se almacena directamente a continuación del byte de longitud, reservando un máximo de **255 bytes para toda la estructura**, por lo que **la longitud máxima de una cadena es de 254 carácteres**.

La única excepción son las **llamadas RSX**, para las que BASC conserva la estructura original de Locomotive BASIC con el fin de garantizar la compatibilidad. Por ello, una rutina RSX recibirá siempre las cadenas de texto en una estructura de 3 bytes:

* 1 byte: longitud
* 2 bytes: puntero al contenido

Además, es posible que el programador no desee reservar siempre los 254 bytes por defecto para una cadena, por lo que BASC incorpora dos sentencias procedentes de Locomotive BASIC 2: **`FIXED`** y **`DECLARE`**.

Estas permiten ajustar el espacio reservado para la cadena, como en el siguiente ejemplo:

```basic
DECLARE A$ FIXED 10  ' La cadena A$ podrá contener hasta 10 carácteres
```

La cadena anterior reservará un total de 11 bytes (1 de longitud + 10 de contenido).
Es importante destacar que, al no existir comprobaciones en tiempo de ejecución —como sí ocurre en un intérprete—, nada impide que el programador intente almacenar más carácteres de los permitidos en `A$`, lo que provocará comportamientos impredecibles.

### Arrays

En Locomotive BASIC, un array que no ha sido declarado previamente con `DIM` se considera que tiene 10 elementos por defecto. BASC es más estricto: la compilación fallará si el código intenta operar con arrays que no hayan sido declarados explicitamente mediante `DIM`.

Además, un array de cadenas reservará inmediatamente la memoria necesaria para todos sus elementos. Por defecto, cada cadena ocupa 255 bytes (1 para la longitud y 254 para el contenido), lo que puede consumir rápidamente la memoria disponible. Por ello, igual que con las cadenas individuales, es posible utilizar la cláusula `FIXED`:

```basic
DIM A$(5) FIXED 10   ' El espacio total será de 11 bytes × 5 elementos
```

### Estructuras con RECORD

BASC incluye soporte para la organización de variables en estructuras más complejas denominadas **REGISTROS**. Internamente, un registro es simplemente una forma de dividir y etiquetar la memoria reservada por una cadena de texto. Para utilizar registros, el primer paso es declarar su estructura mediante la sentencia `RECORD`.

```
RECORD nombre; lista de campos
```

Ejemplo:

```basic
RECORD persona; nom$ FIXED 10, edad
```

Los patrones definidos con `RECORD` pueden aplicarse a cadenas empleando el símbolo `.` tras el nombre de la variable:

```basic
DECLARE A$ FIXED 13  ' No es obligatorio, pero reduce el consumo de memoria
RECORD persona; nom$ FIXED 10, edad ' Requiere 13 bytes de memoria

A$.persona.nom$ = "Juan"
A$.persona.edad = 20
```

El programa anterior dejará el contenido de la memoria reservada por `A$`como sigue:

| BYTE   |  Contenido      |  Valor     |
|--------|-----------------|------------|
| 0 - 10 | longitud y contenido de `nom$` | 4,J,u,a,n,0,0,0,0,0,0 |
| 11 - 12 | valor de `edad` | 20        |

## Soporte para procedimientos

Tradicionalmente, BASIC permite organizar código reutilizable mediante rutinas invocadas con `GOSUB` y `RETURN` (sin soporte para parámetros) o mediante funciones de una sola línea definidas con `DEF FN`. BASC es plenamente compatible con ambos mecanismos, pero además incorpora una forma más moderna de estructurar el código, introducida en la versión 2 Plus de Locomotive BASIC. La sintaxis es la siguiente:

```basic
SUB nombre(lista de parámetros)
    ....
END SUB

FUNCTION nombre(lista de parámetros)
    ....
END FUNCTION
```

Las rutinas declaradas con `FUNCTION` deben incluir al menos una instrucción de asignación al propio nombre de la función, que actuará como valor de retorno.

Las funciones pueden llamarse directamente como parte de una expresion, mientras que las subrutinas deben llamarse con `CALL`, indicando el nombre del procedimiento y los parámetros entre paréntesis separados por comas. 

```basic
function pow2(x)
    pow2 = x * x
end function

sub message(m$)
    print m$
end sub

label MAIN
    result = pow2(2)
    msg$ = "2 * 2 is " + str$(result)
    call message(msg$)
end
```

Las variables declaradas dentro del cuerpo de un procedimiento (mediante `DECLARE`, `DIM`, incluyéndolas en la parte izquierda de una asignación o utilizándolas en `INPUT`, `READ` o `LINE INPUT`) son siempre locales y no pueden ser referenciadas desde el exterior. Las variables globales, por su parte, pueden emplearse dentro de un procedimiento, pero solo en modo lectura (por ejemplo, como parte de una expresión o como parámetro de otra función).

En cuanto a la semántica de paso de parámetros, los enteros se pasan por valor, mientras que las cadenas de texto y los números reales se pasan por referencia (es decir, mediante un puntero a su contenido). Por tanto, en estos dos últimos casos es posible modificar la variable original desde el cuerpo del procedimiento.

**NOTA SOBRE RECURSIVIDAD:** BASC no permite recursividad. Al igual que ocurre con las variables globales, las variables locales reservan memoria en tiempo de compilación. Debido a ello, el código no es reentrante y no es posible realizar llamadas recursivas.

## Uso de código ensamblador

Mediante la sentencia `ASM` es posible incrustar código ensamblador en cualquier parte del programa BASIC. **ABASM**, el ensamblador utilizado por BASC, dispone de su propio manual, donde se describe con detalle la sintaxis y opciones disponibles.

Además, se pueden invocar rutinas escritas en ensamblador utilizando la sentencia `CALL`, tal y como muestra el siguiente ejemplo:

```basic
ASM "mylabel: ret ; rutina vacía"

CALL "mylabel"
```

Es posible pasar argumentos a las rutinas ensambladas, aunque esto requiere conocer la convención de llamadas utilizada por BASC. Los parámetros se apilan **en orden**, del primero al último, y la función se invoca con el registro **IX apuntando al último parámetro**.
La rutina llamada **no** debe desapilar los parámetros; es el llamante quien se encarga de ello tras el retorno.

Por ejemplo, una rutina que reciba tres parámetros enteros (cada uno de 2 bytes):

```
CALL mirutina(param1, param2, param3)
```

Podrá acceder a ellos mediante el siguiente esquema:

| Parámetro | Direcciones relativas |
| --------- | --------------------- |
| param1    | IX+4, IX+5            |
| param2    | IX+2, IX+3            |
| param3    | IX+0, IX+1            |

Por último, es posible añadir la cláusula `ASM` a la declaración de una función o subrutina, indicando que todo el código va a ser ensablador y que el compilador no necesita gestionar la memoria temporal.

``` basic
SUB cpcSetColor(i,c) ASM
    ' Equivalent to the BASIC call INK
    ' param 1: is the ink number (0-16) bening 16 the border ink.
    ' param 2: color in hardware values - &40 (i.e &14 means &54 black)
    ASM "ld      bc,&7F00 ; Gate Array"
    ASM "ld      a,(ix+2) ; ink number"
    ASM "out     (c),a"
    ASM "ld      a,&40"
    ASM "ld      e,(ix+0) ; HW color"
    ASM "or      e"
    ASM "out     (c),a"
 	ASM "ret"
END SUB

CALL cpcSetColor(0,&14)
```

## Gestión de la memoria

El mapa de memoria de un programa compilado con BASC es el siguiente:

| Dirección         | Descripción                                                |
| ----------------- | ---------------------------------------------------------- |
| **0x0170**        | Comienzo del área para la inicialización de la aplicación y reserva de memoria temporal |
| **0x4000**        | Comienzo del área para el código de la aplicación |
| **\_data\_**      | Etiqueta que marca el comienzo del espacio reservado para las variables |
| **\_runtime\_**   | Etiqueta que marca el comienzo del área para rutinas de apoyo generadas por el compilador |
| **\_program_end\_** | Etiqueta que marca la dirección donde finaliza la memoria consumida por el programa |

Locomotive BASIC incluye una serie de comandos relacionados con la gestión de memoria: `HIMEM`, `MEMORY`, `FRE` y `SYMBOL AFTER`.
BASC los soporta, pero su significado varía ligeramente debido al modelo compilado:

| Comando          | Función BASC  |
| ---------------- | ------------- |
| **HIMEM**        | Devuelve la dirección de memoria inmediatamente posterior al final del programa. |
| **MEMORY**       | Establece el la dirección de momria máxima a la que podrá llegar el binario generado. Si se supera, la compilación falla. |
| **SYMBOL AFTER** | BASC reserva memoria para carácteres redefinibles (UDC) igual que Locomotive BASIC. Esta zona forma parte de ***data***. Puede liberarse con `SYMBOL AFTER 256`. |
| **FRE(0)**       | Devuelve la memoria disponible entre `_program_end_` y la zona del Firmware donde empiezan las variables (`&A6FC`). |
| **FRE(1)**       | Devuelve la memoria temporal disponible en ese instante. |
| **FRE("")**      | Fuerza la liberación de la memoria temporal y devuelve el mismo valor que `FRE(0)`. |

BASC utiliza memoria temporal para almacenar valores intermedios durante la evaluación de expresiones (por ejemplo, concatenación de cadenas o cálculo de expresiones numéricas).
Después de cada sentencia, la memoria temporal se libera automáticamente. La única excepción ocurre durante una llamada a `FUNCTION` o `SUB`: la memoria temporal previa a la llamada se preserva para poder restaurar el contexto al regresar.

## Uso del Firmware

BASC se apoya de manera extensa en las rutinas del **Firmware del Amstrad CPC**, especialmente para el manejo de números reales. Esto significa que, aunque el código compilado es más rápido que el interpretado, puede verse limitado por el rendimiento de dichas rutinas del sistema.

Sin embargo, es posible utilizar la sentencia `ASM` para definir alternativas más eficaces para las llamadas al Firmware (como `CLS`, `INK`, `BORDER`, `PAPER`, etc.). Sin embargo, debe tenerse en cuenta que, si no se deshabilitan las interrupciones, el Firmware seguirá activo y **podría sobrescribir los cambios realizados** sin previo aviso.

Otra opción es modificar directamente el código ensamblador del programa, ya que BASC genera durante la compilación un fichero con extenisón `.ASM` que contiene todo el código del programa. Esto permite al programador modificarlo o añadir optimizaciones específicas cuando sea necesario, pudiendo usar **ABASM** para obtener el binario correspondiente. Mediante la opción `--verbose` obtendremos muchos más comentarios en el fichero ASM generado, lo que nos ayudará a realizar un mejor seguimiento de la traducción de nuestras sentencias BASIC a código ensamblador.

# Comandos y sintaxis del lenguaje

## Notación

Carácteres especiales:

| carácter | Notas |
|----------|-------|
| & o &H   | prefijo para números en hexadecimal |
| &X 	   | prefijo para números en binario |
| : 	   | separador de sentencias en la misma línea |
| # 	   | prefijo para denotar un canal de texto (0-9) |
| "        | delimitador de cadenas de texto |
| @        | delante del nombre de una variable indica dirección de memoria apuntada por dicha variable |
| \|       | delante de un identificador indica llamada a función RSX |

## Listado de comandos y funciones

### `ABS(<numeric expression>)`

Función. Devuelve el valor absoluto del número proporcionado como parámetro. La expresión numérica puede ser entera o real.

### `AFTER delay[,timer] GOSUB etiqueta`

Comando. Llama a una subrutina indicada tras un retardo. El "delay" se mide con un grano de 1/50 segundos. El segundo parámetro (opcional) indica cuál de los cuatro temporizadores se debe utilizar (0..3). Si no se especifica, se utiliza el valor 0 por defecto. Como etiqueta para la sentencia GOSUB se puede usar tanto un númerod de línea (INT) como un litaral definido por la sentencia `LABEL`.

BASC emplea las funciones del Firmware para la gestión de eventos asíncronos. Las rutinas del usuario son llamadas con la ROM baja activa y, por tanto, el código debería mantenerse breve y no hacer uso de los primeros 16K de memoria. Por ejemplo, las operaciones con números en coma flotante o las operaciones con textos tratarán de reservar memoria temporal en dicho rango y deberían evitarse. Las operaciones con enteros, en cambio, no deberían dar problemas. Este mecanismo también depende de que las interrupciones estén activas (ver `DI`y `EI`).

``` basic
A = 0
AFTER 50 GOSUB INCR  ' Llama a la rutina INCR después de 1 segundo
A = 5
END

LABEL INCR
    PRINT A
RETURN
```

### `ASC(string)`

Función. Devuelve el valor ASCII del primer carácter de la cadena suministrada como parámetro. 

``` basic
PRINT ASC("HOLA") ' imprime 72, el codigo ASCII para la letra H
```

### `ASM string[,string]*`

Comando. Inserta el código contenido de la lista de cadenas de texto como código ensamblador. Cada cadena de la lista se inserta como una nueva línea.

``` basic
ASM "ld  hl,_my_str", "ld  a,(hl)"
```

### `ATN(x)`

Función. Devuelve la arcotangente (arctan) de `x`. Implica el uso de números reales.

### `AUTO linenumber[,increment]`

Comando. BASC ignora este comando y emite un mensaje de alerta sobre su uso, ya que no tiene utilidad para un programa compilado.

### `BIN$(number,digits)`

Función. Devuelve el valor entero `number` como candea de texto con su representación binaria. Locomotive BASIC permite especificar el número exacto de digitos a utilizar en la representación binaria, pero **BASC solo soporta los valores 8 o 16**.

``` basic
PRINT BIN$(16,8)  ' imprimira la cadena de texto "00010000"
```

### `BORDER colour1[,colour2]`

Permite espedificar el color del borde. Si se proporcionan dos valores, se produce un parpadeo cuyo tiempo controla el comando `SPEED INK`.

``` basic
BORDER 0,1
```

### `CALL address[,list of parameters]`

Comando. Permite llamar a una rutina existente en memoria indicado su dirección, a una rutina declara con SUB o FUNCTION, o a una etiqueta declarada dentro de un bloque en ensamblador.

``` basic
SUB nada
    print "solo imprimo nada"
END SUB

CALL &BC14  ' rutina del firmware para limpiar la pantalla
CALL nada()
CALL "bucle_eterno"
PRINT "aqui no llegaremos"
ASM "bucle_eterno: jr bucle_eterno"
```

### `CAT`

Comando. Muesta el contenido del dispositivo de almacenamiento actual. Es posible cambiar el dispositivo a través de llamadas a funciones RSX como `|TAPE`, `|DISC`, `|A` o `|B`. 

### `CHAIN`

Comando. En BASIC, se utiliza para remplazar el programa actual en memoria por otro. BASC ignora esta instrucción y emite una advertencia si la encuentra en el código.

### `CHAIN MERGE string`

Comando. BASC reinterpreta este comando para permitir dividir nuestro código entre varios ficheros. `string` debe ser una ruta a un fichero .BAS alcanzable desde el fichero donde se hace la referencia.

``` basic
fichero OTRO.BAS
    MYVAR$ = "UNA CADENA MUY UTIL"

fichero MAIN.BAS
    CHAIN MERGE "OTRO.BAS"
    PRINT MYVAR$
    END
```

### `CHR$(x)`

Función. Devuelve una cadena de texto con el carácter equivalente indicado por `x` en el rango 0-255.

``` basic
PRINT CHR$(250)
```

### `CINT(x)`

Función. Devuelve un entero con la conversión redondeada del número real `x`. `x` debe estar dentro del rango -32768..32767 o el valor devuelto será erroneo.

``` basic
PRINT CINT(PI)
```

### `CLEAR`

Comando. Originalmente, fijaba todas las variables a 0, limpiaba la zona de memoria para cadenas de texto, cerraba cualquier fichero abierto y volvia a poner el modo para angulos a `RAD`. Con BASC, solo se llevan a cabo las dos últimas acciones indicadas.

### `CLEAR INPUT`

Comando. Este comando se introdujo con la versión BASIC 1.1. BASC permite su uso incluso en un Amstrad CPC 464 utilizando la rutina del Firmware `KM RESET` en vez de `KM FLUSH`.

### `CLG [tinta]`

Comando. Borra la pantalla de gráficos usando el valor actual de `PAPER`. Si `tinta` está presente, se fija como nuevo valor para `PAPER` antes del borrado.

### `CLOSEIN`

Comando. Cierra el fichero abierto actualmente para lectura.

### `CLOSEOUT`

Comando. Cierra el fichero abierto actualmente para escritura.

### `CLS [#x]`

Comando. Borra la pantalla usando el color de `PAPER` actual. Es posible indicar un canal con `#x`. Los valores 0-7 están disponibles para definir áreas de la pantalla mediante el comando `WINDOW`, miestras que el valor #8 suele estar asociado a la impresora (no soportado por BASC) y el #9 se asocia con ficheros.

### `CONT`

Comando. En el BASIC original permite continuar la ejecución de un programa detenido por las instrucciones `BREAK`, `STOP` o `END`. En un programa compilado no tiene sentido y BASC lo redefine para detener el programa y esperar la pulsación de cualquier tecla antes de continuar, lo que puede ser últil para depurar programas.

### `COPYCHR$()`

Función. Devuelve el carácter situado en la posición actual del cursor. Esta función apareció con la versión BASIC 1.1. BASC proporciona una implementación que permite utilizar esta función incluso en programas que se van a ejecutar en un Amstrad CPC 464.

### `COS(x)`

Función. Devuelve el coseno de `x`. Implica el uso de números reales.

### `CREAL(x)`

Función. Convierte `x` (normalmente un número entero) en un número real.

### `CURSOR sistema[,usuario]`

Comando. Incorporado en la versión 1.1 de BASIC. Permite fijar el valor encendido `1` o apagado `0` a los flags de visiblidad del cursor. El cursor solo se mostrará cuando ambos valores (`sistema` y `usuario`) estén a `1`.

### `DATA lista-de-constantes`

Comando. Permite añadir al programa una serie de valores (números enteros o carácteres) que después pueden leerse en orden mediante la instrucción `READ`.

``` basic
CLS
FOR I=0 TO 5
    READ nom$
    PRINT "Nombre:", nom$
NEXT
END

DATA "Xavier","Ross","Gada",
DATA "Anabel","Rachel","Elvira"
```

### `DECLARE variable[$ FIXED longitud]),...`

Comando. Este comando apareció con la versión 2 de Locomotive BASIC. Permite "dar a conocer" una variable que se va a utilizar posteriormente. Normalmente, solo es necesario declarar los arrays mediante `DIM` ya que las variables quedan declaradas en cuanto se les asigna un valor. Sin embargo, `DECLARE` permite crear cadenas de texto con una longitud máxima menor a los 254 bytes utilizados por defecto o declarar variables enteras con el valor por defecto de 0 reduciendo el código e intrucciones generadas, ya que no es necesaria una asignación inicial.

por ejemplo:

``` basic
B$ = ""              ' B$ reserva espacio para 254 carácteres
DECLARE A$ FIXED 15  ' A$ reserva espacio para 15 carácteres
B = 0                ' B queda inicializada a 0 generando más código ensamblador
DECLARE A            ' que A.
```

### `DEC$(numero,patron)`

Función. Esta función apareció con la versión 1.1 de BASIC. Permite convertir `numero` en una cadena aplicando un patrón para indicar el número de espacios antes o después del punto decimal. BASC no soporta todavía el uso de estos patrones, por lo que esta llamada se comporta, básicamente, igual que `STR$`.

``` basic
PRINT DEC$(15.5, "###.##")
```

### DEF FN nombre(parametros)=expresion

Comando. Permite declarar una función que aplicará la expresión de la derecha a los valores indicados como parámetros en cada llamada. En BASIC 1.0 era la única forma de declarar funciones. BASC soporta `FUNCTION` ... `END FUNCTION` que es un mecanismo mucho más versátil.

A diferencia de Locomotive BASIC **las funciones y procedimientos DEBEN declararse antes de su uso**. También es imporante resaltar que debido a la gestión de tipos más extricta, una función que devuelva un valor real debe terminar su nombre obligatoriamente con el sufijo `!`, igual que una que devuelva una cadena de texto debe hacerlo con `$`.

```
DEF FNintere0s!(principal)=principal * 1.14
PRINT FNinteres!(1000)
```

### `DEFINT, DEFSTR, DEFREAL`

Comandos. Originalmente fijaban un rango de letras iniciales para indicar que una variable era de un tipo determinado. Como BASC utiliza un sistema más restrictivo de tipos, estos comandos no tienen ningún efecto. El programador debe emplear obligatoriamente los sufijos `%`, `!` y `$` para indicar el tipo de una variable.

### `DEG`

Comando. Establece que las funciones que trabajan con ángulos devuelvan sus resultados en grados en vez de radianes.

``` basic
DEG
PRINT SIN(90.0)
RAD
PRINT SIN(90.0)
```

### `DELETE bajo-alto`

Comando. En Locomotive BASIC este comando borraba un conjunto de líneas del programa en BASIC. En BASC, este funcionamiento no tiene sentido, así que `DELETE` se ha modificado para permitir borrar (llenar con 0s) una región de la memoria. El rango debe proporcionarse como: dirección inicial - dirección final.

``` basic
DELETE &C000-&FFFF
```

### `DERR`

Comando. Introducido en la versión 1.1 de BASIC. Almacenaba el último error producido al trabajar con la unidad de disco. BASC ignora cualquier referencia a este comando y emite una advertencia al respecto si lo encuentra en el código.

### `DI`

Comando. Desactiva el mecanismo de interrupciones. Con las interrupciones desactivadas, dejerá de actualizarse el valor devuelto por `TIME` y la gestión de eventos registrados con `AFTER` o `EVERY`. Las interrupciones pueden volverse a activar con el comando `EI`.

### `DIM array(indice1, indice2, ...) [FIXED longitud]`

Comando. Permite declarar y reservar la memoria a utilizar por un array (vector). El tipo de dato debe indicarse como sufijo al nombre del array (`%`, `!`, `$`). Si no se indica ningún sufijo, los datos serán enteros. En el caso de un array de cadenas de texto, es posible reducir el tamaño máximo reservado para cada cadena usando la cláusula `FIXED` después de la lista de indices.

Los indices van desde 0 hasta el número indicado en la declaración.

```
DIM nom$(3) FIXED 8

nom$(0) = "Juan"
nom$(1) = "Daniel"
nom$(2) = "Pepe"
nom$(3) = "Roberto"

FOR I=0 TO 3
    PRINT nom$(I)
NEXT
```

### `DRAW x,y[,i[,modo]]`

Comando. Dibuja una línea desde la posición actual del cursor hasta la posición `x` e `y`. Si se indica un tercer parámetro, este es el color a utilizar. Con la versión 1.1 de BASIC, se añadió un cuarto parámetro soportado por BASC (incluso para programas que correrán en un Amstrad CPC 464). Este cuarto parámetro indica el modo o máscara a aplicar entre cada punto de la línea y el fondo, con los valores que se indican a continuación:

| Valor | Modo  |
|-------|-------|
|   0   | Fill (normal) |
|   1   | XOR (OR eXclusivo) |
|   2   | AND   |
|   3   | OR    |

``` basic
MODE 1
DRAW 100,100,1
DRAW 0,100,2
DRAW 100,0,3
DRAW 0,0,2
```

### `DRAWR x,y[,i[,modo]]`

Comando. Al igual que `DRAW` dibuja una línea, aunque los valores de `x` e `y` no son posiciones absolutas de la pantalla sino valores relativos a la posición actual. El resto de parámetros tienen el mismo significado que en la instrucción `DRAW`.

### `EDIT linea[-linea]`

Comando. En Locomotive BASIC permite editar una línea de código. En BASC este comando no tiene sentido y es ignorado si forma parte del código a compilar.

### `EI`

Comando. Activa las interrupciones. Ver `DI`.

### `END`

Comando. Termina la ejecución del programa. Mientras que en el interprete de BASIC esto significa devolver el control al usuario, BASC salta a un bucle infinito. `STOP`, en cambio, fuerza un reincio de la máquina. 

### `END FUNCTION`

Comando. Termina la declaración de una función. Ver `FUNCTION`.

### `END SUB`

Comando. Termina la declaración de un procedimiento. Ver `SUB`.

### `ENT numero de envolvente, secciones`

Comando. Define la variación en tono de un sonido. Locomotive BASIC permite especificar dos tipos de envolventes de tono (secciones), una con tres parámetros y otra con dos. Aunque no está documentado, para diferenciarlas, es posible utilizar el símbolo `=` antes del primer número en el segundo caso. BASC no falla si se encuentra dicho carácter, pero utiliza el número de parámetros para saber si nos encontramos en el primer caso o en el segundo. En caso de duda, procederá siempre considerando que estamos usando el primer caso, donde cada envolvente se especifica usando tres valores.

Sección tipo 1:
* Parámetro 1: número de escalores, de 0 a 239.
* Parámetro 2: tamaño de cada escalón, de -128 a +127.
* Parámetro 3: pausa
        
Sección tipo 2:
* Parámetro 1: periodo del tono (entero de 16 bits).
* Parámetro 2: pausa

### ENV `número de envolvente, secciones`

Comando. Define la variación en volumen de un sonido. Locomotive BASIC permite especificar dos tipos de envolventes de volumen (secciones), una con tres parámetros y otra con dos. Aunque no está documentado, para diferenciarlas, es posible utilizar el símbolo `=` antes del primer número en el segundo caso. BASC no falla si se encuentra dicho carácter, pero utiliza el número de parámetros para saber si nos encontramos en el primer caso o en el segundo. En caso de duda, procederá siempre considerando que estamos usando el primer caso, donde cada envolvente se especifica usando tres valores.

Sección tipo 1:
* Parámetro 1: número de escalores, de 0 a 127.
* Parámetro 2: tamaño de cada escalón, de -128 a +127.
* Parámetro 3: pausa, rango de 0 a 255.
        
Sección tipo 2:
* Parámetro 1: ID de envolvente según el hardware de sonido.
* Parámetro 2: periodo de la envolvente. Valor que se manda a los registros.

``` basic
ENV 1,=9,2000
ENV 2,127,0,0,127,0,0,127,0,0,127,0,0,127,0,0
ENV 3,=9,9000
```
### `EOF`

Función. Permite saber si el fichero del que se está leyendo ha llegado al final. Devuelve -1 (true) si el final se ha alcanzado o 0 (false) en cualquier otro caso.

``` basic
OPENIN "DATOS.TXT"
WHILE NOT EOF
    LINE INPUT #9,C$
    PRINT C$
WEND
CLOSEIN
```

### `ERASE arrayname`

Comando. En Locomotive BASIC permite liberar la memoria reservada por un array. BASC reserva el espacio durante la compilación, por lo que este comando no tiene utilidad y es ignorado si forma parte del código compilado.

### `ERL`

Comando. En Locomotive BASIC permite conocer la línea donde se ha producido el último error. En un programa compilado no tiene utilidad y es ignorado si forma parte del código compilado.

### `ERR`

Comando. Permite recuperar un código de error (entero) que se haya establecido antes llamando al comando `ERROR`. También puede almacenar el código de error `31` (File not open) si los comandos `OPENIN` u `OPENOUT` fallan.

``` basic
ERROR 5
PRINT ERR
```

### `ERROR integer`

Comando. BASC permite utilizar este comando para fijar un número de error que puede consultarse después con `ERR`.

### `EVERY tiempo[,temporizador] GOSUB etiqueta`

Comando. Fija el `temporizador` indicado (0..3 - 0 por defecto) para saltar a `etiqueta` cada intervalo de `tiempo`. El tiempo tiene un grano de 1/50 segundos, por lo que un valor de 50 quiere decir llamar a la etiqueta cada segundo.

BASC emplea las funciones del Firmware para la gestión de eventos asíncronos. Las rutinas del usuario son llamadas con la ROM baja activa y, por tanto, el código debería mantenerse breve y no hacer uso de los primeros 16K de memoria. Por ejemplo, las operaciones con números en coma flotante o las operaciones con textos tratarán de reservar memoria temporal en dicho rango y deberían evitarse. Las operaciones con enteros, en cambio, no deberían dar problemas. Este mecanismo también depende de que las interrupciones estén activas (ver `DI` y `EI`).

``` basic
A=0
EVERY 300 GOSUB INCA ' imprime e incrementa A cada 6 segundos
END

LABEL INCA
    PRINT A
    A=A+1
    RETURN
```

### `EXIT FOR`

Comando. Aunque en Locomotive BASIC era posible abandonar un bucle con una sentencia `GOTO`, en un programa compilado con BASC se producirán errores inesperados durante la ejecución. La forma adecuada de abandonar un bucle `FOR` antes de su terminación es utilizando el comando `EXIT FOR`, que saltará a la siguiente instrucción tras el `NEXT`.  Este comando fue introducido con la versión 2 de Locomotive BASIC.

``` basic
FOR I=0 TO 100
    IF I = 50 THEN EXIT FOR
NEXT
PRINT I
```

### `EXIT WHILE`

Comando. Aunque en Locomotive BASIC era posible abandonar un bucle con una sentencia `GOTO`, en un programa compilado con BASC se producirán errores inesperados durante la ejecución. La forma adecuada de abandonar un bucle `WHILE` antes de su terminación es utilizando el comando `EXIT WHILE`, que saltará a la siguiente instrucción tras el `WEND`. Este comando fue introducido con la versión 2 de Locomotive BASIC.

``` basic
I=0
WHILE I < 101
    IF I=50 THEN EXIT WHILE
    I=I+1
WEND
PRINT I
```

### `EXP(x)`

Función. Calcula E elevado a `x`, siendo E 2.7182818 aproximadamente, el número cuyo logaritmo natural es 1. Implica el uso de números reales.

### `FILL`

Comando. Solo disponible para ordenadores Amstrad CPC 664, 6128 o superiores. Rellena un área de la pantalla a partir de la posición actual del cursor gráfico con la tinta activa. Permite rellenar figuras, y aunque BASC ompile el programa adecuadamante, fallará si trata de ejecutarse en un Amstrad CPC 464.

``` basic
MODE 0
GRAPHICS PEN 15
MOVE 200,0
DRAW 200,400
MOVE 639,0
FILL 15
```

### `FIX(x)`

Función. Convierte a entero el número real `x` truncándolo. Para que el valor devuelto sea correcto, el número real debe estar en el rango -32768 to +32767.

``` basic
PRINT FIX(PI+0.5), CINT(PI+0.5)
```

### `FOR variable=inicio TO fin STEP variacion`

Comando. Permite especificar un bucle donde `variable` variará de valor desde `inicio` a `fin`. Si no se especifica una `variacion`, el incremento será de 1 en cada pasada del bucle.

``` basic
CLS
T! = TIME
FOR i=1 to 10
    FOR j=1 to 1000
        s = 1000 + j
    NEXT j
    PRINT ".";
NEXT i
PRINT " FIN!"
PRINT TIME-T!
```

### `FRAME`

Comando. Hace que el programa se detenga hasta la siguiente señal de sincronismo vertical del monitor (50 veces por segundo como máximo).

### `FRE(x)`

Función. Según el valor de `x` permite obtener varios valores relacionados con la memoria:

| Valor del parámetro | Valor devuelto |
|**FRE(0)**       | Devuelve la memoria disponible entre `_program_end_` y la zona del Firmware donde empiezan las variables (`&A6FC`). |
| **FRE(1)**       | Devuelve la memoria temporal disponible en ese instante. |
| **FRE("")**      | Fuerza la liberación de la memoria temporal y devuelve el mismo valor que `FRE(0)`. |

### `FUNCTION nombre(parametros) [ASM]`

Comando. Introducido con la versión 2 plus de Locomotive BASIC, este comando permite declarar funciones de forma parecida a `DEF FN` pero cuyo cuerpo se extienda por más de una línea.

Las rutinas declaradas con `FUNCTION` deben incluir al menos una instrucción de asignación al propio nombre de la función, que actuará como valor de retorno. Las funciones pueden llamarse directamente como parte de una expresion. 

```basic
function pow2(x)
    pow2 = x * x
end function

result = pow2(2)
```

La cláusula `ASM`en la declaración de la función permite indicar que todo el cuerpo de la función será código en ensablador (a través del comando ASM), tal y como se explica en la sección `Uso de código ensamblador` del capítulo `Peculiaridades del compilador`.

Se recomienda al programador leer la sección `Soporte para procedimientos` para obtener más información sobre el tratamiento de los parámetros o el soporte a la recursividad en el capítulo `Peculiaridades del compilador`.

### `GOSUB etiqueta`

Comando. Salta a una etiqueta definida como un número de línea o como un literal decalrado con `LABEL`. Vuelve a la linea posterior al `GOSUB` al encontrar la sentencia `RETURN`.

``` basic
A=0
GOSUB incrementar
GOSUB incrementar
PRINT A
END

LABEL incrementar
    A=A+1
RETURN
```

### `GOTO etiqueta`

Comando. Salta a una etiqueta definida como un número de línea o como un literal decalrado con `LABEL`.

### `GRAPHICS PAPER tinta`

Comando. Establece el valor de `tinta` (0..15) a utilizar como color de fondo para los carácteres escritos si se ha utilizado previamente la sentencia `TAG`. También como color al borrar la ventana mediante las llamadas a `CLG`.

``` basic
MODE 0
MASK 15
GRAPHICS PAPER 3
DRAW 640,0
```

### `GRAPHICS PEN tinta,modo`

Comando. Introducido en la versión 1.1 de BASIC. Establece el valor de `tinta` (un valor entre 0 y 15) como color para las instrucciones de dibujo de líneas y puntos. El `modo` se refiere a como debe combinarse el dibujo con el fondo.

* 0: Fondo opaco.
* 1: Fondo transparente.

El valor de fondo solo puede utilizarse si el programa va a ejecutarse sobre máquinas CPC 664 o superiores, ya que en el Amstrad CPC 464 no está soportado y su uso acarreará efectos indefinidos.

``` basic
MODE 0
GRAPHICS PEN 15
MOVE 200,0
DRAW 200,400
MOVE 639,0
FILL 15
```

### `HEX$(x,digitos)`

Función. Devuelve una cedena de texto con la conversión de `x` a número hexadecimal. Locomotive BASIC permite especificar cualquier número de dígitos. BASC solo soporta 2 o 4.

```basic
PRINT HEX$(255,2)
PRINT HEX$(2048,4)
```

### `HIMEM`

Función. Devuelve la dirección de memoria inmediatamente posterior al final del programa compilado por BASC. Puede ser muy útil con el comando `LOAD` para cargar otros binarios en una zona libre de la memoria.

``` basic
PRINT "Limite de la memoria consumida", HIMEM
PRINT "Memoria libre antes de las variables del Firmware", FRE(0)
``` 

### `IF expression THEN expression ELSE expression END IF`

Comando. BASC soporta la estructura tradicional de `IF .. THEN .. ELSE` en una línea de Locomotive BASIC 1.0 y 1.1. Además, añade soporte para la sintaxis introducida en Locomotive BASIC 2 Plus, que permite definir el cuerpo de las sentencias THEN y ELSE en varias líneas. No es posible combinar los dos variantes en una misma sentencia IF, si se usa la forma multilinea en el cuerpo del THEN, también debe hacerse así en el cuerpo del ELSE (si está presente) y terminar la sentencia con `END IF`.

``` basic
PAS$="Por favor"
LABEL PREGUNTA
    PRINT "DAME LA CONTRASEÑA:";
    INPUT C$
IF C$=PAS$ THEN
    PRINT "ADELANTE!"
ELSE
    PRINT "PRUEBA OTRA VEZ"
    GOTO PREGUNTA
END IF
END
```

### `INK tinta,color1[,color2]`

Comando. Asigna `color1` a `tinta`. Si se da un segundo color, la tinta parpadeara entre `color1`y `color2`. En número de tintas disponibles varía con el modo de la pantalla:

* Modo 2: 2 tintas  (0 y 1)
* Modo 1: 4 tintas  (0..3)
* Modo 0: 16 tintas (0..15)

El rango de colores va de 0 (negro) al 26 (blanco brillante).

``` basic
MODE 1
BORDER 0
INK 0,0: INK 1,26: INK 2,26,0
PRINT "READY"
PEN 2: PRINT "_"
```

### `INKEY(tecla)`

Función. Esta función analiza el teclado para determinar qué teclas se están pulsando. El escaneo se realiza 50 veces por segundo. Las teclas [MAYÚS] y [CTRL] se identifican de la siguiente manera:

| Valor devuelto | [MAYÚS] | [CTRL] |Tecla especificada |
|----------------|---------|--------|-------------------|
|      -1        |   N/A   |   N/A  |   Sin pulsar      |
|       0        | Sin pulsar | Sin pulsar | Pulsada    |
|      32        | Pulsada | Sin pulsar | Pulsada       |
|     128        | Sin pulsar | Pulsada | Pulsada       |
|     160        | Pulsada | Pulsada | Pulsada          |

``` basic
CLS
LABEL BUCLE
    IF INKEY(55)=32 THEN PRINT "V + mayusculas": END
GOTO BUCLE
```

### `INKEY$`

Función. Devuelve una cadena de texto con la tecla pulsada. Si no hay ninguna tecla pulsada, devuelve la cadena vacía "".

``` basic
MODE 1
LABEL BUCLE
    k$ = INKEY$
    if K$ <> "" THEN PRINT K$;
GOTO BUCLE
```

### `INP(puerto)`

Función. Lee un valor del `puerto` de Entrada/Salida indicado.

### `INPUT [#canal,]["mesnaje"][;]variable1,variable2...`

Comando. INPUT es un comando muy versatil con muchas opciones. Por ello, queda fuera de este manual y se aconseja al lector consultar cualquiera de las obras listadas en el capítulo sobre `Referencias`.

### INSTR([posición,]cadena1,cadena2)

Función. Busca en `cadena1` la primera aparición `cadena2`. Si se indica el parámetro opcional `posición`, la búsqueda comenzará desde esa posición; de lo contrario, la búsqueda comienza desde el primer carácter. Las posiciones comienzan en 1 y no en 0.

``` basic
POSA = INSTR(0,"AMSTRAD", "A")
PRINT POSA
POSA = INSTR(POSA+1, "AMSTRAD", "A")
PRINT POSA
POSA = INSTR(POSA+1, "AMSTRAD", "A")
PRINT POSA
```

### `INT(x)`

Función. Con números positivos se comporta como `FIX`. Con números negativos devuelve un negativo superior a `FIX`.

### `JOY(joystick)`

Función. Similar a `INKEY`, pero para joysticks. El valor `joystick` debe ser 0 o 1, pues los Amstrad CPC solo soportan dos joysticks simultáneos. Si no hay ninguna dirección o botón del joystick en uso, devuelve 0. En cualquier otro caso, develve un entero que codifica el estado como sigue:

|Bit 	| Decimal 	| Función   |
|-------|-----------|-----------|
|0 	    |1 	        | Arriba    |
|1 	    |2 	        | Abajo     |
|2 	    |4 	        | Izquierda |
|3 	    |8 	        | Derecha   |
|4 	    |16         | Fuego 2   |
|5 	    |32         | Fuego 1   |

### `KEY tecla,cadena`

Comando. Asocia una `cadena` de texto a una `tecla` de función. BASC no soporta este comando y emite un warning si lo encuentra como parte del código a compilar.

### `KEY DEF tecla,repetir[,<normal>[,<mayus>[,<control>]]]`

Comando. Redefine que devuelve la pulsación de `tecla`. BASC no soporta este comando y emite un warning si lo encuentra como parte del código a compilar.

### `LABEL etiqueta`

Comando. Define una etiqueta a la que se puede saltar con `GOTO` o `GOSUB`. `etiqueta` es un identificador y no una cadena de texto, por lo que no debe enmarcarse entre dobles comillas. Las etiquetas no tienen en cuenta la diferencia entre mayúsculas o minúsculas.

``` basic
LABEL main
    PRINT "HOLA MUNDO"
GOTO MAIN
```

### `LEFT$(cadena,n)`

Función. Devuelve los primeros `n` carácteres de la izquierda de `cadena`.

``` basic
PRINT LEFT$("AMSTRAD", 3)
```

### `LEN(cadena)`

Función. Devuelve la longitud en carácteres de `cadena`

``` basic
PRINT LEN("AMSTRAD")
```

### `LET variable=expression`

Comando. Un vestigio de las primeras especificaciones de BASIC. No es necesario emplear este comando para realizar asignaciones en Locomotive BASIC, aunque se soporta su uso por compatibilidad.

### `LINE INPUT [#canal,][;][cadena;]<variable>`

Comando. Acepta una línea de texto del canal indicado (#0 por defecto). El canal #9 se utiliza para leer del fichero de entrada abierto. Para el resto de canales #0-#8 se comporta, practicamente, como el comando `INPUT`.

``` basic
OPENIN "DATOS.TXT"
WHILE NOT EOF
    LINE INPUT #9,C$
    PRINT C$
WEND
CLOSEIN
```

### `LIST [rango de líneas][,#canal]`

Comando. BASC ignora este comando y emite una advertencia si lo encuentra como parte del código a compilar.

### `LOAD fichero[,dirección]`

Comando. Carga un fichero de disco o cienta en memoria. BASC solo soporta la carga de binarios. Si se proporciona el segundo parámetro, cargará el programa en la dirección indicada.

``` basic
DIREC = HIMEM
LOAD "SPRITES.BIN",HIMEM
```

### `LOCATE [#canal,]x,y`

Comando. Posiciona el cursor de texto en la posición `x` e `y`. Las posiciones empiezan en 1 y el tamaño en x depende del modo gráfico (0 = 20, 1 = 40, 2 = 80). Si se indica un `#canal` los límites dependerán de las dimensiones especificadas con `WINDOW`.

``` basic
CLS
LABEL MAIN
    FRAME
    FOR x=2 TO 39:
        LOCATE x-1,10: PRINT " "
        LOCATE x,10: PRINT CHR$(250)
    NEXT
GOTO MAIN
```

### `LOG(x)`

Función. Devuelve el logaritmo natural de `x`. Implica el uso de números reales.

### `LOG10(x)`

Función. Devuelve el logaritmo en base 10 de `x`. Implica el uso de números reales.

### `LOWER$(cadena)`

Función. Devuelve `cadena`con todos sus carácteres pasados a minúsculas.

``` basic
C$="AmsTRaD"
PRINT LOWER$(C$)
PRINT UPPER$(C$)
```

### `MASK mascara[,puntoinicial]`

Comando. Solo disponible a partir de BASIC 1.1. Cualquier programa compilado usando este comando solo funcionará en ordenadores Amstrad CPC664 y CPC6128. Establece la máscara o plantilla que se utilizará al dibujar líneas. El valor binario `mascara` debe estar en el rango de 0 a 255. Su significado es activar (1) o desactivar (0) los bits de cada grupo adyacente de 8 píxeles. `puntoinicial` determina si el primer punto de la línea se debe dibujar (1) o no (0).

``` basic
MODE 0
MASK 15   ' mascara = 00001111
GRAPHICS PAPER 3
DRAW 640,0
```

### `MAX(a,b[,c,d,e...])`

Función. Devuelve el máximo valor de entre los proporcionados como parámetros. BASC soporta tanto el uso de números enteros como reales.

### MEMORY maxdir

Comando. Establece `maxdir` como la dirección máxima en memoria que puede llegar a ocupar el binario generado por el porgrama compilado. Si se supera, la compilación falla.

``` basic
MEMORY &A6FB  ' En &A6FC comienzan las variables del Firmware/AMSDOS
```

### `MERGE fichero`

Comando. Lee `fichero` de disco o cinta y remplaza el programa en memoria. BASC no soporta este comando y producirá un error si lo encuentra como parte del código del programa. Para añadir otros binarios (o remplazarlos tras su uso) se recomienda utilizar el comando `LOAD`.

### `MID$(cadena,inicio[,n])`

Functión y Comando. Como función en una expresión, devuelve el número de carácteres `n` desde la posición `inicio`. Como comando, puede utilizarse para remplazar una parte de la cadena. La escritura en memoria siempre es delicada y el programador debe tener cuidado de no sobrepasar los límites de almacenamiento de la cadena o el programa se comportará de manera inesperada.

``` basic
C$="AMSTRAD"
PRINT MID$(C$,3,3)
MID$(C$,3,3) = "BBB"
PRINT C$
```

### `MIN(a,b[,c,d,e,f...]`

Función. Devuelve el mínimo valor de entre los proporcionados como parámetros. BASC soporta tanto el uso de números enteros como reales.

### `MODE n`

Comando. Cambia el modo de pantalla a 0, 1 o 2.

### `MOVE x,y[tinta[,modo]]`

Comando. Mueve el cursor gráfico a la posición `x` e `y`. Si proporciona un tercer parámetro, este indica la `tinta`con el color a usar a partir de ese momento. El cuarto parámetro indica el modo o máscara a aplicar entre cada punto de las líneas y el fondo, con los valores que se indican a continuación:

| Valor | Modo  |
|-------|-------|
|   0   | Fill (normal) |
|   1   | XOR (OR eXclusivo) |
|   2   | AND   |
|   3   | OR    |

### `MOVER x,y[,tinta[,modo]]`

Comando. Igual que `MOVE`, pero siendo `x` e `y` valores relativos a la posición actual en vez de posiciones absolutas.

### `NEW`

Comando. En Locomotive BASIC borra el programa actual y sus variables de la memoria. BASC emite código para reiniciar la máquina (CALL 0).

### `NEXT variable`

Comando. Delimita un bucle `FOR`.

### `ON n GOSUB lista de etiquetas`

Comando. Salta a la etiqueta de la lista indicada por `n` y regresa tras encontrar un `RETURN`. Las etiquetas empiezan en 1. Pueden ser números de línea o identificadores declarados con `LABEL`.

### `ON n GOTO lista de etiquetas`

Comando. Salta a la etiqueta de la lista indicada por `n`. Las etiquetas empiezan en 1. Pueden ser números de línea o identificadores declarados con `LABEL`.

### `ON BREAK GOSUB etiqueta`

Comando. Este comando salta a `etiqueta` cuando un programa se interrumpe por una pulsación doble de la tecla `ESC`. Los programas compilados por BASC no pueden detenerse de esta manera por lo que este comando es ignorado y se emite una alerta si aparece como parte del código a compilar.

### `ON BREAK STOP`

Comando. Desactiva la última sentencia `ON BREAK GOSUB` que se haya emitido. Como Los programas compilados por BASC ignoran la sentencia anterior, este comando también es ignorado y se emite una alerta si aparece como parte del código a compilar.

### `ON ERROR GOTO etiqueta`

Comando. Este comando salta a `etiqueta` cuando se detecta un error en un programa BASIC durante su ejecución. Este mecanismo requiere que el programa sea interpretado, no compilado, así que BASC ignora este comando y emite una alerta si aparece como parte del código a compilar.

### `ON SQ (canal) GOSUB etiqueta`

Comando. Registra el salto a una etiqueta como una interrupción que debe ejecutarse cuando hay un "slot" libre en la cola de sonido indicada por `canal`. El valor de `canal` debe ser un valor de entre los de la siguiente lista:
* 1 = canal A
* 2 = canal B
* 4 = canal C

``` basic
ON SQ(2) GOSUB INSERTAenB
```

### `OPENIN fichero`

Comando. Abre el fichero indicado por `fichero` para lectura. Se puede consultar un ejemplo en el apartado sobre la función `EOF`. En caso de error produce el código 31 que puede ser consultado con `ERR`. Solo un fichero puede estar abierto a la vez para lectura.

### `OPENOUT fichero`

Comando. Abre el fichero indicado por `fichero` para escritura. En caso de error produce el código 31 que puede ser consultado con `ERR`. Solo un fichero puede estar abierto a la vez para escritura.

### `ORIGIN x,y[,izq,der,arriba,abajo]`

Comando. Establece la posición actual del cursor gráfico. Es posible, además, establecer las dimensiones de la ventana para gráficos, si se proporcionan las coordenadas opcionales `izq`, `der`, `arr` y `abajo`. Una llamada a `MODE` restablece las dimensiones.

``` basic
CLS:BORDER 13 
LABEL BUCLE
    ORIGIN 0,0,50,590,350,50  
    DRAW 540,350 
GOTO BUCLE
```

### `OUT puerto,n`

Comando. Envía el valor `n` al puerto hardware indicado por `puerto`.

### `PAPER [#canal,]tinta`

Comando. Fija la tinta a utilizar como color de fondo. Si no se indica un `canal` se aplica sobre el canal #0. **Ver nota en `PEN`.**

``` basic
MODE 1
INK 1,3  ' color rojo
PAPER 1
CLS
```

### `PEEK(direccion)`

Función. Devuelve el contenido del byte de memoria en `dirección`.

``` basic
' Imprime los 5 bytes de un numero real
N! = PI
FOR I=0 TO 4
    PRINT HEX$(PEEK(@N!+I),2);" ";
NEXT
```
### `PEN [#canal,]tinta`

Comando. Fija `tinta` como el color de dibujo para el canal indicado (#0 por defecto).

``` basic
MODE 1
INK 2,3  ' color rojo
PEN 2
PRINT "HOLA MUNDO"
```

**NOTA:** Los valores de `PAPER` y `PEN` no se aplican de inmediato, se almacenan en las variables del Firmware y se mandan desde la rutina llamada por las interrupciones al hardware una vez por "frame". Si se cambian estos valores desde una rutina llamada por `EVERY` o `AFTER` muy probablemnte no surta efecto.

### `PI`

Función. Devuelve el valor real 3.14159265

### `PLOT x,y[,tinta[,modo]]`

Comando. Desplaza el cursor gráfico a la posición `x` e `y` y dibuja un punto. Si se indica una `tinta` queda establecida como el color activo. Moves graphics cursor and plots colour from current position. El cuarto parámetro indica el modo o máscara a aplicar entre cada punto de la línea y el fondo, con los valores que se indican a continuación:

| Valor | Modo  |
|-------|-------|
|   0   | Fill (normal) |
|   1   | XOR (OR eXclusivo) |
|   2   | AND   |
|   3   | OR    |

### `PLOTR x,y[,tinta[,modo]]`

Comando. Su funcionamiento es igual a `PLOT`salvo porque `x` e `y` son posiciones relavivas a la posición actual del cursor gráfico y no posiciones absolutas.

### `POKE dirección,n`

Comando. Escribe en la posición de memoria `dirección` el valor (byte) `n`. Si `n` es mayor que 255 el valor se trunca.

``` basic
CLS
SUB MEMCOPY(org, dest, n)
    FOR I=0 TO n
        byte = PEEK(org+I)
        POKE dest+I,byte
    NEXT
END SUB

A$ = "HOLA MUNDO"
B$ = ""
CALL MEMCOPY(@A$,@B$,11) ' 10 carácteres mas byte de longitud
PRINT B$
```

### `POS(#canal)`

Función. Devuelve la posición actual en X del cursor de texto para el `canal` indicado (#0 por defecto).

``` basic
MODE 1
PRINT POS(#0), VPOS(#0)
```

### `PRINT [#canal,][lista de elementos]`

Comando. `PRINT` es un comando muy versatil y con múltiples opciones. Por ello, queda fuera del alcance de este documento y se invita al lector a consultar las obras listadas en el capítulo sobre `Referencias`. En cualquier caso, BASC **no soporta el uso de patrones de formato mediante USING**.

### `RAD`

Comando. Establece que las funciones que devuelven grados den los resultados en radianes. Es el comando contrapuesto a `DEG`.

``` basic
DEG
PRINT SIN(90.0)
RAD
PRINT SIN(90.0)
```

### `RANDOMIZE [n]`

Comando. La implementación soportada por BASC difiere un poco del comportamiento habitual de este comando en Locomotive BASIC. Si se usa `RANDOMIZE` sin parámetros, BASC lo interpreta como si se hubiera usado `RANDOMIZE TIME`. El uso de `RANDOMIZE` y `RND` implica el uso de números reales.

``` basic
RANDOMIZE
FOR I=1 TO 20
    PRINT RND
NEXT
```

### `READ lista-de-variables`

Comando. Lee el siguiente dato de los declarados con `DATA` y lo asigna a la variable correspondiente de su lista. El programador es el responsable de que el tipo de dato actual y el tipo de la variable coincidan.

``` basic
CLS
FOR I=0 TO 5
    READ nom$
    PRINT "Nombre:", nom$
NEXT
END

DATA "Xavier","Ross","Gada",
DATA "Anabel","Rachel","Elvira"
```

### `READIN lista-de-variables`

Comando. Es equivalente a `INPUT #9`, es decir, lee datos del fichero de entrada abierto y los asigna a la lista de variables. Actualmente, BASC no soporta variables reales en este comando.

### `RECORD nombre;lista-de-variables`

Comando. Permite declarar un registro que puede aplicarse a variables de tipo cadena (`$`) para crear estructuras de datos. Se invita al lector a consultar el apartado sobre `Estructuras con RECORD` en la sección `Tipos y variables` del capítulo `Peculiaridades del compilador`.

```basic
DECLARE A$ FIXED 13  ' No es obligatorio, pero reduce el consumo de memoria
RECORD persona; nom$ FIXED 10, edad ' Requiere 13 bytes de memoria

A$.persona.nom$ = "Juan"
A$.persona.edad = 20
```

### `RELEASE canal`

Comando. Los sonidos encolados en un determinado `canal`pueden contener un estado de `espera`. Este comando libera dichos sonidos. `canal` es un número entero que indica los canales afectados:

* 1 = canal A
* 2 = canal B
* 4 = canal C

``` basic
RELEASE 7 'libera los sonidos en los tres canales
```

### `REM texto`

Comando. Permite añadir comentarios al texto. Un alias es el symbolo `'`.

### `REMAIN(temporizador)`

Función. Desactiva el evento asignado a `temporizador`(en el rango 0..3) y devuelve cuantos "ticks" quedaban para su activación. Dichos eventos se registran con `AFTER` o `EVERY`.

### `RENUM nueva-linea, linea-origen, incremento`

Comando. En Locomotive BASIC permite renumerar las líneas de código de un programa en BASIC. En un programa compilado no tiene sentido. BASC ignora este comando y emite una advertencia si lo encuentra en el código a compilar.

### `RESTORE [etiqueta]`

Comando. Establece que el siguiente dato a leer con `READ` sea el primer valor declarado con `DATA` encontrado tras la `etiqueta` indicada, sea esta un número de línea o un identificador declarado con `LABEL`. Si no se especifica ninguna `etiqueta` el comando establece el primer dato declarado con `DATA` encontrado en el programa.

```basic
LABEL BUCLE
FOR N=1 TO 5 
    READ A$ 
    PRINT A$;" "; 
    DATA datos,"a leer",una,"y otra",vez   
NEXT 
PRINT 
RESTORE 
GOTO BUCLE
```

### `RESUME`

Comando. Restaura la ejecución de un programa detenido tras un evento de error manejado por `ON ERROR GOTO`. Este mecanismo requiere que el programa sea interpretado, no compilado, así que BASC ignora este comando y emite una alerta si aparece como parte del código a compilar.

### `RETURN`

Comando. Continua la ejecución del programa en la siguiente instrucción al último `GOSUB` ejecutado.

### `RIGHT$(cadena,n)`

Función. Devuelve los primeros `n` carácteres comenzando la cuenta por la derecha de `cadena`.

``` basic
PRINT RIGHT$("AMSTRAD", 3)
```

### `RND[(0)]`

Función. Devuelve un número pseudoaleatorio en el rango [0.0 - 1.0]. Si se llama con el parámetro 0 (`RND(0)`) devuelve, de nuevo, el último número que se generó. El uso de `RANDOMIZE` y `RND` implica el uso de números reales.

``` basic
RANDOMIZE
FOR I=1 TO 20
    PRINT RND
NEXT
```

### `ROUND(x[,n])`

Función. Redondea el número real `x` a la posición decimal indicada por `n` (0 por defecto).

``` basic
FOR I=0 TO 4
    PRINT ROUND(PI, I)
NEXT
PRINT ROUND(PI,-3)
```

### `RUN etiqueta o fichero`

Comando. En BASIC este comando permite ejecutar un programa en memoria desde la `etiqueta` indicada o carga el programa desde `fichero` y lo ejecuta desde el principio. BASC solo soporta la primera de las versiones, haciendo que el programa salte a `etiqueta` como si se tratara de un `GOTO`.

### `SAVE fichero[,tipo][,dirección,tamaño[,entrada]]`

Comando. En BASIC permite grabar un programa a disco o cassette. BASC solo permite grabar una región de memoria como fichero binario. Por tanto, el `tipo` del fichero siempre se considera (y debe indicarse así si se van a utilizar el resto de parámetros) B. Como referencia, los tipos permitidos por la instrucción en BASIC son:

* A - Texto (ASCII)
* P - Fichero protegido
* B - Binario

El resto de parámetros opcionales son:

| Parámetro | Función      |
|-----------|--------------|
|dirección  | Dirección de memoria desde donde comenzar el volcado. |
| tamaño    | Total de bytes que se deben volcar al fichero. |
| entrada   | Dirección donde empezar la ejecución del binario si se carga con `RUN`.|

``` basic
MODE 1
PAPER 3
CLS
SAVE "pantalla.bin",B,&C000,&3FFF
PAPER 0
CLS
LOAD "pantalla.bin"
```

### `SGN(x)`

Función. Devuelve -1 si `x` es menor que 0, devuelve 0 si `x`es igual a 0 o devuelve 1 si `x` es mayor que cero.

``` basic
PRINT SGN(PI)
```

### `SIN(x)`

Función. Devuelve el seno de `x`. Implica el uso de números reales.

### `SOUND canal,perido-tono,duracion,volumen,env,ent,ruido`

Comando. `SOUND` es uno de los principales puntos fuertes de Locomotive BASIC comparado con el resto de las versiones BASIC de la época. Es un comando muy versátil que proporcina un acceso muy amplio al chip de audio de los Amstrad CPC. Por tanto, el lector hará bien en recurrir a los libros de la sección `Referencias` para aprender todos los entresijos de este comando.

``` basic
ENV 2,127,0,0,127,0,0,127,0,0,127,0,0,127,0,0
SOUND 1,1000,0,12,2
SOUND 2,900,0,12,2
```

### `SPACE$(n)`

Función. Devuelve una cadena de texto con tantos espacios en blanco como los indicados por `n`.

### `SPEED INK t1,t2`

Comando. `INK` y `BORDER` permiten especificar dos colores entre los que se alternará. `SPEED INK` permite especificar cuanto tiempo estará visible cada uno de los dos colores. Los tiempos `t1` y `t2` se indican en "frames" (50 por segundo).

``` basic
SPEED INK 150,50 ' 3 segundos y 1 segundo
BORDER 0,1
```

### `SPEED KEY espera,repetición`

Comando. Si se mantiene pulsada una tecla, esta comenzará a repetirse cuando se supera su tiempo de `espera`, cada vez que venza el tiempo de `repetición`. Los tiempos deben darse en "frames" (50 por segundo) en un rango de 1 a 255.

### `SPEED WRITE n`

Comando. Cambia la velocidad (en baudios) a la que se escribe en cassette. `n`puede ser 1 (2000 baudios) o 0 (1000 baudios).

### SQ canal

Función. Permite comprobar el número de entradas libres en la cola para el `canal` indicado (1,2 o 4). Determina si dicho canal está activo y, en caso contrario, por qué la entrada activa de la cola (si la hay) está en espera. El resultado es un entero que codifica la información como sigue:

* Los bits 0, 1 y 2 indican el número de huecos libres en la cola.
* Los bits 3, 4 y 5 indican el estado de socronización de la primera nota en la cola.
* El bit 6 se activa si la primera nota está en espera.
* El bit 7 se activa si el canal está activo ahora mismo.

``` basic
SOUND 65,100,100
PRINT BIN$(SQ(1),8) ' debe imprimir 01000011
```

### `SQR(x)`

Función. Devuelve la raíz cuadrada de `x`. Implica el uso de números reales.

### `STOP`

Comando. En Locomotive BASIC detiene la ejecución del programa y devuelve el control al interprete. El usuario puede retomar la ejecución con `CONT`. Puesto que no tiene mucho uso en un programa compilado, BASC reutiliza esta instrucción para formar un reinicio de la máquina (CALL 0).

### `STR$(x)`

Función. Devuelve una cadena con el número `x` convertido en texto.

``` basic
PRINT "PI = " + STR$(PI)
```

### `STRING$(n,carácter)`

Función. Devuelve una cadena de texto con el carácter indicado repetido `n` veces.

``` basic
MODE 1
LOCATE 1,10
PRINT STRING$(40,250)
```

### `SUB [(parámetros)] [ASM]`

Comando. Proveniente de Locomotive BASIC 2 Plus, `SUB` permite declarar procedimientos con parámetros. Debe utilizarse `CALL` para llamar a un procedimiento declarado con `SUB`. El procedimiento debe declararse antes de que aparezca en el código una llamada al mismo. Si se utiliza la cláusula `ASM`, BASC entiende que el cuerpo del procedimiento va a ser mayoritariamente código en ensablador que no va a usar el mecanismo de memoria temporal, por lo que no se encarga de apilarlo y restaruralo después de cada llamada.

Se recomienda al programador leer las secciones `Soporte para procedimientos` y `Uso de código ensamblador` del capítulo `Peculiaridades del compilador` para obtener más información sobre el tratamiento de los parámetros o el soporte a la recursividad.

``` basic
SUB miUSING(n,long)
    ' Imprime el número N con una LONG fija, rellenando
    ' con 0 los espacios sobrantes a la izquerda.
    n$ = STR$(n)
    text$ = STRING$(long,48)  ' rellena con 0
    digitos = LEN(n$)
    inicio = long - LEN(n$) + 1
    MID$(text$,inicio,digitos)=n$
    PRINT text$
END SUB

num=1234
CALL miUSING(num,8)
```

### `SYMBOL carácter,valor1,valor2,...,valor8`

Comando. Redefine el símbolo indicado por el número `carácter`. Dicho número debe estar disponible para redefinirse (ver `SYMBOL AFTER`). Cada caracter viene representado por una matriz de 8x8 píxeles. Los siguientes 8 valores definen cada fila del carácter. El valor es la suma de píxeles de esa línea que deben pintarse con el color de la tinta actual. Cada pixel de la línea tiene un valor númerico tal y como sigue:

| pixel 1 | pixel 2 | pixel 3 | pixel 4 | pixel 5 | pixel 6 | pixel 7 | pixel 8 |
|---------|---------|---------|---------|---------|---------|---------|---------|
|  128    |    64   |   32    |    16   |    8    |    4    |    2    |    1    |

``` basic
SYMBOL AFTER 240
SYMBOL 240,&00,&00,&74,&7E,&6C,&70,&7C,&30
SYMBOL 241,&7E,&FD,&80,&80,&80,&80,&40,&00
SYMBOL 242,&00,&00,&08,&00,&00,&00,&00,&00
SYMBOL 243,&00,&00,&00,&00,&10,&0C,&00,&00
SYMBOL 244,&60,&F8,&FC,&FC,&FC,&FC,&FC,&FC
SYMBOL 245,&00,&00,&60,&60,&30,&30,&00,&00
SYMBOL 246,&00,&00,&00,&00,&0C,&0C,&00,&00
SYMBOL 247,&FC,&FC,&EC,&CC,&CC,&CC,&00,&00
SYMBOL 248,&00,&00,&00,&00,&00,&00,&EE,&EE

MODE 0
PRINT CHR$(22)+CHR$(1)  ' Modo transparente de escritura ON
LOCATE 5,2:PEN 11:PRINT CHR$(240);
LOCATE 5,2:PEN 1:PRINT CHR$(241);
LOCATE 5,2:PEN 8:PRINT CHR$(242);
LOCATE 5,2:PEN 3:PRINT CHR$(243);
LOCATE 5,3:PEN 10:PRINT CHR$(244);
LOCATE 5,3:PEN 6:PRINT CHR$(245);
LOCATE 5,3:PEN 11:PRINT CHR$(246);
LOCATE 5,4:PEN 9:PRINT CHR$(247);
LOCATE 5,4:PEN 3:PRINT CHR$(248);
PRINT CHR$(22)+CHR$(0)  ' Modo transparente de escritura OFF
```

### `SYMBOL AFTER n`

Comando. Fija el número del carácter a partir del cuál se pueden redefinir. `n` debe ser un valor entre 1 y 256. Por defecto, los programas tienen disponibles los carácteres desde el valor 240 al 255. El valor disponible en un programa compilado será el valor más bajo de los utilizados en `SYMBOL AFTER` si existen múltiples llamadas.

BASC reserva 8 bytes por cada carácter que puede redefinirse. Si no se va a utilizar esta capacidad es recomendable comenzar el programa con `SYMBOL AFTER 256`, lo que evitará que se reserve memoria. Para un ejemplo, ver `SYMBOL`.

### `TAG [#canal]`

Comando. Redirige la salida de texto asociada a `canal` (#0 por defecto) para utilizar como el cursor gráfico en vez del cursor de texto. Esto permite mezclar texto con gráficos o desplazar el texto por píxeles en vez de por bloques de 8x8.

``` basic
MODE 2
BORDER 9
INK 0,12: INK 1,0
LABEL BUCLE
TAG
FOR n=1 TO 100
    MOVE 200+n,320+n
    IF n<70 THEN
        PRINT"Hola";
    ELSE
        PRINT"Adios";
    END IF
NEXT
GOTO BUCLE
```

### TAGOFF [#canal]

Comando.Desactiva el uso del cursor gráfico para el canal de texto indicado (#0 por defecto). Ver `TAG`.

### `TAN(x)`

Función. Devuelve la tangente del ángulo `x`. Implica el uso de números reales.

``` basic
PRINT TAN(45)
```

### `TEST(x,y)`

Función. Devuelve el valor de la tinta en la posición de pantalla `x` e `y`.

``` basic
MODE 1
PRINT TEST(320,200)
PLOT 320,200,1
PRINT TEST(320,200)
```

### `TESTR(x,y)`

Función. Igual que `TEST` pero siendo `x` e `y` posiciones relativas y no absolutas.

### `TIME`

Función. Devuelve el tiempo transcurrido desde el encendido de la máquina. Mide el tiempo en pasos de 1/300 segundos. Requiere que las interrupciones estén activas, por lo que `DI` y ciertas operaciones de disco/cinta harán que deje de contarse el tiempo. El valor devuelto es un número real.

```basic
CLS
T! = TIME
FOR i=1 to 10
    FOR j=1 to 1000
        s = 1000 + j
    NEXT j
    PRINT ".";
NEXT i
PRINT " FIN!"
PRINT "Tiempo="; (TIME-T!)/300.0; "s"
```

### `TROFF`

Comando. Desactiva la impresión de trazas. BASC ignora este comando si lo encuentra como parte del código y emite una advertencia. Ver `TRON`.

### `TRON`

Comando. En Locomotive BASIC permite emitir trazas según se interpreta un programa. BASC ignora este comando si lo encuentra como parte del código y emite una advertencia.

### `UNT(n)`

Comando. Convierte un valor sin signo (como una dirección de memoria) en el rango 0..65535 en un entero con signo en el rango -32768..+32767.

``` basic
PRINT UNT(&FF66) ' debe imprimir el valor -154
```

### `UPPER$(cadena)`

Función. Devuelve `cadena`con todos sus carácteres pasados a mayúsculas.

``` basic
C$="AmsTRaD"
PRINT LOWER$(C$)
PRINT UPPER$(C$)
```

### `VAL(cadena)`

Función. Devuelve el primer **número entero** encontrado en `cadena`. Por tanto, y a diferencia del intérprete de BASIC en las máquinas Amstrad CPC, `VAL` no se puede usar para extraer un número real de una cadena de texto. 

```basic
PRINT VAL("15") + 15
```

### `VPOS(#canal)`

Función. Devuelve la posición actual en Y del cursor de texto para el `canal` indicado (#0 por defecto).

``` basic
MODE 1
PRINT POS(#0), VPOS(#0)
```

### `WAIT puerto,mascara[,inversion]

Comando. Detiene la ejecución hasta que se lee un valor esperado desde el `puerto` de entrada/salida especificado. El comando realiza una operación de **AND** con la `mascara` indicada y una operación de **XOR** con el valor de `inversion` (si se suministra). La ejecución solo continúa si el resultado obtenido es distinto de 0.

```basic
WAIT &FF34,20,25
```

### `WEND`

Comando. Marca el final de un buclo `WHILE`.

### `WHILE condición`

Comando. Marca el inicio de un bucle del que solo se sale cuando `condición` es cierta.

``` basic
CLS
PRINT "Espera de 10 segundos": T! = TIME + 3000
WHILE TIME<T!
    SOUND 1,0,100,15
WEND
SOUND 129,40,30,15
```

### `WIDTH n`

Comando. Especifica el ancho en caracteres máximo a soportar por la impresora. BASC no soporta este comando y emitirá una advertencia si lo encuentra en el código a compilar.

### `WINDOW [#canal,]izq,derecha,arriba,abajo`

Comando. Define una nueva ventana de texto asociada a `canal` que debe estar en el rango #0..#7 (#0 por defecto).

``` basic
MODE 1
WINDOW #1,1,40,20,25
WINDOW #2,2,39,21,24
PAPER 0
PAPER #1,1
PAPER #2,2
CLS#0
CLS#1
CLS#2
```

### `WINDOW SWAP canal1,canal2`

Comando. Intercambia las características de las ventanas de texto indicadas por `canal1` y `canal2`.

``` basic
MODE 1
WINDOW #1,1,40,20,25
PAPER 0
PAPER #1,2
CLS#0
CLS#1
WINDOW SWAP 0,1
PRINT "VENTANA 0"
```
### `WRITE [#canal],dato1,dato2,...`

Comando. En Locomotive BASIC escribe los valores proporcionados en el canal indicado (#0 por defecto). BASC ignora el valor del canal y siempre lo considera #9, el canal para operaciones con ficheros. Por tanto, `WRITE` se puede utilizar para escribir en un fichero mientras que `READIN` serviría para leer los datos de vuelta. Los números reales no están soportados, solo se pueden escribir datos enteros o cadenas de texto.

``` basic
A=15
NOM$="Juan"
OPENOUT "DATOS.TXT"
WRITE #9,NOM$,A
CLOSEOUT
```

### `XPOS`

Función. Devuelve la posición en X del cursor gráfico.

``` basic
MODE 1
PRINT XPOS;YPOS
MOVE 320,200
PRINT XPOS;YPOS
```

### `YPOS`

Función. Devuelve la posición en Y del cursor gráfico. Ver `XPOS`.

### ZONE n

Comando. Cambia la anchura (13 por defecto) de la zona de escritura utilizada por `PRINT` cuando se separan elementos con comas.

``` basic
CLS
PRINT "A","B"
ZONE 4
PRINT "A","B"
```
