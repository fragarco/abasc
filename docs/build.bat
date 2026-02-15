@echo off
REM Example batch file that converts Markdown files to HTML
REM using PANDOC (must be present in the system) and its default HTML template.

SET PANDOC=pandoc --standalone --variable=maxwidth:50em

IF "%1"=="clear" (
    del .\html\en\*.html
    del .\html\es\*.html
    rmdir .\html\en
    rmdir .\html\es
    rmdir .\html
) ELSE (
    if not exist ".\html" mkdir .\html
    if not exist ".\html\en" mkdir .\html\en
    if not exist ".\html\es" mkdir .\html\es

    %PANDOC% .\en\abasc.md -o  .\html\en\abasc.html --metadata title="ABASC"
    %PANDOC% .\en\abasm.md -o  .\html\en\abasm.html --metadata title="ABASM"
    %PANDOC% .\en\basprj.md -o .\html\en\basprj.html --metadata title="BASPRJ"
    %PANDOC% .\en\cdt.md -o    .\html\en\cdt.html --metadata title="CDT"
    %PANDOC% .\en\dsk.md -o    .\html\en\dsk.html --metadata title="DSK"
    %PANDOC% .\en\img.md -o    .\html\en\img.html --metadata title="IMG"

    %PANDOC% .\es\abasc.md -o  .\html\es\abasc.html --metadata title="ABASC"
    %PANDOC% .\es\abasm.md -o  .\html\es\abasm.html --metadata title="ABASM"
    %PANDOC% .\es\basprj.md -o .\html\es\basprj.html --metadata title="BASPRJ"
    %PANDOC% .\es\cdt.md -o    .\html\es\cdt.html --metadata title="CDT"
    %PANDOC% .\es\dsk.md -o    .\html\es\dsk.html --metadata title="DSK"
    %PANDOC% .\es\img.md -o    .\html\es\img.html --metadata title="IMG"
)

@echo on
