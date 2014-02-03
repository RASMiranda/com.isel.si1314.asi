USE [ASIVeste]
GO

IF OBJECT_ID('sp_realizarEncomenda') IS NOT NULL
	DROP PROCEDURE [dbo].sp_realizarEncomenda;
GO

CREATE PROCEDURE sp_realizarEncomenda
    @ProdutoId			[INT],
    @EncomendaRecebida	[INT],
	@QtdEncomendada		[INT],
	@VendaId			[INT],
    @EncomendaId		[INT] OUTPUT
AS
BEGIN
	INSERT INTO [dbo].[Encomenda]
		([ProdutoId], [Recebida], [Qtd], [VendaId])
	VALUES 
		(@ProdutoId, @EncomendaRecebida, @QtdEncomendada, @VendaId);  -- @VendaId para se saber qual é a venda que provocou esta encomenda
	SELECT @EncomendaId = SCOPE_IDENTITY();
END
GO
