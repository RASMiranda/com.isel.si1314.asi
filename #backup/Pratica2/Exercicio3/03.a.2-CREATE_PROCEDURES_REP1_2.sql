/*---------------------------------------------------------------------------------------
-- Criacao dos Elementos necessarios a replicacao sincrona da tabela Disciplinas
--     configuracao para o servidor central 
---------------------------------------------------------------------------------------*/
----- Replicas 1 e 2
USE [DB2_3]
GO 

EXEC master.dbo.sp_dropserver @server=N'$(Rep0)', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'$(Rep0)', @srvproduct=N'SQL Server'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(Rep0)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO


USE [DB2_3]
GO 

DROP SYNONYM [dbo].[insereDisciplina]
GO

CREATE SYNONYM [dbo].[insereDisciplina] FOR [$(Rep0)].[DB2_3].[dbo].[insereDisciplina]
GO

-----
DROP SYNONYM [dbo].[updateDisciplina]
GO

CREATE SYNONYM [dbo].[updateDisciplina] FOR [$(Rep0)].[DB2_3].[dbo].[updateDisciplina]
GO

-----
DROP SYNONYM [dbo].[deleteDisciplina]
GO

CREATE SYNONYM [dbo].[deleteDisciplina] FOR [$(Rep0)].[DB2_3].[dbo].[deleteDisciplina]
GO

