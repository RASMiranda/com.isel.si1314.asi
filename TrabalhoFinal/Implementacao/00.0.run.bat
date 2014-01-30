@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\config_setup.txt) do (set "%%x")



echo Running 00.10.CriacaoTabelas_DB_Sede.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 00.10.CriacaoTabelas_DB_Sede.sql
if not %errorlevel% == 0 goto end


echo Running 00.20.CriacaoTabelas_DB_Loja.sql para lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 00.20.CriacaoTabelas_DB_Loja.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0

echo Running 00.20.CriacaoTabelas_DB_Loja.sql para lojas de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 00.20.CriacaoTabelas_DB_Loja.sql
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0

echo Running 00.25.vw_verificarStock.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 00.25.vw_verificarStock.sql
if not %errorlevel% == 0 goto end

echo Running 00.30.sp_realizarEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 00.30.sp_realizarEncomenda.sql
if not %errorlevel% == 0 goto end

echo Running 00.40.sp_inserirProduto_sp_removerProduto.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 00.40.sp_inserirProduto_sp_removerProduto.sql
if not %errorlevel% == 0 goto end

echo Running 00.50.sp_realizarVenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 00.50.sp_realizarVenda.sql
if not %errorlevel% == 0 goto end

echo Running 00.60.sp_receberEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 00.60.sp_receberEncomenda.sql
if not %errorlevel% == 0 goto end




echo Running 00.930.InsercaoDadosTeste_DB_Sede.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 00.930.InsercaoDadosTeste_DB_Sede.sql
if not %errorlevel% == 0 goto end



echo Running 00.964.InsercaoDadosTeste_DB_Loja.sql para lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 00.964.InsercaoDadosTeste_DB_Loja.sql
if not %errorlevel% == 0 goto end

echo Running 00.964.InsercaoDadosTeste_DB_Loja.sql para lojas de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 00.964.InsercaoDadosTeste_DB_Loja.sql
if not %errorlevel% == 0 goto end



goto end


REM ---------------------------- TODO:

echo Running 00.3.create_linkedServers.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 00.3.create_linkedServers.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


rem 	echo Running 01.a.5-TEST.sql
rem 	sqlcmd -b -H localhost -S "%SEDE%" -i 01.a.5-TEST.sql
rem 	if not %errorlevel% == 0 goto end

rem 00.4.TODO_create_Queues.bat



:end
pause
