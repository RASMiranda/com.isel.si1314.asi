USE [master]
go

-- na instância 1 (principal) A
create login [NT Service\MSSQL$SQL2012DEINST2] FROM Windows   -- se não existir
create login [NT Service\MSSQL$SQL2012DEINST3] FROM Windows   -- se não existir

Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST2];
Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST3];
go