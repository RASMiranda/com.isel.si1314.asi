@echo off

echo Running "Ex1.verificarAlunosEInteresses.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "Ex1.verificarAlunosEInteresses.sql" 
if not %errorlevel% == 0 goto end

:end
pause
