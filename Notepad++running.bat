@echo off
SETLOCAL EnableExtensions
set EXE=notepad++.exe
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto FOUND
EXIT /B 7
goto FIN
:FOUND
EXIT /B 6
:FIN