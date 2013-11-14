-- Execute the following statements at the Primary to configure Log Shipping 
-- for the database [SERVER_INST_A].[BDLS],
-- The script needs to be run at the Primary in the context of the [msdb] database.  
------------------------------------------------------------------------------------- 

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
:setvar backup_directory "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup"
:setvar backup_share "\\MIRANDA-LAPTOP\Backup"
:setvar primary_server "MIRANDA-LAPTOP\SQL2012DEINST1"
:setvar secondary_server_B "MIRANDA-LAPTOP\SQL2012DEINST2"
:setvar secondary_server_C "MIRANDA-LAPTOP\SQL2012DEINST3"

-- Removing the Log Shipping configuration 
-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******
use [msdb]
GO

DECLARE @SP_Delete_RetCode	As int 
EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(secondary_server_B)' 
		,@secondary_database = N'BDLS' 

EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(secondary_server_C)' 
		,@secondary_database = N'BDLS' 
GO
-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******
		
-- ****** Begin: Script to be run at Secondary: [SERVER_INST_B] ******
:connect $(secondary_server_B)
use [msdb]
GO
DECLARE @SP_Delete_RetCode	As int 
EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_secondary_database  
		@secondary_database  = N'BDLS' 
GO
-- ****** End: Script to be run at Secondary: [SERVER_INST_B] ******
		
-- ****** Begin: Script to be run at Secondary: [SERVER_INST_C] ******
:connect $(secondary_server_C)
use [msdb]
GO
DECLARE @SP_Delete_RetCode	As int 
EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_secondary_database  
		@secondary_database  = N'BDLS' 
GO
-- ****** End: Script to be run at Secondary: [SERVER_INST_C] ******

-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******
:connect $(primary_server)
use [msdb]
GO
DECLARE @SP_Delete_RetCode	As int 
EXEC @SP_Delete_RetCode = master.dbo.sp_delete_log_shipping_primary_database  
		@database = N'BDLS' 
GO
-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******

-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******
use [msdb]
GO

DECLARE @LS_BackupJobId	AS uniqueidentifier 
DECLARE @LS_PrimaryId	AS uniqueidentifier 
DECLARE @SP_Add_RetCode	As int 


EXEC @SP_Add_RetCode = master.dbo.sp_add_log_shipping_primary_database 
		@database = N'BDLS' 
		,@backup_directory = N'$(backup_directory)' 
		,@backup_share = N'$(backup_share)' 
		,@backup_job_name = N'LSBackup_BDLS' 
		,@backup_retention_period = 4320
		,@backup_compression = 2
		,@backup_threshold = 60 
		,@threshold_alert_enabled = 1
		,@history_retention_period = 5760 
		,@backup_job_id = @LS_BackupJobId OUTPUT 
		,@primary_id = @LS_PrimaryId OUTPUT 
		,@overwrite = 1 


IF (@@ERROR = 0 AND @SP_Add_RetCode = 0) 
BEGIN 

DECLARE @LS_BackUpScheduleUID	As uniqueidentifier 
DECLARE @LS_BackUpScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'LSBackupSchedule_SERVER_INST_A' 
		,@enabled = 1 
		,@freq_type = 4 
		,@freq_interval = 1 
		,@freq_subday_type = 2 
		,@freq_subday_interval = 30 
		,@freq_recurrence_factor = 0 
		,@active_start_date = 20131113 
		,@active_end_date = 99991231 
		,@active_start_time = 0 
		,@active_end_time = 235900 
		,@schedule_uid = @LS_BackUpScheduleUID OUTPUT 
		,@schedule_id = @LS_BackUpScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_BackupJobId 
		,@schedule_id = @LS_BackUpScheduleID  

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_BackupJobId 
		,@enabled = 1 


END 


EXEC master.dbo.sp_add_log_shipping_alert_job 

EXEC master.dbo.sp_add_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(secondary_server_B)' 
		,@secondary_database = N'BDLS' 
		,@overwrite = 1 

EXEC master.dbo.sp_add_log_shipping_primary_secondary 
		@primary_database = N'BDLS' 
		,@secondary_server = N'$(secondary_server_C)' 
		,@secondary_database = N'BDLS' 
		,@overwrite = 1 

-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******



