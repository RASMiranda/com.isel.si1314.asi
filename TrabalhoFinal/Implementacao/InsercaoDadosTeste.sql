/***********************************************************
    Projeto ASIVeste, Lda
    DEETC -  ASI 2013/2014
    Grupo 5 (David Coelho, Frederico Ferreira, Rui Miranda)
    Descr.: Script para Carregamento de Dados de Testes nas tabelas da SEDE
    Versão: 
        2014.01.25: primeira versao
*/
 
 USE [ASIVESTE]
 GO
 
 /* dados de simulacao para fornecedores*/
insert into [dbo].Fornecedor ( Numero, Nome, Morada) values
            ( 1, 'Camisaria Ideal do Vouga, Lda.', 'Estrada do Vouga, 10, Sever do Vouga');

insert into [dbo].Fornecedor ( Numero, Nome, Morada) values
            ( 2, 'Fabrica de Brinquedos, SA.', 'Cintura Industrial, Sintra');

insert into [dbo].Fornecedor ( Numero, Nome, Morada) values
            ( 3, 'Desporto Rei, SA.', 'Casal do Marco, Azambuja');

Select * from [dbo].[Fornecedor]

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('SC001',0,'Camisa Senhora modelo Roxane', 59.90, 10, 5, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('SC002',0,'Camisa Senhora Ariane botões', 39.90, 10, 5, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('CC001',1,'Casaco Castanho criança', 40, 5, 2, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('CC002',1,'Casaco Castanho junior', 45, 7, 2, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('HC001',2,'Casaco Castanho Adulto', 54.99 , 7, 5, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('HC002',2,'Casaco Castanho Senior', 45.99 , 3, 1, 1);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('DC001',3,'Camisola termica S',10.99 , 10, 10, 3);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('DC002',3,'Camisola termica M',10.99 , 10, 10, 3);

insert into [dbo].Produto  ( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, FornecedorId) Values
			('DC003',3,'Camisola termica L',10.99 , 10, 10, 3);


select * from [dbo].Produto
