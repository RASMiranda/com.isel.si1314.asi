@echo off

echo Running "Ex3-NoDetect"
".\Ex4\Ex4\bin\Debug\Ex1.exe"
if not %errorlevel% == 0 goto end

:end
pause