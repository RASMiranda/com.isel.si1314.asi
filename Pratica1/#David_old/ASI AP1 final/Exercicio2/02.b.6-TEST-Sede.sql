USE [ASI]
GO


-- simular a venda de 10% do stock -------------------------------------------------------------------------------------------
select 'antes da venda de 10% do stock', p.* from viewProduto p;

update viewProduto 
	set qtStock = floor(qtStock * 0.9)
;

select 'depois da venda de 10% do stock', p.* from viewProduto p;
USE [ASI]
GO

-- setup parameters for testing...

DECLARE @RC int
DECLARE @cod int
DECLARE @codFornecedor int
DECLARE @qtEncomenda int
DECLARE @estado bit
DECLARE @tipo char(1)
DECLARE @preco money
DECLARE @qtMinStock int
DECLARE @qtStock int

---------------------------------------------------------------------------------------- [insereProduto] --------------------- 
-- display number of prods before [insereProduto]:
select 'before [insereProduto]', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCV
select * from viewproduto order by tipo desc, codFornecedor

select
	@cod = 89898,		@codFornecedor = 3,	@qtEncomenda = 12,	@estado = 0,
	@tipo = 'C',		@preco = 74,		@qtMinStock = 6,	@qtStock = 8;

EXECUTE @RC = [dbo].[insereProduto] @cod, @codFornecedor, @qtEncomenda,	@estado, @tipo, @preco, @qtMinStock, @qtStock

select
	@cod = 90909,		@codFornecedor = 3,	@qtEncomenda = 12,	@estado = 0,
	@tipo = 'D',		@preco = 77,		@qtMinStock = 10,	@qtStock = 8;

EXECUTE @RC = [dbo].[insereProduto] @cod, @codFornecedor, @qtEncomenda,	@estado, @tipo, @preco, @qtMinStock, @qtStock

-- display number of prods after [insereProduto]:
select 'after [insereProduto]', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCV
select * from viewproduto order by tipo desc, codFornecedor


------------------------------------------------------------------------------------- [produtoAlteraTipo] --------------------

-- display number of prods before [produtoAlteraTipo]:
select 'before [produtoAlteraTipo]', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;
	
-- test redundant case 
select @cod = 12345, @tipo = 'C';

EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test redundant case', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;

GO
