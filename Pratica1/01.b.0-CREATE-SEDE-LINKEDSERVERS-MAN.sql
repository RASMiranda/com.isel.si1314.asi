


USE [ASI]
GO

--Loja Crianças	
/****** Object:  LinkedServer [.\TWO]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_dropserver @server=N'.\TWO', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [.\TWO]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'.\TWO', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'.\TWO',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
DROP SYNONYM [dbo].[ProdutoCrianca]
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
CREATE SYNONYM [dbo].[ProdutoCrianca] FOR [.\TWO].[ASI].[dbo].[Produto]
GO



--Loja Desportitas
/****** Object:  LinkedServer [.\TWO]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_dropserver @server=N'.\THREE', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [.\TWO]    Script Date: 17-10-2013 21:48:19 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'.\THREE', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'.\THREE',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
DROP SYNONYM [dbo].[ProdutoDesp]
GO

/****** Object:  Synonym [dbo].[ProdutoCrianca]    Script Date: 17-10-2013 21:47:39 ******/
CREATE SYNONYM [dbo].[ProdutoDesp] FOR [.\THREE].[ASI].[dbo].[Produto]
GO
