@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


REM Exercico 1 alinea b)----------------------------------------------------------------------------------------

echo Running 01.b.0-CREATE-SEDE-SPs-insereProduto-removeProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.0-CREATE-SEDE-SPs-insereProduto-removeProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.1-CREATE-SEDE-VW-viewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.1-CREATE-SEDE-VW-viewProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.2-CREATE-SEDE-TRG-trViewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.2-CREATE-SEDE-TRG-trViewProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.3-TEST.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.3-TEST.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.4-TEST-viewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.4-TEST-viewProduto.sql
if not %errorlevel% == 0 goto end

:end
pause
