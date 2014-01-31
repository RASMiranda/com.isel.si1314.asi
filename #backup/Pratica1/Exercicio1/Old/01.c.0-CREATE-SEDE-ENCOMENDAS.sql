


USE [ASI]
GO
/****** Object:  StoredProcedure [dbo].[produtosQueDevemSerEncomendados]    Script Date: 17-10-2013 22:21:18 ******/
DROP PROCEDURE [dbo].[produtosQueDevemSerEncomendados]
GO

/****** Object:  StoredProcedure [dbo].[produtosQueDevemSerEncomendados]    Script Date: 17-10-2013 22:21:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[produtosQueDevemSerEncomendados] as
begin
	select f.nome, f.morada, p.cod, p.qtEncomenda
	from fornecedor f inner join produto p on f.cod = p.codFornecedor
	where 1=1
		and p.estado = 0
		and p.cod in (
			select	p.cod
			from	[ProdutoCrianca] p
			where	p.qtStock < p.qtMinStock
			union
			select	p.cod
			from	[ProdutoDesp] p
			where	p.qtStock < p.qtMinStock
		)
	;
end

GO

/****** Object:  StoredProcedure [dbo].[produtosEfectivamenteEncomendados]    Script Date: 17-10-2013 22:20:56 ******/
DROP PROCEDURE [dbo].[produtosEfectivamenteEncomendados]
GO

/****** Object:  StoredProcedure [dbo].[produtosEfectivamenteEncomendados]    Script Date: 17-10-2013 22:20:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[produtosEfectivamenteEncomendados] as
begin
	update produto
	set estado = 1
	where cod in	
	(
		select	p.cod
		from	[ProdutoCrianca] p
		where	p.qtStock < p.qtMinStock
		union
		select	p.cod
		from	[ProdutoDesp] p
		where	p.qtStock < p.qtMinStock
	)
	;
end

GO
/****** Object:  StoredProcedure [dbo].[produtosEncomendadosForamRecebidos]    Script Date: 17-10-2013 22:21:36 ******/
DROP PROCEDURE [dbo].[produtosEncomendadosForamRecebidos]
GO

/****** Object:  StoredProcedure [dbo].[produtosEncomendadosForamRecebidos]    Script Date: 17-10-2013 22:21:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[produtosEncomendadosForamRecebidos] as
begin

	UPDATE [dbo].[viewProduto]
	SET
		qtStock = qtStock + qtEncomenda,
		estado = case when qtMinStock < (qtStock + qtEncomenda) then 0 else 1 end
	WHERE estado = 1

end

GO

/****** Object:  StoredProcedure [dbo].[produtosEncomendadosForamRecebidos]    Script Date: 17-10-2013 22:21:36 ******/
DROP PROCEDURE [dbo].[produtosEncomendadas]
GO

/****** Object:  StoredProcedure [dbo].[produtosEncomendadosForamRecebidos]    Script Date: 17-10-2013 22:21:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[produtosEncomendadas] as
begin
	SET XACT_ABORT ON
	BEGIN TRANSACTION T_produtosEncomendadas
		EXEC [dbo].[produtosQueDevemSerEncomendados]
		EXEC [dbo].[produtosEfectivamenteEncomendados]
		EXEC [dbo].[produtosEncomendadosForamRecebidos]
	COMMIT TRANSACTION T_produtosEncomendadas
end

GO