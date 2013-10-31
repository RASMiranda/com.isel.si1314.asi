:setvar PrincipalDB ALUNO_SIAD-PC\ONE
:setvar MirrorDB ALUNO_SIAD-PC\TWO
:setvar WitnessDB ALUNO_SIAD-PC\THREE

:connect $(PrincipalDB)

if exists (select * from sys.databases where name = 'BDMIRROR')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDMIRROR'
	ALTER DATABASE BDMIRROR SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [BDMIRROR]
end

create database [BDMIRROR]
GO

USE [BDMIRROR]

if object_id('t', 'U') is not null
	drop table t
create table t (i int)
GO

insert into t values(1)

-----------------------------------------------

/*
1.	Garantir que os dois nós começam com a mesma imagem da BD. 
Para isso fazer Backup total no nó onde existem os dados e restore no outro COM OPÇÂO WITH NO RECOVERY.
Vamos admitir que no nó inicial não há actividade sobre a BD durante esta configuração
*/


BACKUP DATABASE [BDMIRROR] 
	TO DISK = N'C:\Temp\BDMIRROR.bak' WITH NOFORMAT, 
	NAME = N'BDMIRROR-Full Database Backup', 
	NOINIT, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO




:connect $(MirrorDB)
USE [MASTER]

if exists (select * from sys.databases where name = 'BDMIRROR')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDMIRROR'
	ALTER DATABASE BDMIRROR SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [BDMIRROR]
end


declare @dataFile varchar(256), @logFile varchar(256)

SELECT 
	@dataFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'Data\BDMIRROR.mdf',
	@logFile = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'Data\BDMIRROR.ldf'
FROM master.sys.master_files
WHERE name = 'master'


RESTORE DATABASE [BDMIRROR] 
	FROM DISK = N'C:\Temp\BDMIRROR.bak' WITH FILE = 1,
	MOVE N'BDMIRROR'		TO @dataFile,
	MOVE N'BDMIRROR_log'	TO @logFile,
	NORECOVERY, NOUNLOAD, STATS = 10
GO

!!del "C:\Temp\BDMIRROR.bak"

