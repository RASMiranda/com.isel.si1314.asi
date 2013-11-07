@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


echo Running "3.1.1. Setup tabelas de Ocorrencia @SEDE.sql"
sqlcmd -H localhost -S "%SEDE%" -i "3.1.1. Setup tabelas de Ocorrencia @SEDE.sql"
if not %errorlevel% == 0 goto end

echo Running "3.1.3. Setup tabelas de Ocorrencia @CVCr.sql"
sqlcmd -H localhost -S "%CVCr%" -i "3.1.3. Setup tabelas de Ocorrencia @CVCr.sql"
if not %errorlevel% == 0 goto end

echo Running "3.1.2. Setup tabelas de Ocorrencia @CVDp.sql"
sqlcmd -H localhost -S "%CVDp%" -i "3.1.2. Setup tabelas de Ocorrencia @CVDp.sql"
if not %errorlevel% == 0 goto end


echo Running "3.1.4. Configurar Distribuidores.sql" @SEDE
sqlcmd -H localhost -S "%SEDE%" -i "3.1.4. Configurar Distribuidores.sql" -v TargetDatabase="%SEDE%"
if not %errorlevel% == 0 goto end

echo Running "3.1.4. Configurar Distribuidores.sql" @CVCr
sqlcmd -H localhost -S "%CVCr%" -i "3.1.4. Configurar Distribuidores.sql" -v TargetDatabase="%CVCr%"
if not %errorlevel% == 0 goto end

echo Running "3.1.4. Configurar Distribuidores.sql" @CVDp
sqlcmd -H localhost -S "%CVDp%" -i "3.1.4. Configurar Distribuidores.sql" -v TargetDatabase="%CVDp%"
if not %errorlevel% == 0 goto end



:end
pause