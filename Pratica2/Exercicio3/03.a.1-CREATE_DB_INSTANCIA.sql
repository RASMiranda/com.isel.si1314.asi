DROP DATABASE [DB2_3]
GO


CREATE DATABASE [DB2_3]
GO

USE [DB2_3]
GO

USE [DB2_3]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE Alunos (
	numero	int PRIMARY KEY,
	nome	varchar(30)
);

alter table alunos
add constraint CK_Sharding_range CHECK ( numero %3 = $(ShardingRange) );

CREATE TABLE Disciplinas (
	codigo	int PRIMARY KEY,
	designacao varchar(30)
);

CREATE TABLE Inscricao (
	numero	int not null,
	codigo	int not null,
	nota	int,
	numSeq	int identity  ( $(ValorInicial), $(Incremento)) 
);



ALTER TABLE Inscricao 
	ADD CONSTRAINT PK_Inscricao PRIMARY KEY (Numero, codigo);

ALTER TABLE Inscricao 
	ADD CONSTRAINT UK_Inscricao_NumSeq UNIQUE (NumSeq);

ALTER TABLE Inscricao 
	ADD CONSTRAINT FK_Inscricao_Alunos FOREIGN KEY (Numero) REFERENCES Alunos (numero);

ALTER TABLE Inscricao 
	ADD CONSTRAINT FK_Inscricao_Disciplinas FOREIGN KEY (codigo) REFERENCES Disciplinas (codigo);

GO

