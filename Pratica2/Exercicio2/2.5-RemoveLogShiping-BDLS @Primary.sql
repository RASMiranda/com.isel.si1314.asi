--:setvar InstanciaPri aluno_siad-pc\one
--:setvar InstanciaSec1 aluno_siad-pc\two
--:setvar InstanciaSec2 aluno_siad-pc\three


--:connect $(InstanciaPri)


-- Removing the Log Shipping configuration 

-- ****** Begin: Script to be run at Primary: [InstanciaA] ******

use [msdb]
GO
-- http://msdn.microsoft.com/en-us/library/ms191297.aspx

DECLARE @SP_Delete_RetCode	As int 

EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(InstanciaSec1)' 
		,@secondary_database = N'BDLS' 

EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(InstanciaSec2)' 
		,@secondary_database = N'BDLS' 

EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_database  
		@database = N'BDLS' 

GO

-- ****** End: Script to be run at Primary: [InstanciaA]  ******


