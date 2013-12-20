@echo off

setlocal enableextensions
cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

REM Ex1.a ========================================================

call Ex1.a.Run.CREATE-DB-TBL.bat

REM Ex1.b ========================================================

call Ex1.b.Run-Ex1-AsAdmin.bat

call Ex1.b.Run-Ex1Cliente.a.bat

call Ex1.Select-Run.bat

REM Ex1.c.0 ======================================================

call Ex1.c.Run-Ex1Cliente.c.bat

call Ex1.Select-Run.bat

REM Ex1.c.1 ======================================================

taskkill /f /fi "pid gt 0" /im Ex1.exe

taskkill /f /fi "pid gt 0" /im Ex1Cliente.exe

call Ex1.c.1.Run-Ex1-AsAdmin.bat

call Ex1.c.Run-Ex1Cliente.c.bat

call Ex1.Select-Run.bat

taskkill /f /fi "pid gt 0" /im Ex1.exe

taskkill /f /fi "pid gt 0" /im Ex1.c.exe

taskkill /f /fi "pid gt 0" /im Ex1Cliente.exe

taskkill /f /fi "pid gt 0" /im Ex1.vshost.exe

taskkill /f /fi "pid gt 0" /im Ex1.c.vshost.exe

taskkill /f /fi "pid gt 0" /im Ex1Cliente.vshost.exe
