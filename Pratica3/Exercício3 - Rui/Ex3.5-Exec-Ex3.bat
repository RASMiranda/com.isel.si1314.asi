@echo off

echo Running "Ex3"
".\Ex3\Ex3\bin\Debug\Ex1.exe"
if not %errorlevel% == 0 goto end

:end
pause