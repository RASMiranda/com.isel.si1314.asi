@echo off

echo Running "Ex1.2\LNEx3"
".\Ex1.2\LNEx3\bin\Debug\LNEx2.exe"
if not %errorlevel% == 0 goto end

:end
pause