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
	DECLARE @oldtipo [char](1)
	
	SELECT @oldtipo = tipo
	  FROM [dbo].[produto]
	 WHERE cod =@codProd
       and tipo <> @tipo;

	IF @@rowcount > 0
		begin
        SET XACT_ABORT ON
        Begin transaction
            if @oldtipo = 'c'
                begin
                    insert into [dbo].ProdutoDesp (cod, preco, qtStock, qtMinStock)
                        select new.cod, new.preco, new.qtStock, new.qtMinStock
                          from [dbo].ProdutoCrianca new
                         where new.cod = @codProd;

                    delete [dbo].ProdutoCrianca
                      where cod = @codProd;
                end
            if @oldtipo = 'd'
                begin
                    insert into [dbo].ProdutoCrianca (cod, preco, qtStock, qtMinStock)
                        select new.cod, new.preco, new.qtStock, new.qtMinStock
                          from [dbo].ProdutoDesp new
                         where new.cod = @codProd;

                    delete [dbo].ProdutoDesp
                      where cod = @codProd;
                end
            update [dbo].Produto
               set tipo = @tipo 
             where cod = @codProd;
         commit transaction
     end

    return @@rowcount
end

GO
