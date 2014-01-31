@echo off

echo Running "0.run.setupBD.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "3.createAndInsertT1.sql" 
if not %errorlevel% == 0 goto end

:end
pause
