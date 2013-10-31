@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (00.config_inst.txt) do (set "%%x")


REM Exercico 2 alinea a)----------------------------------------------------------------------------------------


echo Running 02.a.0-CREATE-SEDE-DespTemp-At-CVCr.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.a.0-CREATE-SEDE-DespTemp-At-CVCr.sql
if not %errorlevel% == 0 goto end


echo Running 02.a.1-Copy-Sede-ProdutoDesp-CVCr.ProdutoDespTemp.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.a.1-Copy-Sede-ProdutoDesp-CVCr.ProdutoDespTemp.sql
if not %errorlevel% == 0 goto end


echo Running 02.a.2-CREATE-Sede-Synonym.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.a.2-CREATE-Sede-Synonym.sql
if not %errorlevel% == 0 goto end


echo Running 02.a.3-CREATE-Sede-Produto-View-Trig.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.a.3-CREATE-Sede-Produto-View-Trig.sql
if not %errorlevel% == 0 goto end


echo Running 02.a.4-TEST-CVCr.sql
sqlcmd -H localhost -S "%CVCr%" -i 02.a.4-TEST-CVCr.sql
if not %errorlevel% == 0 goto end


echo Running 02.a.5-SEDE-Revert.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.a.5-SEDE-Revert.sql
if not %errorlevel% == 0 goto end

:end
pause
