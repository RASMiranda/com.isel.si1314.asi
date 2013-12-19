@echo off

REM @setlocal enableextensions
REM @cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

call startProfiler.bat


call Ex4.clearAlunosEInteresses.bat

call Ex4.0-Insert-Alunos.bat

call Ex4.1-Exec-original.bat


call Ex4.clearAlunosEInteresses.bat

call Ex4.0-Insert-Alunos.bat

call Ex4.2-Exec-modified.bat


taskkill /im "profiler.exe"
