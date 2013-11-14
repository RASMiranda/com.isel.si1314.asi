-- ****** Begin: Script to be run at Secondary: [SERVER_INST_B] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
:setvar BackupFileA "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup\BDLS.bak"
:setvar SecondaryDataFile "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\BDLS.mdf"
:setvar SecondaryLogFile "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\BDLS_log.ldf"

USE [master]
GO

if exists (select * from sys.databases where name = 'BDLS')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDLS'
	ALTER DATABASE BDLS SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [BDLS]
end
GO

RESTORE DATABASE [BDLS]
   FROM DISK = '$(BackupFileA)'
   WITH REPLACE,RECOVERY,	--se não DB fica sempre em Restoring
   MOVE 'BDLS' TO '$(SecondaryDataFile)',
   MOVE 'BDLS_Log' TO '$(SecondaryLogFile)'
GO

-- ****** End: Script to be run at Primary: [SERVER_INST_B]  ******
