-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******

SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'BDLS'
GO

USE [master]
GO
ALTER DATABASE [BDLS] SET RECOVERY FULL WITH NO_WAIT
GO

SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'BDLS'
GO

-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******
