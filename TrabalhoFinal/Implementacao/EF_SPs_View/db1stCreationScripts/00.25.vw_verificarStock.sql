USE [ASIVeste]
GO

IF OBJECT_ID('vw_verificarStock') IS NOT NULL
	DROP VIEW [dbo].vw_verificarStock;
GO

CREATE VIEW vw_verificarStock AS
select
	p.Id Pid, p.FornecedorId Fid, cs.Designacao, cs.StockQtd, p.StockMinimo
from (Produto p inner join ProdutoCS cs on p.id = cs.id)
union
select
	p.Id Pid, p.FornecedorId Fid, hd.Designacao, hd.StockQtd, p.StockMinimo
from (Produto p inner join ProdutoHD hd on p.id = hd.id)
;