USE[ASI]
GO

--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
--:setvar CVCr [MIRANDA-LAPTOP\SQL2012DEINST2]

EXEC('
DROP TABLE [ASI].[dbo].[ProdutoDespTemp]
') AT $(CVCr)
GO

EXEC('
SELECT [cod]
      ,[preco]
      ,[qtStock]
      ,[qtMinStock]
  INTO [ASI].[dbo].[ProdutoDespTemp]
  FROM [ASI].[dbo].[produto]
  WHERE 1=0
') AT $(CVCr)
GO
