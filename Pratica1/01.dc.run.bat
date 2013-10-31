@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (00.config_inst.txt) do (set "%%x")


REM Exercico 1 alineas c) & d)----------------------------------------------------------------------------------------

echo Running 01.c.0-CREATE-SEDE-ENCOMENDAS.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.c.0-CREATE-SEDE-ENCOMENDAS.sql
if not %errorlevel% == 0 goto end

echo Running 01.d.0-CREATE-SEDE-SP-produtoEncomendadoFoiRecebido.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.d.0-CREATE-SEDE-SP-produtoEncomendadoFoiRecebido.sql
if not %errorlevel% == 0 goto end

echo Running 01.dc.1-TEST.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.dc.1-TEST.sql
if not %errorlevel% == 0 goto end

:end
pause
