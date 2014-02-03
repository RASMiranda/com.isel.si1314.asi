USE [master]
GO


if exists (select * from sys.databases where name = 'ASIVesteSede')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASIVesteSede'
	ALTER DATABASE ASIVesteSede SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [ASIVesteSede]
end

CREATE DATABASE [ASIVesteSede];

USE [ASIVesteSede]
GO


IF OBJECT_ID ('[Encomenda]','U') IS NOT NULL
	DROP TABLE [dbo].[Encomenda]
CREATE TABLE [dbo].[Encomenda](
	[EncomendaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Qtd] [int] NOT NULL,
	[Estado] [int] NULL,
	[Produto_ProdutoID] [int] NULL,
	[VendaProduto_VendaProdutosID] [int] NULL
);

IF OBJECT_ID ('[Fornecedor]','U') IS NOT NULL
	DROP TABLE [dbo].[Fornecedor]
CREATE TABLE [dbo].[Fornecedor](
	[FornecedorID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Numero] [int] NOT NULL,
	[Nome] [nvarchar](max) NULL,
	[Morada] [nvarchar](max) NULL
);

IF OBJECT_ID ('[Produto]','U') IS NOT NULL
	DROP TABLE [dbo].[Produto]
CREATE TABLE [dbo].[Produto](
	[ProdutoID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Tipo] [int] NULL,
	[Codigo] [nvarchar](max) NULL,
	[Designacao] [nvarchar](max) NULL,
	[StockQtd] [int] NOT NULL,
	[StockMinimo] [int] NOT NULL,
	[Preco] [real] NOT NULL,
	[Fornecedor_FornecedorID] [int] NULL
);

IF OBJECT_ID ('[Venda]','U') IS NOT NULL
	DROP TABLE [dbo].[Venda]
CREATE TABLE [dbo].[Venda](
	[VendaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[NomeCliente] [nvarchar](max) NULL,
	[MoradaCliente] [nvarchar](max) NULL,
	[Estado] [int] NULL
);

IF OBJECT_ID ('[VendaProdutos]','U') IS NOT NULL
	DROP TABLE [dbo].[VendaProdutos]
CREATE TABLE [dbo].[VendaProdutos](
	[VendaProdutosID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](max) NULL,
	[Qtd] [int] NOT NULL,
	[Estado] [int] NULL,
	[Venda_VendaID] [int] NULL,
	[Produto_ProdutoID] [int] NULL
)
;

/****** Object:  Index [IX_Produto_ProdutoID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Produto_ProdutoID] ON [dbo].[Encomenda] ( [Produto_ProdutoID] ASC );

/****** Object:  Index [IX_VendaProduto_VendaProdutosID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_VendaProduto_VendaProdutosID] ON [dbo].[Encomenda] ( [VendaProduto_VendaProdutosID] ASC );

/****** Object:  Index [IX_Fornecedor_FornecedorID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Fornecedor_FornecedorID] ON [dbo].[Produto] ( [Fornecedor_FornecedorID] ASC );

/****** Object:  Index [IX_Produto_ProdutoID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Produto_ProdutoID] ON [dbo].[VendaProdutos] ( [Produto_ProdutoID] ASC );

/****** Object:  Index [IX_Venda_VendaID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Venda_VendaID] ON [dbo].[VendaProdutos] (	[Venda_VendaID] ASC );
GO


ALTER TABLE [dbo].[Encomenda] 
	WITH CHECK 
	ADD CONSTRAINT [FK_dbo.Encomenda_dbo.Produto_Produto_ProdutoID] 
		FOREIGN KEY([Produto_ProdutoID])
		REFERENCES [dbo].[Produto] ([ProdutoID])
;

ALTER TABLE [dbo].[Encomenda] 
	WITH CHECK 
	ADD CONSTRAINT [FK_dbo.Encomenda_dbo.VendaProdutos_VendaProduto_VendaProdutosID] 
		FOREIGN KEY([VendaProduto_VendaProdutosID])
		REFERENCES [dbo].[VendaProdutos] ([VendaProdutosID])
;

ALTER TABLE [dbo].[Produto]  
	WITH CHECK 
	ADD  CONSTRAINT [FK_dbo.Produto_dbo.Fornecedor_Fornecedor_FornecedorID] 
		FOREIGN KEY([Fornecedor_FornecedorID])
		REFERENCES [dbo].[Fornecedor] ([FornecedorID])
;

ALTER TABLE [dbo].[VendaProdutos]  
	WITH CHECK 
	ADD  CONSTRAINT [FK_dbo.VendaProdutos_dbo.Produto_Produto_ProdutoID] 
		FOREIGN KEY([Produto_ProdutoID])
		REFERENCES [dbo].[Produto] ([ProdutoID])
;

ALTER TABLE [dbo].[VendaProdutos]  
	WITH CHECK 
	ADD  CONSTRAINT [FK_dbo.VendaProdutos_dbo.Venda_Venda_VendaID] 
		FOREIGN KEY([Venda_VendaID])
		REFERENCES [dbo].[Venda] ([VendaID])
;
GO

USE [master]
GO

ALTER DATABASE [ASIVesteSede] SET  READ_WRITE 
GO
