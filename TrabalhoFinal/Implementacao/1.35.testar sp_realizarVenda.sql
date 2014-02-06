USE [ASIVesteSede]

EXECUTE [dbo].[sp_realizarVenda] 
	@NomeCliente = '@NomeCliente',	@MoradaCliente = '@MoradaCliente', 
	@CodigoProduto = 'SC002',		@Qtd = 4
;

select 'Enc' n, x.* from Encomenda x;
select 'Prod' n, x.* from Produto x where codigo = 'SC002';
--select 'PrSC' n, x.* from ProdutoSC x where codigo = 'SC002';
--select 'PrHD' n, x.* from ProdutoHD x where codigo = 'SC002';
select 'Vnd' n, x.* from Venda x;
select 'VndPrd' n, x.* from VendaProdutos x;


/*
delete from Encomenda;
delete from VendaProdutos;
delete from Venda;
update Produto set StockQtd = 10 where Codigo = 'SC002';
update ProdutoHD set StockQtd = 2 where Codigo = 'SC002';
update ProdutoSC set StockQtd = 2 where Codigo = 'SC002';
*/

