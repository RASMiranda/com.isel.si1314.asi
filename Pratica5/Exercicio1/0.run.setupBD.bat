@echo off

echo Running "0.run.setupBD.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "0.run.setupBD.sql" 
if not %errorlevel% == 0 goto end

:end
pause
