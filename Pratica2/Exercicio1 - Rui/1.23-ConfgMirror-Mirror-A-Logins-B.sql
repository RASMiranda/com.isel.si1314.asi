USE [master]
go

-- na instância 2 (principal) B
create login [NT Service\MSSQL$SQL2012DEINST1] FROM Windows   -- se não existir
create login [NT Service\MSSQL$SQL2012DEINST3] FROM Windows   -- se não existir

Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST1];
Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST3];
go