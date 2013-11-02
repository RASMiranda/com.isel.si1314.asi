use [ASI];
go
--TODO: Make it pretty?

select 'exercicio 2.b) Fusão do Centro de vendas de desporto no de crianças'

select '	>Produto de Desporto antes'
select '		>@CV produto '
select * from [dbo].[produto]
where cod=11112
go

select '	>venda de produto de Desporto @ CV Criancas'
update [dbo].[produto]
set qtStock=qtStock-1
where cod=11112--Tipo D (Desportivo)
go

select '	>Produto de Desporto depois'
select '		>@CV produto '
select * from [dbo].[produto]
where cod=11112
go