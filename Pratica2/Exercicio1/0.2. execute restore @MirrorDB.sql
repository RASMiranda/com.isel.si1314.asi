--:setvar PrincipalDB ALUNO_SIAD-PC\ONE
--:setvar MirrorDB ALUNO_SIAD-PC\TWO
--:setvar WitnessDB ALUNO_SIAD-PC\THREE
--:setvar backupFile C:\Temp\BDMIRROR.bak

--:connect $(MirrorDB)

USE [MASTER]

declare @databaseState varchar(30)
select @databaseState = state_desc from sys.databases where name = 'BDMIRROR'
if @databaseState = 'RESTORING'
begin
	RESTORE DATABASE [BDMIRROR] WITH RECOVERY
	--ALTER DATABASE [BDMIRROR] SET PARTNER OFF
end


if exists (select * from sys.databases where name = 'BDMIRROR')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDMIRROR'
	ALTER DATABASE BDMIRROR SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [BDMIRROR]
end


declare @dataFile varchar(256), @logFile varchar(256)

SELECT 
	@dataFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'Data\BDMIRROR.mdf',
	@logFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'Data\BDMIRROR.ldf'
FROM master.sys.master_files
WHERE name = 'master'

print 'Restore from file ''$(backupFile)'''

RESTORE DATABASE [BDMIRROR] 
	FROM DISK = '$(backupFile)' WITH FILE = 1,
	MOVE N'BDMIRROR'		TO @dataFile,
	MOVE N'BDMIRROR_log'	TO @logFile,
	NORECOVERY, NOUNLOAD, STATS = 10
GO

!!del "$(backupFile)"
