@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\config_setup.txt) do (set "%%x")



echo Running 0.01.CreateTablesSede.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 0.01.CreateTablesSede.sql
if not %errorlevel% == 0 goto end


echo Running 0.02.CreateTablesLoja.sql para lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 0.02.CreateTablesLoja.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0

echo Running 0.02.CreateTablesLoja.sql para lojas de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 0.02.CreateTablesLoja.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0


echo Running 0.03.CreateSinonimosSede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.03.CreateSinonimosSede.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


echo Running 0.04.InserirDadosTeste na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 0.04.InserirDadosTeste.sql -v LSC="%LSC%" LHD="%LHD%"
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
