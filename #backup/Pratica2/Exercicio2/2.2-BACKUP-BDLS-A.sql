-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar primary_server "MIRANDA-LAPTOP\SQL2012DEINST1"

:connect $(primary_server)

USE [master]
GO

BACKUP DATABASE [BDLS]
TO DISK = 'BDLS.bak'	--RUI => C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup	
WITH INIT --overwrite existing
GO

-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******