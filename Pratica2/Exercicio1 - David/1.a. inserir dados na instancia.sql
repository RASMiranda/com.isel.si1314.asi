


-- Alinea b)
/*
b)	Pare a instância A e verifique que B toma o papel de principal. Em B, execute a instrução 
insert into t values(2) e faça select * from t.
*/

-- :connect .\ONE
use [BDMIRROR]

select * from t
insert into t values (@@servername, getdate())
select * from t

