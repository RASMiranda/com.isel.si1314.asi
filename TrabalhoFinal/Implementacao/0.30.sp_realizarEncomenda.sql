USE [ASIVesteSede]
GO

IF OBJECT_ID('sp_realizarEncomenda') IS NOT NULL
	DROP PROCEDURE [dbo].sp_realizarEncomenda;
GO

CREATE PROCEDURE sp_realizarEncomenda
    @CodigoProduto		[VARCHAR](30),
    @EncomendaRecebida	[INT],
	@QtdEncomendada		[INT],
	@VendaId			[INT],
    @EncomendaId		[INT] OUTPUT
AS
BEGIN
	INSERT INTO [dbo].[Encomenda]
			   ([Qtd], [Estado], [Produto_ProdutoID], [VendaProduto_VendaProdutosID])
	select @QtdEncomendada, @EncomendaRecebida, ProdutoId, @VendaId
	from Produto where Codigo = @CodigoProduto;
	
	SELECT @EncomendaId = SCOPE_IDENTITY();
END
GO
