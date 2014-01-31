@echo off

echo Running "Ex3.Select.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex3.Select.sql" 
if not %errorlevel% == 0 goto end

:end
pause
