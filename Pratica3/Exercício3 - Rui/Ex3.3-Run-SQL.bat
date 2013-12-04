@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

echo Running "Ex3.2-Delete-All.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "Ex3.2-Delete-All.sql" 
if not %errorlevel% == 0 goto end

:end
pause
