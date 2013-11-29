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
1111        zeca                                                         1           i1
1111        zeca                                                         2           i2
2222        rita                                                         3           i2
2222        rita                                                         4           i3
*/