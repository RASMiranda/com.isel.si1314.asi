@echo off

setlocal enableextensions
cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

REM Config DTC ===================================================

call Ex3.0-Start-CompSrv

type Ex3.1-ConfigDTC.txt

REM Ex3.a ========================================================

call Ex3.b.0-Update-Jose.bat

call Ex3.Select.bat

call Ex3.a.Run-Ex3-AsAdmin.bat

call Ex3.a.Run-Ex3Cliente.bat

call Ex3.Select.bat

taskkill /f /fi "pid gt 0" /im Ex3.exe

taskkill /f /fi "pid gt 0" /im Ex3Cliente.exe

REM Ex3.b ========================================================

call Ex3.b.0-Update-Jose.bat

call Ex3.Select.bat

call Ex3.b.0.Run-Ex3.b.0-AsAdmin

call Ex3.b.0.Run-Ex3Client.bat

call Ex3.Select.bat

taskkill /f /fi "pid gt 0" /im Ex3.b.0.exe

taskkill /f /fi "pid gt 0" /im Ex3Cliente.b.0.exe
