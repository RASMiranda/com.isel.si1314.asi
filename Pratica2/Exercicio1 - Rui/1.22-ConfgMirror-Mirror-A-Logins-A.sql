USE [master]
go

-- na inst�ncia 1 (principal) A
create login [NT Service\MSSQL$SQL2012DEINST2] FROM Windows   -- se n�o existir
create login [NT Service\MSSQL$SQL2012DEINST3] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST2];
Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST3];
go