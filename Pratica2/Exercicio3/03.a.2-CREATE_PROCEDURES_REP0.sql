/*---------------------------------------------------------------------------------------
-- Criacao dos Elementos necessarios a replicacao sincrona da tabela Disciplinas
--     configuracao para o servidor central 
---------------------------------------------------------------------------------------*/
----- Replica 1
USE [DB2_3]
GO 

EXEC master.dbo.sp_dropserver @server=N'$(Rep1)', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'$(Rep1)', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(Rep1)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

USE [DB2_3]
GO 


DROP SYNONYM [dbo].[disciplinaReplica1]
GO

CREATE SYNONYM [dbo].[disciplinaReplica1] FOR [$(Rep1)].[DB2_3].[dbo].[DISCIPLINAS]
GO

------ Replica 2
EXEC master.dbo.sp_dropserver @server=N'$(Rep2)', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'$(Rep2)', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(Rep2)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

USE [DB2_3]
GO 


DROP SYNONYM [dbo].[disciplinaReplica2]
GO

CREATE SYNONYM [dbo].[disciplinaReplica2] FOR [$(Rep2)].[DB2_3].[dbo].[DISCIPLINAS]
GO

----- Procedimentos
DROP PROCEDURE [dbo].[insereDisciplina] 
GO
DROP PROCEDURE [dbo].[deleteDisciplina] 
GO
DROP PROCEDURE [dbo].[updateDisciplina] 
GO



CREATE PROCEDURE [dbo].[insereDisciplina] 
	@cod			[int],
	@designacao 	[varchar](30)
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_insere
		
		INSERT INTO [dbo].[disciplinas]
					([codigo],[designacao] )
				VALUES
					(@cod,@designacao);

		INSERT INTO [dbo].[disciplinaReplica1]
					([codigo],[designacao])
				VALUES
					(@cod,@designacao);

		INSERT INTO [dbo].[disciplinaReplica2]
					([codigo],[designacao])
				VALUES
					(@cod,@designacao);

	COMMIT TRANSACTION T_insere
	RETURN 		
end

GO

CREATE PROCEDURE [dbo].[updateDisciplina] 
	@cod			[int],
	@designacao 	[varchar](30)
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_update
		
		UPDATE [dbo].[disciplinas]
            set [designacao] = @designacao
        WHERE codigo = @cod;

		UPDATE [dbo].[disciplinaReplica1]
            set [designacao] = @designacao
        WHERE codigo = @cod;

		UPDATE [dbo].[disciplinaReplica2]
            set [designacao] = @designacao
        WHERE codigo = @cod;

	COMMIT TRANSACTION T_update
	RETURN 		
end

GO

CREATE PROCEDURE [dbo].[deleteDisciplina] 
	@cod			[int]
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_delete
		
		DELETE [dbo].[disciplinas]
        WHERE codigo = @cod;

		DELETE [dbo].[disciplinaReplica1]
        WHERE codigo = @cod;

		DELETE [dbo].[disciplinaReplica2]
        WHERE codigo = @cod;

	COMMIT TRANSACTION T_delete
	RETURN 		
end

GO
