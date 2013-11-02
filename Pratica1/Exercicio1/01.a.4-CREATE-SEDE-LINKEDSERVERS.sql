USE[ASI]
GO

--Loja Crianças	
EXEC master.dbo.sp_dropserver @server=N'$(CVCr)', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'$(CVCr)', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(CVCr)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

DROP SYNONYM [dbo].[ProdutoCrianca]
GO

CREATE SYNONYM [dbo].[ProdutoCrianca] FOR [$(CVCr)].[ASI].[dbo].[Produto]
GO



--Loja Desportitas
EXEC master.dbo.sp_dropserver @server=N'$(CVDp)', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'$(CVDp)', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'$(CVDp)',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

DROP SYNONYM [dbo].[ProdutoDesp]
GO

CREATE SYNONYM [dbo].[ProdutoDesp] FOR [$(CVDp)].[ASI].[dbo].[Produto]
GO
