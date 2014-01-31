@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")


REM Pratica 2 Exercico 3 alinea a)----------------------------------------------------------------------------------------

REM cria os objectos de base em cada uma das instancias do Sharding
echo Running 03.a.1-CREATE_DB_INSTANCIA.sql
echo sqlcmd -H localhost -S "%Rep0%"  -v ValorInicial = "1" Incremento= "3" ShardingRange="0" -i 03.a.1-CREATE_DB_INSTANCIA.sql
if not %errorlevel% == 0 goto end

echo Running 03.a.1-CREATE_DB_INSTANCIA.sql
echo sqlcmd -H localhost -S "%Rep1%"  -v ValorInicial = "2" Incremento= "3"  ShardingRange="1" -i 03.a.1-CREATE_DB_INSTANCIA.sql
if not %errorlevel% == 0 goto end

echo Running 03.a.1-CREATE_DB_INSTANCIA.sql
echo sqlcmd -H localhost -S "%Rep2%"  -v ValorInicial = "3" Incremento= "3" ShardingRange="2" -i 03.a.1-CREATE_DB_INSTANCIA.sql
if not %errorlevel% == 0 goto end

REM cria os objectos especifico de cada replica, em que a primeira é diferente das seguintes
REM      por causa dos procedimentos que nas restantes sao apenas sinonimos

echo Running 03.a.2-CREATE_PROCEDURES_REP0.sql
sqlcmd -H localhost -S "%Rep0%"   -i 03.a.2-CREATE_PROCEDURES_REP0.sql
if not %errorlevel% == 0 goto end

echo Running 03.a.2-CREATE_PROCEDURES_REP1_2.sql
sqlcmd -H localhost -S "%Rep1%"  -i 03.a.2-CREATE_PROCEDURES_REP1_2.sql
if not %errorlevel% == 0 goto end

echo Running 03.a.2-CREATE_PROCEDURES_REP1_2.sql
sqlcmd -H localhost -S "%Rep2%"  -i 03.a.2-CREATE_PROCEDURES_REP1_2.sql
if not %errorlevel% == 0 goto end

REM os testes sao executados com programa c#

:end
pause
