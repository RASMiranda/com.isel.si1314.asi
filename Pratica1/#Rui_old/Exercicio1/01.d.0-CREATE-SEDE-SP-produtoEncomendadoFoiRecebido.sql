USE [ASI]
GO

DROP PROCEDURE [dbo].produtoEncomendadoFoiRecebido
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].produtoEncomendadoFoiRecebido 
	@cod			[int],
	@qtdEncomenda	[int]
as
begin

	UPDATE [dbo].[viewProduto]
	SET	qtStock = qtStock + @qtdEncomenda
	WHERE cod=@cod AND estado=1
		
end

GO