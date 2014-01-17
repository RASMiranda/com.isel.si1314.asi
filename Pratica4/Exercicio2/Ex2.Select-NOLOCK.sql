USE [ASI]
GO

SELECT [numero]
      ,[titular]
      ,[saldo]
  FROM [dbo].[contas] with(nolock)
GO
