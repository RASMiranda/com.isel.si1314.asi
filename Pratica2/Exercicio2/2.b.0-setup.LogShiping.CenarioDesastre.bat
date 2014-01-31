@echo off

REM Pratica 2 Exercico 2----------------------------------------------------------------------------------------

echo.
echo Setting variables...
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")
REM pause




echo.
echo Desastre em %InstanciaA%... (SHUTDOWN)
sqlcmd -H localhost -S "%InstanciaA%" -Q "SHUTDOWN"
REM pause

echo.
echo Clear previous config from %InstanciaB%: Running "2.b.1-RemoveLogShiping-BDLS @%InstanciaB%.sql"...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.b.1-RemoveLogShiping-BDLS @Secondary.sql"
REM pause

echo.
echo Clear previous config from %InstanciaC%: Running "2.b.1-RemoveLogShiping-BDLS @%InstanciaC%.sql"...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.b.1-RemoveLogShiping-BDLS @Secondary.sql"
REM pause

echo.
echo Bringing %InstanciaB% Online...
sqlcmd -H localhost -S "%InstanciaB%" -Q "RESTORE DATABASE BDLS WITH RECOVERY"
REM pause





echo.
echo Running "2.b.1-RemoveLogShiping-BDLS @%InstanciaC%.sql"...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.b.1-RemoveLogShiping-BDLS @Secondary.sql"
REM pause

echo.
echo Running "2.b.2-RemoveLogShiping-BDLS @%InstanciaB%.sql"...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.b.2-RemoveLogShiping-BDLS @Primary.sql" -v InstanciaSec2="%InstanciaC%"
REM pause


rem set backup_share="\\Vboxsvr\asi"
set backup_share="C:\ASITemp"
set backup_directory="C:\ASITemp" 


echo.
echo Running "2.b.3-ConfigLogShiping-BDLS @%InstanciaB%.sql"...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.b.3-ConfigLogShiping-BDLS @Primary.sql" -v InstanciaPri="%InstanciaB%" InstanciaSec2="%InstanciaC%" backup_share=%backup_share% backup_source_directory=%backup_directory% backup_destination_directory=%backup_directory%
REM pause

echo.
echo Running "2.b.4-ConfigLogShiping-BDLS @%InstanciaC%.sql"...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.b.4-ConfigLogShiping-BDLS @Secondary.sql" -v InstanciaPri="%InstanciaB%" InstanciaSec="%InstanciaC%" copy_job_name="LSCopy_InstanciaBC_BDLS" backup_share=%backup_share% backup_source_directory=%backup_directory% backup_destination_directory=%backup_directory%
REM pause




echo.
echo.
echo Log Shiping Configured on primary_server: "%InstanciaB%", with secondary_server_C: "%InstanciaC%"
pause

:end
