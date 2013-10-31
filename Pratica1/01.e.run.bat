@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (00.config_inst.txt) do (set "%%x")


REM Exercico 1 alinea e)----------------------------------------------------------------------------------------


echo Running 01.e.0-CREATE-SEDE-SP-produtoAlteraTipo.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.e.0-CREATE-SEDE-SP-produtoAlteraTipo.sql
if not %errorlevel% == 0 goto end


echo Running 01.e.1-TEST.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.e.1-TEST.sql
if not %errorlevel% == 0 goto end

:end
pause
