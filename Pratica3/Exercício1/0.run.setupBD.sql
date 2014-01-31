--:connect $(PrincipalDB)

USE [master]
GO

if exists (select * from sys.databases where name = 'BD3_1')
begin
	--ALTER DATABASE [BD3_1] SET PARTNER OFF -- turn off mirror
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BD3_1'
	ALTER DATABASE [BD3_1] SET SINGLE_USER WITH ROLLBACK IMMEDIATE	--TODO: NAO FUNCIONA,Cannot drop database "BD3_1" because it is currently in use.
	DROP DATABASE [BD3_1]
end
GO

create database [BD3_1]
GO

USE [BD3_1]
GO

IF OBJECT_ID('dbo.AlunosAssEst', 'U') IS NOT NULL
  DROP TABLE dbo.AlunosAssEst
GO

IF OBJECT_ID('dbo.Alunos', 'U') IS NOT NULL
  DROP TABLE dbo.Alunos
GO
  
CREATE TABLE Alunos(
NumAl int primary key,
Nome varchar(60),
)
GO

CREATE TABLE AlunosAssEst(
	NumAl int references Alunos,
	nSeq int identity,
	Interesse varchar(10),
	Primary key(NumAl,nSeq)
)
GO
