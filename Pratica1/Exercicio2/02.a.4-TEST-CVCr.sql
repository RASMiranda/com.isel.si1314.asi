use [ASI];
go
--TODO: Make it pretty?

select 'exercicio 2.a) Centro de Vendas Criancas efectua vendas de produtos de Desporto'

select '	>Produto de Desporto antes'
select '		>@CV Criancas global View'
select * from [viewProduto]
where cod=11112
select '		>@CV produto crianca'
select * from [dbo].[produto]
where cod=11112
select '		>@CV produto Desporto'
select * from [dbo].[ProdutoDespTemp]
where cod=11112
go

select '	>venda de produto de Desporto @ CV Criancas'
update [dbo].[viewProduto]
set qtStock=qtStock-1
where cod=11112--Tipo D (Desportivo)
go

select '	>Produto de Desporto depois'
select '		>@CV Criancas global View'
select * from [viewProduto]
where cod=11112
select '		>@CV produto crianca'
select * from [dbo].[produto]
where cod=11112
select '		>@CV produto Desporto'
select * from [dbo].[ProdutoDespTemp]
where cod=11112
go