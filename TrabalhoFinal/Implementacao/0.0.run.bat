@setlocal enableextensions
@cd /d "%~dp0"

@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (.\0.0.config_setup.txt) do (set "%%x")


echo Running 1.01.CreateTablesSede.sql
sqlcmd -b -H localhost -S "%SEDE%" -i 1.01.CreateTablesSede.sql -v ReclamacaoSeedValue=1
if not %errorlevel% == 0 goto end


echo Running 1.02.CreateTablesLoja.sql para lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 1.02.CreateTablesLoja.sql -v ReclamacaoSeedValue=2
if not %errorlevel% == 0 goto end
rem -v ClienteSeed=0

echo Running 1.02.CreateTablesLoja.sql para lojas de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 1.02.CreateTablesLoja.sql -v ReclamacaoSeedValue=3
if not %errorlevel% == 0 goto end


echo Running 1.03.CreateSinonimosSede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.03.CreateSinonimosSede.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end



echo Running 1.03.1.DropPublication-PeerToPeer-Reclamacao-Sede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.031.DropPublication-PeerToPeer-Reclamacao-Sede.sql -v SEDE="%SEDE%" LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end

echo Running 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql na lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 1.032.DropPublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LSC%" LOJA_REMOTA="%LHD%
if not %errorlevel% == 0 goto end

echo Running 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql na loja de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 1.032.DropPublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LHD%" LOJA_REMOTA="%LSC%
if not %errorlevel% == 0 goto end



echo Running 1.03.5.CreatePublication-PeerToPeer-Reclamacao-Sede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.03.5.CreatePublication-PeerToPeer-Reclamacao-Sede.sql -v SEDE="%SEDE%" LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end

TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
goto end
echo Running 1.03.6.CreatePublication-PeerToPeer-Reclamacao.sql na lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 1.03.6.CreatePublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LSC%" LOJA_REMOTA="%LHD%
if not %errorlevel% == 0 goto end

echo Running 1.03.6.CreatePublication-PeerToPeer-Reclamacao.sql na loja de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 1.03.6.CreatePublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LHD%" LOJA_REMOTA="%LSC%
if not %errorlevel% == 0 goto end






echo Running 1.04.InserirDadosTeste na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.04.InserirDadosTeste.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


echo Running 1.25.sp_CrUD_Produto.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.25.sp_CrUD_Produto.sql
if not %errorlevel% == 0 goto end

echo Running 1.30.sp_realizarEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.30.sp_realizarEncomenda.sql
if not %errorlevel% == 0 goto end

echo Running 1.35.sp_realizarVenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.35.sp_realizarVenda.sql
if not %errorlevel% == 0 goto end
rem 1.35.testar sp_realizarVenda.sql

echo Running 1.40.sp_receberEncomenda.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.40.sp_receberEncomenda.sql
if not %errorlevel% == 0 goto end
rem 1.40.testar sp_receberEncomenda.sql


:end
pause
