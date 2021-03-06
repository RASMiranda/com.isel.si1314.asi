USE [master]
GO

--@SEDE
--:setvar ReclamacaoSeedValue 1

if exists (select * from sys.databases where name = 'ASIVesteSede')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASIVesteSede'
	ALTER DATABASE ASIVesteSede SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [ASIVesteSede]
end
GO

CREATE DATABASE [ASIVesteSede];
GO

USE [ASIVesteSede]
GO

IF OBJECT_ID ('[Reclamacao]','U') IS NOT NULL
	DROP TABLE [dbo].[Reclamacao]
GO
CREATE TABLE [dbo].[Reclamacao](
	[ReclamacaoID] [int] PRIMARY KEY IDENTITY($(ReclamacaoSeedValue), 6), -- Assume-se um máximo de 6 nós
	[ClienteBI] [nvarchar](max) NULL,
	[Texto] [nvarchar](max) NULL,
	[DataInsercao] [datetime] NOT NULL
);
GO

IF OBJECT_ID ('[Encomenda]','U') IS NOT NULL
	DROP TABLE [dbo].[Encomenda]
GO
CREATE TABLE [dbo].[Encomenda](
	[EncomendaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Qtd] [int] NOT NULL,
	[Estado] [int] NULL,
	[Produto_ProdutoID] [int] NULL,
	[VendaProduto_VendaProdutosID] [int] NULL
);
GO

IF OBJECT_ID ('[Fornecedor]','U') IS NOT NULL
	DROP TABLE [dbo].[Fornecedor]
GO
CREATE TABLE [dbo].[Fornecedor](
	[FornecedorID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Numero] [int] NOT NULL,
	[Nome] [nvarchar](max) NULL,
	[Morada] [nvarchar](max) NULL
);
GO

IF OBJECT_ID ('[Produto]','U') IS NOT NULL
	DROP TABLE [dbo].[Produto]
GO
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
GO

IF OBJECT_ID ('[Venda]','U') IS NOT NULL
	DROP TABLE [dbo].[Venda]
GO
CREATE TABLE [dbo].[Venda](
	[VendaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[NomeCliente] [nvarchar](max) NULL,
	[MoradaCliente] [nvarchar](max) NULL,
	[Estado] [int] NULL
);
GO

IF OBJECT_ID ('[VendaProdutos]','U') IS NOT NULL
	DROP TABLE [dbo].[VendaProdutos]
GO
CREATE TABLE [dbo].[VendaProdutos](
	[VendaProdutosID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](max) NULL,
	[Qtd] [int] NOT NULL,
	[Estado] [int] NULL,
	[Venda_VendaID] [int] NULL,
	[Produto_ProdutoID] [int] NULL
)
;
GO

/****** Object:  Index [IX_Produto_ProdutoID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Produto_ProdutoID] ON [dbo].[Encomenda] ( [Produto_ProdutoID] ASC );
GO

/****** Object:  Index [IX_VendaProduto_VendaProdutosID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_VendaProduto_VendaProdutosID] ON [dbo].[Encomenda] ( [VendaProduto_VendaProdutosID] ASC );
GO

/****** Object:  Index [IX_Fornecedor_FornecedorID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Fornecedor_FornecedorID] ON [dbo].[Produto] ( [Fornecedor_FornecedorID] ASC );
GO

/****** Object:  Index [IX_Produto_ProdutoID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Produto_ProdutoID] ON [dbo].[VendaProdutos] ( [Produto_ProdutoID] ASC );
GO

/****** Object:  Index [IX_Venda_VendaID]    Script Date: 03-02-2014 13:07:13 ******/
CREATE NONCLUSTERED INDEX [IX_Venda_VendaID] ON [dbo].[VendaProdutos] (	[Venda_VendaID] ASC );
GO


ALTER TABLE [dbo].[Encomenda] 
	WITH CHECK 
	ADD CONSTRAINT [FK_dbo.Encomenda_dbo.Produto_Produto_ProdutoID] 
		FOREIGN KEY([Produto_ProdutoID])
		REFERENCES [dbo].[Produto] ([ProdutoID])
;
GO

ALTER TABLE [dbo].[Encomenda] 
	WITH CHECK 
	ADD CONSTRAINT [FK_dbo.Encomenda_dbo.VendaProdutos_VendaProduto_VendaProdutosID] 
		FOREIGN KEY([VendaProduto_VendaProdutosID])
		REFERENCES [dbo].[VendaProdutos] ([VendaProdutosID])
;
GO

ALTER TABLE [dbo].[Produto]  
	WITH CHECK 
	ADD  CONSTRAINT [FK_dbo.Produto_dbo.Fornecedor_Fornecedor_FornecedorID] 
		FOREIGN KEY([Fornecedor_FornecedorID])
		REFERENCES [dbo].[Fornecedor] ([FornecedorID])
;
GO

ALTER TABLE [dbo].[VendaProdutos]  
	WITH CHECK 
	ADD  CONSTRAINT [FK_dbo.VendaProdutos_dbo.Produto_Produto_ProdutoID] 
		FOREIGN KEY([Produto_ProdutoID])
		REFERENCES [dbo].[Produto] ([ProdutoID])
;
GO

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
