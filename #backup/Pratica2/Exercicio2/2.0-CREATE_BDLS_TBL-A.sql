-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar primary_server "MIRANDA-LAPTOP\SQL2012DEINST1"

:connect $(primary_server)

USE [MASTER]
GO

if exists (select * from sys.databases where name = 'BDLS')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BDLS'
	ALTER DATABASE BDLS SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [BDLS]
end
GO

CREATE DATABASE [BDLS]
GO

USE [BDLS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[t]') AND TYPE IN (N'U'))
	DROP TABLE [t]
GO

CREATE TABLE t (i INT)
GO

INSERT INTO t VALUES(1)
GO

-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******