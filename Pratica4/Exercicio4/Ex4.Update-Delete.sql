USE [ASI]
GO

UPDATE [dbo].[contas]
   SET [titular] = N'José'
      ,[saldo] = 1000
 WHERE [numero]= 1
GO

UPDATE [dbo].[contas]
   SET [saldo] = 1000
 WHERE [numero]= 2
GO

DELETE [dbo].[contas]
WHERE [numero] = 1111
GO

