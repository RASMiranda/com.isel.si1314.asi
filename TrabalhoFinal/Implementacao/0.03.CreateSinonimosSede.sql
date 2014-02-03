:setvar LSC aluno_siad-pc\two
:setvar LHD aluno_siad-pc\three

USE [ASIVesteSede]
GO


BEGIN TRY
	-- Loja Senhora e Crianças 
	EXEC master.dbo.sp_dropserver @server=N'$(LSC)', @droplogins='droplogins'

	EXEC master.dbo.sp_addlinkedserver @server = N'$(LSC)', @srvproduct=N'SQL Server'
	-- For security reasons the linked server remote logins password is changed with ########
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(LSC)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
END TRY
BEGIN CATCH
END CATCH;
GO

if OBJECT_ID('ProdutoSC') is not null
	DROP SYNONYM [dbo].[ProdutoSC]

CREATE SYNONYM [dbo].[ProdutoSC] FOR [$(LSC)].[ASIVesteLoja].[dbo].[Produto]
GO


BEGIN TRY
	-- Loja Homens e Desportistas
	EXEC master.dbo.sp_dropserver @server=N'$(LHD)', @droplogins='droplogins'

	EXEC master.dbo.sp_addlinkedserver @server = N'$(LHD)', @srvproduct=N'SQL Server'
	-- For security reasons the linked server remote logins password is changed with ######## */
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(LHD)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
END TRY
BEGIN CATCH
END CATCH;
GO

if OBJECT_ID('ProdutoHD') is not null
	DROP SYNONYM [dbo].[ProdutoHD]

CREATE SYNONYM [dbo].[ProdutoHD] FOR [$(LHD)].[ASIVesteLoja].[dbo].[Produto]
GO

