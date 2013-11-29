--:connect $(PrincipalDB)

USE [master]

if exists (select * from sys.databases where name = 'BD3_1')
begin
	ALTER DATABASE BDMIRROR SET PARTNER OFF -- turn off mirror
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BD3_1'
	ALTER DATABASE BDMIRROR SET SINGLE_USER WITH ROLLBACK IMMEDIATE	--TODO: NAO FUNCIONA,Cannot drop database "BD3_1" because it is currently in use.
	DROP DATABASE [BD3_1]
end

create database [BD3_1]
GO

USE [BD3_1]


CREATE TABLE Alunos(
NumAl int primary key,
Nome varchar(60),
)


CREATE TABLE AlunosAssEst(
	NumAl int references Alunos,
	nSeq int identity,
	Interesse varchar(10),
	Primary key(NumAl,nSeq)
)
