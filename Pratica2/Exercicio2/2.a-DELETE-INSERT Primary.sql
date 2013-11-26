--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar InstanciaPri aluno_siad-pc\one


-- ****** Begin: Script to be run at Primary: [InstanciaPri] ******
--:connect $(InstanciaPri)

USE [BDLS]
GO

DECLARE @value AS INT

SELECT @value = max(i) FROM t
DELETE FROM t WHERE t.i = @value
INSERT INTO t VALUES(@value+1)
SELECT * FROM t
GO
-- ****** End: Script to be run at Primary: [InstanciaPri]  ******
