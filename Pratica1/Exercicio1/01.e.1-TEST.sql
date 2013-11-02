
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


------------------------------------------------------------------------------------- [produtoAlteraTipo] --------------------

-- display number of prods before [produtoAlteraTipo]:
select 'before [produtoAlteraTipo]', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;

-- test redundant case 
select @cod = 12345, @tipo = 'C';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test redundant case', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;

-- test real case 
select @cod = 12345, @tipo = 'D';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test real case', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;

-- test 2nd real case 
select @cod = 12346, @tipo = 'D';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test 2nd real case', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;

-- undo 1st real test case 
select @cod = 12345, @tipo = 'C';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after undo 1st real test case', null union select 'Produto', count(cod) from Produto union select 'ProdutoCrianca', count(cod) from ProdutoCrianca union select 'ProdutoDesp', count(cod) from ProdutoDesp;

GO