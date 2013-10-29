
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

GO