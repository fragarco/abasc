REM This example was originally created by @cpcbegin
REM used here only for testing purposes
REM https://malagaoriginal.blogspot.com/2025/11/mostrar-el-contenido-de-un-archivo-de.html

label start
mode 2
cat
locate 1,25: print chr$(24) + "File to open (including extension): " + chr$(24);
input "",file$
cls
file$=upper$(file$)
openin file$
while not eof
    line input #9,c$
    print c$
    if vpos(#0) > 23 then
        print chr$(24) + "Press any key to continue..." + chr$(24)
        while inkey$="":wend
        mode 2
    end if
wend
closein
locate 1,25: print chr$(24) + "Do you want to view another document? (y/n)" + chr$(24)
label presskey
k$ = inkey$
if k$="" then goto presskey
if k$="y" or k$="Y" then goto start
stop