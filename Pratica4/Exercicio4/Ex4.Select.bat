@echo off

echo Running "Ex4.Select.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex4.Select.sql" 
if not %errorlevel% == 0 goto end

:end
pause
