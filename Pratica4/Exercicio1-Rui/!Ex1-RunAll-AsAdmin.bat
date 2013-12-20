@echo off

setlocal enableextensions
cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

REM Ex1.a ========================================================

call Ex1.a.Run.CREATE-DB-TBL.bat

REM Ex1.b ========================================================

echo Running Ex1.exe
start "" ".\Ex1Code\Ex1\bin\Debug\Ex1.exe"

timeout 5

echo Running Ex1Cliente.exe
start "" ".\Ex1Code\Ex1Cliente.a\bin\Debug\Ex1Cliente.exe"

REM Ex1.c.0 ======================================================

REM call ...Ex1Cliente.c...exe

REM Ex1.c.1 ======================================================

REM kill ...Ex1...exe

REM call ...Ex1.c...exe

REM call ...Ex1Cliente.c...exe

pause