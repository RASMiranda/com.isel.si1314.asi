USE [ASI]
GO

/****** Object:  View [dbo].[viewProduto]    Script Date: 17-10-2013 21:20:07 ******/
DROP VIEW [dbo].[viewProduto]
GO

/****** Object:  View [dbo].[viewProduto]    Script Date: 17-10-2013 21:20:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewProduto]
AS

	SELECT
		lp.cod, rp.preco, rp.qtStock, rp.qtMinStock
	FROM
		[dbo].[ProdutoSede] lp
		inner join (
			select * from [dbo].[produto] union
			select * from [dbo].[ProdutoDesp]
		) rp
			on lp.cod = rp.cod

GO
