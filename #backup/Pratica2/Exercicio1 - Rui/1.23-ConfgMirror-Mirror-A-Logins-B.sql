USE [master]
go

-- na inst�ncia 2 (principal) B
create login [NT Service\MSSQL$SQL2012DEINST1] FROM Windows   -- se n�o existir
create login [NT Service\MSSQL$SQL2012DEINST3] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST1];
Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST3];
go