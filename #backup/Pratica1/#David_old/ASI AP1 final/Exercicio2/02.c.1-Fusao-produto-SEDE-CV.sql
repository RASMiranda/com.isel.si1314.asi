USE [ASI];
GO

ALTER TABLE [dbo].[produto]
ADD 
	[preco] [money] NULL,
	[qtStock] [int] NULL,
	[qtMinStock] [int] NULL
;
GO

UPDATE [dbo].[produto]
	SET [dbo].[produto].[preco] = [dbo].[produtoCV].[preco],
		[dbo].[produto].[qtStock] = [dbo].[produtoCV].[qtStock],
		[dbo].[produto].[qtMinStock] = [dbo].[produtoCV].[qtMinStock]
FROM
	[dbo].[produto]
INNER JOIN
	[dbo].[produtoCV]
ON
	[dbo].[produtoCV].cod = [dbo].[produto].cod
GO



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
					,[tipo]
					,[preco]
					,[qtStock]
					,[qtMinStock])
				VALUES
					(@codFornecedor
					,@qtEncomenda
					,@cod
					,@estado
					,@tipo
					,@preco
					,@qtStock
					,@qtMinStock)
	
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
		 
        -- apaga na tabela da sede
		DELETE [dbo].[produto]
         WHERE cod = @cod;

         COMMIT TRANSACTION T_removeProduto
	RETURN 		
end


GO

USE [ASI]
GO

/****** Object:  Trigger [trViewProduto]    Script Date: 24-10-2013 12:33:44 ******/
IF OBJECT_ID ('trViewProduto','TR') IS NOT NULL
	DROP TRIGGER [dbo].[trViewProduto]
GO

USE [ASI]
GO

/****** Object:  View [dbo].[viewProduto]    Script Date: 17-10-2013 21:20:07 ******/
IF OBJECT_ID ('viewProduto','V') IS NOT NULL
	DROP VIEW [dbo].[viewProduto]
GO

CREATE SYNONYM [dbo].[viewProduto] FOR [ASI].[dbo].[produto]
GO


