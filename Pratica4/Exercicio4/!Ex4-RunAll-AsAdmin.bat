@echo off

setlocal enableextensions
cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

REM Data ===================================================

REM Ex4.a ========================================================

call Ex4.Update-Delete.bat

call Ex4.Select.bat

call Ex4.a.Run-Ex4-AsAdmin.bat

call Ex4.a.Run-Ex4Cliente.bat

call Ex4.Select.bat

taskkill /f /fi "pid gt 0" /im Ex4.exe

taskkill /f /fi "pid gt 0" /im Ex4Cliente.exe

REM Ex4.b ========================================================

call Ex4.a.Run-Ex4-AsAdmin.bat

call Ex4.b.Run-Ex4Cliente.b.bat

call Ex4.Select.bat

taskkill /f /fi "pid gt 0" /im Ex4.exe

taskkill /f /fi "pid gt 0" /im Ex4Cliente.b.exe
