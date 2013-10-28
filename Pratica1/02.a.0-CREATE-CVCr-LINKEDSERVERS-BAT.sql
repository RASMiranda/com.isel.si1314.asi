USE[ASI]
GO

--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
/*
declare @SEDE as nvarchar(max); set @SEDE = N'MIRANDA-LAPTOP\SQL2012DEINST1';
declare @CVDp as nvarchar(max); set @CVDp = N'MIRANDA-LAPTOP\SQL2012DEINST3';
*/

--Sede
EXEC master.dbo.sp_dropserver 
	--@server=@SEDE 
	@server=N'$(SEDE)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	, @droplogins='droplogins'

EXEC master.dbo.sp_addlinkedserver 
	--@server=@SEDE 
	@server=N'$(SEDE)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	, @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin 
	--@rmtsrvname=@SEDE 
	@rmtsrvname=N'$(SEDE)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	,@useself=N'True'
	,@locallogin=NULL
	,@rmtuser=NULL
	,@rmtpassword=NULL

DROP SYNONYM [dbo].[ProdutoSede]

DECLARE @SQL VARCHAR(MAX)
SET @SQL = 
	'CREATE SYNONYM [dbo].[ProdutoSede] 
	FOR ['+
		--@SEDE
		N'$(SEDE)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	+'].[ASI].[dbo].[Produto]'
EXEC (@SQL)



--Loja Desportitas
EXEC master.dbo.sp_dropserver 
	--@server=@CVDp
	@server=N'$(CVDp)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	, @droplogins='droplogins'

EXEC master.dbo.sp_addlinkedserver 
	--@server=@CVDp
	@server=N'$(CVDp)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	, @srvproduct=N'SQL Server'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin 
	--@rmtsrvname=@CVDp
	@rmtsrvname=N'$(CVDp)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	,@useself=N'True'
	,@locallogin=NULL
	,@rmtuser=NULL
	,@rmtpassword=NULL

DROP SYNONYM [dbo].[ProdutoDesp]

SET @SQL = 
	'CREATE SYNONYM [dbo].[ProdutoDesp] 
	FOR ['+
		--@CVDp
		N'$(CVDp)'--TODO.BAT: Comment SQL vars, replace @SEDE and @CVDp with N'$(SEDE)' and N'$(CVDp)'
	+'].[ASI].[dbo].[Produto]'
EXEC (@SQL)

GO
