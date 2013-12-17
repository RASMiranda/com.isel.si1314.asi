@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

echo Running "Ex4.0-Insert-Alunos.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "Ex4.0-Insert-Alunos.sql" 
if not %errorlevel% == 0 goto end

:end
pause
