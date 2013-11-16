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
/*
    cria Encomenda para todos os produtos abaixo do stock minimo e sem encomenda colocada
        A transacao é toda local à sede, as lojas participam apenas em query
*/


create procedure [dbo].produtoAlteraTipo 
	@codProd			[int],
	@tipo			[char](1)
as
begin
	DECLARE @oldtipo [char](1)
	
	SELECT @oldtipo = tipo
	  FROM [dbo].[produto]
	 WHERE codProd =@codProd
       and tipo <> @tipo;

	IF @@rowcount > 0
		begin
        Begin transaction
            if @oldtipo = 'c'
                begin
                    insert into [dbo].ProdutoDesporto (codProd, preco, qtStock, qtMinStock)
                        select new.codProd, new.preco, new.qtStock, new.qtMinStock
                          from [dbo].ProdutoCrianca new
                         where new.codProd = @codProd;

                    delete [dbo].ProdutoCrianca
                      where codProd = @codProd;
                end
            if @oldtipo = 'd'
                begin
                    insert into [dbo].ProdutoCrianca (codProd, preco, qtStock, qtMinStock)
                        select new.codProd, new.preco, new.qtStock, new.qtMinStock
                          from [dbo].ProdutoDesporto new
                         where new.codProd = @codProd;

                    delete [dbo].ProdutoDesporto
                      where codProd = @codProd;
                end
            update [dbo].Produto
               set tipo = @tipo 
             where codProd = @codProd;
         commit transaction
     end

    return @@rowcount
end
