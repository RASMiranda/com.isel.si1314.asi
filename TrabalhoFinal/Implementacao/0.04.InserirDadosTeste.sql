
USE [ASIVesteSede]
GO

INSERT INTO [dbo].[Fornecedor]
           ([Numero], [Nome], [Morada]) 
     VALUES
           (1, 'Confeções Elite do Vouga, SA.', 'Estrada da Industria, Sever do Vouga'),
		   (2, 'Fabrica de Brinquedos, SA.', 'Cintura Industrial, Sintra'),
		   (3, 'Desporto Rei, Lda.', 'Mem Martins, Sintra'),
		   (4, 'Zara, Lda.', 'Amadora, Lisboa')
;

INSERT INTO [dbo].[Produto]
           ([Tipo], [Codigo], [Designacao], [StockQtd], [StockMinimo], [Preco], [Fornecedor_FornecedorID])
     VALUES
           (2, 'SE001', 'Camisa Elite XS', 10, 5, 45.9, 1),
		   (2, 'SE002', 'Camisa Elite M',   3, 3, 45.9, 1),
		   (2, 'SE003', 'Camisa Elite L',   5, 2, 45.9,	1),

           (0, 'CV001', 'Calca Verde', 10, 7, 15.25, 4),
		   (0, 'SC002', 'Saia Curta',   3, 1, 20, 4),
		   (0, 'BA003', 'Blusa Azul',   5, 10, 19.9, 4)
;

insert into [dbo].Produto 
	( Codigo, Tipo, Designacao, Preco, StockQtd, StockMinimo, [Fornecedor_FornecedorID]) 
Values
			(N'SC001',0,N'Camisa Senhora modelo Roxane', 59.90, 10, 5, 1),
			(N'SC022',0,N'Camisa Senhora Ariane botões', 39.90, 10, 5, 1),
			(N'CC001',1,N'Casaco Castanho criança', 40, 5, 2, 1),
			(N'CC002',1,N'Casaco Castanho junior', 45, 7, 2, 1),
			(N'HC001',2,N'Casaco Castanho Adulto', 54.99 , 7, 5, 1),
			(N'HC002',2,N'Casaco Castanho Senior', 45.99 , 3, 1, 1),
			(N'DC001',3,N'Camisola termica S',10.99 , 10, 10, 3),
			(N'DC002',3,N'Camisola termica M',10.99 , 10, 10, 3),
			(N'DC003',3,N'Camisola termica L',10.99 , 10, 10, 3)
;




INSERT INTO [dbo].[ProdutoHD]
           ([Codigo], [Designacao], [StockQtd], [Preco])
     VALUES
           (N'SE001', N'Camisa Elite XS', 10, 45.9),
		   (N'SE002', N'Camisa Elite M',   3, 45.9),
		   (N'SE003', N'Camisa Elite L',   5, 45.9)
;

insert into [dbo].ProdutoHD
	( Codigo, Designacao, Preco, StockQtd) 
Values
			('SC001',N'Camisa Senhora modelo Roxane', 59.90, 10),
			('SC022',N'Camisa Senhora Ariane botões', 39.90, 10),
			('CC001',N'Casaco Castanho criança', 40, 5),
			('CC002',N'Casaco Castanho junior', 45, 7)
;


INSERT INTO [dbo].[ProdutoSC]
           ([Codigo], [Designacao], [StockQtd], [Preco])
     VALUES
           (N'CV001', N'Calca Verde', 10, 15.25),
		   (N'SC002', N'Saia Curta',   3, 20),
		   (N'BA003', N'Blusa Azul',   5, 19.9)
;


insert into [dbo].ProdutoSC
	( Codigo, Designacao, Preco, StockQtd) 
Values
			(N'HC001',N'Casaco Castanho Adulto', 54.99 , 7),
			(N'HC002',N'Casaco Castanho Senior', 45.99 , 3),
			(N'DC001',N'Camisola termica S', 10.99 , 10),
			(N'DC002',N'Camisola termica M', 10.99 , 10),
			(N'DC003',N'Camisola termica L', 10.99 , 10)
;

GO

