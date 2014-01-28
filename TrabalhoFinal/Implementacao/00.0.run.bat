@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\config_setup.txt) do (set "%%x")



echo Running 00.1.setup_DB_Sede.sql 
sqlcmd -H localhost -S "%SEDE%" -i 00.1.setup_DB_Sede.sql
if not %errorlevel% == 0 goto end

echo Running 00.2.setup_DB_Loja.sql para lojas de produtos de crianca e senhora.
sqlcmd -H localhost -S "%LSC%" -i 00.2.setup_DB_Loja.sql -v ClienteSeed=0
if not %errorlevel% == 0 goto end

echo Running 00.2.setup_DB_Loja.sql para lojas de produtos para homem e desportistas.
sqlcmd -H localhost -S "%LHD%" -i 00.2.setup_DB_Loja.sql -v ClienteSeed=50
if not %errorlevel% == 0 goto end


goto end


REM ---------------------------- TODO:

echo Running 00.3.create_linkedServers.sql
sqlcmd -H localhost -S "%SEDE%" -i 00.3.create_linkedServers.sql -v LSC="%LSC%" LHD="%LHD%"
if not %errorlevel% == 0 goto end


rem 	echo Running 01.a.5-TEST.sql
rem 	sqlcmd -H localhost -S "%SEDE%" -i 01.a.5-TEST.sql
rem 	if not %errorlevel% == 0 goto end

rem 00.4.TODO_create_Queues.bat



:end
pause
