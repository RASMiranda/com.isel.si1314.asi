USE[ASI]
GO

--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
--:setvar CVCr [MIRANDA-LAPTOP\SQL2012DEINST2]

DROP SYNONYM [dbo].[ProdutoDesp]
GO

CREATE SYNONYM [dbo].[ProdutoDesp] FOR $(CVCr).[ASI].[dbo].[ProdutoDespTemp]
GO


--SELECT * FROM [dbo].[ProdutoDesp]