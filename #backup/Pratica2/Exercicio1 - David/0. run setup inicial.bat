@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")



echo Running "0.1. setup bd, table and execute backup @PrincipalDB.sql"
sqlcmd -H localhost -S "%PrincipalDB%" -i "0.1. setup bd, table and execute backup @PrincipalDB.sql" -v backupFile="%windir%\Temp\BDMirror.bak"
if not %errorlevel% == 0 goto end

rem echo Compasso de espera...
rem ping -n 2 127.0.0.1 > nul
icacls C:\Windows\Temp\BDMirror.bak /t /grant:r everyone:(F)

echo Running "0.2. execute restore @MirrorDB.sql"
sqlcmd -H localhost -S "%MirrorDB%" -i "0.2. execute restore @MirrorDB.sql" -v backupFile="%windir%\Temp\BDMirror.bak"
if not %errorlevel% == 0 goto end

echo Configure o Mirror conforme os screenshots...
"0.3.01. ConfgMirror-Mirror-A.png"
pause


:end
pause
