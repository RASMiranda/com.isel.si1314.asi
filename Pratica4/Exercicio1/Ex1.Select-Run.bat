@echo off

echo Running "Ex1.b.Select.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex1.Select.sql" 
if not %errorlevel% == 0 goto end

:end
pause
