--:SETVAR SEDE ALUNO_SIAD-PC\ONE
--:SETVAR LSC ALUNO_SIAD-PC\TWO
--:SETVAR LHD ALUNO_SIAD-PC\THREE

while (@@TRANCOUNT > 0) rollback transaction 
GO

-- Dropping the transactional subscriptions
use [ASIVesteSede]

begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'$(LSC)', @destination_db = N'ASIVesteLoja', @article = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO


begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'$(LHD)', @destination_db = N'ASIVesteLoja', @article = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the transactional articles

begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @article = N'Reclamacao', @subscriber = N'all', @destination_db = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

begin try
	exec sp_droparticle @publication = N'PeerToPeer-Reclamacao', @article = N'Reclamacao', @force_invalidate_snapshot = 1
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the transactional publication

begin try
	exec sp_droppublication @publication = N'PeerToPeer-Reclamacao'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO



/****** Scripting removing replication objects. Script Date: 06-02-2014 14:30:53 ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

-- Disabling the replication database
use [master]

begin try
	exec sp_replicationdboption @dbname = N'ASIVesteSede', @optname = N'publish', @value = N'false'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the registered subscriber

begin try
	exec sp_dropsubscriber @subscriber = N'$(LSC)'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the registered subscriber

begin try
	exec sp_dropsubscriber @subscriber = N'$(LHD)'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the distribution publishers

begin try
	exec sp_dropdistpublisher @publisher = N'$(SEDE)'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the distribution databases

begin try
	exec sp_dropdistributiondb @database = N'distribution'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

/****** Uninstalling the server as a Distributor. Script Date: 06-02-2014 14:30:53 ******/

begin try
	exec sp_dropdistributor @no_checks = 1, @ignore_distributor = 1
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO
