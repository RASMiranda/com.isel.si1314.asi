@echo off

REM Pratica 2 Exercico 2 Alinea b)----------------------------------------------------------------------------------------

echo.
echo seting variables...
for /f "delims=" %%x in (2.0.config_vars.txt) do (set "%%x")
REM pause

echo.
echo Running "2.b.0-BACKUP-BDLS-A.sql"...
sqlcmd -H localhost -S "%primary_server%" -i "2.b.0-BACKUP-BDLS-A.sql" -v primary_server="%primary_server%"
REM pause

echo.
echo Running "2.b.1-RESTORE-BDLS-B.sql"...
sqlcmd -H localhost -S "%secondary_server_B%" -i "2.b.1-RESTORE-BDLS-B.sql" -v secondary_server_B="%secondary_server_B%" BackupFileA="%BackupFileA%" SecondaryDataFile_B="%SecondaryDataFile_B%" SecondaryLogFile_B="%SecondaryLogFile_B%" 
REM pause

echo.
echo Running "2.b.1-RESTORE-BDLS-C.sql"...
sqlcmd -H localhost -S "%secondary_server_C%" -i "2.b.1-RESTORE-BDLS-C.sql" -v secondary_server_C="%secondary_server_C%" BackupFileA="%BackupFileA%" SecondaryDataFile_C="%SecondaryDataFile_C%" SecondaryLogFile_B="%SecondaryLogFile_C%" 
REM pause

echo.
echo seting sql server directories permissions...
icacls "%backup_directory_B%" /t /grant:r everyone:(F)
REM pause

echo.
echo seting sql server network shares...
net share Backup /delete /y
net share Backup="%backup_directory_B%" /unlimited
REM pause

echo.
echo Running "2.b.2-BACKUP-BDLS-B.sql"...
sqlcmd -H localhost -S "%secondary_server_B%" -i "2.b.2-BACKUP-BDLS-B.sql" -v primary_server="%secondary_server_B%"
REM pause

echo.
echo Running "2.b.1-RESTORE-BDLS-C.sql"...
sqlcmd -H localhost -S "%secondary_server_C%" -i "2.b.1-RESTORE-BDLS-C.sql" -v secondary_server_C="%secondary_server_C%" BackupFileB="%BackupFileB%" SecondaryDataFile_C="%SecondaryDataFile_C%" SecondaryLogFile_B="%SecondaryLogFile_C%" 
REM pause

echo.
echo Running "2.b.4-ConfigLogShiping-BDLS-B-C.sql"...
sqlcmd -H localhost -S "%primary_server%" -i "2.b.4-ConfigLogShiping-BDLS-B-C.sql" -v backup_directory="%backup_directory_B%" backup_share="%backup_share%" backup_source_directory="%backup_source_directory%" primary_server="%primary_server%" secondary_server_B="%secondary_server_B%" secondary_server_C="%secondary_server_C%" backup_destination_directory_B="%backup_destination_directory_B%" restore_mode_B="%restore_mode_B%" disconnect_users_B="%disconnect_users_B%" backup_destination_directory_C="%backup_destination_directory_C%" restore_mode_C="%restore_mode_C%" disconnect_users_C="%disconnect_users_C%"
REM pause


echo.
echo.
echo Log Shiping Configured on primary_server: "%secondary_server_B%", with secondary_server_C: "%secondary_server_C%"
pause