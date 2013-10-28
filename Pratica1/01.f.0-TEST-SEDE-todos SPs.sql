

USE [ASI]
GO

-- setup data for testing...

truncate table Produto;
delete from Fornecedor; -- Cannot truncate table 'Fornecedor' because it is being referenced by a FOREIGN KEY constraint.
delete from ProdutoCrianca; -- Could not truncate object 'ProdutoCrianca' because it is not a table.
delete from ProdutoDesp;


INSERT INTO [dbo].[fornecedor] ([cod], [nome], [morada])
select 1, 'Fornecedor#1', 'MoradaForn#1' union
select 2, 'Fornecedor#2', 'MoradaForn#2' union
select 3, 'Fornecedor#3', 'MoradaForn#3' ;



insert into Produto (codFornecedor, cod, qtEncomenda, estado, tipo)
select 1, 11112, 2*15, 0, 'D' union
select 1, 33333, 2*14, 0, 'D' union
select 1, 55554, 2*13, 0, 'D' union
select 1, 77775, 2*15, 0, 'D' union
select 2, 93136, 2*14, 0, 'D' union
select 2, 95157, 2*13, 0, 'D' union
select 2, 22222, 2*5, 0, 'C' union
select 2, 44443, 2*4, 0, 'C' union
select 3, 66664, 2*3, 0, 'C' union
select 3, 88885, 2*5, 0, 'C' union
select 3, 90106, 2*4, 0, 'C' union
select 3, 92127, 2*3, 0, 'C';

insert into produtoDesp (cod,	preco,	qtStock,	qtMinStock)
select 11112, €1127.50, 20, 15 union
select 33333, €1117.40, 21, 14 union
select 55554, €1237.30, 22, 13 union
select 77775, €1047.20, 23, 15 union
select 93136, €1125.10, 24, 14 union
select 95157, €1320.00, 25, 13;

insert into ProdutoCrianca (cod,	preco,	qtStock,	qtMinStock)
select 22222,  €127.50, 10,  5 union
select 44443,  €117.40, 11,  4 union
select 66664,  €237.30, 12,  3 union
select 88885,  €047.20, 13,  5 union
select 90106,  €125.10, 14,  4 union
select 92127,  €320.00, 15,  3;

select 'Produto', count(cod) from Produto union
select 'ProdutoCrianca', count(cod) from ProdutoCrianca union
select 'ProdutoDesp', count(cod) from ProdutoDesp;

select * from Produto;
select * from ProdutoCrianca;
select * from ProdutoDesp;


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

----------------------------------------------------------------------- [produtosQueDevemSerEncomendados] --------------------

-- determinar que produtos precisam ser encomendados:
select 'test [produtosQueDevemSerEncomendados]:'
EXECUTE @RC = [dbo].[produtosQueDevemSerEncomendados] 


---------------------------------------------------------------------- [produtosEfectivamenteEncomendados] -------------------

-- indicar ao sistema que os produtos foram efectivamente encomendados:
select 'test [produtosEfectivamenteEncomendados]:'
EXECUTE @RC = [dbo].[produtosEfectivamenteEncomendados] 

---------------------------------------------------------------------- [produtosEncomendadosForamRecebidos] ------------------

select 'antes de produtosEncomendadosForamRecebidos', p.* from viewProduto p where estado = 1;

-- indicar ao sistema que os produtos encomendados foram recebidos dos fornecedores
EXECUTE @RC = [dbo].produtosEncomendadosForamRecebidos

select 'depois de produtosEncomendadosForamRecebidos', p.* from viewProduto p where cod = 12346;

-- simular a venda de 40% do stock -------------------------------------------------------------------------------------------

update viewProduto 
	set qtStock = floor(qtStock * 0.60)
;

select 'depois da venda de 40% do stock', p.* from viewProduto p;

----------------------------------------------------------------------- [produtosQueDevemSerEncomendados] --------------------

-- determinar que produtos precisam ser encomendados:
select 'test [produtosQueDevemSerEncomendados]:'
EXECUTE @RC = [dbo].[produtosQueDevemSerEncomendados] 

---------------------------------------------------------------------- [produtosEfectivamenteEncomendados] -------------------

-- indicar ao sistema que os produtos foram efectivamente encomendados:
select 'test [produtosEfectivamenteEncomendados]:'
EXECUTE @RC = [dbo].[produtosEfectivamenteEncomendados] 

---------------------------------------------------------------------- [produtoEncomendadoFoiRecebido] -----------------------

select 'antes de produtoEncomendadoFoiRecebido (em excesso)', p.* from viewProduto p where cod = 12345;

-- indicar ao sistema que um dos produtos encomendados foi recebido do fornecedor:
select
	@cod = 12345, @qtEncomenda = 20;

EXECUTE @RC = [dbo].[produtoEncomendadoFoiRecebido] @cod, @qtEncomenda

select 'depois de produtoEncomendadoFoiRecebido (em excesso)', p.* from viewProduto p where cod = 12345;

---------------------------------------------------------------------- [produtosEncomendadosForamRecebidos] ------------------

select 'antes de produtosEncomendadosForamRecebidos', p.* from viewProduto p where estado = 1;

-- indicar ao sistema que os produtos encomendados foram recebidos dos fornecedores
EXECUTE @RC = [dbo].produtosEncomendadosForamRecebidos

select 'depois de produtosEncomendadosForamRecebidos', p.* from viewProduto p where p.cod in (11112, 33333, 77775);

----------------------------------------------------------------------- [produtosQueDevemSerEncomendados] --------------------

-- determinar que produtos precisam ser encomendados:
select 'test [produtosQueDevemSerEncomendados]:'
EXECUTE @RC = [dbo].[produtosQueDevemSerEncomendados] 

