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

CREATE TABLE [dbo].[fornecedor](
    [Id]        [INT] PRIMARY KEY,
    [Numero]    [INT] NOT NULL,         // se calhar devemos forçar que seja único
    [Nome]      [VARCHAR](50),
    [Morada]    [VARCHAR](200)
)
   
CREATE TABLE [dbo].[produto](
    [Id]            [INT] PRIMARY KEY,
    [Codigo]        [VARCHAR](15),      // se calhar forçar que seja unico
    [Tipo]          [INT],              // 0- Criança, 1-Senhora, 2- Homem, 3- Desportista
    [Designacao]    [VARCHAR](50),
    [Preco]         [DECIMAL],          // 2 casas decimais
    [StockQtd]      [INT] NOT NULL,     
    [StockMinimo]   [INT] NOT NULL, 
    [FornecedorId]  [INT] REFERENCES fornecedor
)

CREATE TABLE [dbo].[venda](
    [Id]            [INT] PRIMARY KEY,
    [NomeCliente]   [VARCHAR](50),
    [MoradaCliente] [VARCHAR](200),
    [Estado]        [INT]               //0 - pendente, 1- espera encomenda, 3 -entregue
)

CREATE TABLE [dbo].[vendaProdutos](
    [Id]        [INT] PRIMARY KEY,
    [VendaId]   [INT] RERENCES venda,
    [ProdutoId] [INT] REFERENCES produto,
    [Estado]    [INT],                  //0 - pendente, 1- espera encomenda, 3 -entregue
    [Qtd]       [INT] NOT NULL
)

CREATE TABLE [dbo].[encomenda](
    [Id]            [INT] PRIMARY KEY,
    [FormecedorId]  [INT] REFERENCES fornecedor,
    [Qtd]           [INT] NOT NULL,
    [VendaId]       [INT] REFERENCES venda
)

CREATE TABLE [dbo].[expedicao](
    [Id]            [INT] PRIMARY KEY,
    [VendaId]       [INT] REFERENCES venda,
    [VendaProdutoId][INT] REFERENCES produto,   // para permitir envios parciais de uma encomenda
    [Qtd]           [INT]
)


/* TABELAS PARA CADA SERVIDOR DE REDE DE LOJAS */

CREATE TABLE [dbo].[produto](
    [Id]            [INT] PRIMARY KEY,
    [Codigo]        [VARCHAR](15),
    [Designacao]    [VARCHAR](50),      //não é indicado mas parece relevante estar nas lojas
    [Preco]         [DECIMAL],          //não é indicado mas parece relevante estar nas lojas
    [StockQtd]      [INT] NOT NULL
)

/* 
NOTAS:
    assumindo que podemos usar filas de mensagens não é necessário registar 
    as vendas na loja, logo essa tabela não precisa de aí existir 
*/