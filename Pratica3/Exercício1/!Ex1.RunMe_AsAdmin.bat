@echo off

setlocal enableextensions
cd /d "%~dp0"

rem call 0.stop.MSDTC-RunAsAdmin.bat
net start | find "Distributed Transaction Coordinator" > nul
if %errorlevel%==0 (
	echo Stopping MSDTC...
	net stop msdtc
)


REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


call 0.run.setupBD.bat


rem call Ex1.clearAlunosEInteresses.bat

call Ex1.compilarEExecutarExec1.1.bat

call Ex1.verificarAlunosEInteresses.bat


call Ex1.clearAlunosEInteresses.bat

call Ex1.compilarEExecutarExec1.2.bat

call Ex1.verificarAlunosEInteresses.bat
