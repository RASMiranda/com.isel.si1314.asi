USE [ASIVeste]
GO

begin
	begin transaction;
	delete from [dbo].[ProdutoCS];
	delete from [dbo].[ProdutoHD];
	delete from [dbo].[Expedicao];
	delete from [dbo].[Venda];
	delete from [dbo].[Encomenda];
	delete from [dbo].[Produto];
	delete from [dbo].[Fornecedor];
	commit transaction;
end

/*
INSERT INTO [dbo].[Encomenda]
           ([ProdutoId], [Estado], [Qtd], [VendaId])
     VALUES
           (<Codigo, int,>, <CodigoProduto, int,>, <Estado, int,>, <Qtd, int,>, <CodigoVenda, int,>)
;

INSERT INTO [dbo].[Expedicao]
           ([VendaId], [Expedida])
     VALUES
           (<Codigo, int,>, <CodigoVenda, int,>, <Expedida, bit,>)
;
*/

INSERT INTO [dbo].[Fornecedor]
           ([Nome], [Morada])
     VALUES
			( 'Camisaria Ideal do Vouga, Lda.', 'Estrada do Vouga, 10, Sever do Vouga'),
            ( 'Fabrica de Brinquedos, SA.', 'Cintura Industrial, Sintra'),
            ( 'Desporto Rei, SA.', 'Casal do Marco, Azambuja')
;


DECLARE @RC [int], @fid [int];

select @fid = min(id) from Fornecedor;

EXECUTE @RC = [dbo].[sp_inserirProduto] 0, 'Camisa Senhora modelo Roxane', 59.90, 10, 5, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 0, 'Camisa Senhora Ariane botões', 39.90, 10, 5, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 1, 'Casaco Castanho criança', 40, 5, 2, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 1, 'Casaco Castanho junior', 45, 7, 2, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 2, 'Casaco Castanho Adulto', 54.99 , 7, 5, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 2, 'Casaco Castanho Senior', 45.99 , 3, 1, @fid;

set @fid = @fid +2

EXECUTE @RC = [dbo].[sp_inserirProduto] 3, 'Camisola termica S', 10.99 , 10, 10, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 3, 'Camisola termica M', 10.99 , 10, 10, @fid;
EXECUTE @RC = [dbo].[sp_inserirProduto] 3, 'Camisola termica L', 10.99 , 10, 10, @fid;


/*
INSERT INTO [dbo].[Venda]
           ([NomeCliente], [MoradaCliente], [ProdutoId], [Qtd])
     VALUES
           (<Codigo, int,>, <NomeCliente, varchar(30),>, <MoradaCliente, varchar(30),>, <CodigoProduto, int,>, <qtd, int,>)
;
*/

GO




--select 'select * from ' + name + ';' from sys.tables;
/*
select * from Fornecedor;
select * from Produto;
select * from Venda;
select * from Expedicao;
select * from Encomenda;
*/