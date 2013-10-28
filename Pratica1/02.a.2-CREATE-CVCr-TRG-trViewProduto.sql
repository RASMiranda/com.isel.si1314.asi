


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
	BEGIN TRANSACTION T_trViewProduto_Cr

		UPDATE produto
		SET 
			produto.preco = inserted.preco,
			produto.qtMinStock = inserted.qtMinStock,
			produto.qtStock = inserted.qtStock
		FROM
			produto
		INNER JOIN
			inserted
		ON
			inserted.cod = produto.cod
		

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
			Produto.preco = inserted.preco,
			Produto.qtStock = inserted.qtStock,
			Produto.qtMinStock = inserted.qtMinStock
		FROM Produto
		INNER JOIN
			inserted
		ON
			inserted.cod = Produto.cod

	COMMIT TRANSACTION T_trViewProduto_Cr

end


GO


