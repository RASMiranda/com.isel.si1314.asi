USE [ASIVesteLoja]
GO

/****** Object:  Table [dbo].[Produto]    Script Date: 03-02-2014 12:58:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
	DROP TABLE [dbo].[Produto]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Produto](
		[ProdutoID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Codigo] [nvarchar](max) NULL,
		[Designacao] [nvarchar](max) NULL,
		[StockQtd] [int] NOT NULL,
		[Preco] [real] NOT NULL
	)
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Venda]') AND type in (N'U'))
	DROP TABLE [dbo].[Venda]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Venda]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Venda](
		[VendaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[nomeCliente] [nvarchar](max) NULL,
		[moradaCliente] [nvarchar](max) NULL,
		[codigoProduto] [nvarchar](max) NULL,
		[quantidade] [int] NOT NULL,
	)
END
GO
