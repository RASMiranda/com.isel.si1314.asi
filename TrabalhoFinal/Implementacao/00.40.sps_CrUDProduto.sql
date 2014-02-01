USE [ASIVeste]
GO


-- http://msdn.microsoft.com/en-us/data/gg699321.aspx

IF OBJECT_ID('sp_inserirProduto') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_inserirProduto];
GO

create procedure [dbo].[sp_inserirProduto] 
	@Tipo			[int],
	@Designacao		[varchar](50),
	@Preco			[decimal](8, 2),
	@StockQtd		[int],
	@StockMinimo	[int],
	@FornecedorId	[int]
as
declare
	@Id			[int]
begin

	SET XACT_ABORT ON
	BEGIN TRANSACTION T_sp_inserirProduto

		INSERT INTO [dbo].[Produto] 
					([Tipo], [StockMinimo], [FornecedorId])
				VALUES
					(@Tipo, @StockMinimo, @FornecedorId)
		;
		SELECT @Id = SCOPE_IDENTITY(); -- get id gerado pelo insert

		-- tabelas com replicacao assincrona para as lojas
		IF @tipo = 0 OR @tipo = 1 -- 0- Criança, 1-Senhora
		BEGIN
			INSERT INTO [dbo].[ProdutoCS] 
						([Id], [Designacao], [Preco], [StockQtd])
					VALUES
						(@Id, @Designacao, @Preco, @StockQtd)
			;
		END
		ELSE IF @tipo = 2 OR @tipo = 3 -- 2- Homem, 3- Desportista
		BEGIN
			INSERT INTO [dbo].[ProdutoHD] 
						([Id], [Designacao], [Preco], [StockQtd])
					VALUES
						(@Id, @Designacao, @Preco, @StockQtd)
			;
		END
	
	COMMIT TRANSACTION T_sp_inserirProduto

	SELECT [Id] FROM [dbo].[Produto] WHERE [Id] = @Id;

	RETURN
end
GO




IF OBJECT_ID('sp_alterarProduto') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_alterarProduto];
GO

create procedure [dbo].[sp_alterarProduto] 
	@Id				[int],
	@Tipo			[int],			--
	@Designacao		[varchar](50),
	@Preco			[decimal](8, 2),
	@StockQtd		[int],
	@StockMinimo	[int],			--
	@FornecedorId	[int]			--
as
declare
	@OldTipo		[int]
begin
	
	SET XACT_ABORT ON
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRANSACTION T_sp_alterarProduto

		SELECT @OldTipo = [Tipo] FROM [dbo].[Produto] WHERE [Id] = @Id;

		UPDATE [dbo].[Produto] 
		SET
			[Tipo] = CASE WHEN @Tipo IS NOT NULL THEN @Tipo ELSE [Tipo] END,
			[StockMinimo] = CASE WHEN @StockMinimo IS NOT NULL THEN @StockMinimo ELSE [StockMinimo] END,
			[FornecedorId] = CASE WHEN @FornecedorId IS NOT NULL THEN @FornecedorId ELSE [FornecedorId] END
		WHERE
			[Id] = @Id;

		IF ( @OldTipo in (0, 1) AND @Tipo in (2, 3) )
		BEGIN
			-- move CS > HD
			INSERT INTO [dbo].[ProdutoHD]
					   ([Id], [Designacao], [Preco], [StockQtd])
				SELECT
					[Id], [Designacao], [Preco], [StockQtd]
				FROM [dbo].[ProdutoCS]
				WHERE Id = @Id;

			DELETE FROM [dbo].[ProdutoCS] WHERE Id = @Id;
		END
		ELSE IF ( @OldTipo in (2, 3) AND @Tipo in (0, 1) )
		BEGIN
			-- move HD > CS
			INSERT INTO [dbo].[ProdutoCS]
					   ([Id], [Designacao], [Preco], [StockQtd])
				SELECT
					[Id], [Designacao], [Preco], [StockQtd]
				FROM [dbo].[ProdutoHD]
				WHERE Id = @Id;

			DELETE FROM [dbo].[ProdutoHD] WHERE Id = @Id;
		END

		-- tabelas com replicacao assincrona para as lojas
		IF @Tipo in (0,1)
			UPDATE [dbo].[ProdutoCS]
			SET
				[Designacao] = CASE WHEN @Designacao IS NOT NULL THEN @Designacao ELSE [Designacao] END,
				[Preco] = CASE WHEN @Preco IS NOT NULL THEN @Preco ELSE [Preco] END,
				[StockQtd] = CASE WHEN @StockQtd IS NOT NULL THEN @StockQtd ELSE [StockQtd] END
			WHERE
				[Id] = @Id;

		-- tabelas com replicacao assincrona para as lojas
		ELSE IF @Tipo in (2, 3)
			UPDATE [dbo].[ProdutoHD] 
			SET
				[Designacao] = CASE WHEN @Designacao IS NOT NULL THEN @Designacao ELSE [Designacao] END,
				[Preco] = CASE WHEN @Preco IS NOT NULL THEN @Preco ELSE [Preco] END,
				[StockQtd] = CASE WHEN @StockQtd IS NOT NULL THEN @StockQtd ELSE [StockQtd] END
			WHERE
				[Id] = @Id;

	COMMIT TRANSACTION T_sp_alterarProduto
	RETURN
end
GO




IF OBJECT_ID('sp_removerProduto') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_removerProduto];
GO

create procedure [dbo].[sp_removerProduto] 
	@Id			[int]
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_sp_removerProduto

        DELETE [dbo].[ProdutoCS] WHERE Id = @Id; -- tabela local

        DELETE [dbo].[ProdutoHD] WHERE Id = @Id; -- tabela local

		DELETE [dbo].[Produto] WHERE Id = @Id;

    COMMIT TRANSACTION T_sp_removerProduto
end
GO


