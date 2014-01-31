--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar primary_server "MIRANDA-LAPTOP\SQL2012DEINST1"
--:setvar secondary_server_C "MIRANDA-LAPTOP\SQL2012DEINST3"
-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******
:connect $(primary_server)
USE [BDLS]
GO
DECLARE @value AS INT; SET @value = 2;
DELETE FROM t WHERE t.i = @value
INSERT INTO t VALUES(@value)
GO
SELECT * FROM t
GO
-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******

-- ****** Begin: Script to be run at Secondary: [SERVER_INST_C] ******
:connect $(secondary_server_C)
USE [BDLS]
GO
SELECT * FROM t
GO
-- ****** End: Script to be run at Secondary: [SERVER_INST_C] ******