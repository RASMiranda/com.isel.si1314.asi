@echo off

set AL1.2TargetExec=".\Ex1.2\LNEx3\bin\Debug\LNEx2.exe"

copy /y "..\Ex1.App.config" ".\Ex1.2\LNEx3\App.config" 
%MSBuild% .\Ex1.2\Ex3.sln
echo Running %AL1.2TargetExec%...
%AL1.2TargetExec%
if not %errorlevel% == 0 (
	echo Execucao *COM* excecoes!
	pause
)

:end
pause