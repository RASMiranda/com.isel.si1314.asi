USE [master]
GO

BACKUP DATABASE [BDLS]
TO DISK = 'BDLS.bak'	--RUI => C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup	
WITH INIT --overwrite existing
GO