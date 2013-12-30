@echo off

setlocal enableextensions
cd /d "%~dp0"
cd /d ".\Ex1Code\Ex1.c\bin\Debug\"

echo Running "Ex1.c\...\Ex1.c.exe..."
start "" ".\Ex1.c.exe"
pause