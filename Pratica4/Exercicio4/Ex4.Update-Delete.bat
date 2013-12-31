@echo off

echo Running "Ex4.Update-Delete.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex4.Update-Delete.sql" 
if not %errorlevel% == 0 goto end

:end
pause
