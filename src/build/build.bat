@echo off

del /Q  %~dp0..\..\bin\*.exe

SET COMMON_FLAGS=--onefile -p%~dp0..\ -p%~dp0..\utils -p%~dp0..\emitters --distpath %~dp0..\..\bin

SET ABASC=pyinstaller %~dp0..\abasc.py %COMMON_FLAGS% 
SET BASPRJ=pyinstaller %~dp0..\basprj.py %COMMON_FLAGS%
SET ABASM=pyinstaller %~dp0..\utils\abasm.py %COMMON_FLAGS%
SET DSK=pyinstaller %~dp0..\utils\dsk.py %COMMON_FLAGS%
SET CDT=pyinstaller %~dp0..\utils\cdt.py %COMMON_FLAGS%
SET IMG=pyinstaller %~dp0..\utils\img.py %COMMON_FLAGS%
SET ASMPRJ=pyinstaller %~dp0..\utils\asmprj.py %COMMON_FLAGS%

CALL %ABASC% && CALL %BASPRJ% && CALL %ABASM% && CALL %DSK% && CALL %CDT% && CALL %IMG% && CALL %ASMPRJ%

rmdir /Q /S %~dp0..\..\bin\lib
xcopy /Q /S %~dp0..\lib\  %~dp0..\..\bin\lib\

@echo on