@echo off

set AL4.1TargetExec=".\Ex4-original\Ex4\bin\Debug\Ex1.exe"

copy /y "..\Ex3.App.config" ".\Ex4-original\Ex4\App.config" 
%MSBuild% .\Ex4-original\Ex4.sln
echo Running %AL4.1TargetExec%...
net start msdtc
%AL4.1TargetExec%
net stop msdtc
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