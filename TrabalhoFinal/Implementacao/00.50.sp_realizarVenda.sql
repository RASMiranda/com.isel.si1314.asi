USE [ASIVeste]
GO

IF OBJECT_ID('sp_realizarVenda') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_realizarVenda];
GO

create procedure [dbo].[sp_realizarVenda] 
	@NomeCliente	[VARCHAR](30),
    @MoradaCliente	[VARCHAR](30),
    @ProdutoId		[INT],
    @Qtd 			[INT],

    @VendaId		[INT] OUTPUT,
    @VendaExpedida	[BIT] OUTPUT,
    @ExpedicaoId	[INT] OUTPUT,
    @EncomendaId	[INT] OUTPUT
as
declare
	@Id				[INT],
	@Tipo			[INT],
	@PrdIdEnc		[INT],
	@StockMinimo	[INT],
	@StockQtd		[INT],
	@QtdAEncomendar [INT],
	@ENCOMENDA_AGUARDA_RECEPCAO int = 0,
	@ENCOMENDA_RECEBIDA int = 1,
	@VENDA_AGUARDA_EXPEDICAO int = 0,
	@VENDA_EXPEDIDA int = 1
begin

	-- http://stackoverflow.com/questions/4630689/how-do-i-unset-reset-a-transaction-isolation-level-for-sql-server
	-- SET XACT_ABORT ON -- a trans nao é distribuida
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION T_sp_realizarVenda

	print 'Registar a venda.'
	INSERT INTO [dbo].[Venda]
		([NomeCliente], [MoradaCliente], [ProdutoId], [Qtd])
	VALUES
		(@nomeCliente, @moradaCliente, @produtoId, @Qtd);
	SELECT @VendaId = SCOPE_IDENTITY(); -- get id gerado pelo insert

	print 'Verificar se ha stock para satisfazer @Qtd; se não fica tudo a null.'
	select 
		@Tipo = x.Tipo, 
		@StockMinimo = x.StockMinimo, 
		@StockQtd = x.StockQtd
	from (
		select p.Tipo, p.StockMinimo, hd.StockQtd
		from (Produto p inner join ProdutoHD hd on p.id = hd.Id)
		where p.id = @ProdutoId 
		union
		select p.Tipo, p.StockMinimo, cs.StockQtd
		from (Produto p inner join ProdutoCS cs on p.id = cs.Id)
		where p.id = @ProdutoId
	) x;
	-- print ' :' + cast( as varchar) + 
	print ' @Tipo:' + cast( @Tipo as varchar) + ' @StockMinimo:' + cast( @StockMinimo as varchar) + ' @StockQtd:' + cast( @StockQtd as varchar)

	print 'Registar a expedicao da encomenda: 1 significa que foi expedida.'
	SELECT @VendaExpedida = CASE WHEN @Qtd <= @StockQtd THEN 1 ELSE 0 END;

	INSERT INTO [dbo].[Expedicao]
		([VendaId] ,[Expedida])
	VALUES
		(@VendaId, @VendaExpedida);
	SELECT @ExpedicaoId = SCOPE_IDENTITY();

	print 'Se @Qtd <= StockQtd pode-se vender e expedir ja.'
	if @Qtd <= @StockQtd
	begin

		print 'Actualizar o stock em tabelas com replicacao assincrona para as lojas.'
		IF @tipo = 0 OR @tipo = 1 -- 0- Criança, 1-Senhora
		BEGIN
			UPDATE [dbo].[ProdutoCS]
			SET [StockQtd] = @StockQtd - @Qtd
			WHERE Id = @ProdutoId;
		END
		ELSE IF @tipo = 2 OR @tipo = 3 -- 2- Homem, 3- Desportista
		BEGIN
			UPDATE [dbo].[ProdutoHD]
			SET [StockQtd] = @StockQtd - @Qtd
			WHERE Id = @ProdutoId;
		END
		
		print 'Se novo StockQtd < StockMinimo adiciona-se uma nova entrada (com [Estado] a 0) à tabela de Encomendas.'
		print 'SQ:' + cast(@StockQtd as varchar) + ' - Qtd:' + cast(@Qtd as varchar)  + ' < SM:' + cast(@StockMinimo as varchar) 
		if @StockQtd - @Qtd < @StockMinimo
		begin
			SET @QtdAEncomendar = 2*@StockMinimo;
			print 'QE:' + cast(@QtdAEncomendar as varchar)

			EXECUTE [dbo].[sp_realizarEncomenda]
				@ProdutoId = @ProdutoId,			@EncomendaRecebida = @ENCOMENDA_AGUARDA_RECEPCAO,
				@QtdEncomendada = @QtdAEncomendar, 	@VendaId = null,
				@EncomendaId = @EncomendaId OUTPUT
		end

	end
	else
	begin
		print '@Qtd > hd.StockQtd. Não há stock suficiente: registar a encomenda.'
		SET @QtdAEncomendar = CASE WHEN 2*@StockMinimo > @Qtd THEN 2*@StockMinimo ELSE @Qtd END;

		EXECUTE [dbo].[sp_realizarEncomenda]
			@ProdutoId = @ProdutoId,			@EncomendaRecebida = @ENCOMENDA_AGUARDA_RECEPCAO, 
			@QtdEncomendada = @QtdAEncomendar, 	@VendaId = @VendaId, -- @VendaId para se saber qual é a venda que provocou esta encomenda
			@EncomendaId = @EncomendaId OUTPUT

	end

	COMMIT TRANSACTION T_sp_realizarVenda
	RETURN
end
GO





