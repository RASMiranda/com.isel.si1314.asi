USE [master]
GO

if exists (select * from sys.databases where name = 'ASI')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASI'
	ALTER DATABASE [ASI] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [ASI]
end
GO
CREATE DATABASE [ASI]
GO

USE [ASI]
GO

IF OBJECT_ID('dbo.contas', 'U') IS NOT NULL
  DROP TABLE dbo.contas
GO

create table contas (
	numero int primary key,
	titular varchar(20),
	saldo real
)
GO