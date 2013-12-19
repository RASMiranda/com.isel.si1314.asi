@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

call startProfiler.bat


set AL2.0TargetExec=".\Ex2\Ex2\bin\Debug\Ex1.exe"

copy /y "..\Ex3.App.config" ".\Ex2\Ex2\App.config" 
%MSBuild% .\Ex2\Ex2.sln
echo Running %AL2.0TargetExec%...
%AL2.0TargetExec%
if %errorlevel% == 0 (
	echo Execucao sem excecoes!
	pause
)

:end
pause


taskkill /im "profiler.exe"
