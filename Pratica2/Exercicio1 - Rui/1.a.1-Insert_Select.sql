use [BDMIRROR]
go

insert into t values(2)
go

select * from t
go
--i
--1
--2

--Faz sentido haver failover automático?