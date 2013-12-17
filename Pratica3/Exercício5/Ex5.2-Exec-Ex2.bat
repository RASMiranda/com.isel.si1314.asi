@echo off

set AL5.2TargetExec=".\Ex2\Ex2\bin\Debug\Ex1.exe"

copy /y "..\Ex3.App.config" ".\Ex2\Ex2\App.config" 
%MSBuild% .\Ex2\Ex2.sln
echo Running "Ex2"
%AL5.2TargetExec%
if %errorlevel% == 0 (
	echo Execucao sem excecoes!
	pause
)
if %errorlevel% == 1 (
	echo Execucao *COM* excecoes!
	pause
)

:end
pause