USE [BD3_1]
GO

SELECT a.[NumAl]
      ,a.[Nome]
	  ,ase.[nSeq]
	  ,ase.[Interesse]
  FROM [dbo].[Alunos] a
  LEFT OUTER JOIN [dbo].[AlunosAssEst] ase
	ON ase.[NumAl] = a.[NumAl]
GO
/*
NumAl       Nome                                                         nSeq        Interesse
----------- ------------------------------------------------------------ ----------- ----------

(0 row(s) affected)
*/