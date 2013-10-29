
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
select 'before [insereProduto]', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;
select * from viewproduto order by tipo desc, codFornecedor

select
	@cod = 12345,		@codFornecedor = 3,	@qtEncomenda = 12,	@estado = 0,
	@tipo = 'C',		@preco = 74,		@qtMinStock = 6,	@qtStock = 8;

EXECUTE @RC = [dbo].[insereProduto] @cod, @codFornecedor, @qtEncomenda,	@estado, @tipo, @preco, @qtMinStock, @qtStock

select
	@cod = 12346,		@codFornecedor = 3,	@qtEncomenda = 12,	@estado = 0,
	@tipo = 'C',		@preco = 77,		@qtMinStock = 10,	@qtStock = 8;

EXECUTE @RC = [dbo].[insereProduto] @cod, @codFornecedor, @qtEncomenda,	@estado, @tipo, @preco, @qtMinStock, @qtStock

-- display number of prods after [insereProduto]:
select 'after [insereProduto]', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;
select * from viewproduto order by tipo desc, codFornecedor

GO