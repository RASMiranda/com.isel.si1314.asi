USE [ASIVeste]
GO


-- a remover esta tabela vai ser escrita por replicacao assincrona; e lida qd se usa o servico de vendas da sede
INSERT INTO [dbo].[Produto]
           ([Id], [Designacao], [Preco], [StockQtd])
     VALUES
			(1, 'Camisa Senhora modelo Roxane', 59.90, 10),
			(2, 'Camisa Senhora Ariane botões', 39.90, 10),
			(3, 'Casaco Castanho criança', 40, 5),
			(4, 'Casaco Castanho junior', 45, 7),
			(5, 'Casaco Castanho Adulto', 54.99 , 7),
			(6, 'Casaco Castanho Senior', 45.99 , 3),
			(7, 'Camisola termica S',10.99 , 10),
			(8, 'Camisola termica M',10.99 , 10),
			(9, 'Camisola termica L',10.99 , 10)
;

GO

-- select 'select * from ' + name + ';' from sys.tables;
-- select * from Produto;
