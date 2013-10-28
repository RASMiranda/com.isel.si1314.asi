@echo off

set SEDE=MIRANDA-LAPTOP\SQL2012DEINST1
set CVCr=MIRANDA-LAPTOP\SQL2012DEINST2



echo Running 2.b.1-Setup Instancia da Sede - script de fusão de partições horizontais.sql
sqlcmd -H localhost -S "%SEDE%" -i "2.b.1-Setup Instancia da Sede - script de fusão de partições horizontais.sql" -v CVCr="%CVCr%"
if not %errorlevel% == 0 goto end

echo Running 2.b.2-CREATE-SEDE-VW-viewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 2.b.2-CREATE-SEDE-VW-viewProduto.sql
if not %errorlevel% == 0 goto end

echo Running 2.b.3-CREATE-SEDE-TRG-trViewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 2.b.3-CREATE-SEDE-TRG-trViewProduto.sql
if not %errorlevel% == 0 goto end

:end
pause