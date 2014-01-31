/*
  Na configuração de mirroring indicar como service accounts de principal, mirror e witness
  o user das credenciais windows que usa nas instâncias do Sql Server.
  Se continuar tver erros relacionados com segurança, deixar em branco essas indicações e
  proceder como se exemplçifica a seguir:
*/


:connect ALUNO_SIAD-PC\ONE

create login [NT SERVICE\MSSQL$TWO] from Windows   -- se não existir
create login [NT SERVICE\MSSQL$THREE] from Windows   -- se não existir

grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$TWO];
grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$THREE];

GO


:connect ALUNO_SIAD-PC\TWO

create login [NT SERVICE\MSSQL$ONE] from Windows   -- se não existir
create login [NT SERVICE\MSSQL$THREE] from Windows   -- se não existir

grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$ONE];
grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$THREE];

GO

:connect ALUNO_SIAD-PC\THREE

-- na instância 3 (se apenas for witness, não é necessário, 
-- mas para poder usá-la quer como principal, quer como mirror, deve fazer)

create login [NT SERVICE\MSSQL$ONE] from Windows   -- se não existir
create login [NT SERVICE\MSSQL$TWO] from Windows   -- se não existir

grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$ONE];
grant connect on Endpoint::Mirroring to [NT SERVICE\MSSQL$TWO];

GO
