USE [ASI]
GO

--Loja Crianças	
/****** Object:  LinkedServer [MIRANDA-LAPTOP\SQL2012DEINST2]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_dropserver @server=N'MIRANDA-LAPTOP\SQL2012DEINST2', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [MIRANDA-LAPTOP\SQL2012DEINST2]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'MIRANDA-LAPTOP\SQL2012DEINST2', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MIRANDA-LAPTOP\SQL2012DEINST2',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
DROP SYNONYM [dbo].[ProdutoCrianca]
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
CREATE SYNONYM [dbo].[ProdutoCrianca] FOR [MIRANDA-LAPTOP\SQL2012DEINST2].[ASI].[dbo].[Produto]
GO



--Loja Desportitas
/****** Object:  LinkedServer [MIRANDA-LAPTOP\SQL2012DEINST2]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_dropserver @server=N'MIRANDA-LAPTOP\SQL2012DEINST3', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [MIRANDA-LAPTOP\SQL2012DEINST2]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'MIRANDA-LAPTOP\SQL2012DEINST3', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MIRANDA-LAPTOP\SQL2012DEINST3',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
DROP SYNONYM [dbo].[ProdutoDesp]
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
CREATE SYNONYM [dbo].[ProdutoDesp] FOR [MIRANDA-LAPTOP\SQL2012DEINST3].[ASI].[dbo].[Produto]
GO
