--03.1-CREATE-CVCrianca-TBL-ocorrencias.sql
USE [ASI]
GO
ALTER TABLE [dbo].[ocorrencias] DROP CONSTRAINT [FK__ocorrenci__codPr]
GO
DROP TABLE [dbo].[ocorrencias]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias](
	[identificador] [int] IDENTITY(1,3) NOT FOR REPLICATION NOT NULL,
	[descricao] [text] NULL,
	[codProd] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[identificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[ocorrencias]  WITH CHECK ADD  CONSTRAINT [FK__ocorrenci__codPr] FOREIGN KEY([codProd])
REFERENCES [dbo].[produto] ([cod]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ocorrencias] CHECK CONSTRAINT [FK__ocorrenci__codPr] 
GO



