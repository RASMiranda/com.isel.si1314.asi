--:setvar PrincipalDB ALUNO_SIAD-PC\ONE
--:setvar MirrorDB ALUNO_SIAD-PC\TWO
--:setvar WitnessDB ALUNO_SIAD-PC\THREE
--:setvar backupFile C:\Temp\BDMIRROR.bak

--:connect $(PrincipalDB)

USE [master]

if exists (select * from sys.databases where name = 'BDMIRROR')
begin
	ALTER DATABASE BDMIRROR SET PARTNER OFF -- turn off mirror
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDMIRROR'
	--ALTER DATABASE BDMIRROR SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [BDMIRROR]
end

create database [BDMIRROR]
GO

USE [BDMIRROR]

if object_id('t', 'U') is not null
	drop table t
create table t (dbname varchar(32), dtime datetime)
GO

insert into t values(@@servername, getdate())

-----------------------------------------------

/*
1.	Garantir que os dois nós começam com a mesma imagem da BD. 
Para isso fazer Backup total no nó onde existem os dados e restore no outro COM OPÇÂO WITH NO RECOVERY.
Vamos admitir que no nó inicial não há actividade sobre a BD durante esta configuração
*/

print 'Backup to file ''$(backupFile)'''

BACKUP DATABASE [BDMIRROR] 
	TO DISK = '$(backupFile)' WITH NOFORMAT, 
	NAME = N'BDMIRROR-Full Database Backup', 
	NOINIT, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
