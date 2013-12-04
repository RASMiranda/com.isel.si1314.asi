@echo off

echo Running "Ex2"
".\Ex2\Ex2\bin\Debug\Ex1.exe"
if not %errorlevel% == 0 goto end

:end
pause