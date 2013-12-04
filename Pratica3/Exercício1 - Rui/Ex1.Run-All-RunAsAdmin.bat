@setlocal enableextensions
@cd /d "%~dp0"

@echo off

call 0.run.setupBD.bat

call 0.stop.MSDTC-RunAsAdmin.bat

call Ex1.a.1-Run-SQL.bat

call Ex1.a.2-Exec-Ex1.1.bat

call Ex1.a.4-Run-SQL.bat

call Ex1.b.1-Run-SQL.bat

call Ex1.b.2-Exec-Ex1.2.bat
