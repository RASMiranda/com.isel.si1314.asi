USE [ASIVeste]

declare 
	@currProdutoId int,
	@VendaId int,
	@VendaExpedida bit,
	@ExpedicaoId int,
	@EncomendaId int;

select @currProdutoId = min(id)+4 from Produto;


select 'Enc' n, x.* from Encomenda x;
-- select 'Exp' n, x.* from Expedicao x;
select * from Produto x inner join (select x.* from ProdutoCS x union select x.* from ProdutoHD x) y on x.Id = y.Id where x.id = @currProdutoId;
select 'Vnd' n, x.* from Venda x;


EXECUTE [dbo].[sp_realizarVenda] 
	@NomeCliente = '@NomeCliente', @MoradaCliente = '@MoradaCliente', @ProdutoId = @currProdutoId, @Qtd = 4,
	@VendaId = @VendaId OUTPUT,
	@VendaExpedida = @VendaExpedida OUTPUT,
--	@ExpedicaoId = @ExpedicaoId OUTPUT,
	@EncomendaId = @EncomendaId OUTPUT

select '========================================================================================================='
select 'Enc' n, x.* from Encomenda x;
-- select 'Exp' n, x.* from Expedicao x;
select * from Produto x inner join (select x.* from ProdutoCS x union select x.* from ProdutoHD x) y on x.Id = y.Id where x.id = @currProdutoId;
select 'Vnd' n, x.* from Venda x;
