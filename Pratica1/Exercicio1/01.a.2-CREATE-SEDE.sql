USE [master]
GO

if exists (select * from sys.databases where name = 'ASI')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ASI'
	ALTER DATABASE ASI SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	USE [master]
	DROP DATABASE [ASI]
end


CREATE DATABASE [ASI]
GO

USE [ASI]
GO
/****** Object:  Table [dbo].[fornecedor]    Script Date: 17-10-2013 20:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fornecedor](
	[cod] [int] NOT NULL,
	[nome] [varchar](20) NULL,
	[morada] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[produto]    Script Date: 17-10-2013 20:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[produto](
	[codFornecedor] [int] NULL,
	[qtEncomenda] [int] NULL,
	[cod] [int] NOT NULL,
	[estado] [bit] NULL,
	[tipo] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[produto]  WITH CHECK ADD  CONSTRAINT [fk_produto_fornecedor] FOREIGN KEY([codFornecedor])
REFERENCES [dbo].[fornecedor] ([cod])
GO
ALTER TABLE [dbo].[produto] CHECK CONSTRAINT [fk_produto_fornecedor]
GO
