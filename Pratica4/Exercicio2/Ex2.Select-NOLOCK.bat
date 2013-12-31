@echo off

echo Running "Ex2.Select-NOLOCK.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex2.Select-NOLOCK.sql" 
if not %errorlevel% == 0 goto end

:end
pause
