/***********************************************************
    Projeto ASIVeste, Lda
    DEETC -  ASI 2013/2014
    Grupo 5 (David Coelho, Frederico Ferreira, Rui Miranda)
    Descr.: Script para criação das tabelas nas diversas bases de dados
    Versão: 
        2014.01.25 Draft, apenas def das tabelas
*/

-- run @Sede

USE [master]
GO

if exists (select * from sys.databases where name = 'ASIVeste')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASIVeste'
	ALTER DATABASE ASIVeste SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [ASIVeste]
end


CREATE DATABASE [ASIVeste]
GO

USE [ASIVeste]
GO

--select 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name + '; -- ' + OBJECT_NAME(object_id) + ': fk @' + OBJECT_NAME(parent_object_id) + ' references ' + OBJECT_NAME(referenced_object_id) from sys.foreign_keys where referenced_object_id = OBJECT_ID ('[Fornecedor]','U') 

IF OBJECT_ID ('[Fornecedor]','U') IS NOT NULL
	DROP TABLE [dbo].[Fornecedor]
GO

CREATE TABLE [dbo].[Fornecedor] (
    [Codigo]	[INT] PRIMARY KEY,	-- ex-Id
	-- [Numero]    [INT] NOT NULL,         // se calhar devemos forçar que seja único; ja temos um identificador unico. pq ter 2?
    [Nome]      [VARCHAR](50),
    [Morada]    [VARCHAR](200)
)
GO


IF OBJECT_ID ('[Produto]','U') IS NOT NULL
	DROP TABLE [dbo].[Produto]
GO

CREATE TABLE [dbo].[Produto](
    [Codigo]        [INT] PRIMARY KEY,
    [Tipo]          [INT],				-- 0- Criança, 1-Senhora, 2- Homem, 3- Desportista
    [Designacao]    [VARCHAR](50),
    [Preco]         [DECIMAL](8,2),		-- 2 casas decimais
    [StockQtd]      [INT] NOT NULL,     -- replica cujo valor é decrementado via WCF nas vendas
    [StockMinimo]   [INT] NOT NULL, 
    [CodigoFornecedor]  [INT] REFERENCES [dbo].[fornecedor] ([Codigo])
)
GO

-- Adicionar um check constrait 0 < StockQtd ? a sede recebe multiplos pedidos de multiplas lojas; faz sentido 
ALTER TABLE [dbo].[Produto]
	ADD CONSTRAINT [chk_stockqtd_positivo] CHECK (0 <= [StockQtd])
GO



IF OBJECT_ID ('[Cliente]','U') IS NOT NULL
	DROP TABLE [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] ( -- replicação assincrona Loja >> Sede
    [Codigo] [INT] PRIMARY KEY,
    [Nome]   [VARCHAR](50),
    [Morada] [VARCHAR](200)
)
GO



IF OBJECT_ID ('[Venda]','U') IS NOT NULL
	DROP TABLE [dbo].[Venda]
GO

CREATE TABLE [dbo].[Venda] (
    [Codigo]		[INT] PRIMARY KEY,
    [CodigoCliente]	[INT], -- sem FK por causa da replicacao ser Assincrona
    [CodigoProduto]	[INT] REFERENCES Produto([Codigo]),   
    [qtd] 			[INT]
)
GO


IF OBJECT_ID ('[Expedicao_Venda]','U') IS NOT NULL
	DROP TABLE [dbo].[Expedicao_Venda]
GO

CREATE TABLE [dbo].[Expedicao_Venda]( -- simplificar: nao ha envios parciais de uma Encomenda
	[Codigo]            [INT] PRIMARY KEY,
	[CodigoVenda]       [INT] REFERENCES Venda( [Codigo] ),
	[Expedida]          [BIT] DEFAULT 0
)
GO



IF OBJECT_ID ('[Encomenda_Fornecedor]','U') IS NOT NULL
	DROP TABLE [dbo].[Encomenda_Fornecedor]
GO

CREATE TABLE [dbo].[Encomenda_Fornecedor] (
    [Codigo]		[INT] PRIMARY KEY,
    [CodigoProduto]	[INT] REFERENCES Produto( [Codigo] ), 
    [Estado]        [INT],                  -- 0 - espera Entrega da Encomenda, 3 -entregue
    [Qtd]           [INT] NOT NULL,
    [CodigoVenda]   [INT] NULL -- uma encomenda pode ser feita preventivamente por isso pode ser NULL
)
GO
