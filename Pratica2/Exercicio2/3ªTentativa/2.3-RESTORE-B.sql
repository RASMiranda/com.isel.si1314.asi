USE [master]
GO

DROP DATABASE [BDLS]
GO

:setvar BackupFileA "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup\BDLS.bak"
:setvar SecondaryDataFile "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\BDLS.mdf"
:setvar SecondaryLogFile "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\BDLS_log.ldf"

RESTORE DATABASE [BDLS]
   FROM DISK = '$(BackupFileA)'
   WITH REPLACE,RECOVERY,	--se não DB fica sempre em Restoring
   MOVE 'BDLS' TO '$(SecondaryDataFile)',
   MOVE 'BDLS_Log' TO '$(SecondaryLogFile)'
GO
