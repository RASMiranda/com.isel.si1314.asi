use [ASI]
go

--TODO: Comment stvar in batch/SSMS: Activate Query>SQLCMD Mode
--:setvar CVCr MIRANDA-LAPTOP\SQL2012DEINST2

insert into [produtoCrianca] 
	(cod, preco, qtStock, qtMinStock)
select 
	cod, preco, qtStock, qtMinStock 
from [produtoDesp];

delete from produtoDesp;

drop synonym ProdutoCrianca;
drop synonym ProdutoDesp;

CREATE SYNONYM [dbo].[ProdutoCV] FOR [$(CVCr)].[ASI].[dbo].[Produto]
GO
