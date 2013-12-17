@echo off

REM @setlocal enableextensions
REM @cd /d "%~dp0"

call startProfiler.bat

call Ex3.clearAlunosEInteresses.bat

call Ex3.0-Exec-Ex3-NoDetect.bat

call Ex3.clearAlunosEInteresses.bat

call Ex3.5-Exec-Ex3.bat

taskkill /im "profiler.exe"
