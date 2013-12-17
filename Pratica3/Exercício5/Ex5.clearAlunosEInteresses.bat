@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

echo Deleting All...
sqlcmd -H localhost -S "%PrincipalDB%" -Q "DELETE FROM BD3_1..AlunosAssEst; DELETE FROM BD3_1..Alunos;"
if not %errorlevel% == 0 goto end

:end
pause
