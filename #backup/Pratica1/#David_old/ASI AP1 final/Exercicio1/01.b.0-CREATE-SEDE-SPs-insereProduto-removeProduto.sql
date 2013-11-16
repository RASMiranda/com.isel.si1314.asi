

USE [ASI]
GO

/****** Object:  StoredProcedure [dbo].[insereProduto]    Script Date: 24-10-2013 12:19:24 ******/
DROP PROCEDURE [dbo].[insereProduto]
GO

/****** Object:  StoredProcedure [dbo].[insereProduto]    Script Date: 24-10-2013 12:19:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[insereProduto] 
	@cod			[int],
	@codFornecedor	[int],
	@qtEncomenda	[int],
	@estado			[bit],
	@tipo			[char](1),
	@preco			[money],
	@qtMinStock		[int],
	@qtStock		[int]
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_insereProduto
		
		INSERT INTO [dbo].[produto]
					([codFornecedor]
					,[qtEncomenda]
					,[cod]
					,[estado]
					,[tipo])
				VALUES
					(@codFornecedor
					,@qtEncomenda
					,@cod
					,@estado
					,@tipo)

		IF @tipo = 'D'
		BEGIN
			INSERT INTO ProdutoDesp
						([cod]
						,[preco]
						,[qtStock]
						,[qtMinStock])
					VALUES
						(@cod
						,@preco
						,@qtStock
						,@qtMinStock)

		END
		IF @tipo = 'C'
		BEGIN
			INSERT INTO ProdutoCrianca
						([cod]
						,[preco]
						,[qtStock]
						,[qtMinStock])
					VALUES
						(@cod
						,@preco
						,@qtStock
						,@qtMinStock)
		END
		

	
	COMMIT TRANSACTION T_insereProduto
	RETURN 		
end

GO

DROP PROCEDURE [dbo].[removeProduto]
GO

create procedure [dbo].[removeProduto] 
	@cod			[int]
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_removeProduto
		IF @tipo = 'D'
		BEGIN
            DELETE ProdutoDesp
             WHERE cod = @cod;
		END
		IF @tipo = 'C'
		BEGIN
            DELETE ProdutoCrianca
             WHERE cod = @cod;
		END
        -- apaga na tabela da sede
		DELETE [dbo].[produto]
         WHERE cod = @cod;

         COMMIT TRANSACTION T_removeProduto
	RETURN 		
end


GO


