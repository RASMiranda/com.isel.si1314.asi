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
    @VendaExpedida		[BIT],
    @EncomendaId		[INT],

	@ENCOMENDA_AGUARDA_RECEPCAO int = 0,	@ENCOMENDA_RECEBIDA int = 1,
	@VENDA_AGUARDA_EXPEDICAO int = 0,		@VENDA_EXPEDIDA int = 1
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

	-- print ' :' + cast( as varchar) + 
	-- print ' @Tipo:' + cast( @Tipo as varchar) + ' @StockMinimo:' + cast( @StockMinimo as varchar) + ' @StockQtd:' + cast( @StockQtd as varchar)

	print 'Registar a expedicao da encomenda: 1 significa que foi expedida.'
	SELECT @VendaExpedida = CASE 
								WHEN @Qtd <= @StockQtd 
								THEN @VENDA_EXPEDIDA 
								ELSE @VENDA_AGUARDA_EXPEDICAO 
							END;

	print 'Registar a venda.'

	INSERT INTO [dbo].[Venda]
		([NomeCliente], [MoradaCliente], [Estado])
	VALUES
		(@nomeCliente, @moradaCliente, @VendaExpedida);
	SELECT @VendaId = SCOPE_IDENTITY(); -- get id gerado pelo insert

	INSERT INTO [dbo].[VendaProdutos]
		([Codigo], [Qtd], [Estado], [Venda_VendaID], [Produto_ProdutoID])
	VALUES
		(@CodigoProduto, @Qtd, @VendaExpedida, @VendaId, @ProdutoId);
	SELECT @VendaProdutosId = SCOPE_IDENTITY(); -- get id gerado pelo insert
	
	print 'Se @Qtd <= StockQtd pode-se vender e expedir ja.'
	if @Qtd <= @StockQtd
	begin

		print 'Actualizar o stock.'
		UPDATE [dbo].[Produto]
		SET [StockQtd] = @StockQtd - @Qtd
		WHERE Codigo = @CodigoProduto and ProdutoID = @ProdutoId;

		/* cada loja actualiza o seu stock antes de mandar o pedido de venda
		if @Tipo in (0, 1)
			UPDATE [dbo].[ProdutoSC]
			SET [StockQtd] = @StockQtd - @Qtd
			WHERE Codigo = @CodigoProduto;
		else if @Tipo in (2, 3)
			UPDATE [dbo].[ProdutoHD]
			SET [StockQtd] = @StockQtd - @Qtd
			WHERE Codigo = @CodigoProduto;
		else
			print('Tipo desconhecido.')
		*/

		print 'Se novo StockQtd < StockMinimo adiciona-se uma nova entrada (com [Estado] a 0) à tabela de Encomendas.'
		print 'SQ:' + cast(@StockQtd as varchar) + ' - Qtd:' + cast(@Qtd as varchar)  + ' < SM:' + cast(@StockMinimo as varchar) 
		if @StockQtd - @Qtd < @StockMinimo
		begin
			SET @QtdAEncomendar = 2*@StockMinimo;
			print 'QE:' + cast(@QtdAEncomendar as varchar)

			EXECUTE [dbo].[sp_realizarEncomenda]
				@CodigoProduto = @CodigoProduto,	@EncomendaRecebida = @ENCOMENDA_AGUARDA_RECEPCAO,
				@QtdEncomendada = @QtdAEncomendar, 	@VendaId = null,
				@EncomendaId = @EncomendaId OUTPUT
		end

	end
	else
	begin
		print '@Qtd > hd.StockQtd. Não há stock suficiente: registar a encomenda.'
		SET @QtdAEncomendar = CASE WHEN 2*@StockMinimo > @Qtd THEN 2*@StockMinimo ELSE @Qtd END;

		EXECUTE [dbo].[sp_realizarEncomenda]
			@CodigoProduto = @CodigoProduto,	@EncomendaRecebida = @ENCOMENDA_AGUARDA_RECEPCAO, 
			@QtdEncomendada = @QtdAEncomendar, 	@VendaId = @VendaId, -- @VendaId para se saber qual é a venda que provocou esta encomenda
			@EncomendaId = @EncomendaId OUTPUT

	end

	COMMIT TRANSACTION T_sp_realizarVenda
	RETURN
end
GO





