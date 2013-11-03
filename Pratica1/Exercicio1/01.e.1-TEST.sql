
USE [ASI]
GO

-- setup parameters for testing...

DECLARE @RC int
DECLARE @cod int
DECLARE @tipo char(1)


------------------------------------------------------------------------------------- [produtoAlteraTipo] --------------------

-- display number of prods before [produtoAlteraTipo]:
select 'before [produtoAlteraTipo]', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;

select 'Produto na instancia Criancas'
    union
    select cast(count(*) as varchar)  from ProdutoCrianca
order by 1 desc;

select 'Produto na instancia Desportistas'
    union
    select cast(count(*) as varchar)  from ProdutoDesp
order by 1 desc;


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

-- test real case 
select @cod = 12345, @tipo = 'D';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test real case', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;

select 'Produto na instancia Criancas'
    union
    select cast(count(*) as varchar)  from ProdutoCrianca
order by 1 desc;

select 'Produto na instancia Desportistas'
    union
    select cast(count(*) as varchar)  from ProdutoDesp
order by 1 desc;
    
    
-- test 2nd real case 
select @cod = 12346, @tipo = 'D';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after test 2nd real case', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;

-- undo 1st real test case 
select @cod = 12345, @tipo = 'C';
EXECUTE @RC = [dbo].[produtoAlteraTipo] @cod, @tipo

select 'after undo 1st real test case', null 
    union 
    select case tipo 
                when 'C' then 'Crianca' 
                when 'D' then 'desporto' 
            end, count(*) from dbo.viewProduto
    group by tipo;

select 'Produto na instancia Criancas'
    union
    select cast(count(*) as varchar)  from ProdutoCrianca
order by 1 desc;

select 'Produto na instancia Desportistas'
    union
    select cast(count(*) as varchar)  from ProdutoDesp
order by 1 desc;

GO