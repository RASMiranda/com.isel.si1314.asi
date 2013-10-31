/*
  Na configuração de mirroring indicar como service accounts de principal, mirror e witness
  o user das credenciais windows que usa nas instâncias do Sql Server.
  Se continuar tver erros relacionados com segurança, deixar em branco essas indicações e
  proceder como se exemplçifica a seguir:
*/



-- na instância 1 (principal)
create login [NT SERVICE\MSSQL$INSTANCIA2] FROM Windows   -- se não existir
create login [NT SERVICE\MSSQL$INSTANCIA3] FROM Windows   -- se não existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA2];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA3];

-- na instância 2 (mirror)
create login [NT SERVICE\MSSQL$INSTANCIA1] FROM Windows   -- se não existir
create login [NT SERVICE\MSSQL$INSTANCIA3] FROM Windows   -- se não existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA1];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA3];


-- na instância 3 (se apenas for witness, não é necessário, mas para poder usá-la 
-- quer como principal, quer como mirror, deve fazer)
create login [NT SERVICE\MSSQL$INSTANCIA1] FROM Windows   -- se não existir
create login [NT SERVICE\MSSQL$INSTANCIA2] FROM Windows   -- se não existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA1];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA2];
