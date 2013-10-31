USE[ASI]
GO

--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
:connect $(CVCr)

USE[ASI]
GO

DROP VIEW [dbo].[viewProduto];
GO

CREATE VIEW [dbo].[viewProduto]
AS
	SELECT
		[cod]
		,[preco]
		,[qtStock]
		,[qtMinStock]
	FROM
		[ASI].[dbo].[produto] 
	UNION ALL
	SELECT
		[cod]
		,[preco]
		,[qtStock]
		,[qtMinStock]
	FROM
		[ASI].[dbo].[ProdutoDespTemp];
GO

DROP TRIGGER [dbo].[trViewProduto]
GO

CREATE TRIGGER [dbo].[trViewProduto]
ON [dbo].[viewProduto]
INSTEAD OF UPDATE AS 
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_trViewProduto_CVCr

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
		

		UPDATE ProdutoDespTemp
		SET 
			ProdutoDespTemp.preco = inserted.preco,
			ProdutoDespTemp.qtMinStock = inserted.qtMinStock,
			ProdutoDespTemp.qtStock = inserted.qtStock
		FROM
			ProdutoDespTemp
		INNER JOIN
			inserted
		ON
			inserted.cod = ProdutoDespTemp.cod

	COMMIT TRANSACTION T_trViewProduto_CVCr

end
GO



