/***********************************************************
    Projeto ASIVeste, Lda
    DEETC -  ASI 2013/2014
    Grupo 5 (David Coelho, Frederico Ferreira, Rui Miranda)
    Descr.: Script para criação das tabelas nas diversas bases de dados
    Versão: 
        2014.01.25 Draft, apenas def das tabelas
*/
    
    
USE [ASIVESTE]
GO 


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Fornecedor](
    [Id]        [INT] PRIMARY KEY,
    [Numero]    [INT] NOT NULL,         // se calhar devemos forçar que seja único
    [Nome]      [VARCHAR](50),
    [Morada]    [VARCHAR](200)
)
GO
   
CREATE TABLE [dbo].[Produto](
    [Id]            [INT] PRIMARY KEY,
    [Codigo]        [VARCHAR](15),      // Temos de Garantir que é unico
    [Tipo]          [INT],              // 0- Criança, 1-Senhora, 2- Homem, 3- Desportista
    [Designacao]    [VARCHAR](50),
    [Preco]         [DECIMAL](8,2),          // 2 casas decimais
    [StockQtd]      [INT] NOT NULL,     
    [StockMinimo]   [INT] NOT NULL, 
    [FornecedorId]  [INT] REFERENCES Fornecedor([Id])
)
GO

CREATE TABLE [dbo].[Venda](
    [Id]            [INT] PRIMARY KEY,
    [NomeCliente]   [VARCHAR](50),
    [MoradaCliente] [VARCHAR](200),
    [Estado]        [INT]               //0 - pendente, 1- (espera) encomenda, 3 -entregue
)
GO

CREATE TABLE [dbo].[VendaProdutos](
    [Id]        [INT] PRIMARY KEY,
    [VendaId]   [INT] REFERENCES Venda([Id]),
    [ProdutoId] [INT] REFERENCES Produto([Id]),
    [Estado]    [INT],                  //0 - pendente, 1- (espera) encomenda, 3 -entregue
    [Qtd]       [INT] NOT NULL
)
GO

CREATE TABLE [dbo].[Encomenda](
    [Id]            [INT] PRIMARY KEY,
    [ProdutoId]     [INT] REFERENCES Produto([Id]),
    [Estado]        [INT],                  //0 - (espera Entrega da) encomenda, 3 -entregue
    [Qtd]           [INT] NOT NULL,
    [VendaId]       [INT] REFERENCES Venda([Id])
)
GO

CREATE TABLE [dbo].[Expedicao](
    [Id]            [INT] PRIMARY KEY,
    [VendaId]       [INT] REFERENCES Venda([Id]),
    [VendaProdutoId][INT] REFERENCES Produto([Id]),   // para permitir envios parciais de uma Encomenda
    [Qtd]           [INT]
)
GO


/* TABELAS PARA CADA SERVIDOR DE REDE DE LOJAS */   
USE [ASIVESTE]
GO 


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Produto](
    [Id]            [INT] PRIMARY KEY,
    [Codigo]        [VARCHAR](15),
    [Designacao]    [VARCHAR](50),      //não é indicado mas parece relevante estar nas lojas
    [Preco]         [DECIMAL](8,2),          //não é indicado mas parece relevante estar nas lojas
    [StockQtd]      [INT] NOT NULL
)
GO

/* 
NOTAS:
    assumindo que podemos usar filas de mensagens não é necessário registar 
    as Vendas na loja, logo essa tabela não precisa de aí existir 
*/