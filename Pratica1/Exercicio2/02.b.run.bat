@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


REM Exercico 2 alinea a)----------------------------------------------------------------------------------------


echo Running 02.b.1-CREATE-SEDE-Sinonimo-FusaoPartHoriz.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.b.1-CREATE-SEDE-Sinonimo-FusaoPartHoriz.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end


echo Running 02.b.2-CREATE-SEDE-VW-viewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.b.2-CREATE-SEDE-VW-viewProduto.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end


echo Running 02.b.3-CREATE-SEDE-TRG-trViewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.b.3-CREATE-SEDE-TRG-trViewProduto.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end


echo Running 02.b.4-TEST-CVCr.sql
sqlcmd -H localhost -S "%CVCr%" -i 02.b.4-TEST-CVCr.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end


echo Running 02.b.5-TEST-Sede.sql
sqlcmd -H localhost -S "%SEDE%" -i 02.b.5-TEST-Sede.sql -v CVCr="%CVCr%" CVDp="%CVDp%" SEDE="%SEDE%"  
if not %errorlevel% == 0 goto end

:end
pause
