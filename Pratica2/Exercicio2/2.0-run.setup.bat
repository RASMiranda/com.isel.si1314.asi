@echo off

REM Pratica 2 Exercico 2----------------------------------------------------------------------------------------

echo.
echo Setting variables...
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")
REM pause

echo.
echo Running "2.0-CREATE_BDLS_TBL-A.sql"...
sqlcmd -H localhost -S "%InstanciaA%" -i "2.0-CREATE_BDLS_TBL-A.sql"
rem -v primary_server="%primary_server%"
REM pause

echo.
echo Running "2.1-SET-BDLS-RECOVERY-FULL-A.sql @%InstanciaA%"...
sqlcmd -H localhost -S "%InstanciaA%" -i "2.1-SET-BDLS-RECOVERY-FULL-A.sql"
rem -v primary_server="%primary_server%"
REM pause

if exist c:\ASITemp rd /s /q c:\ASITemp
md c:\ASITemp
icacls c:\ASITemp /t /grant:r everyone:(F)

echo.
echo Running "2.2-BACKUP-BDLS-A.sql @%InstanciaA%"...
sqlcmd -H localhost -S "%InstanciaA%" -i "2.2-BACKUP-BDLS-A.sql" -v backupFile="C:\ASITemp\BDLSbackup.bin"
REM pause

echo.
echo Running "2.3-RESTORE-BDLS-BeC.sql" @%InstanciaB%...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.3-RESTORE-BDLS-BeC.sql" -v backupFile="C:\ASITemp\BDLSbackup.bin" restoreMode="NORECOVERY"
REM pause

echo.
echo Running "2.3-RESTORE-BDLS-BeC.sql" @%InstanciaC%...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.3-RESTORE-BDLS-BeC.sql" -v backupFile="C:\ASITemp\BDLSbackup.bin" restoreMode="STANDBY"
REM pause

:end
pause
