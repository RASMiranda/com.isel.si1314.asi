CREATE TABLE Alunos(
NumAl int primary key,
Nome varchar(60),
)


CREATE TABLE AlunosAssEst(
	NumAl int references Alunos,
	nSeq int identity,
	Interesse varchar(10),
	Primary key(NumAl,nSeq)
)
