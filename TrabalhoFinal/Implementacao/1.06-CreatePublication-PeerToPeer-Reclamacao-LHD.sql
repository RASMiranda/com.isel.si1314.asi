 while (@@TRANCOUNT > 0) rollback transaction 
/****** Scripting replication configuration. Script Date: 06-02-2014 14:36:49 ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

/****** Begin: Script to be run at Publisher ******/

/****** Installing the server as a Distributor. Script Date: 06-02-2014 14:36:49 ******/
use master
exec sp_adddistributor @distributor = N'MIRANDA-LAPTOP\SQL2012DEINST3', @password = N'', @from_scripting = 1
GO

-- Adding the agent profiles
-- Updating the agent profile defaults
exec sp_MSupdate_agenttype_default @profile_id = 1
GO
exec sp_MSupdate_agenttype_default @profile_id = 2
GO
exec sp_MSupdate_agenttype_default @profile_id = 4
GO
exec sp_MSupdate_agenttype_default @profile_id = 6
GO
exec sp_MSupdate_agenttype_default @profile_id = 11
GO

-- Adding the distribution databases
use master
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST3\MSSQL\Data', @data_file = N'distribution.MDF', @data_file_size = 5, @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST3\MSSQL\Data', @log_file = N'distribution.LDF', @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1, @from_scripting = 1
GO

------ Script Date: Replication agents checkup ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Checkup') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Checkup'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Replication agents checkup')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Replication agents checkup', @enabled = 1, @description = N'Detects replication agents that are not logging history actively.', @start_step_id = 1, @category_name = N'REPL-Checkup', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 2, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'sys.sp_replication_agent_checkup @heartbeat_interval = 10', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @database_name = N'master', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: Reinitialize subscriptions having data validation failures ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Alert Response') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Alert Response'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Reinitialize subscriptions having data validation failures')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Reinitialize subscriptions having data validation failures', @enabled = 1, @description = N'Reinitializes all subscriptions that have data validation failures.', @start_step_id = 1, @category_name = N'REPL-Alert Response', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'exec sys.sp_MSreinit_failed_subscriptions @failure_level = 1', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'master', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: Replication monitoring refresher for distribution. ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Alert Response') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Alert Response'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Replication monitoring refresher for distribution.')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Replication monitoring refresher for distribution.', @enabled = 0, @description = N'Replication monitoring refresher for distribution.', @start_step_id = 1, @category_name = N'REPL-Alert Response', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'exec dbo.sp_replmonitorrefreshjob  ', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 2147483647, @retry_interval = 1, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 64, @freq_interval = 0, @freq_subday_type = 0, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: Agent history clean up: distribution ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-History Cleanup') < 1 
  execute msdb.dbo.sp_add_category N'REPL-History Cleanup'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Agent history clean up: distribution')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Agent history clean up: distribution', @enabled = 1, @description = N'Removes replication agent history from the distribution database.', @start_step_id = 1, @category_name = N'REPL-History Cleanup', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'EXEC dbo.sp_MShistory_cleanup @history_retention = 48', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: Distribution clean up: distribution ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Distribution Cleanup') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Distribution Cleanup'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Distribution clean up: distribution')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Distribution clean up: distribution', @enabled = 1, @description = N'Removes replicated transactions from the distribution database.', @start_step_id = 1, @category_name = N'REPL-Distribution Cleanup', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'EXEC dbo.sp_MSdistribution_cleanup @min_distretention = 0, @max_distretention = 72', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 500, @active_end_time = 459
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

-- Adding the distribution publishers
exec sp_adddistpublisher @publisher = N'MIRANDA-LAPTOP\SQL2012DEINST3', @distribution_db = N'distribution', @security_mode = 1, @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST3\MSSQL\ReplData', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

