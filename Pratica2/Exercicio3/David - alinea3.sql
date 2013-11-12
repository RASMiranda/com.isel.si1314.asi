create table Alunos (
	numero	int PRIMARY KEY,
	nome	varchar(30)
)
;

create table Disciplinas (
	codigo	int PRIMARY KEY,
	designacao varchar(30)
)
;

create table Inscricao (
	numero	int,
	codigo	int,
	nota	int,
	numSeq	identity
)
;

ALTER TABLE Inscricao 
	ADD CONSTRAINT PK_Inscricao PRIMARY KEY (Numero, codigo)
;

ALTER TABLE Inscricao 
	ADD CONSTRAINT UK_Inscricao_NumSeq UNIQUE (NumSeq)
;

ALTER TABLE Inscricao 
	ADD CONSTRAINT FK_Inscricao_Alunos FOREIGN KEY (Numero) REFERENCES Alunos (numero)
;

ALTER TABLE Inscricao 
	ADD CONSTRAINT FK_Inscricao_Disciplinas FOREIGN KEY (codigo) REFERENCES Disciplinas (codigo)
;



