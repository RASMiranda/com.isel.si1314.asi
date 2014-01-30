USE [ASI]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE [dbo].[receberEncomenda]
GO

create procedure [dbo].[receberEncomenda] 
	@codProd		[int],
	@qtEncomenda	[int]
as
    declare @encomendaId int
begin
		-- se existe uma encomenda aberta para este produto nesta quantidade
		-- recebe o produto marcando que ja nao tem encomenda pendente e ajusta o stock actual
	SET XACT_ABORT ON
	BEGIN Transaction
		select @encomendaId = codEnc from [dbo].ProdutosEncomendados
         where cod = @codProd 
           and qtEncomenda = @qtEncomenda
           and estado = 1;
           
		if @encomendaId >=0
        BEGIN
			update [dbo].viewProduto
			   set qtStock = qtStock + @qtEncomenda, estado = 0
			 where cod = @codProd;
            
			update [dbo].ProdutosEncomendados
			   set estado = 0
			 where codEnc = @encomendaId;
        END
             
	Commit Transaction;
       
	return @@rowcount
END

GO

