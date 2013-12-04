@echo off

echo Running "Ex2-DeleteInteresses"
".\Ex2-DeleteInteresses\Ex2\bin\Debug\Ex1.exe"
if not %errorlevel% == 0 goto end

:end
pause