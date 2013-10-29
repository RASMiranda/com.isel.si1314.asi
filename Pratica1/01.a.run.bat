@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (00.config_inst.txt) do (set "%%x")


REM Exercico 1 alinea a)----------------------------------------------------------------------------------------


echo Running 01.a.2-CREATE-SEDE.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.a.2-CREATE-SEDE.sql
if not %errorlevel% == 0 goto end

echo Running 01.a.3-CREATE-LOJA.sql
sqlcmd -H localhost -S "%CVCr%" -i 01.a.3-CREATE-LOJA.sql
if not %errorlevel% == 0 goto end

echo Running 01.a.3-CREATE-LOJA.sql
sqlcmd -H localhost -S "%CVDp%" -i 01.a.3-CREATE-LOJA.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.0-CREATE-SEDE-LINKEDSERVERS.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.a.4-CREATE-SEDE-LINKEDSERVERS.sql -v CVCr="%CVCr%" CVDp="%CVDp%"
if not %errorlevel% == 0 goto end

echo Running 01.a.5-TEST.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.a.5-TEST.sql
if not %errorlevel% == 0 goto end

:end
pause
