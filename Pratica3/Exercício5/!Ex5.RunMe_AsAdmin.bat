@echo off

REM @setlocal enableextensions
REM @cd /d "%~dp0"

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

call startProfiler.bat


call Ex5.clearAlunosEInteresses.bat

call Ex5.2-Exec-Ex2.bat


taskkill /im "profiler.exe"
