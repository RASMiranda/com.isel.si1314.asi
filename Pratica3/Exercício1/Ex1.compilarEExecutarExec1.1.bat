@echo off

set AL1.1TargetExec=".\Ex1.1\LNEx2\bin\Debug\LNEx2.exe"

copy /y "..\Ex1.App.config" ".\Ex1.1\LNEx2\App.config" 
%MSBuild% .\Ex1.1\Ex2.sln
echo Running %AL1.1TargetExec%...
%AL1.1TargetExec%
if %errorlevel% == 0 (
	echo Execucao sem excecoes!
	pause
)

:end
pause