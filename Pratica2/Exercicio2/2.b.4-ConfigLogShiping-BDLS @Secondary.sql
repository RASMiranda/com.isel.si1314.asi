--:setvar InstanciaPri aluno_siad-pc\two
--:setvar InstanciaSec aluno_siad-pc\three


--:setvar backup_share \\Vboxsvr\asi
--:setvar backup_source_directory C:\ASITemp
--:setvar backup_destination_directory C:\ASITemp
--:setvar copy_job_name LSCopy_InstanciaAB_BDLS

--:connect $(InstanciaSec)



-- Execute the following statements at the Secondary to configure Log Shipping 
-- for the database [$(InstanciaSec)].[BDLS],
-- the script needs to be run at the Secondary in the context of the [msdb] database. 
------------------------------------------------------------------------------------- 


-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Secondary: [$(InstanciaSec)] ******

DECLARE @LS_Secondary__CopyJobId	AS uniqueidentifier
DECLARE @LS_Secondary__RestoreJobId	AS uniqueidentifier
DECLARE @LS_Secondary__SecondaryId	AS uniqueidentifier
DECLARE @LS_Add_RetCode	As int 

print 'Running Add_log_shipping_secondary_primary @$(InstanciaSec)'
EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary 
		@primary_server = N'$(InstanciaPri)' 
		,@primary_database = N'BDLS' 
		,@backup_source_directory = N'$(backup_source_directory)'
		,@backup_destination_directory = N'$(backup_destination_directory)'
		,@copy_job_name = N'$(copy_job_name)'
		,@restore_job_name = N'LSRestore_InstanciaPri_BDLS_Desastre' 
		,@file_retention_period = 4320 
		,@overwrite = 1 
		,@copy_job_id = @LS_Secondary__CopyJobId OUTPUT 
		,@restore_job_id = @LS_Secondary__RestoreJobId OUTPUT 
		,@secondary_id = @LS_Secondary__SecondaryId OUTPUT 

IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

	DECLARE @LS_SecondaryCopyJobScheduleUID	As uniqueidentifier
	DECLARE @LS_SecondaryCopyJobScheduleID	AS int 

	print 'Running Add_schedule @$(InstanciaSec)'
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

	print 'Running Attach_schedule @$(InstanciaSec) - LS_Secondary__CopyJobId'
	EXEC msdb.dbo.sp_attach_schedule 
			@job_id = @LS_Secondary__CopyJobId 
			,@schedule_id = @LS_SecondaryCopyJobScheduleID  

	DECLARE @LS_SecondaryRestoreJobScheduleUID	As uniqueidentifier
	DECLARE @LS_SecondaryRestoreJobScheduleID	AS int 

	print 'Running Add_schedule @$(InstanciaSec)'
	EXEC msdb.dbo.sp_add_schedule 
			@schedule_name =N'DefaultRestoreJobSchedule_Desastre' 
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

	print 'Running Attach_schedule @$(InstanciaSec) - LS_Secondary__RestoreJobId'
	EXEC msdb.dbo.sp_attach_schedule 
			@job_id = @LS_Secondary__RestoreJobId 
			,@schedule_id = @LS_SecondaryRestoreJobScheduleID  


END 


DECLARE @LS_Add_RetCode2	As int 


IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

	print 'Running Add_log_shipping_secondary_database @$(InstanciaSec) > $(InstanciaPri)'
	EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database 
			@secondary_database = N'BDLS' 
			,@primary_server = N'$(InstanciaPri)' 
			,@primary_database = N'BDLS' 
			,@restore_delay = 0 
			,@restore_mode = 1 
			,@disconnect_users	= 0 
			,@restore_threshold = 45   
			,@threshold_alert_enabled = 1 
			,@history_retention_period	= 5760 
			,@overwrite = 1 

END 


IF (@@error = 0 AND @LS_Add_RetCode = 0) 
BEGIN 

	print 'Running Update_job @$(InstanciaSec) - LS_Secondary__CopyJobId '
	EXEC msdb.dbo.sp_update_job 
			@job_id = @LS_Secondary__CopyJobId 
			,@enabled = 1 

	print 'Running Update_job @$(InstanciaSec) - LS_Secondary__RestoreJobId '
	EXEC msdb.dbo.sp_update_job 
			@job_id = @LS_Secondary__RestoreJobId 
			,@enabled = 1 

END 

print ''
GO

-- ****** End: Script to be run at Secondary: [$(InstanciaSec)] ******
