REM This example was originally created by @cpcbegin
REM used here only for testing purposes
REM https://malagaoriginal.blogspot.com/2025/11/mostrar-el-contenido-de-un-archivo-de.html

mode 2
file$="TEST.TXT"
openin "!"+UPPER$(file$)
while not eof
    line input #9,c$
    print c$
    if vpos(#0) > 23 then
        print "        Press any key to continue       "
        while inkey$="":wend
        mode 2
    end if
wend
closein
