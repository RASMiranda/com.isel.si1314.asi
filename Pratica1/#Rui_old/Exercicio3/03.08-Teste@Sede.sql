USE [ASI]
GO

delete from [dbo].[ocorrencias] 
delete from [MIRANDA-LAPTOP\SQL2012DEINST2].[ASI].[dbo].[ocorrencias]
delete from [MIRANDA-LAPTOP\SQL2012DEINST3].[ASI].[dbo].[ocorrencias]

delete from [ASI].[dbo].[produto]

delete from [dbo].[fornecedor]
delete from ProdutoCrianca
delete from ProdutoDesp
GO

SELECT 'fornecedor antes'
SELECT *
  FROM [dbo].[fornecedor]

SELECT 'ocorrencias antes'
SELECT *
  FROM [dbo].[ocorrencias]

SELECT 'produto antes'
SELECT *
  FROM [dbo].[produto]

SELECT 'ocorrencias criancas antes'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST2].[ASI].[dbo].[ocorrencias]

SELECT 'produto criancas antes'
SELECT *
  FROM [dbo].ProdutoCrianca

SELECT 'ocorrencias desp antes'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST3].[ASI].[dbo].[ocorrencias]

SELECT 'produto desp antes'
SELECT *
  FROM [dbo].ProdutoDesp
GO

INSERT INTO [dbo].[fornecedor]
           ([cod]
           ,[nome]
           ,[morada])
     VALUES
           (1
           ,'forn1'
           ,'morada1')
GO


DECLARE @RC int
DECLARE @cod int
DECLARE @codFornecedor int
DECLARE @qtEncomenda int
DECLARE @estado bit
DECLARE @tipo char(1)
DECLARE @preco money
DECLARE @qtMinStock int
DECLARE @qtStock int

SELECT 
   @cod = 2
  ,@codFornecedor = 1
  ,@qtEncomenda = 2
  ,@estado = 1
  ,@tipo = 'C'
  ,@preco = 2
  ,@qtMinStock = 2
  ,@qtStock = 2

EXECUTE @RC = [dbo].[insereProduto] 
   @cod
  ,@codFornecedor
  ,@qtEncomenda
  ,@estado
  ,@tipo
  ,@preco
  ,@qtMinStock
  ,@qtStock

SELECT 
   @cod = 3
  ,@codFornecedor = 1
  ,@qtEncomenda = 3
  ,@estado = 1
  ,@tipo = 'D'
  ,@preco = 3
  ,@qtMinStock = 3
  ,@qtStock = 3

EXECUTE @RC = [dbo].[insereProduto] 
   @cod
  ,@codFornecedor
  ,@qtEncomenda
  ,@estado
  ,@tipo
  ,@preco
  ,@qtMinStock
  ,@qtStock
GO


INSERT INTO [dbo].[ocorrencias]
           ([descricao]
           ,[codProd])
     VALUES
           ('TESTE P2P 2 crianca'
           ,2)
--INSERT INTO [dbo].[ocorrencias]
--           ([descricao]
--           ,[codProd])
--     VALUES
--           ('TESTE P2P 3 crianca'
--           ,3)
GO



SELECT 'fornecedor depois'
SELECT *
  FROM [dbo].[fornecedor]

SELECT 'ocorrencias depois'
SELECT *
  FROM [dbo].[ocorrencias]

SELECT 'produto depois'
SELECT *
  FROM [dbo].[produto]

SELECT 'ocorrencias criancas depois'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST2].[ASI].[dbo].[ocorrencias]

SELECT 'produto criancas depois'
SELECT *
  FROM [dbo].ProdutoCrianca

SELECT 'ocorrencias desp depois'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST3].[ASI].[dbo].[ocorrencias]

SELECT 'produto desp depois'
SELECT *
  FROM [dbo].ProdutoDesp
GO


SELECT 'ocorrencias depois'
SELECT *
  FROM [dbo].[ocorrencias]

SELECT 'ocorrencias criancas depois'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST2].[ASI].[dbo].[ocorrencias]

SELECT 'ocorrencias desp depois'
SELECT *
  FROM [MIRANDA-LAPTOP\SQL2012DEINST3].[ASI].[dbo].[ocorrencias]
GO