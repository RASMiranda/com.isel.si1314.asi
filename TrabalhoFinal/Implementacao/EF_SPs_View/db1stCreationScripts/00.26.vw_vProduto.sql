USE [ASIVeste]
GO

IF OBJECT_ID('vw_vProduto') IS NOT NULL
	DROP VIEW [dbo].vw_vProduto;
GO

CREATE VIEW vw_vProduto AS
select
	p.Id, p.Tipo, c.Designacao, c.Preco, c.StockQtd, p.StockMinimo, p.FornecedorId
from Produto p inner join ProdutoCS c on p.id = c.id
union
select
	p.Id, p.Tipo, h.Designacao, h.Preco, h.StockQtd, p.StockMinimo, p.FornecedorId 
from Produto p inner join ProdutoHD h on p.id = h.id
;
