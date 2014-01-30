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
    [Id]        [INT] IDENTITY PRIMARY KEY,
    [Nome]      [VARCHAR](50),
    [Morada]    [VARCHAR](200)
)
GO


IF OBJECT_ID ('[Produto]','U') IS NOT NULL
	DROP TABLE [dbo].[Produto]
GO

CREATE TABLE [dbo].[Produto](
    [Id]			[INT] IDENTITY PRIMARY KEY,
    [Tipo]          [INT],				-- 0- Criança, 1-Senhora, 2- Homem, 3- Desportista
    [StockMinimo]   [INT] NOT NULL, 
    [FornecedorId]  [INT] NOT NULL REFERENCES [dbo].[fornecedor] ( [Id] )
)
GO


IF OBJECT_ID ('[ProdutoCS]','U') IS NOT NULL
	DROP TABLE [dbo].[ProdutoCS]
GO

CREATE TABLE [dbo].[ProdutoCS](
	[Id]			[INT] PRIMARY KEY REFERENCES [dbo].[Produto] ( [Id] ),
    [Designacao]    [VARCHAR](50),
    [Preco]         [DECIMAL](8,2),		-- 2 casas decimais
    [StockQtd]      [INT] NOT NULL,     -- replica cujo valor é decrementado via WCF nas vendas
)
GO

-- Adicionar um check constrait 0 < StockQtd ? a sede recebe multiplos pedidos de multiplas lojas; faz sentido 
/* ALTER TABLE [dbo].[ProdutoCS]
	ADD CONSTRAINT [chk_stockqtd_positivo_cs] CHECK (0 <= [StockQtd])
GO */


IF OBJECT_ID ('[ProdutoHD]','U') IS NOT NULL
	DROP TABLE [dbo].[ProdutoHD]
GO

CREATE TABLE [dbo].[ProdutoHD](
	[Id]			[INT] PRIMARY KEY REFERENCES [dbo].[Produto] ( [Id] ),
    [Designacao]    [VARCHAR](50),
    [Preco]         [DECIMAL](8,2),		-- 2 casas decimais
    [StockQtd]      [INT] NOT NULL,     -- replica cujo valor é decrementado via WCF nas vendas
)
GO

-- Adicionar um check constrait 0 < StockQtd ? a sede recebe multiplos pedidos de multiplas lojas; faz sentido 
ALTER TABLE [dbo].[ProdutoHD]
	ADD CONSTRAINT [chk_stockqtd_positivo_hd] CHECK (0 <= [StockQtd])
GO


/*
IF OBJECT_ID ('[Cliente]','U') IS NOT NULL
	DROP TABLE [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] ( -- replicação assincrona Loja >> Sede
    [Id]     [INT] PRIMARY KEY,
    [Nome]   [VARCHAR](50),
    [Morada] [VARCHAR](200)
)
GO
*/


IF OBJECT_ID ('[Venda]','U') IS NOT NULL
	DROP TABLE [dbo].[Venda]
GO

CREATE TABLE [dbo].[Venda] (
    [Id]			[INT] IDENTITY PRIMARY KEY,
    [NomeCliente]	[VARCHAR](30),
    [MoradaCliente]	[VARCHAR](30),
    [ProdutoId]		[INT] NOT NULL REFERENCES Produto( [Id] ),
    [Qtd] 			[INT]
)
GO


IF OBJECT_ID ('[Expedicao]','U') IS NOT NULL
	DROP TABLE [dbo].[Expedicao]
GO

CREATE TABLE [dbo].[Expedicao]( -- simplificar: nao ha envios parciais de uma Encomenda
	[Id]			[INT] IDENTITY PRIMARY KEY,
	[VendaId]		[INT] NOT NULL REFERENCES Venda( [Id] ),
	[Expedida]		[BIT] DEFAULT 0  -- 0 - produto Vendido aguarda Expedicao, 1 - Expedido
)
GO



IF OBJECT_ID ('[Encomenda]','U') IS NOT NULL
	DROP TABLE [dbo].[Encomenda]
GO

CREATE TABLE [dbo].[Encomenda] (
    [Id]		[INT] IDENTITY PRIMARY KEY,
    [ProdutoId]	[INT] REFERENCES Produto( [Id] ), 
    [Recebida]	[BIT] DEFAULT 0,            -- 0 - espera recepcao da Encomenda, 1 - recebida
    [Qtd]		[INT] NOT NULL,
    [VendaId]	[INT] NULL -- uma encomenda pode ser feita preventivamente por isso pode ser NULL
)
GO
