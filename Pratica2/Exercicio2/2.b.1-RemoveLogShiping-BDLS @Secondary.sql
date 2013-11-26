--:setvar InstanciaSec aluno_siad-pc\three


--:connect $(InstanciaSec)


-- Removing the Log Shipping configuration 

-- ****** Begin: Script to be run at Secondary: [InstanciaSec] ******

use [msdb]
GO
-- http://msdn.microsoft.com/en-us/library/ms191297.aspx

DECLARE @SP_Delete_RetCode	As int 

EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_secondary_database  
		@secondary_database  = N'BDLS' 

GO
-- ****** End: Script to be run at Primary: [InstanciaSec]  ******

