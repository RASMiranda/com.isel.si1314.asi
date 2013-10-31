use [BDMIRROR]
go

select * from t
go
--Msg 955, Level 14, State 1, Line 1
--Database BDMIRROR is enabled for Database Mirroring, but the database lacks quorum: the database cannot be opened.  Check the partner and witness connections if configured.
--Msg 208, Level 16, State 1, Line 2
--Invalid object name 't'.
