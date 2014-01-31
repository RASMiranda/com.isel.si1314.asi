

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
		lp.cod, lp.codFornecedor, lp.qtEncomenda, lp.estado, lp.tipo,
		rp.preco, rp.qtMinStock, rp.qtStock
	FROM
		dbo.produto lp
		inner join (
			select * from ProdutoCrianca union
			select * from ProdutoDesp
		) rp
			on lp.cod = rp.cod

GO
