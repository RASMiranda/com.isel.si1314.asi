
USE [ASI]
GO


-- simular a venda de 40% do stock -------------------------------------------------------------------------------------------
select 'antes da venda de 40% do stock', p.* from viewProduto p;

update viewProduto 
	set qtStock = floor(qtStock * 0.60)
;

select 'depois da venda de 40% do stock', p.* from viewProduto p;