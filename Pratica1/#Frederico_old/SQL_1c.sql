/*
*	ISEL-ADEETC-MEIC
*	ASI - 2013/2014
*	Desc: Pratica 1
*       E1_c) Procedimentos de Encomendar e Receber Produtos.
*             Inclui a criação de uma tabela com os produtos encomendados, que é usada na receção dos produtos
*             Nesta versao optamos por manter o registo de todas as encomendas (abertas e fechadas segundo Estado)
*             e incluir campo de datetime. 
*             O delete de um produto terá de actuar tambem nos produtos encomendados
*/




/*
    cria tabela para registo de encomendas
*/

USE [ASI]

create table [dbo].ProdutosEncomendados
(
	codEnc int primary key identity,
    codProd int REFERENCES [dbo].produto.codProd,
    codForn int REFERENCES [dbo].fornecedor.codProd,
    diaHora     datetime default CURRENT_TIMESTAMP, 
    estado      bit NOT NULL,
    qtEncomenda int NOT NULL
)
go

/*
    cria Encomenda para todos os produtos abaixo do stock minimo e sem encomenda colocada
        A transacao é toda local à sede, as lojas participam apenas em query
*/


create procedure [dbo].[encomendarProduto] 
as
begin
	BEGIN Transaction
		insert into ProdutosEncomendados ( codProd, codForn, qtEncomenda, estado)
		select codProd, codForn, qtEncomenda, 1
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


create procedure [dbo].[receberProduto] 
	@codProd		[int],
	@qtEncomenda	[int]
as
    declare @encomendaId int

begin
		-- se existe uma encomenda aberta para este produto nesta quantidade
		-- recebe o produto marcando que ja nao tem encomenda pendente e ajusta o stock actual
    
	BEGIN Transaction

		select @encomendaId = codEnc from [dbo].ProdutosEncomendados
						where codProd = @codProd 
							and qtEncomenda = @qtEncomenda
							and estado = 1;
		if @encomendaId >=0
				update [dbo].viewProduto
					set qtStock = qtStock + @qtEncomenda, estado = 0
				where codProd = @codProd;
            
				update [dbo].ProdutosEncomendados
					set estado = 0
					where codEnc = @encomendaId;

	Commit Transaction;
			-- retorna 1 se deu rececao do produto
       
	return @@rowcount

END
