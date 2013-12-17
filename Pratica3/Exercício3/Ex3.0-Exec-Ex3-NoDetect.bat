@echo off

set AL3.1TargetExec=".\Ex3-NoDetect\Ex3\bin\Debug\Ex1.exe"

copy /y "..\Ex3.App.config" ".\Ex3-NoDetect\Ex3\App.config" 
%MSBuild% .\Ex3-NoDetect\Ex3.sln
echo Running %AL3.1TargetExec%...
%AL3.1TargetExec%
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
