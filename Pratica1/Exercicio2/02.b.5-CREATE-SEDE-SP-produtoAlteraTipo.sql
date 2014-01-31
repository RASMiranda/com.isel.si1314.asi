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

drop procedure [dbo].produtoAlteraTipo 
GO

create procedure [dbo].produtoAlteraTipo 
	@codProd			[int],
	@tipo			[char](1)
as
begin
	SET XACT_ABORT ON
	Begin transaction
	
		update [dbo].Produto
		   set tipo = @tipo 
		 where cod = @codProd;
		 
	commit transaction

    return @@rowcount
end

GO
