USE [ASI]
GO

/****** Object:  View [dbo].[viewProduto]    Script Date: 17-10-2013 21:20:07 ******/
IF OBJECT_ID ('viewProduto','V') IS NOT NULL
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
		cv.preco, cv.qtMinStock, cv.qtStock
	FROM
		dbo.produto lp inner join ProdutoCV cv
			on lp.cod = cv.cod
GO
