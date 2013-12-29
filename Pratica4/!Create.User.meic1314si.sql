USE [master]
GO

/****** Object:  Login [meic1314si]    Script Date: 26-12-2013 23:39:38 ******/
DROP LOGIN [meic1314si]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [meic1314si]    Script Date: 26-12-2013 23:39:38 ******/
CREATE LOGIN [meic1314si] WITH PASSWORD=N'QHÜ÷Qf|±RÕbëu
¡à=-Ê\^ª|', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO

ALTER LOGIN [meic1314si] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [securityadmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [serveradmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [setupadmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [processadmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [diskadmin] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [dbcreator] ADD MEMBER [meic1314si]
GO

ALTER SERVER ROLE [bulkadmin] ADD MEMBER [meic1314si]
GO


