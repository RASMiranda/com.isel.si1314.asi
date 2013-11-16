-- Execute the following statements at the Primary to configure Log Shipping 
-- for the database [SERVER_INST_A].[BDLS],
-- The script needs to be run at the Primary in the context of the [msdb] database.  
------------------------------------------------------------------------------------- 

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar backup_directory "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup"
--:setvar backup_share "\\MIRANDA-LAPTOP\Backup"
--:setvar backup_source_directory "\\MIRANDA-LAPTOP\Backup"
--:setvar primary_server "MIRANDA-LAPTOP\SQL2012DEINST1"
--:setvar secondary_server_B "MIRANDA-LAPTOP\SQL2012DEINST2"
--:setvar secondary_server_C "MIRANDA-LAPTOP\SQL2012DEINST3"
--:setvar backup_destination_directory_B "\\MIRANDA-LAPTOP\BackupLogShipINST2BTemp"
--:setvar restore_mode_B 0
--:setvar disconnect_users_B 0
--:setvar backup_destination_directory_C "\\MIRANDA-LAPTOP\BackupLogShipINST3cTemp"
--:setvar restore_mode_C 1
--:setvar disconnect_users_C 1


-- Removing the Log Shipping configuration 
-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******
:connect $(primary_server)
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
:connect $(primary_server)
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
GO
-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******
-- Execute the following statements at the Secondary to configure Log Shipping 
-- for the database [SERVER_INST_B].[BDLS],
-- the script needs to be run at the Secondary in the context of the [msdb] database. 
------------------------------------------------------------------------------------- 
-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Secondary: [SERVER_INST_B] ******
:connect $(secondary_server_B)

use [msdb]
GO

DECLARE @LS_Secondary__CopyJobId	AS uniqueidentifier 
DECLARE @LS_Secondary__RestoreJobId	AS uniqueidentifier 
DECLARE @LS_Secondary__SecondaryId	AS uniqueidentifier 
DECLARE @LS_Add_RetCode	As int 


EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary 
		@primary_server = N'$(primary_server)' 
		,@primary_database = N'BDLS' 
		,@backup_source_directory = N'$(backup_source_directory)' 
		,@backup_destination_directory = N'$(backup_destination_directory_B)' 
		,@copy_job_name = N'LSCopy_SERVER_INST_A_BDLS' 
		,@restore_job_name = N'LSRestore_SERVER_INST_A_BDLS' 
		,@file_retention_period = 4320 
		,@overwrite = 1 
		,@copy_job_id = @LS_Secondary__CopyJobId OUTPUT 
		,@restore_job_id = @LS_Secondary__RestoreJobId OUTPUT 
		,@secondary_id = @LS_Secondary__SecondaryId OUTPUT 

IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

DECLARE @LS_SecondaryCopyJobScheduleUID	As uniqueidentifier 
DECLARE @LS_SecondaryCopyJobScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'DefaultCopyJobSchedule' 
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
		,@schedule_uid = @LS_SecondaryCopyJobScheduleUID OUTPUT 
		,@schedule_id = @LS_SecondaryCopyJobScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_Secondary__CopyJobId 
		,@schedule_id = @LS_SecondaryCopyJobScheduleID  

DECLARE @LS_SecondaryRestoreJobScheduleUID	As uniqueidentifier 
DECLARE @LS_SecondaryRestoreJobScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'DefaultRestoreJobSchedule' 
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
		,@schedule_uid = @LS_SecondaryRestoreJobScheduleUID OUTPUT 
		,@schedule_id = @LS_SecondaryRestoreJobScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_Secondary__RestoreJobId 
		,@schedule_id = @LS_SecondaryRestoreJobScheduleID  


END 


DECLARE @LS_Add_RetCode2	As int 


IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database 
		@secondary_database = N'BDLS' 
		,@primary_server = N'$(primary_server)' 
		,@primary_database = N'BDLS' 
		,@restore_delay = 0 
		,@restore_mode = N'$(restore_mode_B)'  
		,@disconnect_users	= N'$(disconnect_users_B)'  
		,@restore_threshold = 45   
		,@threshold_alert_enabled = 1 
		,@history_retention_period	= 5760 
		,@overwrite = 1 

END 


IF (@@error = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary__CopyJobId 
		,@enabled = 1 

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary__RestoreJobId 
		,@enabled = 1 

END 
GO

-- ****** End: Script to be run at Secondary: [SERVER_INST_B] ******

-- Execute the following statements at the Secondary to configure Log Shipping 
-- for the database [SERVER_INST_C].[BDLS],
-- the script needs to be run at the Secondary in the context of the [msdb] database. 
------------------------------------------------------------------------------------- 
-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Secondary: [SERVER_INST_C] ******
:connect $(secondary_server_C)

use [msdb]
GO

DECLARE @LS_Secondary__CopyJobId	AS uniqueidentifier 
DECLARE @LS_Secondary__RestoreJobId	AS uniqueidentifier 
DECLARE @LS_Secondary__SecondaryId	AS uniqueidentifier 
DECLARE @LS_Add_RetCode	As int 


EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary  
		@primary_server = N'$(primary_server)' 
		,@primary_database = N'BDLS' 
		,@backup_source_directory = N'$(backup_source_directory)' 
		,@backup_destination_directory = N'$(backup_destination_directory_C)'  
		,@copy_job_name = N'LSCopy_SERVER_INST_A_BDLS' 
		,@restore_job_name = N'LSRestore_SERVER_INST_A_BDLS'  
		,@file_retention_period = 4320 
		,@overwrite = 1 
		,@copy_job_id = @LS_Secondary__CopyJobId OUTPUT 
		,@restore_job_id = @LS_Secondary__RestoreJobId OUTPUT 
		,@secondary_id = @LS_Secondary__SecondaryId OUTPUT 

IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

DECLARE @LS_SecondaryCopyJobScheduleUID	As uniqueidentifier 
DECLARE @LS_SecondaryCopyJobScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'DefaultCopyJobSchedule' 
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
		,@schedule_uid = @LS_SecondaryCopyJobScheduleUID OUTPUT 
		,@schedule_id = @LS_SecondaryCopyJobScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_Secondary__CopyJobId 
		,@schedule_id = @LS_SecondaryCopyJobScheduleID  

DECLARE @LS_SecondaryRestoreJobScheduleUID	As uniqueidentifier 
DECLARE @LS_SecondaryRestoreJobScheduleID	AS int 


EXEC msdb.dbo.sp_add_schedule 
		@schedule_name =N'DefaultRestoreJobSchedule' 
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
		,@schedule_uid = @LS_SecondaryRestoreJobScheduleUID OUTPUT 
		,@schedule_id = @LS_SecondaryRestoreJobScheduleID OUTPUT 

EXEC msdb.dbo.sp_attach_schedule 
		@job_id = @LS_Secondary__RestoreJobId 
		,@schedule_id = @LS_SecondaryRestoreJobScheduleID  


END 


DECLARE @LS_Add_RetCode2	As int 


IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database 
		@secondary_database = N'BDLS' 
		,@primary_server = N'$(primary_server)' 
		,@primary_database = N'BDLS' 
		,@restore_delay = 0 
		,@restore_mode = N'$(restore_mode_C)'  
		,@disconnect_users	= N'$(disconnect_users_C)'   
		,@restore_threshold = 45   
		,@threshold_alert_enabled = 1 
		,@history_retention_period	= 5760 
		,@overwrite = 1 

END 


IF (@@error = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary__CopyJobId 
		,@enabled = 1 

EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary__RestoreJobId 
		,@enabled = 1 

END 
GO

-- ****** End: Script to be run at Secondary: [SERVER_INST_C] ******



