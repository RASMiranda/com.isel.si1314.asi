select 'Enc' n, x.* from Encomenda x;
select 'Prod' n, x.* from Produto x where codigo = 'SC002';
select 'PrSC' n, x.* from ProdutoSC x where codigo = 'SC002';
select 'PrHD' n, x.* from ProdutoHD x where codigo = 'SC002';
select 'Vnd' n, x.* from Venda x;
select 'VndPrd' n, x.* from VendaProdutos x;

EXECUTE [dbo].[sp_receberEncomenda] 13

select 'Enc' n, x.* from Encomenda x;
select 'Prod' n, x.* from Produto x where codigo = 'SC002';
select 'PrSC' n, x.* from ProdutoSC x where codigo = 'SC002';
select 'PrHD' n, x.* from ProdutoHD x where codigo = 'SC002';
select 'Vnd' n, x.* from Venda x;
select 'VndPrd' n, x.* from VendaProdutos x;
/*
update ProdutoSC set stockqtd = 2 where codigo = 'SC002';
update ProdutoHD set stockqtd = 2 where codigo = 'SC002';
*/