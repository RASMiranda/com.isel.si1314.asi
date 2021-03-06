USE [master]
GO

--@LSC
--:setvar ReclamacaoSeedValue 2
--@LHD
--:setvar ReclamacaoSeedValue 3

if exists (select * from sys.databases where name = 'ASIVesteLoja')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASIVesteLoja'
	ALTER DATABASE ASIVesteLoja SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [ASIVesteLoja]
end
GO

CREATE DATABASE [ASIVesteLoja];
GO

USE [ASIVesteLoja]
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

/****** Object:  Table [dbo].[Produto]    Script Date: 03-02-2014 12:58:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
	DROP TABLE [dbo].[Produto]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Produto](
		[ProdutoID] [int] IDENTITY(1,1) NOT NULL,
		[Codigo] [nvarchar](max) NULL,
		[Designacao] [nvarchar](max) NULL,
		[StockQtd] [int] NOT NULL,
		[Preco] [real] NOT NULL,
		[RowVersion] [timestamp] NOT NULL,
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
