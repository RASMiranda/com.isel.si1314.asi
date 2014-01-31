USE [ASI]

IF OBJECT_ID ('ocorrencia','U') IS NOT NULL
	DROP TABLE [dbo].[ocorrencia]
GO

create table ocorrencia (
	id integer identity (1, 3) not for replication primary key,
	descr varchar(30),
	codproduto integer
)
GO

alter table ocorrencia
add constraint FK_ocorrencia_produto FOREIGN KEY ( codproduto ) references produto(cod)
GO

/*
:connect .\two
alter table asi..ocorrencia drop constraint FK_ocorrencia_produto
go
:connect .\three
alter table asi..ocorrencia drop constraint FK_ocorrencia_produto
go
*/