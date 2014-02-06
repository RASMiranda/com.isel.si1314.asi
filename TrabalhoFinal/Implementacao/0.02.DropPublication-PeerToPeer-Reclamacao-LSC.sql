--TODO: COMMENT SETVAR
:SETVAR SEDE MIRANDA-LAPTOP\SQL2012DEINST1
:SETVAR LSC MIRANDA-LAPTOP\SQL2012DEINST2
:SETVAR LHD MIRANDA-LAPTOP\SQL2012DEINST3

while (@@TRANCOUNT > 0) rollback transaction 
GO
-- Dropping the transactional subscriptions
use [ASIVesteLoja]
begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'$(SEDE)', @destination_db = N'ASIVesteSede', @article = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO
use [ASIVesteLoja]
begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @subscriber = N'$(LHD)', @destination_db = N'ASIVesteLoja', @article = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the transactional articles
use [ASIVesteLoja]
begin try
	exec sp_dropsubscription @publication = N'PeerToPeer-Reclamacao', @article = N'Reclamacao', @subscriber = N'all', @destination_db = N'all'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO
	use [ASIVesteLoja]
	begin try
	exec sp_droparticle @publication = N'PeerToPeer-Reclamacao', @article = N'Reclamacao', @force_invalidate_snapshot = 1
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the transactional publication
use [ASIVesteLoja]
begin try
	exec sp_droppublication @publication = N'PeerToPeer-Reclamacao'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO



/****** Scripting removing replication objects. Script Date: 06-02-2014 14:35:14 ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

-- Disabling the replication database
use master
exec sp_replicationdboption @dbname = N'ASIVesteLoja', @optname = N'publish', @value = N'false'
GO


-- Dropping the registered subscriber
begin try
	exec sp_dropsubscriber @subscriber = N'$(SEDE)'
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
	exec sp_dropdistpublisher @publisher = N'$(LSC)'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

-- Dropping the distribution databases
use master
begin try
	exec sp_dropdistributiondb @database = N'distribution'
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch
GO

/****** Uninstalling the server as a Distributor. Script Date: 06-02-2014 14:35:15 ******/
use master
begin try
	exec sp_dropdistributor @no_checks = 1, @ignore_distributor = 1
end try
begin catch
	declare @message as varchar(4000); set @message = N'AVISO: '+ERROR_MESSAGE()
	raiserror (@message,0,1);
end catch	
GO
