USE [ASIVesteSede]
GO

IF OBJECT_ID('sp_realizarVenda') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_realizarVenda];
GO

create procedure [dbo].[sp_realizarVenda] 
	@NomeCliente	[VARCHAR](30),
    @MoradaCliente	[VARCHAR](30),
    @CodigoProduto	[VARCHAR](30),
    @Qtd 			[INT]
as
declare
	@ProdutoId		[INT],
	@Tipo			[INT],
	@StockMinimo	[INT],
	@StockQtd		[INT],
	@QtdAEncomendar [INT],

    @VendaId			[INT],
    @VendaProdutosId	[INT],
    @VendaEstado		[BIT],
    @EncomendaId		[INT]
	
begin

	-- http://stackoverflow.com/questions/4630689/how-do-i-unset-reset-a-transaction-isolation-level-for-sql-server
	-- SET XACT_ABORT ON -- a trans nao é distribuida
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION T_sp_realizarVenda

	print 'Verificar se ha stock para satisfazer @Qtd; se não fica tudo a null.'
	select 
		@ProdutoId = ProdutoID,
		@Tipo = Tipo,
		@StockMinimo = StockMinimo, 
		@StockQtd = StockQtd
	from Produto 
	where Codigo = @CodigoProduto;

	/* print 'Registar a expedicao da encomenda: 1 significa que foi expedida.' */
	SELECT @VendaEstado = 0 -- Pendente (ASIVesteSede.Models.Venda.Pendente)

	/* print 'Registar a venda.' */

	INSERT INTO [dbo].[Venda]
		([NomeCliente], [MoradaCliente], [Estado])
	VALUES
		(@nomeCliente, @moradaCliente, @VendaEstado);
	SELECT @VendaId = SCOPE_IDENTITY(); -- get id gerado pelo insert

	INSERT INTO [dbo].[VendaProdutos]
		([Codigo], [Qtd], [Estado], [Venda_VendaID], [Produto_ProdutoID])
	VALUES
		(@CodigoProduto, @Qtd, @VendaEstado, @VendaId, @ProdutoId);
	SELECT @VendaProdutosId = SCOPE_IDENTITY(); -- get id gerado pelo insert
	
	/* print 'Se @Qtd <= StockQtd pode-se vender e expedir ja.' */
	if @Qtd <= @StockQtd
	begin

		/* print 'Actualizar o stock.' */
		UPDATE [dbo].[Produto]
		SET [StockQtd] = @StockQtd - @Qtd
		WHERE Codigo = @CodigoProduto and ProdutoID = @ProdutoId;

		/* print 'Se novo StockQtd < StockMinimo adiciona-se uma nova entrada (com [Estado] a 0) à tabela de Encomendas.' */
		/* print 'SQ:' + cast(@StockQtd as varchar) + ' - Qtd:' + cast(@Qtd as varchar)  + ' < SM:' + cast(@StockMinimo as varchar)  */
		if @StockQtd - @Qtd < @StockMinimo
		begin
			SET @QtdAEncomendar = 2*@StockMinimo;
			/* print 'QE:' + cast(@QtdAEncomendar as varchar) */

			EXECUTE [dbo].[sp_realizarEncomenda]
				@CodigoProduto = @CodigoProduto,	
				@QtdEncomendada = @QtdAEncomendar, 
				@VendaId = null
		end

	end
	else
	begin
		/* print '@Qtd > hd.StockQtd. Não há stock suficiente: registar a encomenda.' */
		SET @QtdAEncomendar = CASE WHEN 2*@StockMinimo > @Qtd THEN 2*@StockMinimo ELSE @Qtd END;

		EXECUTE [dbo].[sp_realizarEncomenda]
			@CodigoProduto = @CodigoProduto,	
			@QtdEncomendada = @QtdAEncomendar, 	
			@VendaId = @VendaId -- @VendaId para se saber qual é a venda que provocou esta encomenda

	end

	COMMIT TRANSACTION T_sp_realizarVenda

	SELECT @VendaId VendaId; -- para actualizar o EF

	RETURN
end
GO





