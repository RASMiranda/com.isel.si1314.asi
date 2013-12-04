@echo off

echo Running "Ex1.1\LNEx2"
".\Ex1.1\LNEx2\bin\Debug\LNEx2.exe"
if not %errorlevel% == 0 goto end

:end
pause