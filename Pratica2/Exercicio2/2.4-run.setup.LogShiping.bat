@echo off

REM Pratica 2 Exercico 2----------------------------------------------------------------------------------------

echo.
echo Setting variables...
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")
REM pause




echo.
echo Running "2.4-RemoveLogShiping-BDLS @%InstanciaB%.sql"...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.4-RemoveLogShiping-BDLS @Secondary.sql"
REM pause

echo.
echo Running "2.4-RemoveLogShiping-BDLS @%InstanciaC%.sql"...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.4-RemoveLogShiping-BDLS @Secondary.sql"
REM pause

echo.
echo Running "2.5-RemoveLogShiping-BDLS @%InstanciaA%.sql"...
sqlcmd -H localhost -S "%InstanciaA%" -i "2.5-RemoveLogShiping-BDLS @Primary.sql" -v InstanciaSec1="%InstanciaB%" InstanciaSec2="%InstanciaC%"
REM pause


rem set backup_share="\\Vboxsvr\asi"
set backup_share="C:\ASITemp"
set backup_directory="C:\ASITemp" 


echo.
echo Running "2.6-ConfigLogShiping-BDLS @%InstanciaA%.sql"...
sqlcmd -H localhost -S "%InstanciaA%" -i "2.6-ConfigLogShiping-BDLS @Primary.sql" -v InstanciaPri="%InstanciaA%" InstanciaSec1="%InstanciaB%" InstanciaSec2="%InstanciaC%" backup_share=%backup_share% backup_source_directory=%backup_directory% backup_destination_directory=%backup_directory%
REM pause

echo.
echo Running "2.7-ConfigLogShiping-BDLS @%InstanciaB%.sql"...
sqlcmd -H localhost -S "%InstanciaB%" -i "2.7-ConfigLogShiping-BDLS @Secondary.sql" -v InstanciaPri="%InstanciaA%" InstanciaSec="%InstanciaB%" copy_job_name="LSCopy_InstanciaAB_BDLS" backup_share=%backup_share% backup_source_directory=%backup_directory% backup_destination_directory=%backup_directory%
REM pause

echo.
echo Running "2.7-ConfigLogShiping-BDLS @%InstanciaC%.sql"...
sqlcmd -H localhost -S "%InstanciaC%" -i "2.7-ConfigLogShiping-BDLS @Secondary.sql" -v InstanciaPri="%InstanciaA%" InstanciaSec="%InstanciaC%" copy_job_name="LSCopy_InstanciaAC_BDLS" backup_share=%backup_share% backup_source_directory=%backup_directory% backup_destination_directory=%backup_directory%
REM pause


echo.
echo.
echo Log Shiping Configured on primary_server: "%InstanciaA%", with secondary_server_B: "%InstanciaB%" and secondary_server_C: "%InstanciaC%"
pause

:end

