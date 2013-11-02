USE [ASI];
GO

ALTER TABLE [dbo].[produto]
ADD 
	[preco] [money] NULL,
	[qtStock] [int] NULL,
	[qtMinStock] [int] NULL
;
GO

UPDATE [dbo].[produto]
	SET [dbo].[produto].[preco] = [dbo].[produtoCV].[preco],
		[dbo].[produto].[qtStock] = [dbo].[produtoCV].[qtStock],
		[dbo].[produto].[qtMinStock] = [dbo].[produtoCV].[qtMinStock]
FROM
	[dbo].[produto]
INNER JOIN
	[dbo].[produtoCV]
ON
	[dbo].[produtoCV].cod = [dbo].[produto].cod
GO