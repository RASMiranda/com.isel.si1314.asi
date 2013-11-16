
USE [ASI]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE [dbo].[ProdutosEncomendados]
GO

create table [dbo].[ProdutosEncomendados]
(
	codEnc int primary key identity,
    cod int REFERENCES [dbo].produto,
    codFornecedor int REFERENCES [dbo].fornecedor,
    diaHora     datetime default CURRENT_TIMESTAMP, 
    estado      bit NOT NULL,
    qtEncomenda int NOT NULL
)

GO

DROP PROCEDURE [dbo].[encomendarProdutos] 
GO

create procedure [dbo].[encomendarProdutos] 
as
begin
	BEGIN Transaction
		insert into ProdutosEncomendados ( cod, codFornecedor, qtEncomenda, estado)
		select cod, codFornecedor, qtEncomenda, 1
		  from [dbo].viewProduto 
		 where qtStock < qtMinStock
		   and Estado = 0;

            -- se existiam produtos a encomendar, marca-os como encomendados
        if @@rowcount > 0 
            update [dbo].viewProduto set estado= 1
             where qtStock < qtMinStock
               and Estado = 0;
	Commit Transaction;

    return @@rowcount
END

GO

