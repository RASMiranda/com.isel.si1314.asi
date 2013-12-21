--:connect $(PrincipalDB)

USE [master]
GO


if NOT EXISTS (select * from sys.databases where name = 'ASI')
begin
    create database [BD3_1]
end
GO

USE [ASI]
GO

alter database [ASI] set TRUSTWORTHY on
GO

sp_configure 'clr enabled', 1 ;
GO

RECONFIGURE;
GO
