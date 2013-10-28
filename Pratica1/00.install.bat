@echo off

REM TODO Change Instances names!

set SEDE=MIRANDA-LAPTOP\SQL2012DEINST1
set CVCr=MIRANDA-LAPTOP\SQL2012DEINST2
set CVDp=MIRANDA-LAPTOP\SQL2012DEINST3

REM Exercico 1----------------------------------------------------------------------------------------


echo Running 01.a.2-CREATE-SEDE.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.a.2-CREATE-SEDE.sql
if not %errorlevel% == 0 goto end

echo Running 01.a.3-CREATE-LOJA.sql
sqlcmd -H localhost -S "%CVCr%" -i 01.a.3-CREATE-LOJA.sql
if not %errorlevel% == 0 goto end

echo Running 01.a.3-CREATE-LOJA.sql
sqlcmd -H localhost -S "%CVDp%" -i 01.a.3-CREATE-LOJA.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.0-CREATE-SEDE-LINKEDSERVERS.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.0-CREATE-SEDE-LINKEDSERVERS-BAT.sql -v CVCr="%CVCr%" CVDp="%CVDp%"
if not %errorlevel% == 0 goto end

echo Running 01.b.0-CREATE-SEDE-SP-insereProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.0-CREATE-SEDE-SP-insereProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.1-CREATE-SEDE-VW-viewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.1-CREATE-SEDE-VW-viewProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.b.2-CREATE-SEDE-TRG-trViewProduto.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.b.2-CREATE-SEDE-TRG-trViewProduto.sql
if not %errorlevel% == 0 goto end

echo Running 01.c.0-CREATE-SEDE-ENCOMENDAS.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.c.0-CREATE-SEDE-ENCOMENDAS.sql
if not %errorlevel% == 0 goto end

echo Running 01.d.0-CREATE-SEDE-SP-produtoEncomendadoFoiRecebido.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.d.0-CREATE-SEDE-SP-produtoEncomendadoFoiRecebido.sql
if not %errorlevel% == 0 goto end

echo Running 01.e.0-CREATE-SEDE-SP-produtoAlteraTipo.sql
sqlcmd -H localhost -S "%SEDE%" -i 01.e.0-CREATE-SEDE-SP-produtoAlteraTipo.sql
if not %errorlevel% == 0 goto end

echo Running 01.f.0-TEST-SEDE-todos SPs.sql
sqlcmd -H localhost -S "%SEDE%" -i "01.f.0-TEST-SEDE-todos SPs.sql"
if not %errorlevel% == 0 goto end

REM Exercico 2----------------------------------------------------------------------------------------

echo Running 02.a.0-CREATE-CVCr-LINKEDSERVERS-BAT.sql
sqlcmd -H localhost -S "%CVCr%" -i 02.a.0-CREATE-CVCr-LINKEDSERVERS-BAT.sql -v SEDE="%SEDE%" CVDp="%CVDp%"
if not %errorlevel% == 0 goto end

echo Running 02.a.1-CREATE-CVCr-VW-viewProduto.sql
sqlcmd -H localhost -S "%CVCr%" -i "02.a.1-CREATE-CVCr-VW-viewProduto.sql"
if not %errorlevel% == 0 goto end

echo Running 02.a.2-CREATE-CVCr-TRG-trViewProduto.sql
sqlcmd -H localhost -S "%CVCr%" -i "02.a.2-CREATE-CVCr-TRG-trViewProduto.sql"
if not %errorlevel% == 0 goto end

echo Running 02.a.3-TEST-CVCr.sql
sqlcmd -H localhost -S "%CVCr%" -i "02.a.3-TEST-CVCr.sql"
if not %errorlevel% == 0 goto end

:end
pause