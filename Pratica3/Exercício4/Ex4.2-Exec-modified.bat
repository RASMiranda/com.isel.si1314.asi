@echo off

set AL4.2TargetExec=".\Ex4\Ex4\bin\Debug\Ex1.exe"

copy /y "..\Ex3.App.config" ".\Ex4\Ex4\App.config" 
%MSBuild% .\Ex4\Ex4.sln
echo Running %AL4.2TargetExec%...
%AL4.2TargetExec%
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