------ Script Date: MIRANDA-LAPTOP\SQL2012DEINST3-ASIVesteLoja-1 ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-LogReader') < 1 
  execute msdb.dbo.sp_add_category N'REPL-LogReader'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'MIRANDA-LAPTOP\SQL2012DEINST3-ASIVesteLoja-1')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'MIRANDA-LAPTOP\SQL2012DEINST3-ASIVesteLoja-1', @enabled = 1, @description = N'No description available.', @start_step_id = 1, @category_name = N'REPL-LogReader', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Log Reader Agent startup message.', @subsystem = N'TSQL', @command = N'sp_MSadd_logreader_history @perfmon_increment = 0, @agent_id = 1, @runstatus = 1, 
                    @comments = N''Starting agent.''', @cmdexec_success_code = 0, @on_success_action = 3, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 2, @step_name = N'Run agent.', @subsystem = N'LogReader', @command = N'-Publisher [MIRANDA-LAPTOP\SQL2012DEINST3] -PublisherDB [ASIVesteLoja] -Distributor [MIRANDA-LAPTOP\SQL2012DEINST3] -DistributorSecurityMode 1  -Continuous', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 2147483647, @retry_interval = 1, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 3, @step_name = N'Detect nonlogged agent shutdown.', @subsystem = N'TSQL', @command = N'sp_MSdetect_nonlogged_shutdown @subsystem = ''LogReader'', @agent_id = 1', @cmdexec_success_code = 0, @on_success_action = 2, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 64, @freq_interval = 0, @freq_subday_type = 0, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-3 ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Distribution') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Distribution'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-3')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-3', @enabled = 1, @description = N'No description available.', @start_step_id = 1, @category_name = N'REPL-Distribution', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Distribution Agent startup message.', @subsystem = N'TSQL', @command = N'sp_MSadd_distribution_history @perfmon_increment = 0, @agent_id = 3, @runstatus = 1,  
                    @comments = N''Starting agent.''', @cmdexec_success_code = 0, @on_success_action = 3, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 2, @step_name = N'Run agent.', @subsystem = N'Distribution', @command = N'-Subscriber [MIRANDA-LAPTOP\SQL2012DEINST1] -SubscriberDB [ASIVesteSede] -Publisher [MIRANDA-LAPTOP\SQL2012DEINST3] -Distributor [MIRANDA-LAPTOP\SQL2012DEINST3] -DistributorSecurityMode 1 -Publication [PeerToPeer-Reclamacao] -PublisherDB [ASIVesteLoja]    -Continuous', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 2147483647, @retry_interval = 1, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 3, @step_name = N'Detect nonlogged agent shutdown.', @subsystem = N'TSQL', @command = N'sp_MSdetect_nonlogged_shutdown @subsystem = ''Distribution'', @agent_id = 3', @cmdexec_success_code = 0, @on_success_action = 2, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 64, @freq_interval = 0, @freq_subday_type = 0, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

