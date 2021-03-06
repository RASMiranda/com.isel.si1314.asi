--:setvar LSC MIRANDA-LAPTOP\SQL2012DEINST2
--:setvar LHD MIRANDA-LAPTOP\SQL2012DEINST3

USE [ASIVesteSede]
GO


BEGIN TRY
	-- Loja Senhora e Crian�as 
	EXEC master.dbo.sp_dropserver @server=N'$(LSC)', @droplogins='droplogins'
END TRY
BEGIN CATCH
--ainda nao existe
END CATCH;

BEGIN TRY
	EXEC master.dbo.sp_addlinkedserver @server = N'$(LSC)', @srvproduct=N'SQL Server'
	-- For security reasons the linked server remote logins password is changed with ########
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(LSC)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
END TRY
BEGIN CATCH
--ja existe
END CATCH;
GO

if OBJECT_ID('ProdutoSC') is not null
	DROP SYNONYM [dbo].[ProdutoSC]

CREATE SYNONYM [dbo].[ProdutoSC] FOR [$(LSC)].[ASIVesteLoja].[dbo].[Produto]
GO


BEGIN TRY
	-- Loja Homens e Desportistas
	EXEC master.dbo.sp_dropserver @server=N'$(LHD)', @droplogins='droplogins'
END TRY
BEGIN CATCH
--ainda nao existe
END CATCH;

BEGIN TRY
	EXEC master.dbo.sp_addlinkedserver @server = N'$(LHD)', @srvproduct=N'SQL Server'
	-- For security reasons the linked server remote logins password is changed with ######## */
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(LHD)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
END TRY
BEGIN CATCH
--j� existe
END CATCH;
GO

if OBJECT_ID('ProdutoHD') is not null
	DROP SYNONYM [dbo].[ProdutoHD]

CREATE SYNONYM [dbo].[ProdutoHD] FOR [$(LHD)].[ASIVesteLoja].[dbo].[Produto]
GO

