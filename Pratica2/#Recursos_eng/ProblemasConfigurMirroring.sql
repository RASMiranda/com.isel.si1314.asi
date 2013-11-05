/*
  Na configura��o de mirroring indicar como service accounts de principal, mirror e witness
  o user das credenciais windows que usa nas inst�ncias do Sql Server.
  Se continuar tver erros relacionados com seguran�a, deixar em branco essas indica��es e
  proceder como se exempl�ifica a seguir:
*/



-- na inst�ncia 1 (principal)
create login [NT SERVICE\MSSQL$INSTANCIA2] FROM Windows   -- se n�o existir
create login [NT SERVICE\MSSQL$INSTANCIA3] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA2];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA3];

-- na inst�ncia 2 (mirror)
create login [NT SERVICE\MSSQL$INSTANCIA1] FROM Windows   -- se n�o existir
create login [NT SERVICE\MSSQL$INSTANCIA3] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA1];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA3];


-- na inst�ncia 3 (se apenas for witness, n�o � necess�rio, mas para poder us�-la 
-- quer como principal, quer como mirror, deve fazer)
create login [NT SERVICE\MSSQL$INSTANCIA1] FROM Windows   -- se n�o existir
create login [NT SERVICE\MSSQL$INSTANCIA2] FROM Windows   -- se n�o existir

Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA1];
Grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$INSTANCIA2];
