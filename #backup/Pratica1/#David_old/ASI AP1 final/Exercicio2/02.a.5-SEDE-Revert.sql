USE[ASI]
GO

DROP TABLE #ProdutoDespTemp;
GO

SELECT [cod]
      ,[preco]
      ,[qtStock]
      ,[qtMinStock]
INTO #ProdutoDespTemp
  FROM [dbo].[ProdutoDesp];
GO

--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
--:setvar CVDp MIRANDA-LAPTOP\SQL2012DEINST3
DROP SYNONYM [dbo].[ProdutoDesp]
GO
CREATE SYNONYM [dbo].[ProdutoDesp] FOR [$(CVDp)].[ASI].[dbo].[Produto]
GO

DELETE FROM [dbo].[ProdutoDesp]
GO

INSERT INTO [dbo].[ProdutoDesp]
SELECT [cod]
      ,[preco]
      ,[qtStock]
      ,[qtMinStock]
FROM #ProdutoDespTemp
GO

DROP TABLE #ProdutoDespTemp;
GO


--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
--:setvar CVCr "MIRANDA-LAPTOP\SQL2012DEINST2"
:connect $(CVCr)
USE[ASI]
GO
DROP VIEW [dbo].[viewProduto];
GO
DROP TRIGGER [dbo].[trViewProduto]
GO
DROP TABLE [dbo].[ProdutoDespTemp]
GO
