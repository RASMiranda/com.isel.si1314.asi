@echo off

setlocal enableextensions
cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

REM Ex2 ========================================================

call Ex2.Select.bat

call Ex2.Run-Ex2-AsAdmin.bat

call Ex2.Run-Ex2Cliente.bat

call Ex2.Select.bat


taskkill /f /fi "pid gt 0" /im Ex2.exe

taskkill /f /fi "pid gt 0" /im Ex2Cliente.exe

taskkill /f /fi "pid gt 0" /im Ex2Cliente.a.exe
