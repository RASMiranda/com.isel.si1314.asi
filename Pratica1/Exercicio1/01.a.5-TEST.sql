
USE [ASI]
GO

-- setup data for testing...

truncate table Produto;
delete from Fornecedor; -- Cannot truncate table 'Fornecedor' because it is being referenced by a FOREIGN KEY constraint.
delete from ProdutoCrianca; -- Could not truncate object 'ProdutoCrianca' because it is not a table.
delete from ProdutoDesp;


INSERT INTO [dbo].[fornecedor] ([cod], [nome], [morada])
select 1, 'Fornecedor#1', 'MoradaForn#1' union
select 2, 'Fornecedor#2', 'MoradaForn#2' union
select 3, 'Fornecedor#3', 'MoradaForn#3' ;



insert into Produto (codFornecedor, cod, qtEncomenda, estado, tipo)
select 1, 11112, 2*15, 0, 'D' union
select 1, 33333, 2*14, 0, 'D' union
select 1, 55554, 2*13, 0, 'D' union
select 1, 77775, 2*15, 0, 'D' union
select 2, 93136, 2*14, 0, 'D' union
select 2, 95157, 2*13, 0, 'D' union
select 2, 22222, 2*5, 0, 'C' union
select 2, 44443, 2*4, 0, 'C' union
select 3, 66664, 2*3, 0, 'C' union
select 3, 88885, 2*5, 0, 'C' union
select 3, 90106, 2*4, 0, 'C' union
select 3, 92127, 2*3, 0, 'C';

insert into produtoDesp (cod,	preco,	qtStock,	qtMinStock)
select 11112, €1127.50, 20, 15 union
select 33333, €1117.40, 21, 14 union
select 55554, €1237.30, 22, 13 union
select 77775, €1047.20, 23, 15 union
select 93136, €1125.10, 24, 14 union
select 95157, €1320.00, 25, 13;

insert into ProdutoCrianca (cod,	preco,	qtStock,	qtMinStock)
select 22222,  €127.50, 10,  5 union
select 44443,  €117.40, 11,  4 union
select 66664,  €237.30, 12,  3 union
select 88885,  €047.20, 13,  5 union
select 90106,  €125.10, 14,  4 union
select 92127,  €320.00, 15,  3;

select 'Produto', count(cod) from Produto union
select 'ProdutoCrianca', count(cod) from ProdutoCrianca union
select 'ProdutoDesp', count(cod) from ProdutoDesp;

select * from Produto;
select * from ProdutoCrianca;
select * from ProdutoDesp;