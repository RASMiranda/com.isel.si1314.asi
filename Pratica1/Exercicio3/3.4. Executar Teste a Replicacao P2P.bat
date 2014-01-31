@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

goto nao_apagar_ocorrencias
echo Apagar Ocorrencias na SEDE...
sqlcmd -H localhost -S "%SEDE%" -Q "delete from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Apagar Ocorrencias na CVCr...
sqlcmd -H localhost -S "%CVCr%" -Q "delete from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Apagar Ocorrencias na CVDp...
sqlcmd -H localhost -S "%CVDp%" -Q "delete from asi..ocorrencia"
if not %errorlevel% == 0 goto end

:nao_apagar_ocorrencias


echo Running "3.4.1. Listar Produtos disponiveis.sql" @SEDE
sqlcmd -H localhost -S "%SEDE%" -i "3.4.1. Listar Produtos disponiveis.sql"
if not %errorlevel% == 0 goto end



echo Contar Ocorrencias existentes na SEDE... (0)
sqlcmd -H localhost -S "%SEDE%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVCr... (0)
sqlcmd -H localhost -S "%CVCr%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVDp... (0)
sqlcmd -H localhost -S "%CVDp%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end



echo Running "3.4.2. Inserir 3 Ocorrencias na Sede.sql" @SEDE
sqlcmd -H localhost -S "%SEDE%" -i "3.4.2. Inserir 3 Ocorrencias na Sede.sql"
if not %errorlevel% == 0 goto end

echo Running "3.4.3. Inserir 3 Ocorrencias na CVCr.sql" @CVCr
sqlcmd -H localhost -S "%CVCr%" -i "3.4.3. Inserir 3 Ocorrencias na CVCr.sql"
if not %errorlevel% == 0 goto end

echo Running "3.4.4. Inserir 3 Ocorrencias na CVDp.sql" @CVDp
sqlcmd -H localhost -S "%CVDp%" -i "3.4.4. Inserir 3 Ocorrencias na CVDp.sql"
if not %errorlevel% == 0 goto end





echo Contar Ocorrencias existentes na SEDE... (3)
sqlcmd -H localhost -S "%SEDE%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVCr... (3)
sqlcmd -H localhost -S "%CVCr%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVDp... (3)
sqlcmd -H localhost -S "%CVDp%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Constata-se que cada tabela so tem 3 entradas.
echo Daqui a alguns segundos da-se a replicacao...
pause




echo Contar Ocorrencias existentes na SEDE... (9)
sqlcmd -H localhost -S "%SEDE%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVCr... (9)
sqlcmd -H localhost -S "%CVCr%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Contar Ocorrencias existentes na CVDp... (9)
sqlcmd -H localhost -S "%CVDp%" -Q "select count(*) from asi..ocorrencia"
if not %errorlevel% == 0 goto end

echo Constata-se que cada uma das 3 tabelas ja tem 9 entradas.
echo Ocorreu a replicacao das linhas.
pause




:end
pause