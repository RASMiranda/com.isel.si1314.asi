/*
*	ISEL-ADEETC-MEIC
*	ASI - 2013/2014
*	Desc: Pratica 1
*       Excercicio 1 test
*/

:setvar serverSEDE "FFSS"
:setvar serverCVVC "FFSS\ISELALFA"
:setvar serverCVVD "FFSS\ISELBETA"
:setvar criarBD "sim"

RAISERROR('Exercicio 1.A: criacao Modelo Global e Modelos Locais das Lojas ...',0,1); --info
:!!PAUSE 


    -- vai recriar a base de dados de suporte?
if $(criarBD)  = 'sim'
    BEGIN
        :connect $(serverSEDE)
        USE [master];
        IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'ASI')
            BEGIN
                ALTER DATABASE [ASI] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                DROP DATABASE [ASI];
                CREATE DATABASE [ASI];
                -- chamar script SQL_SEDE_1a.sql
                
            END
        :connect $(serverCVVC)
        USE [master];
        IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'ASI')
            BEGIN
                ALTER DATABASE [ASI] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                DROP DATABASE [ASI];
                CREATE DATABASE [ASI];
                -- chamar script SQL_CVVC_1a.sql
                
        :connect $(serverCVVD)
        USE [master];
        IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'ASI')
            BEGIN
                ALTER DATABASE [ASI] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                DROP DATABASE [ASI];
                CREATE DATABASE [ASI];
                -- chamar script SQL_CVVD_1a.sql
    END
GO

if $(criarBD)  = 'sim'
    BEGIN
        r: SQL_1a.sql
        
    END
GO

-- Vai iniciar os testes
:connect $(serverSEDE)
use [ASI]
GO

 
-- :r SQL_1a.sql
RAISERROR('Exercicio 1.a)e b) -- TESTES',0,1); --info
:!!PAUSE 
    -- fornecedores
insert into [dbo].fornecedor ( codForn, nome, morada) values ( 10, 'Fornecedor 11', 'Rua A, Porto')
insert into [dbo].fornecedor ( codForn, nome, morada) values ( 11, 'Fornecedor 12', 'Rua B, Alverca')

RAISERROR('     insere Produtos: 3 Crianca + 4 Desportista',0,1); --info
:!!PAUSE 

    -- codProd, codForn, qtEncomenda, estado, tipo, preco, qtStock, qtMinStock
exec	[dbo].insertProduto   10, 10,  5, 0, 'c',    25,      5,     6
exec	[dbo].insertProduto   11, 10, 10, 0, 'd',    50,     10,     7
exec	[dbo].insertProduto   12, 11,  5, 0, 'c',    35,      5,     2
exec	[dbo].insertProduto   13, 11, 10, 0, 'd',    60,     10,     2
exec	[dbo].insertProduto   14, 10, 10, 0, 'd',    70,     10,     2 
exec	[dbo].insertProduto   15, 10, 10, 0, 'c',    45,     10,     2 
exec	[dbo].insertProduto   16, 10, 10, 0, 'd',    80,     10,     2 

select * from [dbo].ViewProduto;
select * from [dbo].ProdutoCrianca;
select * from [dbo].ProdutoDesportista;

RAISERROR('     apaga Produtos: 1 Crianca + 1 Desportista',0,1); --info
:!!PAUSE 

    -- codProd, codForn, qtEncomenda, estado, tipo, preco, qtStock, qtMinStock
exec	[dbo].deleteProduto   15
exec	[dbo].deleteProduto   16

select * from [dbo].ViewProduto;
select * from [dbo].ProdutoCrianca;
select * from [dbo].ProdutoDesportista;

RAISERROR('     altera Produtos: 1 Crianca + 1 Desportista',0,1); --info
:!!PAUSE 

    -- codProd, codForn, qtEncomenda, estado, tipo, preco, qtStock, qtMinStock
update [dbo].viewProduto set qtEncomenda = 7, qtStock = qtstock -1
where codProd = 10

update [dbo].viewProduto set fornecedor = 11, preco = preco +1
where codProd = 11

select * from [dbo].ViewProduto;
select * from [dbo].ProdutoCrianca;
select * from [dbo].ProdutoDesportista;

RAISERROR('Exercicio 1.c), d) e e) -- TESTES',0,1); --info
if $(criarBD)  = 'sim'
    BEGIN
        r: SQL_1c.sql
        
    END
GO

RAISERROR('     Processa encomendas',0,1); --info
:!!PAUSE 

exec [dbo].encomendarProduto
select * from [dbo].ViewProduto;
select * from [dbo].ProdutosEncomendados

RAISERROR('     Processa recebimento de encomenda quantidade errada',0,1); --info
:!!PAUSE 
exec [dbo].receberProduto 13, 11
select * from [dbo].ViewProduto;
select * from [dbo].ProdutosEncomendados

RAISERROR('     Processa recebimento de encomenda quantidade correcta',0,1); --info
:!!PAUSE 
exec [dbo].receberProduto 13, 10
select * from [dbo].ViewProduto;
select * from [dbo].ProdutosEncomendados

RAISERROR('     Altera o tipo de Produto',0,1); --info
:!!PAUSE 
if $(criarBD)  = 'sim'
    BEGIN
        r: SQL_1e.sql
        
    END
GO

exec [dbo].receberProduto 14, 'c'
select * from [dbo].ViewProduto;
select * from [dbo].ProdutoCrianca;
select * from [dbo].ProdutoDesportista;

RAISERROR('Exercicio 2.a): vendas de vestuario de Desportita no centro de vendas de vestuario Crianca ...',0,1); --info
RAISERROR(' H1: todas as vendas "temporariamente" numa unica loja...',0,1); --info

:!!PAUSE 



/*

use [ASI];
SELECT TABLE_NAME, TABLE_TYPE 
  FROM information_schema.tables
 order by TABLE_TYPE;
 
-- lista os seus conteudos
select * from [dbo].fornecedor;
select * from [dbo].produto;
select * from [dbo].ViewProduto;
GO

:!!ECHO Vai listar os objectos da BD do Centro de Venda de Vesturario de Criancas
:!!PAUSE 

:connect $(serverCVVC) 

use [ASI];
 
SELECT * FROM information_schema.tables
select * from [dbo].produto;
GO

:!!ECHO Vai listar os objectos da BD do Centro de Venda de Vesturario de Desportistas
:!!PAUSE 

:connect $(serverCVVD) 

use [ASI];
 
SELECT * FROM information_schema.tables;
select * from [dbo].produto;
GO
*/