-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar InstanciaA "MIRANDA-LAPTOP\SQL2012DEINST1"

--:connect $(InstanciaA)

USE [master]
GO

DECLARE @recovery_model_desc varchar(20)
SELECT @recovery_model_desc = recovery_model_desc FROM sys.databases WHERE name = 'BDLS'
if @recovery_model_desc <> 'FULL'
begin
	ALTER DATABASE [BDLS] SET RECOVERY FULL WITH NO_WAIT
	SELECT @recovery_model_desc 'was', recovery_model_desc 'now_Is' FROM sys.databases WHERE name = 'BDLS'
end
GO

/*
<recovery_option> ::= 
{
    RECOVERY { FULL | BULK_LOGGED | SIMPLE } 
  | TORN_PAGE_DETECTION { ON | OFF }
  | PAGE_VERIFY { CHECKSUM | TORN_PAGE_DETECTION | NONE }
}
*/


-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******
