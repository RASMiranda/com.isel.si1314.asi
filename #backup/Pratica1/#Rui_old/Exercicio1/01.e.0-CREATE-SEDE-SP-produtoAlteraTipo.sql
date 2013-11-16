USE [ASI]
GO

/****** Object:  StoredProcedure [dbo].[produtoAlteraTipo]    Script Date: 24-10-2013 12:19:24 ******/
DROP PROCEDURE [dbo].[produtoAlteraTipo]
GO

/****** Object:  StoredProcedure [dbo].[produtoAlteraTipo]    Script Date: 24-10-2013 12:19:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[produtoAlteraTipo] 
	@cod			[int],
	@tipo			[char](1)
as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_produtoAlteraTipo
		DECLARE @oldtipo [char](1)
	
		SELECT @oldtipo = tipo
		FROM [dbo].[produto]
		WHERE cod=@cod

		IF @oldtipo <> @tipo
		BEGIN
			DECLARE @preco [money],
					@qtStock [int],
					@qtMinStock [int]

			UPDATE [dbo].[produto]
			SET	tipo=@tipo
			WHERE cod=@cod

			IF @oldtipo = 'C' AND @tipo = 'D'
			BEGIN
			
				SELECT TOP 1
					@preco = preco,
					@qtStock = qtStock,
					@qtMinStock = qtMinStock
				FROM ProdutoCrianca
				WHERE cod=@cod

				DELETE FROM ProdutoCrianca
				WHERE cod=@cod

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
			IF @oldtipo = 'D' AND @tipo = 'C'
			BEGIN
				SELECT TOP 1
					@preco = preco,
					@qtStock = qtStock,
					@qtMinStock = qtMinStock
				FROM ProdutoDesp
				WHERE cod=@cod

				DELETE FROM ProdutoDesp
				WHERE cod=@cod

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
		END

	
	COMMIT TRANSACTION T_produtoAlteraTipo
	RETURN 		
end


GO


