/****** Scripting replication configuration. Script Date: 31-10-2013 17:10:20 ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/
--DAVID
--:connect ALUNO_SIAD-PC\ONE
--RUI
--:setvar TargetDatabase MIRANDA-LAPTOP\SQL2012DEINST1
print 'Using $(TargetDatabase)'

declare @dataFolder varchar(256), @replFolder varchar(256)

SELECT 
	@dataFolder = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'Data',
	@replFolder = SUBSTRING(physical_name, 1, CHARINDEX(N'\DATA\', physical_name) ) + 'ReplData'
FROM master.sys.master_files
WHERE name = 'ASI'


/****** Installing the server as a Distributor. Script Date: 31-10-2013 17:10:20 ******/
use master

exec sp_dropdistributor @no_checks = 1

exec sp_adddistributor @distributor = N'$(TargetDatabase)', @password = N''

exec sp_adddistributiondb @database = N'distribution', @data_folder = @dataFolder, @log_folder = @dataFolder, @log_file_size = 2, 
	@min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1


use [distribution] 
if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder', @replFolder, 'user', dbo, 'table', 'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder', @replFolder, 'user', dbo, 'table', 'UIProperties'


exec sp_adddistpublisher @publisher = N'$(TargetDatabase)', @distribution_db = N'distribution', @security_mode = 1, 
	@working_directory = @replFolder, @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

