@echo off

echo Running "Ex1.a.CREATE-DB-TBL.sql..."
sqlcmd -S "%PrincipalDBA%" -U "%PrincipalUSR%" -P "%PrincipalPWD%" -i "Ex1.a.CREATE-DB-TBL.sql" 
if not %errorlevel% == 0 goto end

:end
pause
