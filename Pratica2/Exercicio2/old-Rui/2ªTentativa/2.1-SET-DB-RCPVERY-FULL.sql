SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'BDLS_2'
GO

USE [master]
GO
ALTER DATABASE [BDLS_2] SET RECOVERY FULL WITH NO_WAIT
GO

SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'BDLS_2'
GO
