@echo off
REM Example batch file that converts Markdown files to HTML
REM using PANDOC (must be present in the system) and its default HTML template.

SET PANDOC=pandoc --standalone --variable=maxwidth:50em

del .\en\*.html
del .\es\*.html

%PANDOC% .\en\abasc.md -o .\en\abasc.html
%PANDOC% .\en\abasm.md -o .\en\abasm.html
%PANDOC% .\en\cdt.md -o .\en\cdt.html
%PANDOC% .\en\dsk.md -o .\en\dsk.html
%PANDOC% .\en\dsk.md -o .\en\img.html

%PANDOC% .\en\abasc.md -o .\en\abasc.html
%PANDOC% .\es\abasm.md -o .\es\abasm.html
%PANDOC% .\es\cdt.md -o .\es\cdt.html
%PANDOC% .\es\dsk.md -o .\es\dsk.html
%PANDOC% .\en\dsk.md -o .\es\img.html

@echo on
