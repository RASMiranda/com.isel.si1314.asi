USE [ASIVesteSede]
GO

IF OBJECT_ID('sp_realizarEncomenda') IS NOT NULL
	DROP PROCEDURE [dbo].sp_realizarEncomenda;
GO

CREATE PROCEDURE sp_realizarEncomenda
    @CodigoProduto		[VARCHAR](30),
	@QtdEncomendada		[INT],
	@VendaId			[INT]
AS
DECLARE
	@EncomendaId 		[INT],
	@ENCOMENDA_AGUARDA_RECEPCAO int = 0,	@ENCOMENDA_RECEBIDA int = 1
BEGIN
	INSERT INTO [dbo].[Encomenda]
			   ([Qtd], [Estado], [Produto_ProdutoID], [VendaProduto_VendaProdutosID])
	select @QtdEncomendada, @ENCOMENDA_AGUARDA_RECEPCAO, ProdutoId, @VendaId
	from Produto where Codigo = @CodigoProduto;
	
	SELECT @EncomendaId = SCOPE_IDENTITY();

	SELECT @EncomendaId EncomendaId;
END
GO
