/*
*	ISEL-ADEETC-MEIC
*	ASI - 2013/2014
*	Desc: Pratica 1
*/

RAISERROR('Exercico 1 a) cricao modelo no Centro de Venda de Vesturario de Crianca',0,1); --info

:connect $(serverCVVC) 

USE [ASI]
GO

/****** Object:  Table [dbo].[produto]    Script Date: 2013-10-27 22:11:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[produto](
	[codProd] [int] NOT NULL,
	[preco] [money] NULL,
	[qtStock] [int] NULL,
	[qtMinStock] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codProd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

RAISERROR('Exercico 1 a) cricao modelo no Centro de Venda de Vesturario de Desportista',0,1); --info

:connect $(serverCVVD) 

USE [ASI]
GO

/****** Object:  Table [dbo].[produto]    Script Date: 2013-10-27 22:11:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[produto](
	[codProd] [int] NOT NULL,
	[preco] [money] NULL,
	[qtStock] [int] NULL,
	[qtMinStock] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codProd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


RAISERROR('Exercico 1 a) cricao modelo na SEDE',0,1); --info

USE [ASI]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
USE [ASI]
GO

/****** Object:  Table [dbo].[fornecedor]    Script Date: 2013-10-27 22:07:02 ******/
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[fornecedor](
	[codForn] [int] NOT NULL,
	[nome] [varchar](20) NOT NULL,
	[morada] [varchar](60) NULL,
    PRIMARY KEY CLUSTERED 
    (
        [codForn] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                        ) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[produto]    Script Date: 2013-10-27 22:08:45 ******/

CREATE TABLE [dbo].[produto](
	[codProd] [int] NOT NULL,
	[codForn] [int] NULL,
	[qtEncomenda] [int] NOT NULL,
	[estado] [bit] NOT NULL,
	[tipo] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codProd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[produto]  WITH CHECK ADD FOREIGN KEY([codForn])
REFERENCES [dbo].[fornecedor] ([codForn])
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 2013-10-27 22:15:37 ******/
CREATE SYNONYM [dbo].[ProdutoCrianca] FOR [FFSS\ISELALFA].[ASI].[dbo].[Produto]
GO

/****** Object:  Synonym [dbo].[ProdutoDesporto]    Script Date: 2013-10-27 22:15:58 ******/
CREATE SYNONYM [dbo].[ProdutoDesporto] FOR [FFSS\ISELBETA].[ASI].[dbo].[Produto]
GO

/****** Object:  View [dbo].[viewProduto]    Script Date: 2013-10-26 22:59:22 ******/
CREATE VIEW [dbo].[viewProduto]
AS
SELECT
	sede.codForn, sede.qtEncomenda, sede.codProd, sede.estado, sede.tipo,
	lojas.preco, lojas.qtMinStock, lojas.qtStock
FROM
	[ASI].[dbo].produto sede
	inner join (
		select * from ProdutoDesporto 
		union
		select * from ProdutoCrianca
	) lojas
		on sede.codProd = lojas.codProd

GO

/****** Object:  StoredProcedure [dbo].[deleteProduto]    Script Date: 2013-10-26 23:04:27 ******/
create procedure [dbo].[deleteProduto] 
	@codProd		[int]
as
	declare @tipo char;
	begin
            -- poderia ser usado um query sobre a view, mas como o delete tem de ser sobre a 
            --    tabela, isto acabava por aumentar o acopolamento (piorar a qualidade)
		select @tipo= tipo
		  from [dbo].Produto
		where codProd = @codProd;
		if @tipo = 'c'
			begin
				delete [dbo].produtoCrianca
				 where codProd = @codProd;
			end
		else
			begin
				delete [dbo].produtoDesporto
				 where codProd = @codProd;
			end
		delete [dbo].produto
		 where codProd = @codProd;
	end

GO

/****** Object:  StoredProcedure [dbo].[insertProduto]    Script Date: 2013-10-26 23:05:28 ******/
create procedure [dbo].[insertProduto] 
	@codProd		[int],
	@codForn		[int],
	@qtEncomenda	[int],
	@estado			[bit],
	@tipo			[char], -- esta na loja
	@preco			[money],
	@qtStock		[int],
	@qtMinStock		[int]
as
begin
	insert into [dbo].produto ( codProd,codForn, qtEncomenda, estado, tipo )
	Values ( @codProd,@codForn, @qtEncomenda, @estado, @tipo );

	if @tipo = 'c'
	begin
		insert into [dbo].produtoCrianca ( codProd,preco, qtStock, qtMinStock )
		Values ( @codProd, @preco, @qtStock, @qtMinStock );
	end
	else
	begin
		insert into [dbo].produtoDesporto ( codProd,preco, qtStock, qtMinStock )
		Values ( @codProd, @preco, @qtStock, @qtMinStock );
	end
end

GO

/****** Object:  Trigger [dbo].[trgUpd_ViewProduto]    Script Date: 2013-10-26 23:06:13 ******/

CREATE TRIGGER [dbo].[trgUpd_ViewProduto]
ON [dbo].[viewProduto]
INSTEAD OF UPDATE
AS
BEGIN
  BEGIN TRANSACTION
  -- primeiro processa os que mudaram de loja
            -- Eram de crianca
    if exists (select old.codProd 
               from [dbo].Produto old, INSERTED new
              where old.codProd = new.codProd 
                and old.tipo <> new.tipo
                and old.tipo = 'c')
      BEGIN 
          delete [dbo].ProdutoCrianca
          where 
            codProd = 
            (Select new.codProd from INSERTED new, [dbo].produto old
                where old.codProd = new.codProd
                  and old.tipo <> new.tipo
                  and old.tipo ='c');

            -- coloca em Desporto
          insert into [dbo].ProdutoDesporto (codProd, preco, qtStock, qtMinStock)
            select new.codProd, new.preco, new.qtStock, new.qtMinStock
            from INSERTED new, [dbo].Produto old
            where old.codProd = new.codProd
              and new.tipo = 'd'
              and old.tipo = 'c';
      END
            -- Eram de Desporto
    if exists (select old.codProd 
               from [dbo].Produto old, INSERTED new
              where old.codProd = new.codProd 
                and old.tipo <> new.tipo
                and old.tipo = 'd')
      BEGIN 
          delete [dbo].ProdutoDesporto
          where 
            codProd = 
            (Select new.codProd from INSERTED new, [dbo].produto old
                where old.codProd = new.codProd
                  and old.tipo <> new.tipo
                  and old.tipo ='d');

            -- coloca em Desporto
          insert into [dbo].ProdutoCrianca (codProd, preco, qtStock, qtMinStock)
            select new.codProd, new.preco, new.qtStock, new.qtMinStock
            from INSERTED new, [dbo].Produto old
            where new.codProd = old.codProd
              and new.tipo = 'c'
              and old.tipo = 'd';
      END
      
    --  faz o update dos dados nas tabelas remotas.
    -- (mesmo nas que acabou de inserir, mas não deve ter impacto negativo por isso)
    UPDATE [dbo].ProdutoCrianca
        Set 
            preco = INSERTED.preco,
            qtStock = INSERTED.qtStock,
            qtMinStock = INSERTED.qtMinStock
        FROM INSERTED
        WHERE INSERTED.codProd = produtoCrianca.codProd
          AND INSERTED.tipo = 'c';
       

    UPDATE [dbo].ProdutoDesporto
        Set 
            preco = INSERTED.preco,
            qtStock = INSERTED.qtStock,
            qtMinStock = INSERTED.qtMinStock
        FROM INSERTED
        WHERE INSERTED.codProd = produtoDesporto.codProd
          AND INSERTED.tipo = 'd';

    UPDATE [dbo].Produto
        set 
            codForn =  INSERTED.codForn,
            qtEncomenda=  INSERTED.qtEncomenda,   
            estado=  INSERTED.estado, 
            tipo =  INSERTED.tipo
        From INSERTED
		where Produto.codProd = INSERTED.codProd;
	Commit Transaction
END
GO

RAISERROR('Criacao terminada!',0,1); --info
