USE [ASI]
GO

UPDATE [dbo].[contas]
   SET [titular] = N'Jos�'
      ,[saldo] = 1000
 WHERE [numero]=1
GO

DELETE [dbo].[contas]
WHERE [numero]=1111
GO

