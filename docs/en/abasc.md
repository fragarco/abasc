<!-- omit in toc -->
ABASC: USER MANUAL
==================
**A BASIC cross compiler for the Amstrad CPC machines**

- [Introduction](#introduction)
  - [Influences](#influences)
  - [A Brief Overview of the Locomotive BASIC Versions](#a-brief-overview-of-the-locomotive-basic-versions)
    - [Version 1.0](#version-10)
    - [Version 1.1](#version-11)
    - [Version 2](#version-2)
    - [Version 2 Plus](#version-2-plus)
- [References](#references)
- [Syntax Supported by ABASC](#syntax-supported-by-abasc)
    - [Example 1 (syntax compatible with BASIC 1.0 and 1.1)](#example-1-syntax-compatible-with-basic-10-and-11)
    - [Example 2 (syntax using several BASIC 2 enhancements)](#example-2-syntax-using-several-basic-2-enhancements)
- [Additional Tools](#additional-tools)
- [Using the Compiler](#using-the-compiler)
    - [Options](#options)
  - [Creating a Project Using BASPRJ](#creating-a-project-using-basprj)
- [Peculiarities of the Compiler](#peculiarities-of-the-compiler)
  - [Types and Variables](#types-and-variables)
    - [String Handling](#string-handling)
    - [Arrays](#arrays)
    - [RECORD Structures](#record-structures)
  - [Functions and Procedures](#functions-and-procedures)
  - [Using Assembly Code](#using-assembly-code)
  - [Pointers](#pointers)
  - [Memory Management](#memory-management)
  - [Using the Firmware](#using-the-firmware)
  - [Libraries](#libraries)
- [Commands and Language Syntax](#commands-and-language-syntax)
  - [Notation](#notation)
  - [List of Commands and Functions](#list-of-commands-and-functions)
    - [`ABS(<numeric expression>)`](#absnumeric-expression)
    - [`AFTER delay[,timer] GOSUB label`](#after-delaytimer-gosub-label)
    - [`ASC(string)`](#ascstring)
    - [`ASM string[,string]*`](#asm-stringstring)
    - [`ATN(x)`](#atnx)
    - [`AUTO linenumber[,increment]`](#auto-linenumberincrement)
    - [`BIN$(number,digits)`](#binnumberdigits)
    - [`BORDER colour1[,colour2]`](#border-colour1colour2)
    - [`CALL address[, list of parameters]`](#call-address-list-of-parameters)
    - [`CAT`](#cat)
    - [`CHAIN`](#chain)
    - [`CHAIN MERGE string`](#chain-merge-string)
    - [`CHR$(x)`](#chrx)
    - [`CINT(x)`](#cintx)
    - [`CLEAR`](#clear)
    - [`CLEAR INPUT`](#clear-input)
    - [`CLG [ink]`](#clg-ink)
    - [`CLOSEIN`](#closein)
    - [`CLOSEOUT`](#closeout)
    - [`CLS [#x]`](#cls-x)
    - [`CONST`](#const)
    - [`CONT`](#cont)
    - [`COPYCHR$(#channel)`](#copychrchannel)
    - [`COS(x)`](#cosx)
    - [`CREAL(x)`](#crealx)
    - [`CURSOR system[, user]`](#cursor-system-user)
    - [`DATA list-of-constants`](#data-list-of-constants)
    - [`DECLARE variable[$ FIXED length],...`](#declare-variable-fixed-length)
    - [`DEC$(number, pattern)`](#decnumber-pattern)
    - [`DEF FN name(parameters) = expression`](#def-fn-nameparameters--expression)
    - [`DEFINT, DEFSTR, DEFREAL`](#defint-defstr-defreal)
    - [`DEG`](#deg)
    - [`DELETE low-high`](#delete-low-high)
    - [`DERR`](#derr)
    - [`DI`](#di)
    - [`DIM array(index1, index2, ...) [FIXED length]`](#dim-arrayindex1-index2--fixed-length)
    - [`DRAW x,y[,i[,mode]]`](#draw-xyimode)
    - [`DRAWR x,y[,i[,mode]]`](#drawr-xyimode)
    - [`EDIT line[-line]`](#edit-line-line)
    - [`EI`](#ei)
    - [`END`](#end)
    - [`END FUNCTION`](#end-function)
    - [`END SUB`](#end-sub)
    - [`ENT envelope_number, sections`](#ent-envelope_number-sections)
    - [`ENV envelope_number, sections`](#env-envelope_number-sections)
    - [`EOF`](#eof)
    - [`ERASE arrayname`](#erase-arrayname)
    - [`ERL`](#erl)
    - [`ERR`](#err)
    - [`ERROR integer`](#error-integer)
  - [`EVERY time[,timer] GOSUB label`](#every-timetimer-gosub-label)
    - [`EXIT FOR`](#exit-for)
    - [`EXIT WHILE`](#exit-while)
    - [`EXP(x)`](#expx)
    - [`FILL`](#fill)
    - [`FIX(x)`](#fixx)
    - [`FOR variable = start TO end STEP increment`](#for-variable--start-to-end-step-increment)
    - [`FRAME`](#frame)
    - [`FRE(x)`](#frex)
    - [`FUNCTION name(parameters) [ASM]`](#function-nameparameters-asm)
    - [`GOSUB label`](#gosub-label)
    - [`GOTO label`](#goto-label)
    - [`GRAPHICS PAPER ink`](#graphics-paper-ink)
    - [`GRAPHICS PEN ink, mode`](#graphics-pen-ink-mode)
    - [`HEX$(x, digits)`](#hexx-digits)
    - [`HIMEM`](#himem)
    - [`IF expression THEN expression ELSE expression END IF`](#if-expression-then-expression-else-expression-end-if)
    - [`INK ink, color1[, color2]`](#ink-ink-color1-color2)
    - [`INKEY(key)`](#inkeykey)
    - [`INKEY$`](#inkey)
    - [`INP(port)`](#inpport)
    - [`INPUT [#channel,] "prompt"[;] variable1, variable2,...`](#input-channel-prompt-variable1-variable2)
    - [`INSTR([start_position,] string1, string2)`](#instrstart_position-string1-string2)
    - [`INT(x)`](#intx)
    - [`JOY(joystick)`](#joyjoystick)
    - [`KEY key, string`](#key-key-string)
    - [`KEY DEF key, repeat[,<normal>[,<shift>[,<ctrl>]]]`](#key-def-key-repeatnormalshiftctrl)
    - [`LABEL label`](#label-label)
    - [`LEFT$(string, n)`](#leftstring-n)
    - [`LEN(string)`](#lenstring)
    - [`LET variable = expression`](#let-variable--expression)
    - [`LINE INPUT [#channel,][;][string;]<variable>`](#line-input-channelstringvariable)
    - [`LIST [line range][, #channel]`](#list-line-range-channel)
    - [`LOAD filename[,address]`](#load-filenameaddress)
    - [`LOCATE [#channel,] x, y`](#locate-channel-x-y)
    - [`LOG(x)`](#logx)
    - [`LOG10(x)`](#log10x)
    - [`LOWER$(string)`](#lowerstring)
    - [`MASK mask[,startPoint]`](#mask-maskstartpoint)
    - [`MAX(a, b[, c, d, e...])`](#maxa-b-c-d-e)
    - [`MEMORY maxAddress`](#memory-maxaddress)
    - [`MERGE filename`](#merge-filename)
    - [`MID$(string, start[, n])`](#midstring-start-n)
    - [`MIN(a, b[, c, d, e, f...])`](#mina-b-c-d-e-f)
    - [`MODE n`](#mode-n)
    - [`MOVE x, y[, ink[, mode]]`](#move-x-y-ink-mode)
    - [`MOVER x, y[, ink[, mode]]`](#mover-x-y-ink-mode)
    - [`NEW`](#new)
    - [`NEXT variable`](#next-variable)
    - [`ON n GOSUB list_of_labels`](#on-n-gosub-list_of_labels)
    - [`ON n GOTO list_of_labels`](#on-n-goto-list_of_labels)
    - [`ON BREAK GOSUB label`](#on-break-gosub-label)
    - [`ON BREAK STOP`](#on-break-stop)
    - [`ON ERROR GOTO label`](#on-error-goto-label)
    - [`ON SQ(channel) GOSUB label`](#on-sqchannel-gosub-label)
    - [`OPENIN file`](#openin-file)
    - [`OPENOUT file`](#openout-file)
    - [`ORIGIN x,y[,left,right,top,bottom]`](#origin-xyleftrighttopbottom)
  - [`OUT port,n`](#out-portn)
    - [`PAPER [#channel,]ink`](#paper-channelink)
    - [`PEEK(address)`](#peekaddress)
    - [`PEN [#channel,]ink`](#pen-channelink)
    - [`PI`](#pi)
    - [`PLOT x,y[,ink[,mode]]`](#plot-xyinkmode)
    - [`PLOTR x,y[,ink[,mode]]`](#plotr-xyinkmode)
    - [`POKE address,n`](#poke-addressn)
    - [`POS(#channel)`](#poschannel)
    - [`PRINT [#channel,][list of items]`](#print-channellist-of-items)
    - [`RAD`](#rad)
    - [`RANDOMIZE [n]`](#randomize-n)
    - [`READ variable-list`](#read-variable-list)
    - [`READIN variable-list`](#readin-variable-list)
    - [`RECORD name;variable-list`](#record-namevariable-list)
    - [`RELEASE channel`](#release-channel)
    - [`REM text`](#rem-text)
    - [`REMAIN(timer)`](#remaintimer)
    - [`RENUM new-line, origin-line, step`](#renum-new-line-origin-line-step)
    - [`RESTORE [label]`](#restore-label)
    - [`RESUME`](#resume)
    - [`RETURN`](#return)
    - [`RIGHT$(string, n)`](#rightstring-n)
    - [`RND[(0)]`](#rnd0)
    - [`ROUND(x[,n])`](#roundxn)
    - [`RUN [label | file]`](#run-label--file)
    - [`SAVE file[,type][,address,size[,entry]]`](#save-filetypeaddresssizeentry)
    - [`SGN(x)`](#sgnx)
    - [`SHARED variable | array [,variable | array]`](#shared-variable--array-variable--array)
    - [`SIN(x)`](#sinx)
    - [`SOUND channel,period,duration,volume,env,ent,noise`](#sound-channelperioddurationvolumeenventnoise)
    - [`SPACE$(n)`](#spacen)
    - [`SPEED INK t1,t2`](#speed-ink-t1t2)
    - [`SPEED KEY delay,repeat`](#speed-key-delayrepeat)
    - [`SPEED WRITE n`](#speed-write-n)
    - [`SQ channel`](#sq-channel)
    - [`SQR(x)`](#sqrx)
    - [`STOP`](#stop)
    - [`STR$(x)`](#strx)
    - [`STRING$(n,character)`](#stringncharacter)
    - [`SUB [(parameters)] [ASM]`](#sub-parameters-asm)
    - [`SYMBOL character,value1,value2,...,value8`](#symbol-charactervalue1value2value8)
    - [`SYMBOL AFTER n`](#symbol-after-n)
    - [`TAG [#channel]`](#tag-channel)
    - [`TAGOFF [#channel]`](#tagoff-channel)
    - [`TAN(x)`](#tanx)
    - [`TEST(x,y)`](#testxy)
    - [`TESTR(x,y)`](#testrxy)
    - [`TIME[(n)]`](#timen)
    - [`TROFF`](#troff)
    - [`TRON`](#tron)
    - [`UNT(n)`](#untn)
    - [`UPPER$(cadena)`](#uppercadena)
    - [`VAL(cadena)`](#valcadena)
    - [`VPOS([#canal])`](#vposcanal)
    - [`WAIT puerto,mascara[,inversion]`](#wait-puertomascarainversion)
    - [`WEND`](#wend)
    - [`WHILE condición`](#while-condición)
    - [`WIDTH n`](#width-n)
    - [`WINDOW [#channel,]left,right,top,bottom`](#window-channelleftrighttopbottom)
    - [`WINDOW SWAP channel1,channel2`](#window-swap-channel1channel2)
    - [`WRITE [#channel,]data1,data2,...`](#write-channeldata1data2)
    - [`XPOS`](#xpos)
    - [`YPOS`](#ypos)
    - [`ZONE n`](#zone-n)
- [Appendix I: Debugging Compiled Programs](#appendix-i-debugging-compiled-programs)
  - [Verifying BASIC Code](#verifying-basic-code)
  - [Debugging our Code](#debugging-our-code)
- [Appendix II: Extending the Compiler](#appendix-ii-extending-the-compiler)


---

# Introduction

**ABASC (Amstrad BASic Compiler)** is a cross-compiler written entirely in Python and without external dependencies, making it highly portable to any system that includes a standard **Python 3** installation.

It is designed to support the dialect of BASIC created by **Locomotive Software** for the Amstrad CPC microcomputers, ensuring that all existing documentation for this language remains fully relevant and useful.

Furthermore, as a cross-compiler running on modern systems, ABASC incorporates several features from **Locomotive BASIC 2 Plus**, providing a development experience closer to modern programming languages while preserving the classic style of the original BASIC.

## Influences

ABASC owes its existence to the **CPCBasic** compiler: [https://cpcbasic.webcindario.com/CPCBasicSp.html](https://cpcbasic.webcindario.com/CPCBasicSp.html). ABASC would likely not exist if that project was still active and its source code publicly available.

## A Brief Overview of the Locomotive BASIC Versions

### Version 1.0

The first version of Locomotive BASIC appeared with the Amstrad CPC 464. It was a relatively fast language compared to other BASIC implementations of its time. Among its main advantages was broad access to the audio chip’s capabilities. Program lines were numbered and those numbers served as labels for the `GOTO` and `GOSUB` statements.

### Version 1.1

Introduced with the CPC 664 and 6128, this version fixed various bugs and added new functions such as `FRAME`, `COPYCHR$`, and `FILL`. However, it still required the use of line numbers.

### Version 2

Released in 1987 for the Amstrad PC 1512 and 1640, this version removed the need for line numbers thanks to the `LABEL` command and enabled the development of applications for the GEM graphical environment, although it still lacked advanced code-structuring mechanisms.

### Version 2 Plus

Introduced in 1989, this revision added `FUNCTION`, `SUB`, multi-line `IF` statements, and other enhancements aimed at facilitating the development of more structured programs.

---

# References

This manual is **not** intended to be a comprehensive guide to programming in BASIC. For in-depth information on Locomotive BASIC programming, the following texts are recommended:

* *Amstrad CPC464 – User Manual* (I. Spital, R. Perry, W. Poel, C. Lawson)
* *BASIC Programmer’s Reference Manual* (Amsoft)
* *Amstrad CPC6128 – User Manual* (I. Spital, R. Perry, W. Poel, C. Lawson)
* *BASIC 2 User Guide* (Locomotive Software Ltd.)
* *BASIC 2 PLUS Language Reference* (Locomotive Software Ltd.)
* *Using Locomotive BASIC 2 on the Amstrad 1512* (Robert Ransom)

To deepen your knowledge of the Amstrad CPC464/CPC6128 firmware, or of Z80 assembly programming, the following reference books are recommended:

* *CPC464/664/6128 FIRMWARE, ROM Routines and Explanations* (B. Godden, P. Overell, D. Radisic)
* *The Amstrad CPC Firmware Guide* (Bob Taylor)
* *Z80 Assembly Language Programming* (Lance A. Leventhal)
* *Ready-Made Machine Language Routines for the Amstrad CPC* (Joe Pritchard)

---

# Syntax Supported by ABASC

1. Line numbers are not required.
2. Labels for jumps can be defined using `LABEL`.
3. Multi-line `IF ... THEN ... ELSE ... END IF` blocks.
4. Procedure definitions with `FUNCTION` and `SUB`.
5. Inline assembly through `ASM`.
6. Inclusion of external BASIC code with `CHAIN MERGE`.
7. Data structure definitions using `RECORD`.

### Example 1 (syntax compatible with BASIC 1.0 and 1.1)

```basic
10 MODE 1
20 BORDER 0
30 PAPER 3
40 INK 0,1,2
50 PEN 0
60 PRINT "Hello world"
70 END
```

### Example 2 (syntax using several BASIC 2 enhancements)

```basic
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

---

# Additional Tools

In addition to the compiler, the development package includes several extra tools that cover the entire workflow from generating the binary to package it for distribution. Each tool has its own manual distributed alongside the compiler documentation. All utilities are fully independent and can be used on their own.

* `abasm.py` — Assembler compatible with WinAPE and RVM syntax. [manual](abasm.html)
* `basprj.py` — Creates a basic project structure to use with `ABASC`. [manual](basprj.html)
* `img.py` — Converts images to CPC format and can generate loading screens. [manual](img.html)
* `dsk.py` — Creates `.DSK` disk images, allowing you to distribute compiled binaries and additional files. [manual](dsk.html)
* `cdt.py` — Creates `.CDT` tape images, also useful for distributing binaries and other accompanying files. [manual](cdt.html)


# Using the Compiler

```
python abasc.py [options] file.bas [-o output]
```

### Options

* `--version` — Displays the compiler version.
* `-O <n>` — Optimization level (0 = none, 1 = peephole, 2 = full).
* `-W <n>` — Warning level (0 = none, 1 = important, 2 = important and medium, 3 = all).
* `--data <n>` — Starting address for the data area (0x4000 by default)
* `-v`, `--verbose` — Generates auxiliary compilation files (preprocessed output, symbol table, syntax tree, etc.).
* `-o`, `--out` — Output file name (without extension).

## Creating a Project Using BASPRJ

In `ABASC`, project management is straightforward. It is sufficient to create a main source file that imports any additional required files using the `CHAIN MERGE` command. After running `ABASC`, a compiled binary file will be generated. A subsequent call to the `DSK` or `CDT` tools is then enough to package the result for use in emulators or on real hardware (for example, via devices such as Gotek, M4, or DDI-Revival).

```bash
python3 abasc.py main.bas
python3 dsk.py -n main.dsk --put-bin main.bin --start-addr=0x0040 --load-addr=0x0040
```

However, it is also possible to quickly generate a basic project structure using the `BASPRJ` tool. This utility automatically creates a build script with everything needed to get started: on Windows, a `make.bat` file is generated, while on Linux and macOS a `make.sh` file is created. In addition, a `main.bas` file containing ready-to-use example code is included.

```bash
python3 basprj.py -n myproject
```

For more detailed information, please refer to the specific `BASPRJ` documentation.

---

# Peculiarities of the Compiler

Although ABASC aims to compile programs written for BASIC 1.0 and 1.1 with little or no modification, the very nature of a compiler versus an interpreter naturally introduces certain differences. This section explains those particular behaviors that may surprise programmers accustomed to the traditional BASIC interpreter.

## Types and Variables

ABASC uses a somewhat stricter type system than the original Locomotive BASIC interpreter. By default, **all variables are integers**, unless a suffix is used to indicate a different data type.

| Type    | Suffix       | Notes                                                            |
| ------- | ------------ | ---------------------------------------------------------------- |
| Integer | % (optional) | Integer values in the range -32768 to 32767                      |
| Real    | !            | 5-byte floating-point values (4-byte mantissa + 1-byte exponent) |
| String  | $            | Strings of up to 254 characters (see next section)               |

### String Handling

In the original Locomotive BASIC, strings used a **double-indirection** structure. A string variable occupied 3 bytes:

* Byte 1: length
* Bytes 2–3: pointer to the string data

The maximum length was 255 characters.

In ABASC, string data is stored **directly after the length byte**, reserving **up to 255 bytes for the entire structure**. Therefore, **the maximum string length is 254 characters**.

The only exception is **RSX calls**, for which ABASC preserves the original Locomotive BASIC string structure to ensure compatibility. Thus, RSX routines will always receive strings in the 3-byte indirection format:

* 1 byte: length
* 2 bytes: pointer to content

In addition, programmers may not always want to reserve the full 254 bytes for every string. ABASC therefore includes two statements from Locomotive BASIC 2: **`FIXED`** and **`DECLARE`**, which allow specifying the exact buffer size:

```basic
DECLARE A$ FIXED 10  ' A$ may contain up to 10 characters
```

The above sentence reserves 11 bytes total (1 length byte + 10 characters). It is important to note that ABASC does **not perform runtime bounds checking**—unlike an interpreter—so writing more characters than the space allocated for `A$` will lead to unpredictable behavior.

### Arrays

In Locomotive BASIC, an array that has not been explicitly declared with `DIM` is assumed to contain 10 elements. ABASC is stricter: compilation will fail if the program attempts to use an array that has not been declared explicitly with `DIM`.

Furthermore, a string array immediately allocates memory for **all its elements**. By default, each string occupies 255 bytes (1 length + 254 content), which can quickly exhaust available memory. As with individual strings, the `FIXED` clause may be used:

```basic
DIM A$(5) FIXED 10   ' Total memory = 11 bytes × 5 elements
```

### RECORD Structures

ABASC supports organizing data into more complex structures known as **records** as it was introduced by Locomotive BASIC version 2 Plus. Internally, a record is simply a structured way of subdividing and labeling the memory reserved by a string. To use records, their layout must first be defined using the `RECORD` statement:

```
RECORD name; field list
```

Example:

```basic
RECORD person; name$ FIXED 10, age
```

Record patterns may then be applied to strings by using the `.` operator:

```basic
DECLARE A$ FIXED 13         ' Optional but reduces memory usage
RECORD person; name$ FIXED 10, age   ' Requires 13 bytes total

A$.person.name$ = "Juan"
A$.person.age = 20
```

The program above leaves the memory reserved for `A$` in the following layout:

| Bytes | Content                     | Value                           |
| ----- | --------------------------- | ------------------------------- |
| 0–10  | Length + content of `name$` | 4, J, u, a, n, 0, 0, 0, 0, 0, 0 |
| 11–12 | Value of `age`              | 20                              |

## Functions and Procedures

Traditionally, BASIC allows reusable code to be organized through routines invoked with `GOSUB` and `RETURN` (without parameter support), or through single-line functions defined with `DEF FN`. ABASC is fully compatible with both mechanisms, but it also adds a more modern and structured approach introduced in Locomotive BASIC 2 Plus. The syntax is:

```basic
SUB name(parameter list)
    ....
END SUB

FUNCTION name(parameter list)
    ....
END FUNCTION
```

Functions defined with `FUNCTION` must include at least one assignment to the function’s own name in their bodies, which serves as the return value.

Functions can be called directly as part of an expression, while subroutines must be invoked using `CALL`, specifying the procedure name and a comma-separated list of parameters inside parentheses.

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

Variables declared inside a procedure—using `DECLARE`, `DIM`, by assigning to them, or by using them in `INPUT`, `READ`, or `LINE INPUT`—are always local and cannot be accessed from outside the procedure. Global variables, on the other hand, may be used inside a procedure but only if they are referenced through the use of `SHARED` at the beginning of the routine body.

Regarding parameter passing semantics, integers are passed **by value**, while strings, real numbers and arrays are passed **by reference** (that is, as a pointer to their underlying data). Consequently, in the latter three cases, the procedure may modify the original variable. Arrays must be used in calls adding the postfix `[]` to identify the variable as an array, equal to its use in the command `SHARED`. However, in the procedure declaration, the indexes for each of the array components should be added between the `[]` symbols.

```basic
DIM myvec(3)

sub printvec(v[3])
    for i=0 to 3
        print v(i)
    next
end sub

myvec(0) = 0; myvec(1) = 1: myvec(2) = 2; myvec(3) = 3
call printvec(myvec[])
```

**NOTE ON RECURSION:** ABASC does not support recursion because local variables reserve memory at compile time in the stack. Because of this, the code is not reentrant, making recursive calls impossible.

## Using Assembly Code

The `ASM` statement allows you to embed assembly code directly within any part of a BASIC program. **ABASM**, the assembler used by ABASC, has its own dedicated manual that describes the supported syntax and available options in detail.

You can also call assembly routines using the `CALL` statement, as shown in the following example:

```basic
ASM "mylabel: ret ; empty routine"

CALL "mylabel"
```

It is possible to pass arguments to assembly routines, although this requires understanding ABASC’s calling convention. Parameters are **pushed onto the stack in order**, from first to last, and the routine is invoked with the **IX register pointing to the last parameter**.
The callee **must not** remove parameters from the stack; this is handled by the caller after the routine returns.

For example, a routine receiving three integer parameters (each 2 bytes long):

```
CALL myroutine(param1, param2, param3)
```

can access them using the following layout:

| Parameter | Relative Address |
| --------- | ---------------- |
| param1    | IX+4, IX+5       |
| param2    | IX+2, IX+3       |
| param3    | IX+0, IX+1       |

Finally, you can append the `ASM` clause to the declaration of a function or subroutine. This indicates that the entire routine is written in assembly and that the compiler does not need to allocate or manage temporary memory (heap) for it.

```basic
SUB cpcSetColor(i, c) ASM
    ' Equivalent to the BASIC INK statement
    ' param 1: ink number (0–16), with 16 being the border ink
    ' param 2: hardware color value – &40 (i.e., &14 becomes &54 for black)

    ASM "ld      bc,&7F00 ; Gate Array"
    ASM "ld      a,(ix+2) ; ink number"
    ASM "out     (c),a"
    ASM "ld      a,&40"
    ASM "ld      e,(ix+0) ; hardware color"
    ASM "or      e"
    ASM "out     (c),a"
    ASM "ret"
END SUB

CALL cpcSetColor(0, &14)
```

It's even possible to include other binary or assembly files to our program using `ASM`:

```basic
ASM "read 'mylib.asm'    ; extra assembly code"
ASM "incbin 'assets.bin' ; binary content to append"
```

## Pointers

Locomotive BASIC uses the `@` symbol to access the memory address of a given variable. For example, to read and display the 5-byte representation of a real number in memory, you can use the following code:

```basic
a! = 43.375
PRINT "MEMORY ADDRESS:"; @a!
PRINT "MEMORY CONTENT (HEX):"
FOR i = 0 TO 4
    PRINT i, HEX$(PEEK(@a! + i), 2)
NEXT
```

`ABASC` extends the use of `@` by allowing access not only to the address of a variable, but also to the address of a label declared with `LABEL`, as well as to the memory location that will be read by the next `READ` statement (that is, the current `DATA` pointer). It's even possible to access to the address of a label defined in assembly. These options are particularly useful when working with data imported from binary files or assembly sources.

```basic
LABEL MAIN
    CLS

    spdir = @LABEL(mysprite)
    RESTORE palette
    pldir = @DATA
    asmdir = @LABEL("asm_label")
    ' Example usage of these pointers...
END

LABEL mysprite:
    ASM "read 'my_sprite.asm'"

LABEL palette:
    DATA 1,2,3,4

ASM "asm_label:"
```

## Memory Management

The memory map for a program compiled with ABASC is structured as follows:

| Address             | Description                                                                |
| ------------------- | -------------------------------------------------------------------------- |
| **0x0040**          | Start of the application-initialization area and temporary memory space (heap).|
| **\_code\_**        | Program main source code. Starts just after the heap and the startup code.       |
| **\_runtime\_**     | Label marking the beginning of compiler-generated support routines.         |
| **\_data\_**        | Label marking the beginning of the static variable-allocation area. The lowest address for this area is 0x4000 as it can not share the address space used by the Firmware. The initial address, however, can be set using the parameter `--data`. if the preceding code overpasses the configured starting address for the data area, it will be allocated to start from the first free address. |
| **\_program_end\_** | Label marking the address where the program’s memory usage ends.            |

Locomotive BASIC provides several commands for memory management: `HIMEM`, `MEMORY`, `FRE`, and `SYMBOL AFTER`.
ABASC supports them as well, but their semantics differ slightly due to the compiled-code model:

| Command          | Meaning in ABASC                              |
| ---------------- | -------------------------------------------- |
| **HIMEM**        | Returns the memory address immediately above the end of the compiled program (_program_end_ address). |
| **MEMORY**       | Sets the maximum memory address the compiled binary may reach. If exceeded, compilation fails.|
| **SYMBOL AFTER** | ABASC reserves memory for redefinable characters (UDCs), just as Locomotive BASIC does. This region is part of the `_data_` segment. It can be released with `SYMBOL AFTER 256`. |
| **FRE(0)**       | Returns the free memory between `_program_end_` and the Firmware’s variable-storage area (`&A6FC`). |
| **FRE(1)**       | Returns the currently available temporary memory (heap). |
| **FRE("")**      | Forces a cleanup of temporary memory (heap) and returns the same value as `FRE(0)`. |

ABASC uses temporary memory to store intermediate results during the evaluation of expressions (such as string concatenation or numeric computations). This memory is allocated in a block called the "heap". The heap starts around the memory address 0x040 and its total maximum size is calculated at compiling time. After each statement, this temporary memory is automatically released. The only exception occurs during a `FUNCTION` or `SUB` call: the temporary memory allocated before the call is preserved so it can be restored when execution returns to the caller.

## Using the Firmware

ABASC makes extensive use of the **Amstrad CPC Firmware** routines, especially for handling floating-point numbers. This means that although compiled code is significantly faster than interpreted BASIC, its performance may still be limited by the speed of these system routines.

However, you can use the `ASM` statement to provide more efficient replacements for Firmware calls (such as `CLS`, `INK`, `BORDER`, `PAPER`, etc.). Keep in mind, though, that unless interrupts are disabled, the Firmware remains active and **may overwrite your changes** without warning.

Another option is to modify the program’s assembly code directly. During compilation, ABASC generates an `.ASM` file containing the full assembly code. This allows the developer to adjust or extend the generated code and apply specific optimizations when needed, using **ABASM** to produce the final binary. When the `--verbose` option is enabled, the generated ASM file includes more detailed comments, making it easier to follow how each BASIC statement is translated into assembly code.

## Libraries

The ABASC installation includes a directory called `lib`. Any `.BAS` file can be placed there to be included in any of your programs using the `CHAIN MERGE` command.

`CHAIN MERGE` will first try to resolve any file to include against the local directory of our source code. If the specified file is not local to the program, it will then search in the ABASC `lib` directory, treating it as a "library" — a reusable `.BAS` file that can be used in any project. For example, we can test the `memory.bas` file distributed with ABASC using this simple program:

```basic
CHAIN MERGE "memory.bas"

A$="Hello world"
B$=""

CALL MEMSET(&C000, &4000, 0)
CALL MEMCOPY(@B$, @A$, LEN(A$)+1)
PRINT B$
```

---

# Commands and Language Syntax

The following section provides a concise overview of the notation, commands, and functions supported by the compiler. It is **not** intended to be an exhaustive guide to Locomotive BASIC, but rather to highlight the elements that are specific to the compiler.
For a more comprehensive understanding of the language, refer to the works listed in the *References* section at the beginning of this manual.

## Notation

Special characters:

| Character   | Notes          |
| ----------- | -------------- |
| `&` or `&H` | Prefix for hexadecimal numbers        |
| `&X`        | Prefix for binary numbers             |
| `:`         | Separates multiple statements on the same line |
| `#`         | Prefix used to indicate a text channel (0–9)   |
| `"`         | String delimiter                               |
| `@`         | Placed before a variable name to indicate the memory address referenced by that variable |
| `\|`        | Placed before an identifier to indicate an RSX function call |

## List of Commands and Functions

### `ABS(<numeric expression>)`

**Function.** Returns the absolute value of the given numeric expression. The expression can be either integer or floating-point.

### `AFTER delay[,timer] GOSUB label`

**Command.** Calls the specified subroutine after a delay. The `delay` is measured in 1/50 second increments. The optional second parameter specifies which of the four timers to use (0..3). If omitted, timer 0 is used by default. The `GOSUB` label can be either a line number (integer) or a literal defined with the `LABEL` statement.

ABASC uses Firmware routines to handle asynchronous events. User routines are called with the lower ROM active, so code should remain short and **avoid using the first 16K of memory**. Operations with floating-point numbers or text may attempt to allocate temporary memory in this area (the heap) and should be avoided. Integer operations, on the other hand, are safe. This mechanism also requires that interrupts are enabled (see `DI` and `EI`).

```basic
A = 0
AFTER 50 GOSUB INCR  ' Calls the INCR routine after 1 second
A = 5
END

LABEL INCR
    PRINT A
RETURN
```

### `ASC(string)`

**Function.** Returns the ASCII value of the first character in the provided string.

```basic
PRINT ASC("HELLO")  ' prints 72, the ASCII code for H
```

### `ASM string[,string]*`

**Command.** Inserts the contents of the provided string(s) as assembler code. Each string is inserted as a new line.

```basic
ASM "ld  hl,_my_str", "ld  a,(hl)"
```

### `ATN(x)`

**Function.** Returns the arctangent of `x`. This function uses floating-point arithmetic.

### `AUTO linenumber[,increment]`

**Command.** Ignored by ABASC. The compiler emits a warning because this command has no effect in compiled programs.

### `BIN$(number,digits)`

**Function.** Returns the integer `number` as a string containing its binary representation. Locomotive BASIC allows specifying the exact number of digits, but **ABASC only supports 8 or 16 digits**.

```basic
PRINT BIN$(16,8)  ' prints the string "00010000"
```

### `BORDER colour1[,colour2]`

**Command**.Sets the border color. If two values are provided, the border will blink according to the timing controlled by the `SPEED INK` command.

```basic
BORDER 0,1
```

### `CALL address[, list of parameters]`

**Command**. Calls an existing routine in memory, either by its memory address, a routine declared with `SUB` or `FUNCTION`, or a label defined inside an assembler block.

```basic
SUB nothing
    PRINT "Just printing nothing"
END SUB

CALL &BC14         ' Firmware routine to clear the screen
CALL nothing()     ' Call a BASIC subroutine
CALL "infinite_loop" 
PRINT "We will never reach here"
ASM "infinite_loop: jr infinite_loop"
```

### `CAT`

**Command**. Displays the contents of the current storage device. The device can be changed using RSX commands such as `|TAPE`, `|DISC`, `|A`, or `|B`.

### `CHAIN`

**Command**. In BASIC, this replaces the current program in memory with another program. ABASC ignores this instruction and issues a warning if it is found.

### `CHAIN MERGE string`

**Command**. Redefined in ABASC to allow splitting your code across multiple files. `string` should be the path to a `.BAS` file accessible from the main file location.

`CHAIN MERGE` cannot find the `string`file relative to our program directory, it will then search in the ABASC `lib` directory, treating `string` as a "library" — a reusable `.BAS` file that can be used in any project.

```basic
' MORECODE.BAS
MYVAR$ = "A VERY USEFUL STRING"

' MAIN.BAS
CHAIN MERGE "MORECODE.BAS"
PRINT MYVAR$
END
```

### `CHR$(x)`

**Function**. Returns a string containing the character corresponding to the numeric value `x` (0–255).

```basic
PRINT CHR$(250)
```

### `CINT(x)`

**Function**. Converts a real number `x` to the nearest integer. `x` must be within the range -32768..32767; otherwise, the result may be incorrect.

```basic
PRINT CINT(PI)
```

### `CLEAR`

**Command**. This command sets all numeric variables to 0 and strings to "", closes open files, and resets angle mode to `RAD`.

### `CLEAR INPUT`

**Command**. Introduced in BASIC 1.1. ABASC supports it even on an Amstrad CPC 464, using the firmware routine `KM RESET` instead of `KM FLUSH`.

### `CLG [ink]`

**Command**. Clears the graphics screen using the current `PAPER` value. If `ink` is provided, it is assigned as the new `PAPER` value before clearing.

### `CLOSEIN`

**Command**. Closes the currently open file used for reading. See `OPENIN`.

### `CLOSEOUT`

**Command**. Closes the currently open file used for writing. See `OPENOUT`.

### `CLS [#x]`

**Command**. Clears the screen using the current `PAPER` color. A channel may be specified with `#x`. Values 0–7 define screen areas via the `WINDOW` command. `#8` is usually associated with the Printer (not supported in ABASC), and `#9` is for files.

### `CONST`

**Command**. CONST declares and defines named constants, assigning them a fixed integer value. When the constant name is used in an expression, its value is substituted directly, which may enable compiler optimizations. Any attempt to change the value of a constant will cause the compilation to fail with an error, alerting the programmer to the invalid operation.

``` basic
CONST VMEM = &C000

FOR I=0 TO 16384
    POKE VMEM + I, &FF
NEXT
```

### `CONT`

**Command**. In original BASIC, continues execution after a `BREAK`, `STOP`, or `END`. In a compiled program, ABASC redefines it to pause execution and wait for any keypress, may be useful for debugging.

### `COPYCHR$(#channel)`

**Function**. Returns the character at the current text cursor position for the given `channel`. Introduced in BASIC 1.1, ABASC provides support even on programs running on an Amstrad CPC 464.

``` basic
MODE 1
PRINT "HELLO WORLD"
LOCATE 3,1
C$ = COPYCHR$(#0)  ' L letter
LOCATE 1,2: PRINT C$
```

### `COS(x)`

**Function**. Returns the cosine of `x`. Requires real-number arithmetic.

### `CREAL(x)`

**Function**. Converts the integer `x` to a real number.

### `CURSOR system[, user]`

**Command**. Introduced in BASIC 1.1. Controls cursor visibility using two flags. The cursor is shown only if both `system` and `user` are set to `1`. Otherwise, the cursor is hidden.

### `DATA list-of-constants`

**Command**. Allows adding a series of values (integers or characters) to the program, which can later be read sequentially using the `READ` statement.

```basic
CLS
FOR I=0 TO 5
    READ name$
    PRINT "Name:", name$
NEXT
END

DATA "Xavier","Ross","Gada",
DATA "Anabel","Rachel","Elvira"
```

### `DECLARE variable[$ FIXED length],...`

**Command**. Introduced in Locomotive BASIC 2, `DECLARE` allows you to "predefine" a variable that will be used later. Typically, only arrays need explicit declaration with `DIM` since scalar variables are automatically declared when assigned. However, `DECLARE` can be used to:

* Create string variables with a maximum length smaller than the default 254 bytes.
* Declare integer variables initialized to 0 without generating extra assignment instructions.

Example:

```basic
B$ = ""               ' B$ reserves 254 characters by default
DECLARE A$ FIXED 15   ' A$ reserves 15 characters
B = 0                 ' B initialized to 0, generating less assembler code
DECLARE A             ' declares integer A
```

### `DEC$(number, pattern)`

**Function**. Introduced in BASIC 1.1, `DEC$` converts `number` to a string using a pattern to define the number of spaces before or after the decimal point. ABASC currently ignores the pattern, so this behaves similarly to `STR$`.

```basic
PRINT DEC$(15.5, "###.##")
```

### `DEF FN name(parameters) = expression`

**Command**. Declares a single-line function applying the expression on the right to the given parameters. In BASIC 1.0, this was the only way to define functions. ABASC supports the more versatile `FUNCTION ... END FUNCTION` syntax.

**Important differences in ABASC:** Functions and subroutines **must be declared before use** and type suffixes are mandatory, a function returning a real must end with `!`, and a string function must end with `$`.

```basic
DEF FNinterest!(principal) = principal * 1.14
PRINT FNinterest!(1000)
```

### `DEFINT, DEFSTR, DEFREAL`

**Command**. In original BASIC, these defined ranges of initial letters for variable types. ABASC uses strict type suffixes (`%`, `!`, `$`) and ignores these commands entirely. Programmers must explicitly use suffixes to define variable types.

### `DEG`

**Command**. Sets angle-related functions (`SIN`, `COS`, etc.) to interpret input in degrees instead of radians.

```basic
DEG
PRINT SIN(90.0)  ' prints 1
RAD
PRINT SIN(90.0)  ' prints 0.8939 (value in radians)
```

### `DELETE low-high`

**Command**. In Locomotive BASIC this command was used to delete a range of program lines. In ABASC, this behavior does not make sense, so `DELETE` has been redefined to clear (fill with zeros) a memory region. The range must be specified as: starting address - ending address.

```basic
DELETE &C000-&FFFF
```

### `DERR`

**Command**. Introduced in BASIC 1.1, it stored the last disk-related error. ABASC ignores any reference to this command and issues a warning if it appears in the code.

### `DI`

**Command**. Disables the interrupt mechanism. With interrupts disabled, the `TIME` value stops updating, and events scheduled with `AFTER` or `EVERY` are not processed. Interrupts can be re-enabled using the `EI` command.

### `DIM array(index1, index2, ...) [FIXED length]`

**Command**. Declares an array and reserves memory for it. The data type is indicated using a suffix on the array name (`%`, `!`, `$`). If no suffix is specified, the array stores integers. For string arrays, you can reduce the maximum memory allocated for each element using the `FIXED` clause after the index list.

Indices start at 0 and go up to the number specified in the declaration.

```basic
DIM name$(3) FIXED 8

name$(0) = "Juan"
name$(1) = "Daniel"
name$(2) = "Pepe"
name$(3) = "Roberto"

FOR I=0 TO 3
    PRINT name$(I)
NEXT
```

### `DRAW x,y[,i[,mode]]`

**Command**. Draws a line from the current cursor position to the coordinates `x` and `y`. The optional third parameter specifies the color. In BASIC 1.1, a fourth parameter was added (supported by ABASC even for programs running on an Amstrad CPC 464), which defines the mode or mask applied between each point of the line and the background:

| Value | Mode               |
| ----- | ------------------ |
| 0     | Fill (normal)      |
| 1     | XOR (exclusive OR) |
| 2     | AND                |
| 3     | OR                 |

```basic
MODE 1
DRAW 100,100,1
DRAW 0,100,2
DRAW 100,0,3
DRAW 0,0,2
```

### `DRAWR x,y[,i[,mode]]`

**Command**. Works similarly to `DRAW`, but the `x` and `y` values are **relative** to the current cursor position rather than absolute screen coordinates. The other parameters function the same way as in `DRAW`.

### `EDIT line[-line]`

**Command**. In Locomotive BASIC, this command allows editing a specific line of code. In ABASC, it is ignored and has no effect during compilation.

### `EI`

**Command**. Enables interrupts. See also `DI`.

### `END`

**Command**. Ends program execution. In the BASIC interpreter, this returns control to the user. In ABASC, it jumps to an infinite loop. Note that `STOP` forces a machine restart.

### `END FUNCTION`

**Command**. Marks the end of a function declaration. See `FUNCTION`.

### `END SUB`

**Command**. Marks the end of a procedure declaration. See `SUB`.

### `ENT envelope_number, sections`

**Command.** Defines the pitch variation of a sound. Locomotive BASIC allows specifying two types of pitch envelopes (sections): one with three parameters and another with two. Although not officially documented, to differentiate the second type, the `=` symbol could be placed before the first number. ABASC does not fail if this character is present; however, it determines the envelope type based on the number of parameters. If there is any ambiguity, ABASC assumes the first type, where each envelope is defined with three values.

**Type 1 Section:**

* Parameter 1: number of steps, from 0 to 239.
* Parameter 2: step size, from -128 to +127.
* Parameter 3: pause

**Type 2 Section:**

* Parameter 1: pitch period (16-bit integer).
* Parameter 2: pause

### `ENV envelope_number, sections`

**Command.** Defines the volume variation of a sound. Locomotive BASIC supports two types of volume envelopes (sections): one with three parameters and another with two. Similar to `ENT`, the second type can optionally start with the `=` symbol. ABASC determines the envelope type based on the number of parameters and assumes the three-parameter type by default.

**Type 1 Section:**

* Parameter 1: number of steps, from 0 to 127.
* Parameter 2: step size, from -128 to +127.
* Parameter 3: pause, range 0–255

**Type 2 Section:**

* Parameter 1: envelope ID according to the sound hardware.
* Parameter 2: envelope period, the value sent directly to the hardware registers.

```basic
ENV 1,=9,2000
ENV 2,127,0,0,127,0,0,127,0,0,127,0,0,127,0,0
ENV 3,=9,9000
```

### `EOF`

**Function.** Checks whether the file currently being read has reached the end. Returns `-1` (true) if the end of the file has been reached, or `0` (false) otherwise.

```basic
OPENIN "DATA.TXT"
WHILE NOT EOF
    LINE INPUT #9, C$
    PRINT C$
WEND
CLOSEIN
```

### `ERASE arrayname`

**Command.** In Locomotive BASIC, this frees the memory reserved for an array. In ABASC, memory is allocated at compile time, so this command has no effect and is ignored in compiled code.

### `ERL`

**Command.** In Locomotive BASIC, this returns the line number of the last error. In compiled programs, it has no effect and is ignored.

### `ERR`

**Command.** Returns the error code (integer) previously set by the `ERROR` command. It can also return code `31` ("File not open") if `OPENIN` or `OPENOUT` failed.

```basic
ERROR 5
PRINT ERR
```

### `ERROR integer`

**Command.** Sets an error code that can be retrieved later using `ERR`.

## `EVERY time[,timer] GOSUB label`

**Command**. Sets the specified `timer` (0–3, default 0) to call the subroutine at `label` every `time` ticks. Each tick represents 1/50 of a second, so a value of 50 corresponds to calling the label once per second.

ABASC relies on the Amstrad CPC Firmware routines for handling asynchronous events. User routines are executed with the lower ROM active, so the code should be kept short and **avoid using the first 16K of memory**. Operations involving floating-point numbers or strings may attempt to allocate temporary memory within this range (the heap) and should be avoided, while integer operations are generally safe. This mechanism also requires that interrupts are enabled (see `DI` and `EI`).

```basic
A = 0
EVERY 300 GOSUB INCA  ' Prints and increments A every 6 seconds
END

LABEL INCA
    PRINT A
    A = A + 1
RETURN
```

### `EXIT FOR`

**Command**. In Locomotive BASIC, it was possible to exit a loop using a `GOTO` statement. In a program compiled with ABASC, using `GOTO` to exit loops may cause unexpected runtime errors. The proper way to exit a `FOR` loop early is to use `EXIT FOR`, which jumps to the statement immediately after the corresponding `NEXT`. This command was introduced in Locomotive BASIC 2.

```basic
FOR I = 0 TO 100
    IF I = 50 THEN EXIT FOR
NEXT
PRINT I
```

### `EXIT WHILE`

**Command**. Using `GOTO` to exit a `WHILE` loop in compiled code can lead to runtime errors. To exit a `WHILE` loop correctly, use `EXIT WHILE`, which jumps to the statement immediately after the corresponding `WEND`. This command was introduced in Locomotive BASIC 2.

```basic
I = 0
WHILE I < 101
    IF I = 50 THEN EXIT WHILE
    I = I + 1
WEND
PRINT I
```

### `EXP(x)`

**Function**. Returns e raised to the power of `x`, where e ≈ 2.7182818 (the number whose natural logarithm is 1). Requires floating-point support.

### `FILL`

**Command**. Only available on Amstrad CPC 664, 6128, or higher. Fills an area of the screen starting from the current graphics cursor position using the active pen color. It can fill shapes automatically. While ABASC will compile the program, execution on an Amstrad CPC 464 will fail.

```basic
MODE 0
GRAPHICS PEN 15
MOVE 200,0
DRAW 200,400
MOVE 639,0
FILL 15
```

### `FIX(x)`

**Function**. Converts the real number `x` to an integer by truncation. The result is valid only if `x` is within the range -32768 to +32767.

```basic
PRINT FIX(PI + 0.5), CINT(PI + 0.5)
```

### `FOR variable = start TO end STEP increment`

Command. Defines a loop in which `variable` iterates from `start` to `end`. If no `increment` is specified, the loop defaults to a step of 1.

```basic
CLS
T! = TIME
FOR i = 1 TO 10
    FOR j = 1 TO 1000
        s = 1000 + j
    NEXT j
    PRINT ".";
NEXT i
PRINT " DONE!"
PRINT TIME - T!
```

**NOTE:** `GOTO` should not be use to leave a FOR LOOP. Instead, use `EXIT FOR`.

### `FRAME`

**Command**. Pauses program execution until the next vertical sync signal of the monitor (maximum 50 times per second).

### `FRE(x)`

**Function**. Returns values related to memory depending on the parameter `x`:

| Parameter   | Return Value |
| ----------- | ------------ |
| **FRE(0)**  | Returns the available memory between `_program_end_` and the Firmware area where variables start (`&A6FC`). |
| **FRE(1)**  | Returns the currently available temporary memory (heap).|
| **FRE("")** | Forces the release of temporary memory (heap) and returns the same value as `FRE(0)`.|

### `FUNCTION name(parameters) [ASM]`

**Command**. Introduced in Locomotive BASIC 2 Plus, this command declares a function similar to `DEF FN` but with a multi-line body.

Functions declared with `FUNCTION` must include at least one assignment to the function’s own name, which will act as the return value. Functions can be called directly as part of an expression.

```basic
FUNCTION pow2(x)
    pow2 = x * x
END FUNCTION

result = pow2(2)
```

The optional `ASM` clause indicates that the function body will consist entirely of assembly code (using the `ASM` command), as described in the section **Using Assembly Code** under **Peculiarities of the Compiler**.

Programmers are advised to read the **Functions and Procedures** section for more information about parameter handling and the lack of recursion support, as discussed in the **Peculiarities of the Compiler** chapter.

### `GOSUB label`

**Command**. Jumps to a label, which can be defined either as a line number or as a literal declared with `LABEL`. Execution returns to the line immediately following the `GOSUB` when a `RETURN` statement is encountered.

```basic
A = 0
GOSUB increment
GOSUB increment
PRINT A
END

LABEL increment
    A = A + 1
RETURN
```

### `GOTO label`

**Command**. Jumps to a label, which can be defined either as a line number or as a literal declared with `LABEL`.

### `GRAPHICS PAPER ink`

**Command**. Sets the `ink` value (0–15) to be used as the background color for text characters if a `TAG` statement has been used. It also determines the background color when clearing a graphics window via `CLG`.

```basic
MODE 0
MASK 15
GRAPHICS PAPER 3
DRAW 640,0
```

### `GRAPHICS PEN ink, mode`

**Command**. Introduced in BASIC 1.1. Sets the `ink` value (0–15) to be used for line and point drawing commands. The `mode` parameter determines how the drawing is combined with the background:

* 0: Opaque background.
* 1: Transparent background.

The background color can only be used on CPC 664 or higher models. On an Amstrad CPC 464, this feature is unsupported and may produce undefined behavior.

```basic
MODE 0
GRAPHICS PEN 15
MOVE 200,0
DRAW 200,400
MOVE 639,0
FILL 15
```

### `HEX$(x, digits)`

**Function**. Returns a string representing the hexadecimal conversion of `x`. Locomotive BASIC allows any number of digits, but ABASC only supports 2 or 4 digits.

```basic
PRINT HEX$(255,2)
PRINT HEX$(2048,4)
```

### `HIMEM`

**Function**. Returns the memory address immediately following the end of the program compiled by ABASC. This can be particularly useful with the `LOAD` command to load other binaries into free memory space.

```basic
PRINT "Memory used limit:", HIMEM
PRINT "Free memory before firmware variables:", FRE(0)
```

### `IF expression THEN expression ELSE expression END IF`

**Command**. ABASC supports the traditional one-line `IF ... THEN ... ELSE` structure from Locomotive BASIC 1.0 and 1.1. It also supports the multi-line syntax introduced in Locomotive BASIC 2 Plus, which allows the `THEN` and `ELSE` blocks to span multiple lines.

You cannot mix single-line and multi-line formats in the same `IF` statement. If the `THEN` block uses the multi-line format, the `ELSE` block (if present) must also use it, and the statement must end with `END IF`.

```basic
PAS$ = "Please"
LABEL QUESTION
    PRINT "ENTER THE PASSWORD:";
    INPUT C$
IF C$ = PAS$ THEN
    PRINT "ACCESS GRANTED!"
ELSE
    PRINT "TRY AGAIN"
    GOTO QUESTION
END IF
END
```

### `INK ink, color1[, color2]`

**Command**. Assigns `color1` to the specified `ink`. If a second color is provided, the ink will alternate (blink) between `color1` and `color2`. The number of available inks depends on the screen mode:

* Mode 2: 2 inks (0 and 1)
* Mode 1: 4 inks (0–3)
* Mode 0: 16 inks (0–15)

The color range is from 0 (black) to 26 (bright white).

```basic
MODE 1
BORDER 0
INK 0,0: INK 1,26: INK 2,26,0
PRINT "READY"
PEN 2: PRINT "_"
```

### `INKEY(key)`

**Function**. Checks the keyboard to determine which keys are currently pressed. The keyboard is scanned 50 times per second. The [SHIFT] and [CTRL] keys are identified as follows:

| Return Value | [SHIFT]     | [CTRL]      | Specified Key |
| ------------ | ----------- | ----------- | ------------- |
| -1           | N/A         | N/A         | Not pressed   |
| 0            | Not pressed | Not pressed | Pressed       |
| 32           | Pressed     | Not pressed | Pressed       |
| 128          | Not pressed | Pressed     | Pressed       |
| 160          | Pressed     | Pressed     | Pressed       |

```basic
CLS
LABEL LOOP
    IF INKEY(55) = 32 THEN PRINT "V + SHIFT"; END
GOTO LOOP
```

### `INKEY$`

**Function**. Returns a string containing the key currently pressed. If no key is pressed, it returns an empty string `""`.

```basic
MODE 1
LABEL LOOP
    k$ = INKEY$
    IF k$ <> "" THEN PRINT k$;
GOTO LOOP
```

### `INP(port)`

**Function**. Reads a value from the specified input/output `port`.

### `INPUT [#channel,] "prompt"[;] variable1, variable2,...`

**Command**. `INPUT` is a versatile command with many options. Its full usage is beyond the scope of this manual. Users are advised to consult the references listed in the `References` section.

### `INSTR([start_position,] string1, string2)`

**Function**. Searches `string1` for the first occurrence of `string2`. If the optional `start_position` parameter is provided, the search begins at that position; otherwise, it starts at the first character. Positions are 1-based, not 0-based.

```basic
posA = INSTR(1, "AMSTRAD", "A")
PRINT posA
posA = INSTR(posA + 1, "AMSTRAD", "A")
PRINT posA
posA = INSTR(posA + 1, "AMSTRAD", "A")
PRINT posA
```

### `INT(x)`

**Function**. For positive numbers, it behaves like `FIX`, truncating the decimal part. For negative numbers, it returns the smallest integer greater than or equal to `x` (i.e., rounding toward minus infinity), which may differ from `FIX`.

### `JOY(joystick)`

**Function**. Works similarly to `INKEY`, but for joysticks. The `joystick` parameter must be 0 or 1, as Amstrad CPC computers support a maximum of two joysticks simultaneously. If no direction or button is pressed, it returns 0. Otherwise, it returns an integer encoding the joystick state as follows:

| Bit | Decimal | Function |
| --- | ------- | -------- |
| 0   | 1       | Up       |
| 1   | 2       | Down     |
| 2   | 4       | Left     |
| 3   | 8       | Right    |
| 4   | 16      | Fire 2   |
| 5   | 32      | Fire 1   |

### `KEY key, string`

**Command**. Assigns a text `string` to a function `key`. ABASC does **not** support this command and will issue a warning if it is encountered in the code.

### `KEY DEF key, repeat[,<normal>[,<shift>[,<ctrl>]]]`

**Command**. Redefines the behavior of a key press. ABASC does **not** support this command and will issue a warning if it appears in the code.

### `LABEL label`

**Command**. Defines a label that can be used as a target for `GOTO` or `GOSUB`. The `label` is an identifier, **not** a string, so it should **not** be enclosed in quotation marks. Labels are case-insensitive.

```basic
LABEL MAIN
    PRINT "HELLO WORLD"
GOTO MAIN
```

Next to symbol `@` can be used to obtain the address in memory of a label (defined in BASIC or assembly) or the address that the next call to `READ` will use to obtain the values.

```basic
LABEL MAIN
    CLS

    spdir = @LABEL(mysprite)
    RESTORE palette
    pldir = @DATA
    asmdir = @LABEL("asm_label")
    ' Example usage of these pointers...
END

LABEL mysprite:
    ASM "read 'my_sprite.asm'"

LABEL palette:
    DATA 1,2,3,4

ASM "asm_label:"
```

### `LEFT$(string, n)`

**Function**. Returns the first `n` characters from the left of `string`.

```basic
PRINT LEFT$("AMSTRAD", 3)  ' Output: "AMS"
```

### `LEN(string)`

**Function**. Returns the length of `string` in characters.

```basic
PRINT LEN("AMSTRAD")  ' Output: 7
```

### `LET variable = expression`

**Command**. A legacy from early BASIC specifications. It is **not required** to use `LET` for assignments in Locomotive BASIC, but it is supported for compatibility purposes.

### `LINE INPUT [#channel,][;][string;]<variable>`

**Command**. Reads a line of text from the specified input channel (#0 by default). Channel #9 is used to read from an open input file. For channels #0–#8, it behaves similarly to the `INPUT` command.

```basic
OPENIN "DATOS.TXT"
WHILE NOT EOF
    LINE INPUT #9, C$
    PRINT C$
WEND
CLOSEIN
```

### `LIST [line range][, #channel]`

**Command**. Ignored by ABASC. If encountered in the code, a warning is issued.

### `LOAD filename[,address]`

**Command**. Loads a file from disk or tape into memory. ABASC **only supports loading binary files**. If a memory address is provided as the second parameter, the binary content will be loaded at that location.

```basic
ENDDIR = HIMEM
LOAD "SPRITES.BIN", ENDDIR
```

### `LOCATE [#channel,] x, y`

**Command**. Moves the text cursor to the position `x`, `y`. Coordinates start at 1. The maximum `x` value depends on the current graphics mode:

* Mode 0 → 20 columns
* Mode 1 → 40 columns
* Mode 2 → 80 columns

If a `#channel` is specified, the limits depend on the dimensions defined with `WINDOW`.

```basic
CLS
LABEL MAIN
    FRAME
    FOR x = 2 TO 39
        LOCATE x-1, 10: PRINT " "
        LOCATE x, 10: PRINT CHR$(250)
    NEXT
GOTO MAIN
```

### `LOG(x)`

**Function**. Returns the natural logarithm (base e) of `x`. Requires floating-point numbers.

### `LOG10(x)`

**Function**. Returns the base-10 logarithm of `x`. Requires floating-point numbers.

### `LOWER$(string)`

**Function**. Returns `string` with all characters converted to lowercase.

```basic
C$ = "AmsTRaD"
PRINT LOWER$(C$)  ' Output: "amstrad"
PRINT UPPER$(C$)  ' Output: "AMSTRAD"
```

### `MASK mask[,startPoint]`

**Command**. Available only from BASIC 1.1 onward. Programs compiled using this command will only run on Amstrad CPC 664 or CPC 6128 computers.

Defines the mask or pattern to use when drawing lines. The binary value `mask` must be between 0 and 255. Each bit in `mask` determines whether a group of 8 consecutive pixels is drawn (1) or skipped (0). The optional parameter `startPoint` specifies whether the first pixel of the line should be drawn (1) or not (0).

```basic
MODE 0
MASK 15   ' mask = 00001111
GRAPHICS PAPER 3
DRAW 640,0
```

### `MAX(a, b[, c, d, e...])`

**Function**. Returns the maximum value among the parameters provided. Supports both integer and floating-point numbers.

### `MEMORY maxAddress`

**Command**. Sets `maxAddress` as the maximum memory address that the compiled binary can occupy. If the program exceeds this limit during compilation, the compilation will fail.

```basic
MEMORY &A6FB  ' The Firmware/AMSDOS variables start at &A6FC
```

### `MERGE filename`

**Command**. Reads `filename` from disk or tape and replaces the program currently in memory. ABASC **does not support** this command and will produce an error if it is found in the source code. To add or replace other binaries, it is recommended to use the `LOAD` command instead.

### `MID$(string, start[, n])`

**Function and Command**. As a function, it returns a substring of length `n` starting at position `start` from `string`. As a command, It can be used to replace part of the string in memory. Writing directly to string memory is delicate, and the programmer must ensure not to exceed the allocated length of the string; otherwise, the program may behave unpredictably.

```basic
C$ = "AMSTRAD"
PRINT MID$(C$, 3, 3)       ' Output: "STR"
MID$(C$, 3, 3) = "BBB"
PRINT C$                   ' Output: "AMBBBAD"
```

### `MIN(a, b[, c, d, e, f...])`

**Function**. Returns the minimum value among the parameters provided. Supports both integer and floating-point numbers.

### `MODE n`

**Command**. Changes the screen mode. Valid values are 0, 1, or 2.

### `MOVE x, y[, ink[, mode]]`

**Command**. Moves the graphics cursor to the absolute position `(x, y)`.

* Optional parameter `ink` sets the drawing color from that point onward.
* Optional parameter `mode` defines how each point of the line is combined with the background, with the following values:

| Value | Mode               |
| ----- | ------------------ |
| 0     | Fill (normal)      |
| 1     | XOR (exclusive OR) |
| 2     | AND                |
| 3     | OR                 |

### `MOVER x, y[, ink[, mode]]`

**Command**. Works like `MOVE`, but the `x` and `y` coordinates are **relative** to the current cursor position instead of absolute screen coordinates.

### `NEW`

**Command**. In Locomotive BASIC, this clears the current program and all its variables from memory. ABASC generates code to reset the machine (`CALL 0`).

### `NEXT variable`

**Command**. Marks the end of a `FOR` loop.

### `ON n GOSUB list_of_labels`

**Command**. Jumps to the label in the list indicated by `n` and returns after encountering a `RETURN`. Labels are 1-based. They can be either line numbers or identifiers declared with `LABEL`.

### `ON n GOTO list_of_labels`

**Command**. Jumps to the label in the list indicated by `n`. Labels are 1-based and can be either line numbers or identifiers declared with `LABEL`.

### `ON BREAK GOSUB label`

**Command**. In Locomotive BASIC, this jumps to `label` when a program is interrupted by a double press of the `ESC` key. Compiled ABASC programs cannot be interrupted in this way, so this command is ignored and a warning is issued if it appears in the code.

### `ON BREAK STOP`

**Command**. Cancels the last `ON BREAK GOSUB` statement issued. Since compiled ABASC programs ignore the previous statement, this command is also ignored, and a warning is issued if it appears in the code.

### `ON ERROR GOTO label`

**Command**. In interpreted BASIC, this jumps to `label` when an error is detected during program execution. This mechanism does not apply to compiled programs, so ABASC jumps to the label **only** if `ERR` is different from 0 (for example, after changing the value with the `ERROR` command).

**NOTE:** Be careful not to leave a WHILE or FOR bucle using this command as it may cause an undefined behaviour.

```basic
ERROR 0
ON ERROR GOTO errormsg
ERROR 1
ON ERROR GOTO errormsg
PRINT "No errors"
END

LABEL errormsg
    print "Error", ERR
END
```

### `ON SQ(channel) GOSUB label`

**Command**. Registers a jump to a label as an interrupt to be executed when there is a free "slot" in the sound queue of the specified `channel`. The `channel` value must be one of the following:

* 1 = channel A
* 2 = channel B
* 4 = channel C

```basic
ON SQ(2) GOSUB InsertInB
```

### `OPENIN file`

**Command**. Opens the specified `file` for reading. See the `EOF` function section for an example. If an error occurs, error code 31 is generated, which can be retrieved using `ERR`. Only one file can be open for reading at a time.

### `OPENOUT file`

**Command**. Opens the specified `file` for writing. If an error occurs, error code 31 is generated, which can be retrieved using `ERR`. Only one file can be open for writing at a time.

### `ORIGIN x,y[,left,right,top,bottom]`

**Command**. Sets the current position of the graphics cursor. Optionally, you can define the dimensions of the graphics window by providing `left`, `right`, `top`, and `bottom` coordinates. Calling `MODE` will reset the window dimensions.

```basic
CLS: BORDER 13
LABEL LOOP
    ORIGIN 0,0,50,590,350,50
    DRAW 540,350
GOTO LOOP
```

## `OUT port,n`

**Command.** Sends the value `n` to the specified hardware `port`.

### `PAPER [#channel,]ink`

**Command.** Sets the background color for text. If no `channel` is specified, the command applies to channel #0. **See note under `PEN`.**

```basic
MODE 1
INK 1,3  ' red color
PAPER 1
CLS
```

### `PEEK(address)`

**Function.** Returns the content of the memory byte at the specified `address`.

```basic
' Print the 5 bytes of a real number
N! = PI
FOR I = 0 TO 4
    PRINT HEX$(PEEK(@N!+I),2);" ";
NEXT
```

### `PEN [#channel,]ink`

**Command.** Sets `ink` as the drawing color for the specified channel (#0 by default).

```basic
MODE 1
INK 2,3  ' red color
PEN 2
PRINT "HELLO WORLD"
```

**NOTE:** The `PAPER` and `PEN` values are not applied immediately. They are stored in firmware variables and sent to the hardware once per frame via the routine called by the interrupts. If these values are changed inside a routine triggered by `EVERY` or `AFTER`, it is very likely that the change will have no effect.

### `PI`

**Function.** Returns the real number 3.14159265.

### `PLOT x,y[,ink[,mode]]`

**Command.** Moves the graphics cursor to position `x`,`y` and plots a point. If an `ink` value is specified, it becomes the active drawing color. The fourth parameter defines the drawing mode or mask applied between each point and the background:

| Value | Mode               |
| ----- | ------------------ |
| 0     | Fill (normal)      |
| 1     | XOR (exclusive OR) |
| 2     | AND                |
| 3     | OR                 |

### `PLOTR x,y[,ink[,mode]]`

**Command.** Works like `PLOT` but with `x` and `y` interpreted as relative coordinates from the current graphics cursor position rather than absolute coordinates.

### `POKE address,n`

**Command.** Writes the value `n` (a byte) into the memory location `address`. If `n` is greater than 255, the value is truncated.

```basic
CLS
SUB MEMCOPY(org,dest,n)
    FOR I = 0 TO n
        byte = PEEK(org+I)
        POKE dest+I,byte
    NEXT
END SUB

A$ = "HELLO WORLD"
B$ = ""
CALL MEMCOPY(@A$, @B$, 11)  ' 10 characters plus length byte
PRINT B$
```

### `POS(#channel)`

**Function.** Returns the current X position of the text cursor for the specified `channel` (#0 by default).

```basic
MODE 1
PRINT POS(#0), VPOS(#0)
```

### `PRINT [#channel,][list of items]`

**Command.** `PRINT` is a highly versatile command with many options. Its full details are beyond the scope of this manual, so the reader is encouraged to consult the references listed in the `References` chapter. **Note:** ABASC does **not** support formatted output using `USING`.

### `RAD`

**Command.** Sets trigonometric functions to return results in radians. It is the counterpart to `DEG`.

```basic
DEG
PRINT SIN(90.0)
RAD
PRINT SIN(90.0)
```

### `RANDOMIZE [n]`

**Command.** The ABASC implementation differs slightly from the usual behavior in Locomotive BASIC. If `RANDOMIZE` is used without parameters, ABASC treats it as if `RANDOMIZE TIME` had been used. Both `RANDOMIZE` and `RND` require the use of real numbers.

```basic
RANDOMIZE
FOR I=1 TO 20
    PRINT RND
NEXT
```

### `READ variable-list`

**Command.** Reads the next datum from those declared using `DATA` and assigns it to the corresponding variable in the list. It is the programmer’s responsibility to ensure that the data type matches the type of the target variable.

```basic
CLS
FOR I=0 TO 5
    READ name$
    PRINT "Name:", name$
NEXT
END

DATA "Xavier","Ross","Gada",
DATA "Anabel","Rachel","Elvira"
```

### `READIN variable-list`

**Command.** Equivalent to `INPUT #9`; that is, it reads data from the currently open input file and assigns them to the variables in the list. At present, ABASC does not support real variables with this command.

### `RECORD name;variable-list`

**Command.** Declares a record structure that can be applied to string (`$`) variables in order to create data structures. See the section *Record Structures with `RECORD`* in the chapter *Compiler Specifics* for more details.

```basic
DECLARE A$ FIXED 13   ' Optional, but reduces memory usage
RECORD person; name$ FIXED 10, age   ' Requires 13 bytes of memory

A$.person.name$ = "Juan"
A$.person.age = 20
```

### `RELEASE channel`

**Command.** Sounds queued on a given `channel` may enter a *hold* state. This command releases those sounds. `channel` is an integer that specifies the affected channels:

* 1 = channel A
* 2 = channel B
* 4 = channel C

```basic
RELEASE 7   ' releases sounds on all three channels
```

### `REM text`

**Command.** Inserts a comment in the program. The symbol `'` is an alias for this command.

### `REMAIN(timer)`

**Function.** Disables the event associated with `timer` (in the range 0–3) and returns the number of ticks remaining before it would have been triggered. Such events are registered using `AFTER` or `EVERY`.

### `RENUM new-line, origin-line, step`

**Command.** In Locomotive BASIC, this command renumbers the program’s line numbers. In a compiled program this has no meaning. ABASC ignores this command and issues a warning if it appears in the source code.

### `RESTORE [label]`

**Command.** Sets the next value to be read by `READ` to the first `DATA` item found after the specified `label`, which may be either a line number or an identifier declared using `LABEL`. If no `label` is given, the next `READ` will fetch the very first `DATA` item in the program.

```basic
LABEL LOOP
FOR N=1 TO 5 
    READ A$ 
    PRINT A$;" "; 
    DATA data,"to read",again,and,again   
NEXT 
PRINT 
RESTORE 
GOTO LOOP
```

### `RESUME`

**Command.** Resumes execution after an error event handled by `ON ERROR GOTO`. This mechanism only works in interpreted BASIC. ABASC implements 'ON ERROR GOTO' in a different way so it ignores `RESUME` and issues a warning if it appears in the code.

### `RETURN`

**Command.** Continues execution at the instruction immediately following the most recent `GOSUB`.

### `RIGHT$(string, n)`

**Function.** Returns the rightmost `n` characters from `string`.

```basic
PRINT RIGHT$("AMSTRAD", 3)
```

### `RND[(0)]`

**Function.** Returns a pseudo-random number in the range [0.0–1.0]. When called with the parameter `0` (`RND(0)`), it returns the **last** generated random number. The use of `RANDOMIZE` and `RND` implies the use of real numbers.

```basic
RANDOMIZE
FOR I=1 TO 20
    PRINT RND
NEXT
```

### `ROUND(x[,n])`

**Function.** Rounds the real number `x` to `n` decimal places (`n = 0` by default).

```basic
FOR I=0 TO 4
    PRINT ROUND(PI, I)
NEXT
PRINT ROUND(PI, -3)
```

### `RUN [label | file]`

**Command.** In Locomotive BASIC, this command runs the program already in memory from the beginning (no argument), starts the program in memory at the specified `label`, or loads a program from `file` and executes it from the beginning. ABASC only supports the first two forms. Bedore jumping to the start or the `label`, ABASC executes a `CLEAR` command to ensure some consistency between executions.

### `SAVE file[,type][,address,size[,entry]]`

**Command.** In Locomotive BASIC, this instruction saves a program to disk or tape. ABASC, however, only allows saving a memory region as a binary file. Therefore, the file `type` must be always **B** (Binary), and must be specified as such if any of the following parameters are used. For reference, the file types supported in Locomotive BASIC are:

* **A** – ASCII text
* **P** – Protected file
* **B** – Binary

The additional optional parameters are:

| Parameter | Description                                             |
| --------- | ------------------------------------------------------- |
| `address` | Starting memory address for the dump.                   |
| `size`    | Total number of bytes to write to the file.             |
| `entry`   | Execution address when the binary is loaded with `RUN`. |

```basic
MODE 1
PAPER 3
CLS
SAVE "pantalla.bin",B,&C000,&4000
PAPER 0
CLS
LOAD "pantalla.bin"
```
### `SGN(x)`

**Function.** Returns **–1** if `x` is less than 0, **0** if `x` is exactly 0, and **1** if `x` is greater than 0.

```basic
PRINT SGN(PI)
```

### `SHARED variable | array [,variable | array]`

This command is imported from Locomotive BASIC 2 Plus. Sometimes is necessary to allow routines to access global variables declared in the main program. This can be done by declaring the variable in the routine as SHARED. The use of brackets at the end of the variable name means that the variable is an array.

```basic
DIM vec(3)

SUB setvec()
    SHARED vec[]
    vec(0) = 1
    vec(1) = 2
    vec(2) = 3
END SUB

call setvec()
```

### `SIN(x)`

**Function.** Returns the sine of `x`. Requires the use of real numbers.

### `SOUND channel,period,duration,volume,env,ent,noise`

**Command.**
`SOUND` is one of the strongest features of Locomotive BASIC compared to other BASIC dialects of the era. It is extremely flexible and provides extensive access to the Amstrad CPC's sound chip.
Given its complexity, readers are encouraged to study the books listed in the **References** chapter for full details.

```basic
ENV 2,127,0,0,127,0,0,127,0,0,127,0,0,127,0,0
SOUND 1,1000,0,12,2
SOUND 2,900,0,12,2
```

### `SPACE$(n)`

**Function.** Returns a string containing `n` space characters.

### `SPEED INK t1,t2`

**Command.** The `INK` and `BORDER` commands can assign two alternating colors. `SPEED INK` specifies how long each color remains visible. `t1` and `t2` represent durations in **frames** (50 per second).

```basic
SPEED INK 150,50 ' 3 seconds and 1 second
BORDER 0,1
```

### `SPEED KEY delay,repeat`

**Command.** When a key is held down, it begins repeating after the specified `delay`, then repeats again every `repeat` frames. Times must be in the range **1 to 255 frames** (50 per second).

### `SPEED WRITE n`

**Command.** Changes the tape output speed (in baud). `n` can be:

* **1** → 2000 baud
* **0** → 1000 baud

### `SQ channel`

**Function.** Returns the number of free entries in the queue for the specified `channel` (1, 2, or 4).
It also determines whether that channel is currently active and, if not, why the first entry in the queue (if present) is waiting.

The result is an integer whose bits encode the information as follows:

* **Bits 0, 1, 2** – Number of free slots in the queue.
* **Bits 3, 4, 5** – Synchronization status of the first note in the queue.
* **Bit 6** – Set if the first note is waiting.
* **Bit 7** – Set if the channel is currently active.

```basic
SOUND 65,100,100
PRINT BIN$(SQ(1),8) ' should print 01000011
```

### `SQR(x)`

**Function.** Returns the square root of `x`. Requires real-number support.

### `STOP`

**Command.** In Locomotive BASIC, this stops program execution and returns control to the interpreter.
Execution may be resumed with `CONT`. Since this is of little use in a compiled program, ABASC repurposes this instruction to perform a machine reset (`CALL 0`).

### `STR$(x)`

**Function.** Converts the number `x` to a string.

```basic
PRINT "PI = " + STR$(PI)
```

### `STRING$(n,character)`

**Function.** Returns a string composed of the specified `character` repeated `n` times.

```basic
MODE 1
LOCATE 1,10
PRINT STRING$(40,250)
```

### `SUB [(parameters)] [ASM]`

**Command.** Imported from **Locomotive BASIC 2 Plus**, `SUB` defines procedures with parameters.
You must use `CALL` to invoke a procedure declared with `SUB`. Procedures must be declared **before** any call to them appears in the code.

If the `ASM` clause is specified, ABASC assumes that the body of the procedure will consist mostly of assembly code that does **not** rely on the temporary-memory mechanism.

Programmers are encouraged to read the sections **Functions and Procedures** and **Using Assembly Code** in the chapter **“Compiler Peculiarities”** for details on parameter handling and recursion support.

```basic
SUB myUSING(n,long)
    ' Prints number N using a fixed LONG width,
    ' padding the left side with zeroes.
    n$ = STR$(n)
    text$ = STRING$(long,48)  ' fill with ASCII 0
    digits = LEN(n$)
    ini = long - LEN(n$) + 1
    MID$(text$,ini,digits)=n$
    PRINT text$
END SUB

num=1234
CALL myUSING(num,8)
```

### `SYMBOL character,value1,value2,...,value8`

**Command.** Redefines the symbol identified by the numeric code `character`. This code must correspond to a redefinable character slot (see `SYMBOL AFTER`).

Each character is represented by an **8×8 pixel matrix**. The eight values following the character code define each row of the matrix. Each value is the sum of the bits corresponding to the pixels that should be lit using the current pen color. The bit values for each pixel position are:

| Pixel 1 | Pixel 2 | Pixel 3 | Pixel 4 | Pixel 5 | Pixel 6 | Pixel 7 | Pixel 8 |
| ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 128     | 64      | 32      | 16      | 8       | 4       | 2       | 1       |

```basic
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
PRINT CHR$(22)+CHR$(1)  ' Transparent printing ON
LOCATE 5,2:PEN 11:PRINT CHR$(240);
LOCATE 5,2:PEN 1: PRINT CHR$(241);
LOCATE 5,2:PEN 8: PRINT CHR$(242);
LOCATE 5,2:PEN 3: PRINT CHR$(243);
LOCATE 5,3:PEN 10:PRINT CHR$(244);
LOCATE 5,3:PEN 6: PRINT CHR$(245);
LOCATE 5,3:PEN 11:PRINT CHR$(246);
LOCATE 5,4:PEN 9: PRINT CHR$(247);
LOCATE 5,4:PEN 3: PRINT CHR$(248);
PRINT CHR$(22)+CHR$(0)  ' Transparent printing OFF
```

### `SYMBOL AFTER n`

**Command.** Sets the character code from which redefinitions are allowed. `n` must be between **1 and 256**. By default, programs may redefine characters **240–255**.

In a compiled program, the effective available range is the **lowest** value used across all `SYMBOL AFTER` statements.

ABASC reserves **8 bytes per redefinable character**. If custom symbols are not needed, it is recommended to begin the program with:

```basic
SYMBOL AFTER 256
```

This prevents memory from being reserved. See the `SYMBOL` section for an example.

### `TAG [#channel]`

**Command.** Redirects the text output of the specified `channel` (#0 by default) so that it uses the **graphics cursor** instead of the text cursor. This allows mixing text with graphics or moving the printed text pixel-by-pixel instead of in 8×8 character blocks.

```basic
MODE 2
BORDER 9
INK 0,12 : INK 1,0
LABEL BUCLE
TAG
FOR n = 1 TO 100
    MOVE 200+n, 320+n
    IF n < 70 THEN
        PRINT "Hola";
    ELSE
        PRINT "Adios";
    END IF
NEXT
GOTO BUCLE
```

### `TAGOFF [#channel]`

**Command.** Disables the use of the graphics cursor for the specified text channel (#0 by default).
See `TAG` for details.

### `TAN(x)`

**Function.** Returns the tangent of angle `x`. Uses real-number arithmetic.

```basic
PRINT TAN(45)
```

### `TEST(x,y)`

**Function.** Returns the ink value of the pixel located at screen coordinates `(x, y)`.

```basic
MODE 1
PRINT TEST(320,200)
PLOT 320,200,1
PRINT TEST(320,200)
```

### `TESTR(x,y)`

**Function.** Equivalent to `TEST`, but interprets `x` and `y` as **relative** rather than absolute positions.

### `TIME[(n)]`

**Function.** Returns the time elapsed since the machine was powered on. The measurement is done in units of 1/300 of a second. It requires interrupts to be enabled; therefore, `DI` and certain disk/tape operations will prevent the timer from advancing. The returned value is a real number.

ABASC provides an additional usage mode in which `TIME` behaves as a **command**. In this form, you may supply an integer value in parentheses, and that value becomes the new `TIME` counter.

```basic
CLS
T! = TIME      ' TIME(0) could be used instead
FOR i = 1 TO 10
    FOR j = 1 TO 1000
        s = 1000 + j
    NEXT j
    PRINT ".";
NEXT i
PRINT " FIN!"
PRINT "Tiempo ="; (TIME - T!) / 300.0; "s"   ' If TIME(0) was used, subtracting is unnecessary
```

Finally, if ABASC detects that the value returned by `TIME` is being converted to an integer, it applies an optimization that avoids using real numbers. However, the programmer should be cautious when using `TIME` in this way, since the value wraps around every 3 seconds due to the lower precision of integers.

```basic
TIME(0)
FOR I = 0 TO 20
    FRAME
    PRINT CINT(TIME)
NEXT
```

### `TROFF`

**Command.** Disables trace printing. ABASC ignores this command when compiling and emits a warning.
See also `TRON`.

### `TRON`

**Command.** In Locomotive BASIC, enables execution tracing during program interpretation. ABASC ignores this command when compiling and emits a warning.

### `UNT(n)`

**Command.** Converts an unsigned value (such as a memory address) in the range 0..65535 into a signed integer in the range -32768..+32767.

```basic
PRINT UNT(&FF66)  ' Outputs: -154
```

### `UPPER$(cadena)`

**Function.** Returns `cadena` with all characters converted to uppercase.

```basic
C$ = "AmsTRaD"
PRINT LOWER$(C$)
PRINT UPPER$(C$)
```

### `VAL(cadena)`

**Function.** Returns the first **integer** found in `cadena`. Unlike the BASIC interpreter on Amstrad CPC machines, `VAL` **cannot** extract a real number from a string.

```basic
PRINT VAL("15") + 15  ' Outputs: 30
```

### `VPOS([#canal])`

**Function.** Returns the current Y position of the text cursor for the specified `canal` (#0 by default).

```basic
MODE 1
PRINT POS(#0), VPOS(#0)
```

### `WAIT puerto,mascara[,inversion]`

**Command.** Pauses execution until a specified value is read from the given I/O `puerto`. The command performs an **AND** with the `mascara` and an optional **XOR** with `inversion` (if provided). Execution resumes only if the result is nonzero.

```basic
WAIT &FF34, 20, 25
```

### `WEND`

**Command.** Marks the end of a `WHILE` loop.

### `WHILE condición`

**Command.** Marks the beginning of a loop that continues executing as long as `condición` is true.

```basic
CLS
PRINT "Waiting 10 seconds": T! = TIME + 3000
WHILE TIME < T!
    SOUND 1, 0, 100, 15
WEND
SOUND 129, 40, 30, 15
```

### `WIDTH n`

**Command.** Specifies the maximum character width for the printer. ABASC does **not** support this command and will issue a warning if it appears in the code to be compiled.

### `WINDOW [#channel,]left,right,top,bottom`

**Command.** Defines a new text window for the specified `channel` (#0 by default, valid range #0..#7).

```basic
MODE 1
WINDOW #1, 1, 40, 20, 25
WINDOW #2, 2, 39, 21, 24
PAPER 0
PAPER #1, 1
PAPER #2, 2
CLS#0
CLS#1
CLS#2
```

### `WINDOW SWAP channel1,channel2`

**Command.** Swaps the settings of the text windows associated with `channel1` and `channel2`.

```basic
MODE 1
WINDOW #1, 1, 40, 20, 25
PAPER 0
PAPER #1, 2
CLS#0
CLS#1
WINDOW SWAP 0, 1
PRINT "WINDOW 0"
```

### `WRITE [#channel,]data1,data2,...`

**Command.** In Locomotive BASIC, writes the specified values to the indicated channel (#0 by default). ABASC ignores the channel parameter and always uses #9, the channel for file operations. Therefore, `WRITE` can be used to save data to a file, while `READIN` can be used to read it back. Real numbers are **not supported**; only integers or text strings can be written.

```basic
A = 15
NOM$ = "Juan"
OPENOUT "DATA.TXT"
WRITE #9, NOM$, A
CLOSEOUT
```

### `XPOS`

**Function.** Returns the current **X** position of the graphics cursor.

```basic
MODE 1
PRINT XPOS; YPOS
MOVE 320, 200
PRINT XPOS; YPOS
```

### `YPOS`

**Function.** Returns the current **Y** position of the graphics cursor. See `XPOS`.

### `ZONE n`

**Command.** Changes the width (default is 13) of the print zone used by `PRINT` when items are separated with commas.

```basic
CLS
PRINT "A", "B"
ZONE 4
PRINT "A", "B"
```

---

# Appendix I: Debugging Compiled Programs

Debugging programs generated by a cross-compiler can be a challenging task, as the machine running the code is different from the machine where it was developed. Fortunately, emulators can significantly simplify this process. For example, **WinApe** and **Retro Virtual Machine** allow us to set up an effective debugging environment.

## Verifying BASIC Code

**WinApe** provides a convenient way to "paste" BASIC code and run it. This allows us to compare results between the BASIC interpreter and our compiled code. Naturally, to make a fair comparison, we cannot use features introduced in Locomotive BASIC 2.0 (such as `FUNCTION`, `SUB`, multiline `IF`, etc.). However, we **can** use the following options:

* Code without line numbers
* Code split across multiple files

When compiling with ABASC, the first step is handled by the preprocessor. With the `--verbose` option enabled, it generates an intermediate file with the `.BPP` extension, where line numbers are added and any additional files referenced with `CHAIN MERGE` are included.

To paste code into **WinApe**, follow these steps:

1. Select the desired code in your preferred editor and choose the `Copy` option.
2. In **WinApe**, go to the `File` menu and select `Paste`.
3. If you are pasting a large amount of code, enable `Settings > High Speed` to accelerate the process. Remember to switch back to `Normal Speed` once the paste is complete.

## Debugging our Code

It is not possible to debug BASIC code step by step, but we **can** debug the assembly code generated by the compiler. As part of the compilation process, ABASC produces an intermediate file with the `.ASM` extension. This file uses a syntax compatible with **WinApe** and **Retro Virtual Machine 2.0**.

In **Retro Virtual Machine**, we can enable debugging tools by following these steps:

1. Open our Amstrad CPC machine (464 or 6128).
2. Click on the hamburger menu in the top-left corner.
3. Enable the `Developer Mode` option.

An icon with a hammer will appear in the top toolbar. Clicking on it will display a submenu with various tools; we select the last one, the **Retro Virtual Machine** console. From this console, we can navigate through the machine’s directories and load our code as follows:

* `ls` — Lists the contents of the current directory.
* `cd` — Changes the current directory.
* `asm` — Assembles the specified `.ASM` file.

This method allows us to load our program into a test environment much faster than using `.DSK` files and disk support. Once the program is in memory, it can be executed with the command:

```basic
CALL &170
```

Additionally, after assembling our code with **Retro Virtual Machine**, it is possible to list all symbols (line labels, variable names, etc.) in the console using the command:

```
symbols
```

This allows us to set breakpoints at any memory location with:

```
break memory-address
```

To clear all breakpoints, simply execute:

```
break -x
```

This debugging process requires some familiarity with assembly code. The `References` section includes books and resources that can serve as useful learning material.

Finally, readers are encouraged to consult the official documentation for **WinApe** and **Retro Virtual Machine** to explore additional debugging options and fully leverage the tools provided by these emulators.

---

# Appendix II: Extending the Compiler

One of the major advantages of ABASC is that, being written in Python, it is easy to **extend and modify its functionality**. The source code is organized across the following main files:

* **abasc.py – Main file:** Handles the compiler options and executes the compilation process step by step.
* **baspp.py – Preprocessor:** Adds line numbers and inserts any additional code files referenced via `CHAIN MERGE`. If the `--verbose` option is enabled, it generates an intermediate file with the `.BPP` extension.
* **baslex.py – Lexical Analyzer:** Scans the source code and generates the corresponding list of tokens. With `--verbose`, it produces an intermediate `.LEX` file.
* **basparse.py – Syntax Analyzer:** Processes the token list, checks the program’s syntax, and generates an intermediate representation of the code in the form of an Abstract Syntax Tree (AST). With `--verbose`, an intermediate `.AST` file is generated.
* **emitters/cpcemitter.py – Assembler Code Generator:** Takes the AST produced by the syntax analyzer and outputs the equivalent assembly code. The result is saved as a `.ASM` file, which is then assembled by **ABASM** to produce the final binary.
* **emitters/cpcrt.py – Compiler Runtime:** Contains assembly routines called by the code generated by `cpcemitter.py`.

Whenever changes are made to any of these files, it is recommended to check for obvious errors. This can be done by running the following commands from the directory containing `abasc.py`:

* **Type checking:**

```bash
mypy . --explicit-package-bases
```

* **Unit testing:**

```bash
python3 -m unittest -b
```

Finally, the `examples` directory contains several sample programs that can be compiled and also used for testing and experimenting with the compiler.

---

