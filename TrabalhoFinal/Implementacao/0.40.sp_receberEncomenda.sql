USE [ASIVesteSede]
GO

IF OBJECT_ID('sp_receberEncomenda') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_receberEncomenda];
GO

create procedure [dbo].[sp_receberEncomenda]
    @EncomendaId	[INT]
as
declare
    @ProdutoVendidoId	[INT],
	@CodigoProdutoVendido [VARCHAR](30),
    @VendaId			[INT],
    @VendaProdutoId		[INT],

	@QtdEncomendada	[INT] = 0,
	@QtdVendida		[INT] = 0,
	@StockMinimo	[INT],
	@StockQtdActual	[INT],
	@Tipo			[INT],

	@RC int,

	@ENCOMENDA_AGUARDA_RECEPCAO int = 0,	@ENCOMENDA_RECEBIDA int = 1,
	@VENDA_AGUARDA_EXPEDICAO int = 0,		@VENDA_EXPEDIDA int = 1
begin

	-- http://stackoverflow.com/questions/4630689/how-do-i-unset-reset-a-transaction-isolation-level-for-sql-server
	SET XACT_ABORT ON
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION T_sp_receberEncomenda

	SELECT
		@QtdEncomendada = e.Qtd,
		@VendaProdutoId = e.VendaProduto_VendaProdutosID,
		@ProdutoVendidoId = p.ProdutoID,
		@CodigoProdutoVendido = p.Codigo,
		@StockMinimo = p.StockMinimo,
		@StockQtdActual = p.StockQtd,
		@Tipo = p.Tipo
	FROM [dbo].[Encomenda] e
			inner join Produto p
				on e.Produto_ProdutoID = p.ProdutoID
	WHERE [EncomendaID] = @EncomendaId AND
			e.[Estado] = 0;

	if @@ROWCOUNT = 0
		THROW 50001, 'Encomenda nao existente ou ja recebida.', 1;

	print ' @QtdEncomendada: ' + cast(@QtdEncomendada as varchar) + ' @ProdutoVendidoId: ' + cast(@ProdutoVendidoId as varchar) +
		' @StockMinimo: ' + cast(@StockMinimo as varchar) + ' @StockQtdActual: ' + cast(@StockQtdActual as varchar) + ' @Tipo: ' + cast(@Tipo as varchar);

	print 'A declarar esta EncomendaId como entregue.'
	UPDATE [dbo].[Encomenda]
	SET Estado = @ENCOMENDA_RECEBIDA
	WHERE [EncomendaID] = @EncomendaId AND 
			[Estado] = @ENCOMENDA_AGUARDA_RECEPCAO;
	
	if @@ROWCOUNT = 0
		THROW 50002, 'Encomenda nao existente ou ja recebida.', 0;

	IF @VendaProdutoId is not null
	BEGIN
		print 'A obter a info relativa a venda'

		SELECT
			@VendaId = v.VendaID,
			@QtdVendida = vp.Qtd
		FROM
			VendaProdutos vp 
			inner join Venda v	
				on vp.Venda_VendaID = v.VendaID
		WHERE
			vp.VendaProdutosID = @VendaProdutoId AND
			vp.Produto_ProdutoID = @ProdutoVendidoId;

		if @@ROWCOUNT = 0
			THROW 50003, 'VendaProduto nao foi encontrada.', 0;


		print 'A expedir a venda que esta à espera desta encomenda.'

		UPDATE [dbo].[VendaProdutos]
		SET Estado = @VENDA_EXPEDIDA
		WHERE [VendaProdutosId] = @VendaProdutoId;

		if @@ROWCOUNT = 0
			THROW 50004, 'VendaProduto nao foi actualizada.', 0;

		UPDATE [dbo].[Venda]
		SET Estado = @VENDA_EXPEDIDA
		WHERE [VendaId] = @VendaId;

		if @@ROWCOUNT = 0
			THROW 50005, 'Venda nao foi actualizada.', 0;
	END

	print 'A determinar quantas unidades foram vendidas.'
	SELECT @StockQtdActual = @StockQtdActual + @QtdEncomendada - @QtdVendida;

	-- trans distribuida
	print 'A actualizar o StockQtd. So uma das tabelas remotas sera efectivamente escrita.'

	UPDATE [dbo].[Produto]
	SET StockQtd = @StockQtdActual
	WHERE [ProdutoId] = @ProdutoVendidoId;

	if @Tipo in (0, 1)
	begin
		UPDATE [dbo].[ProdutoSC]
		SET StockQtd = @StockQtdActual
		WHERE [Codigo] = @CodigoProdutoVendido;

		if @@ROWCOUNT = 0
			THROW 50006, 'ProdutoSC nao foi actualizado.', 0;
	end
	else if @Tipo in (2, 3)
	begin
		UPDATE [dbo].[ProdutoHD]
		SET StockQtd = @StockQtdActual
		WHERE [Codigo] = @CodigoProdutoVendido;

		if @@ROWCOUNT = 0
			THROW 50007, 'ProdutoHD nao foi actualizado.', 0;
	end
	else
		print 'Tipo de produto desconhecido: ' + cast(@tipo as varchar)

	COMMIT TRANSACTION T_sp_receberEncomenda

	print 'Done T_sp_receberEncomenda!'
	RETURN
end
GO





