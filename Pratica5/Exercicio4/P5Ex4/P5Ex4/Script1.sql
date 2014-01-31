create table tr(i int, r Rectangulo)

drop table tr

insert into tr values(1,'(1,3)')
insert into tr values(2,'(2,4)')
insert into tr values(3,null)
insert into tr values(4,'null')

select * from tr

select r.l1 as l1, r.l2 as l2, r.area as a from tr







