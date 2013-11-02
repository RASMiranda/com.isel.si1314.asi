USE [ASI]
GO


-- simular a venda de 10% do stock -------------------------------------------------------------------------------------------
select 'antes da venda de 10% do stock', p.* from viewProduto p;

update viewProduto 
	set qtStock = floor(qtStock * 0.9)
;

select 'depois da venda de 10% do stock', p.* from viewProduto p;