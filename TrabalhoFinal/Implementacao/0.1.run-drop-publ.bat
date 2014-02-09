@setlocal enableextensions
@cd /d "%~dp0"

@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (.\0.0.config_setup.txt) do (set "%%x")

echo Running 1.03.1.DropPublication-PeerToPeer-Reclamacao-Sede.sql na Sede.
sqlcmd -b -H localhost -S "%SEDE%" -i 1.03.1.DropPublication-PeerToPeer-Reclamacao-Sede.sql -v SEDE="%SEDE%" LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end

echo Running 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql na lojas de produtos de crianca e senhora.
sqlcmd -b -H localhost -S "%LSC%" -i 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LSC%" LOJA_REMOTA="%LHD%"
if not %errorlevel% == 0 goto end

echo Running 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql na loja de produtos para homem e desportistas.
sqlcmd -b -H localhost -S "%LHD%" -i 1.03.2.DropPublication-PeerToPeer-Reclamacao-Loja.sql -v SEDE="%SEDE%" ESTA_LOJA="%LHD%" LOJA_REMOTA="%LSC%"
if not %errorlevel% == 0 goto end

