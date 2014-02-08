USE [ASIVesteSede]
GO

DECLARE @RC int
DECLARE @Tipo int
DECLARE @Codigo nvarchar(max)
DECLARE @Designacao nvarchar(max)
DECLARE @StockQtd int
DECLARE @StockMinimo int
DECLARE @Preco real
DECLARE @FornecedorId int
DECLARE @ProdutoId int

EXECUTE @RC = [dbo].[sp_inserirProduto] 
   @Tipo = 0			,@Codigo = 'PIPO'			,@Designacao = 'Ze do Pipo'
  ,@StockQtd = 50		,@StockMinimo = 20			,@Preco = 5
  ,@FornecedorId = 1	,@ProdutoId = @ProdutoId


print @ProdutoId
