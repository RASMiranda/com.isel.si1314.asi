-- ****** Begin: Script to be run at Secondary: [SERVER_INST_B] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar backupFile C:\ASITemp\BDLSbackup.bin
--:setvar restoreMode NORECOVERY
--:setvar restoreMode STANDBY



--:connect $(InstanciaBeC)

USE [master]
GO

--TODO: FAZ SENTIDO? -- WITH NORECOVERY >> sim sse estiver em restoring
IF (SELECT DATABASEPROPERTYEX ('BDLS', 'Status')) = 'RESTORING'
BEGIN
	print 'Database is in RESTORING state. Issuing RESTORE WITH RECOVERY...'
	RESTORE DATABASE [BDLS] WITH RECOVERY
END
GO

if exists (select * from sys.databases where name = 'BDLS')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDLS'
	ALTER DATABASE BDLS SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [BDLS]
end
GO

CREATE DATABASE [BDLS] -- to get the datafile location
GO

declare
	@dataFolder nvarchar(256), 
	@standByFile nvarchar(256),
	@dataFile nvarchar(256), 
	@logFile nvarchar(256)

SELECT 
	@dataFolder = physical_name,
	@standByFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'DATA\BDLS.stdby',
	@dataFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'DATA\BDLS.mdf',
	@logFile  = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'DATA\BDLS_log.ldf'
FROM master.sys.master_files
WHERE name = 'BDLS'

--select @dataFile, @logFile

--RESTORE HEADERONLY FROM DISK='$(backupFile)'
--RESTORE FILELISTONLY FROM DISK='$(backupFile)'

if '$(restoreMode)' = 'NORECOVERY'
begin
	RESTORE DATABASE [BDLS]
	   FROM DISK = '$(backupFile)'
	   WITH 
		REPLACE, 
		NORECOVERY, -- WITH NORECOVERY FAZ SENTIDO? Sim pq senao a BD sobe ao estado online e já não aceita mais dados do log shipper.
		MOVE 'BDLS' TO @dataFile,
		MOVE 'BDLS_Log' TO @logFile
end
else if '$(restoreMode)' = 'STANDBY'
begin
	RESTORE DATABASE [BDLS]
	   FROM DISK = '$(backupFile)'
	   WITH 
		REPLACE, 
		STANDBY = @standByFile,
		MOVE 'BDLS' TO @dataFile,
		MOVE 'BDLS_Log' TO @logFile
end
GO

-- ****** End: Script to be run at Primary: [SERVER_INST_B]  ******
