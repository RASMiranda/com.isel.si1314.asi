USE [ASIVeste]
GO

IF OBJECT_ID('sp_receberEncomenda') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_receberEncomenda];
GO

create procedure [dbo].[sp_receberEncomenda] -- ou sp_receberEncomenda ?
    @EncomendaId	[INT]
as
declare
	@ProdutoId		[INT],
    @VendaId		[INT],
    @ExpedicaoId	[INT],
	@QtdEncomendada	[INT],

	@ENCOMENDA_AGUARDA_RECEPCAO int = 0,	@ENCOMENDA_RECEBIDA int = 1,
	@VENDA_AGUARDA_EXPEDICAO int = 0,		@VENDA_EXPEDIDA int = 1
begin

	-- http://stackoverflow.com/questions/4630689/how-do-i-unset-reset-a-transaction-isolation-level-for-sql-server
	-- SET XACT_ABORT ON -- a trans nao é distribuida
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION T_sp_receberEncomenda

	print 'Obter a VendaId e o ProdutoId para esta EncomendaId.'
	SELECT @ProdutoId = [ProdutoId], @QtdEncomendada = [Qtd], @VendaId = [VendaId]
	FROM [dbo].[Encomenda]
	WHERE [Id] = @EncomendaId;

	print 'A declarar esta EncomendaId como entregue.'
	UPDATE [dbo].[Encomenda]
	SET Recebida = @ENCOMENDA_RECEBIDA
	WHERE [Id] = @EncomendaId;

	print 'A expedir a venda que esta à espera desta encomenda. Se @VendaId is null o update n faz nada.'
	UPDATE [dbo].[Expedicao]
	SET Expedida = @VENDA_EXPEDIDA
	WHERE [VendaId] = @VendaId;

	print ' @QtdEncomendada='+cast(@QtdEncomendada as varchar)

	print 'A determinar quantas unidades foram vendidas.'
	SELECT @QtdEncomendada = @QtdEncomendada - [Qtd]
	FROM [dbo].[Venda]
	WHERE [Id] = @VendaId;

	print ' @QtdEncomendada='+cast(@QtdEncomendada as varchar) + ' @ProdutoId='+cast(@ProdutoId as varchar)

	print 'A actualizar o StockQtd. So uma das tabelas sera efectivamente escrita.'
	UPDATE [dbo].[ProdutoCS]
	SET StockQtd = StockQtd + @QtdEncomendada
	WHERE [Id] = @ProdutoId;

	UPDATE [dbo].[ProdutoHD]
	SET StockQtd = StockQtd + @QtdEncomendada
	WHERE [Id] = @ProdutoId;

	COMMIT TRANSACTION T_sp_receberEncomenda
	RETURN
end
GO





