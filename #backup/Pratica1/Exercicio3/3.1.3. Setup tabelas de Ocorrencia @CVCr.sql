USE [ASI]

IF OBJECT_ID ('ocorrencia','U') IS NOT NULL
	DROP TABLE [dbo].[ocorrencia]
GO

create table ocorrencia (
	id integer identity (2, 3) not for replication primary key,
	descr varchar(30),
	codproduto integer
)
GO

/*
alter table ocorrencia
add constraint FK_ocorrencia_produto FOREIGN KEY ( codproduto ) references produto(cod)
GO
*/