USE [master]
go

-- na inst�ncia 3 (principal) C
create login [NT Service\MSSQL$SQL2012DEINST1] FROM Windows   -- se n�o existir
create login [NT Service\MSSQL$SQL2012DEINST2] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST1];
Grant connect on Endpoint::Mirroring to [NT Service\MSSQL$SQL2012DEINST2];
go