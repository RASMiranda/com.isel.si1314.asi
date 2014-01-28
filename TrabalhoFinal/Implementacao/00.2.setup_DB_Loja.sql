/***********************************************************
    Projeto ASIVeste, Lda
    DEETC -  ASI 2013/2014
    Grupo 5 (David Coelho, Frederico Ferreira, Rui Miranda)
    Descr.: Script para criação das tabelas nas diversas bases de dados
    Versão: 
        2014.01.25 Draft, apenas def das tabelas
*/
    
-- run @Lojas

--:setvar ClienteSeed 1

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

IF OBJECT_ID ('[Produto]','U') IS NOT NULL
	DROP TABLE [dbo].[Produto]
GO

CREATE TABLE [dbo].[Produto](
    [Codigo]        [INT] PRIMARY KEY,
    [Designacao]    [VARCHAR](50),	-- não é indicado mas parece relevante estar nas lojas
    [Preco]         [DECIMAL](8,2),	-- não é indicado mas parece relevante estar nas lojas
    [StockQtd]      [INT] NOT NULL  -- replica cujo valor é decrementado via WCF nas vendas
)
GO

-- Adicionar um check constrait 0 < StockQtd ? a sede recebe multiplos pedidos de multiplas lojas; faz sentido 
ALTER TABLE [dbo].[Produto]
	ADD CONSTRAINT [chk_stockqtd_positivo] CHECK (0 <= [StockQtd])
GO



IF OBJECT_ID ('[Cliente]','U') IS NOT NULL
	DROP TABLE [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] ( -- replicação assincrona
    [Codigo] [INT] IDENTITY($(ClienteSeed), 100) PRIMARY KEY, -- seed value varia em funcao da loja
    [Nome]   [VARCHAR](50),
    [Morada] [VARCHAR](200)
)
GO
