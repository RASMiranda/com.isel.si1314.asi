
USE [ASI]
GO

-- setup parameters for testing...

DECLARE @RC int
DECLARE @cod int
DECLARE @qtEncomenda int

----------------------------------------------------------------------- [encomendarProdutos] --------------------

update [dbo].viewProduto set qtStock = qtMinStock -1, estado = 0
where cod in (11112, 12345)


-- determinar que produtos precisam ser encomendados:
select 'test [encomendarProdutos]:'
EXECUTE @RC = [dbo].[encomendarProdutos] 

-- verifica se criou a encomenda:
select 'test [ProdutosEncomendados]:'

select p.cod, e.qtEncomenda, e.diaHora, f.nome, p.qtStock, p.qtMinStock 
  from [dbo].[ProdutosEncomendados] e, [dbo].ViewProduto p, [dbo].[fornecedor] f
 where e.cod= p.cod
   and e.codFornecedor = f.cod
   and e.estado= 1
   

 
 
select TOP 1  @cod = cod, @qtEncomenda = qtEncomenda
  from [dbo].[ProdutosEncomendados]
 where estado = 1
 

 
 EXECUTE @RC= [dbo].[receberProduto] @cod, @qtEncomenda
  
select 'test [receberProduto]:'

select p.cod, e.qtEncomenda, e.diaHora, f.nome, p.qtStock, p.qtMinStock 
  from [dbo].[ProdutosEncomendados] e, [dbo].ViewProduto p, [dbo].[fornecedor] f
 where e.cod= p.cod
   and e.codFornecedor = f.cod
   and e.estado= 0 
   
GO
 