USE [BD3_1]
GO

INSERT INTO [dbo].[Alunos]
			([NumAl], [Nome])
     SELECT 1111, 'aaa'
     UNION ALL 
	 SELECT 4444, 'bbbb'
GO

