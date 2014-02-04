USE [ASIVesteSede]
GO

IF OBJECT_ID('sp_inserirProduto') IS NOT NULL
	DROP PROCEDURE [dbo].sp_inserirProduto;
GO

CREATE PROCEDURE sp_inserirProduto
	@Tipo			int,
	@Codigo			nvarchar(max),
	@Designacao		nvarchar(max),
	@StockQtd		int,
	@StockMinimo	int,
	@Preco			real,
	@FornecedorId	int
AS
DECLARE
	@ProdutoId	int
BEGIN
	SET XACT_ABORT ON -- a trans é distribuida
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- default value
	BEGIN TRANSACTION T_sp_inserirProduto

	INSERT INTO [dbo].[Produto]
				([Tipo],[Codigo],[Designacao],[StockQtd],[StockMinimo],[Preco],[Fornecedor_FornecedorID])
		 VALUES
				(@Tipo, @Codigo, @Designacao, @StockQtd, @StockMinimo, @Preco, @FornecedorID)
	;

	if @@ROWCOUNT <> 1
		THROW 50001, 'Erro ao inserir em [Produto] @sp_inserirProduto.', 1;

	SELECT @ProdutoId = SCOPE_IDENTITY();

	if @Tipo in (0,1)
	begin
		INSERT INTO [dbo].[ProdutoSC]
				   ([Codigo],[Designacao],[StockQtd],[Preco])
			 VALUES
				   (@Codigo, @Designacao, @StockQtd, @Preco);

		if @@ROWCOUNT <> 1
			THROW 50003, 'Erro ao inserir em [ProdutoSC] @sp_inserirProduto.', 1;
	end
	else if @Tipo in (2,3)
	begin
		INSERT INTO [dbo].[ProdutoHD]
				   ([Codigo],[Designacao],[StockQtd],[Preco])
			 VALUES
				   (@Codigo, @Designacao, @StockQtd, @Preco);

		if @@ROWCOUNT <> 1
			THROW 50005, 'Erro ao inserir em [ProdutoHD] @sp_inserirProduto.', 1;
	end
	else
		THROW 50009, 'Tipo desconhecido @sp_inserirProduto.', @Tipo;

	COMMIT TRANSACTION T_sp_inserirProduto

	SELECT @ProdutoId ProdutoId -- para actualizar o EF
END
GO



IF OBJECT_ID('sp_actualizarProduto') IS NOT NULL
	DROP PROCEDURE [dbo].sp_actualizarProduto;
GO

CREATE PROCEDURE sp_actualizarProduto
	@ProdutoId		int,			@Tipo			int,	@Codigo			nvarchar(max),
	@Designacao		nvarchar(max),	@StockQtd		int,	@StockMinimo	int,
	@Preco			real,			@FornecedorId	int,	@novoCodigo		nvarchar(max) = NULL
AS
BEGIN
	SET XACT_ABORT ON -- a trans é distribuida
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- default value
	BEGIN TRANSACTION T_sp_actualizarProduto

	if @novoCodigo is null
		set @novoCodigo = @Codigo

	UPDATE [dbo].[Produto]
	   SET [Tipo] = @Tipo
		  ,[Codigo] = @novoCodigo
		  ,[Designacao] = @Designacao
		  ,[StockQtd] = @StockQtd
		  ,[StockMinimo] = @StockMinimo
		  ,[Preco] = @Preco
		  ,[Fornecedor_FornecedorID] = @FornecedorId
	 WHERE [ProdutoID] = @ProdutoId 
			and [Codigo] = @Codigo
	 ;

	if @@ROWCOUNT <> 1
		THROW 50001, 'Erro ao actualizar [Produto] @sp_actualizarProduto.', @ProdutoId;

	if @Tipo in (0,1)
	begin
		UPDATE [dbo].[ProdutoSC]
			SET [Codigo] = @novoCodigo
				,[Designacao] = @Designacao
				,[StockQtd] = @StockQtd
				,[Preco] = @Preco
		WHERE [Codigo] = @Codigo
		;

		if @@ROWCOUNT <> 1
			THROW 50003, 'Erro ao actualizar [ProdutoSC] @sp_actualizarProduto.', 1;
	end
	else if @Tipo in (2,3)
	begin
		UPDATE [dbo].[ProdutoHD]
			SET [Codigo] = @novoCodigo
				,[Designacao] = @Designacao
				,[StockQtd] = @StockQtd
				,[Preco] = @Preco
		WHERE [Codigo] = @Codigo
		;

		if @@ROWCOUNT <> 1
			THROW 50005, 'Erro ao actualizar [ProdutoHD] @sp_actualizarProduto.', 1;
	end
	else
		THROW 50007, 'Tipo desconhecido @sp_actualizarProduto.', @Tipo;

	COMMIT TRANSACTION T_sp_actualizarProduto
END
GO




IF OBJECT_ID('sp_removerProduto') IS NOT NULL
	DROP PROCEDURE [dbo].sp_removerProduto;
GO

CREATE PROCEDURE sp_removerProduto
	@ProdutoId		int = null,
	@Codigo			nvarchar(max) = null
AS
DECLARE
	@Tipo int
BEGIN
	SET XACT_ABORT ON -- a trans é distribuida
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- default value
	BEGIN TRANSACTION T_sp_removerProduto

	if @ProdutoId is null and @Codigo is null
		THROW 50000, '@ProdutoId e @Codigo foram passados a null em @sp_removerProduto.', @ProdutoId;

	select
		@ProdutoId = ProdutoId,
		@Tipo = Tipo,
		@Codigo = Codigo
	from [dbo].[Produto]
	where (@ProdutoId is null OR ProdutoId = @ProdutoId ) AND
			(@Codigo is null OR Codigo = @Codigo )
	;

	if @@ROWCOUNT <> 1
		THROW 50001, 'Erro ao determinar chaves de [Produto] em @sp_removerProduto.', @ProdutoId;

	DELETE FROM [dbo].[Produto]
	WHERE [ProdutoID] = @ProdutoId AND
			[Codigo] = @Codigo
	;

	if @@ROWCOUNT <> 1
		THROW 50002, 'Erro ao remover [Produto] @sp_removerProduto.', @ProdutoId;

	if @Tipo in (0,1)
	begin
		DELETE FROM [dbo].[ProdutoSC] WHERE [Codigo] = @Codigo;

		if @@ROWCOUNT <> 1
			THROW 50003, 'Erro ao remover [ProdutoSC] @sp_removerProduto.', 1;
	end
	else if @Tipo in (2,3)
	begin
		DELETE FROM [dbo].[ProdutoHD] WHERE [Codigo] = @Codigo;

		if @@ROWCOUNT <> 1
			THROW 50004, 'Erro ao remover [ProdutoHD] @sp_removerProduto.', 1;
	end
	else
		THROW 50005, 'Tipo desconhecido @sp_removerProduto.', @Tipo;

	COMMIT TRANSACTION T_sp_removerProduto
END
GO

