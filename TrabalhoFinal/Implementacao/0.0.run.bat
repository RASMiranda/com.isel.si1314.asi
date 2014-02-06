@setlocal enableextensions
@cd /d "%~dp0"

@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (.\0.0.config_setup.txt) do (set "%%x")



echo Running 1.01.CreateTablesSede.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 1.01.CreateTablesSede.sql
if not %errorlevel% == 0 goto end


echo Running 1.02.CreateTablesLoja-LSC.sql para lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 1.02.CreateTablesLoja-LSC.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0

echo Running 1.02.CreateTablesLoja-LHD.sql para lojas de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 1.02.CreateTablesLoja-LHD.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0


echo Running 1.03.CreateSinonimosSede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.03.CreateSinonimosSede.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


echo Running 1.04.InserirDadosTeste na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.04.InserirDadosTeste.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


echo Running 0.25.sp_CrUD_Produto.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.25.sp_CrUD_Produto.sql
if not %errorlevel% == 0 goto end

echo Running 0.30.sp_realizarEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.30.sp_realizarEncomenda.sql
if not %errorlevel% == 0 goto end

echo Running 0.35.sp_realizarVenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.35.sp_realizarVenda.sql
if not %errorlevel% == 0 goto end
rem 0.35.testar sp_realizarVenda.sql

echo Running 0.40.sp_receberEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.40.sp_receberEncomenda.sql
if not %errorlevel% == 0 goto end
rem 0.40.testar sp_receberEncomenda.sql


:end
pause
