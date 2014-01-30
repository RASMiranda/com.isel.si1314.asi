declare 
	@currEncomendaId int

select @currEncomendaId = min(id) from Encomenda where Recebida = 0;


select 'Enc' n, x.* from Encomenda x;
select 'Exp' n, x.* from Expedicao x;
select * from Produto x inner join (select x.* from ProdutoCS x union select x.* from ProdutoHD x) y on x.Id = y.Id where x.id in (select distinct produtoid from Encomenda where Id = @currEncomendaId);
select 'Vnd' n, x.* from Venda x;


EXECUTE [dbo].[sp_receberEncomenda] @EncomendaId = @currEncomendaId;


select '========================================================================================================='
select 'Enc' n, x.* from Encomenda x;
select 'Exp' n, x.* from Expedicao x;
select * from Produto x inner join (select x.* from ProdutoCS x union select x.* from ProdutoHD x) y on x.Id = y.Id where x.id in (select distinct produtoid from Encomenda where Id = @currEncomendaId);
select 'Vnd' n, x.* from Venda x;
