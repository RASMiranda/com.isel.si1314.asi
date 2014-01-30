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


