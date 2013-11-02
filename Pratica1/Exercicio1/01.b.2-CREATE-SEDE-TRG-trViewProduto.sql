


USE [ASI]
GO

/****** Object:  Trigger [trViewProduto]    Script Date: 24-10-2013 12:33:44 ******/
DROP TRIGGER [dbo].[trViewProduto]
GO

/****** Object:  Trigger [dbo].[trViewProduto]    Script Date: 24-10-2013 12:33:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[trViewProduto]
ON [dbo].[viewProduto]
INSTEAD OF UPDATE AS 
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_trViewProduto

		UPDATE ProdutoCrianca
		SET 
			ProdutoCrianca.preco = inserted.preco,
			ProdutoCrianca.qtMinStock = inserted.qtMinStock,
			ProdutoCrianca.qtStock = inserted.qtStock
		FROM
			ProdutoCrianca
		INNER JOIN
			inserted
		ON
			inserted.cod = ProdutoCrianca.cod
		

		UPDATE ProdutoDesp
		SET 
			ProdutoDesp.preco = inserted.preco,
			ProdutoDesp.qtMinStock = inserted.qtMinStock,
			ProdutoDesp.qtStock = inserted.qtStock
		FROM
			ProdutoDesp
		INNER JOIN
			inserted
		ON
			inserted.cod = ProdutoDesp.cod

		UPDATE Produto
		SET 
			Produto.codFornecedor = inserted.codFornecedor,
			Produto.estado = inserted.estado,
			Produto.qtEncomenda = inserted.qtEncomenda
		FROM Produto
		INNER JOIN
			inserted
		ON
			inserted.cod = Produto.cod

	COMMIT TRANSACTION T_trViewProduto

end


GO


