@echo off

REM Pratica 2 Exercico 2 Alinea a)----------------------------------------------------------------------------------------

echo.
echo seting variables...
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")
REM pause

echo.
echo Running "2.a-DELETE-INSERT @Primary.sql" @%InstanciaB%...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.a-DELETE-INSERT @Primary.sql"
REM pause

echo Pausa de 30 segundos... +-
ping -n 30 -w 1000 1.2.3.4 > nul

echo.
echo Running "SELECT FROM T" @%InstanciaB%...
sqlcmd -H localhost -S "%InstanciaB%" -Q "SELECT * FROM BDLS..t"
REM pause

echo.
echo Running "SELECT FROM T" @%InstanciaC%...
sqlcmd -H localhost -S "%InstanciaC%" -Q "SELECT * FROM BDLS..t"
REM pause


pause