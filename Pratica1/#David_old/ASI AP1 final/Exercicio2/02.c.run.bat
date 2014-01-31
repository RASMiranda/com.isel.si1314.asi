@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


REM Exercico 2 alinea a)----------------------------------------------------------------------------------------


echo Running 02.c.1-Fusao-produto-SEDE-CV.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.c.1-Fusao-produto-SEDE-CV.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end


echo Running 02.c.2-TEST-Fusao-produto-SEDE-CV.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.c.2-TEST-Fusao-produto-SEDE-CV.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end

:end
pause