------ Script Date: MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-4 ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Distribution') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Distribution'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-4')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-4', @enabled = 1, @description = N'No description available.', @start_step_id = 1, @category_name = N'REPL-Distribution', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Distribution Agent startup message.', @subsystem = N'TSQL', @command = N'sp_MSadd_distribution_history @perfmon_increment = 0, @agent_id = 4, @runstatus = 1,  
                    @comments = N''Starting agent.''', @cmdexec_success_code = 0, @on_success_action = 3, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 2, @step_name = N'Run agent.', @subsystem = N'Distribution', @command = N'-Subscriber [MIRANDA-LAPTOP\SQL2012DEINST2] -SubscriberDB [ASIVesteLoja] -Publisher [MIRANDA-LAPTOP\SQL2012DEINST3] -Distributor [MIRANDA-LAPTOP\SQL2012DEINST3] -DistributorSecurityMode 1 -Publication [PeerToPeer-Reclamacao] -PublisherDB [ASIVesteLoja]    -Continuous', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 3, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 2147483647, @retry_interval = 1, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 3, @step_name = N'Detect nonlogged agent shutdown.', @subsystem = N'TSQL', @command = N'sp_MSdetect_nonlogged_shutdown @subsystem = ''Distribution'', @agent_id = 4', @cmdexec_success_code = 0, @on_success_action = 2, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'distribution', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 64, @freq_interval = 0, @freq_subday_type = 0, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO

exec sp_addsubscriber @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST1', @type = 0, @description = N''
GO
exec sp_addsubscriber @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST2', @type = 0, @description = N''
GO

------ Script Date: Expired subscription clean up ------
begin transaction 
  DECLARE @JobID BINARY(16)
  DECLARE @ReturnCode INT
  SELECT @ReturnCode = 0
if (select count(*) from msdb.dbo.syscategories where name = N'REPL-Subscription Cleanup') < 1 
  execute msdb.dbo.sp_add_category N'REPL-Subscription Cleanup'

select @JobID = job_id from msdb.dbo.sysjobs where (name = N'Expired subscription clean up')
if (@JobID is NULL)
BEGIN
  execute @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'Expired subscription clean up', @enabled = 1, @description = N'Detects and removes expired subscriptions from published databases.', @start_step_id = 1, @category_name = N'REPL-Subscription Cleanup', @owner_login_name = N'MIRANDA-LAPTOP\Rui Miranda', @notify_level_eventlog = 0, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'Run agent.', @subsystem = N'TSQL', @command = N'EXEC sys.sp_expired_subscription_cleanup', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @database_name = N'master', @retry_attempts = 0, @retry_interval = 0, @os_run_priority = 0, @flags = 0
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Replication agent schedule.', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 1, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20140206, @active_end_date = 99991231, @active_start_time = 10000, @active_end_time = 235959
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

  execute @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'MIRANDA-LAPTOP\SQL2012DEINST3'
  if (@@ERROR <> 0 OR @ReturnCode <> 0) goto QuitWithRollback

END

commit transaction 
goto EndSave 
QuitWithRollback: 
  if (@@TRANCOUNT > 0) rollback transaction 
EndSave:
GO


/****** End: Script to be run at Publisher ******/


-- Enabling the replication database
use master
exec sp_replicationdboption @dbname = N'ASIVesteLoja', @optname = N'publish', @value = N'true'
GO

exec [ASIVesteLoja].sys.sp_addlogreader_agent @publisher_security_mode = 1, @job_name = N'MIRANDA-LAPTOP\SQL2012DEINST3-ASIVesteLoja-1', @job_login = N'MIRANDA-LAPTOP\Rui Miranda', @job_password = N'mitra'
GO
exec [ASIVesteLoja].sys.sp_addqreader_agent @job_name = null, @frompublisher = 1, @job_login = null, @job_password = null
GO
-- Adding the transactional publication
use [ASIVesteLoja]
declare @originatorid as bigint;set @originatorid=0;
tryagain:
begin try
	set @originatorid = @originatorid +1;
	exec sp_addpublication @publication = N'PeerToPeer-Reclamacao', @description = N'Peer-to-Peer publication of database ''ASIVesteSede'' from Publisher ''MIRANDA-LAPTOP\SQL2012DEINST1''.', @sync_method = N'native', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'false', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'true', @enabled_for_p2p = N'true', @enabled_for_het_sub = N'false', @p2p_conflictdetection = N'true', @p2p_originator_id = @originatorid
end try
begin catch
	declare @message as varchar(4000); set @message = N'Tentar o próximo p2p originator id. AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
	GOTO tryagain
end catch
GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'sa'
GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'MIRANDA-LAPTOP\Rui Miranda'
GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'NT SERVICE\SQLAgent$SQL2012DEINST3'
GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'NT SERVICE\Winmgmt'
GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'NT SERVICE\SQLWriter'
GO
--exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'NT Service\MSSQL$SQL2012DEINST3'
--GO
exec sp_grant_publication_access @publication = N'PeerToPeer-Reclamacao', @login = N'distributor_admin'
GO

-- Adding the transactional articles
use [ASIVesteLoja]
exec sp_addarticle @publication = N'PeerToPeer-Reclamacao', @article = N'Reclamacao', @source_owner = N'dbo', @source_object = N'Reclamacao', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008035DDF, @identityrangemanagementoption = N'manual', @destination_table = N'Reclamacao', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboReclamacao468852877581993472333818430]', @del_cmd = N'CALL [sp_MSdel_dboReclamacao468852877581993472333818430]', @upd_cmd = N'SCALL [sp_MSupd_dboReclamacao468852877581993472333818430]'
GO

-- Adding the transactional subscriptions
use [ASIVesteLoja]
begin try
	exec sp_addsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST1', @destination_db = N'ASIVesteSede', @subscription_type = N'Push', @sync_type = N'replication support only', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
end try
begin catch
	while(@@TRANCOUNT > 0) 
		commit transaction 
	exec sp_addsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST1', @destination_db = N'ASIVesteSede', @subscription_type = N'Push', @sync_type = N'replication support only', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
end catch
exec sp_addpushsubscription_agent @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST1', @subscriber_db = N'ASIVesteSede', @job_login = N'MIRANDA-LAPTOP\Rui Miranda', @job_password = N'mitra', @subscriber_security_mode = 1, @job_name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-3', @dts_package_location = N'Distributor'
GO
use [ASIVesteLoja]
begin try
	exec sp_addsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST2', @destination_db = N'ASIVesteLoja', @subscription_type = N'Push', @sync_type = N'replication support only', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
	end try
begin catch
	while(@@TRANCOUNT > 0) 
		commit transaction 
	exec sp_addsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST2', @destination_db = N'ASIVesteLoja', @subscription_type = N'Push', @sync_type = N'replication support only', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
end catch
exec sp_addpushsubscription_agent @publication = N'PeerToPeer-Reclamacao', @subscriber = N'MIRANDA-LAPTOP\SQL2012DEINST2', @subscriber_db = N'ASIVesteLoja', @job_login = N'MIRANDA-LAPTOP\Rui Miranda', @job_password = N'mitra', @subscriber_security_mode = 1, @job_name = N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-4', @dts_package_location = N'Distributor'
GO

----Star Agents Jobs
USE msdb ;
GO


EXEC dbo.sp_start_job N'Replication agents checkup' ;
GO

EXEC dbo.sp_start_job N'Replication monitoring refresher for distribution.' ;
GO

EXEC dbo.sp_start_job N'Reinitialize subscriptions having data validation failures' ;
GO

EXEC dbo.sp_start_job N'Agent history clean up: distribution' ;
GO

EXEC dbo.sp_start_job N'Distribution clean up: distribution' ;
GO

EXEC dbo.sp_start_job N'Expired subscription clean up' ;
GO

EXEC dbo.sp_start_job N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-4' ;
GO

EXEC dbo.sp_start_job N'MIRANDA-LAPTOP\SQL201-ASIVesteLoja-PeerToPeer-Reclamacao-MIRANDA-LAPTOP\SQL201-3' ;
GO

---lsc
EXEC dbo.sp_start_job N'MIRANDA-LAPTOP\SQL2012DEINST3-ASIVesteLoja-1' ;
GO


