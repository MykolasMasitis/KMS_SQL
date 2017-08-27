-- Debugging AddMove proedure
USE kms
GO
ENABLE TRIGGER dbo.uModMoves ON dbo.moves
GO 
ENABLE TRIGGER dbo.uDelMoves ON dbo.moves
GO 

declare @recid int
declare @curdate date = getdate()
exec dbo.AddPerson @scn='NB', @dr='19740620', @w=1, @gr='RUS', @mr='Москва', @fam='Рябов', @im='Михаил', 
	@ot='Станиславович', @c_doc=14, @s_doc='4501', @n_doc='591777', @d_doc='20020129'
print cast(@recid as varchar(6))
go 

select * from dbo.moves 
select * from dbo.kmsview

declare @recid int
exec dbo.UpdatePerson @recid=2, @scn='CD', @ul=745, @dom='20', @kv='40'
print cast(@recid as varchar(6))

select * from dbo.moves 
select power(2,(3-1))

update dbo.moves set status=1 where recid =7



declare @recid int
exec dbo.UpdatePerson @recid=2, @scn='CD', @status=1
print cast(@recid as varchar(6))

select * from dbo.moves 

declare @recid int
exec dbo.UpdatePerson @recid=3, @scn='CD', @status=1, @s_kms='770000', @n_kms='4049700674'
print cast(@recid as varchar(6))

select * from dbo.moves 



select * from kmsview
select SUSER_id()

declare @recid int
exec dbo.AddMove default, 1, 'NB', '20170620', default, default, default, default,
	'001-438-525-01', '19740620', default, 1,
	'104', '100', 0, 'Контактная информация', 'RUS', 'Москва', 'Комментарий','X', 9999,
	'Рябов',' ','Михаил',' ','Станиславович',' ',
	'Масевич','Миколас','Казимирас',
	null,null,null,null,
	'P2104','001002003','19991201','19991231',
	'770000','4049700674',default,default,'20000101','20991231','20000115',
	'46-12','003004',default,default,'19950101','20991231','19950115',
	'775352082900219',null,default,default,'20100101',null,null,
	'775252082900219',null,default,default,'20100202',null,
	14,'4501','591777','20020129','20190620','ОВД р-на Текстильщики',default,
	23,'AA','001002','20110101','20140101',
	9,'','506348520','20160624','20290624','Госдударственный Департамент США',default,
	745,'20','2',null,'40','19900911',
	'46000','Сергиево-Посадский район',1,'Хотьково',7,'Первомайская','15',default,default,default,'19740622',
	@out_id=@recid output
print cast(@recid as varchar(6))

declare @id int
exec dbo.AddMove @scn='POK', @recid=2, @dp='20170710', @out_id=@id output 
print cast(@id as varchar(6))

--
DISABLE TRIGGER dbo.uModMoves ON dbo.moves
ENABLE TRIGGER dbo.uModMoves ON dbo.moves
GO
--
-- Пробуем поменять статус с 0 на 1
update dbo.moves set status=1 where recid=1

go
declare @dr date
set @dr=''
select iif(@dr is null or @dr='', 0, 1)

GO 

IF EXISTS (SELECT * FROM sys.server_triggers WHERE name = 'logon_trigger')
DROP TRIGGER logon_trigger ON ALL SERVER
GO

CREATE TRIGGER logon_trigger ON ALL SERVER FOR LOGON AS
BEGIN 
 DECLARE @whologged varchar(100) = (SELECT USER_NAME())
 IF EXISTS (SELECT name FROM sys.databases WHERE name=N'kms')
 BEGIN 
  IF EXISTS (SELECT * FROM master.sys.objects WHERE OBJECT_ID=OBJECT_ID('users')) DROP TABLE kms.dbo.users
   CREATE TABLE dbo.users(recid int IDENTITY(1,1),[name] varchar(150), created datetime default sysdatetime(),
	CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([recid] ASC))
 END 
END 
GO 

select * from sys.objects where SCHEMA_ID=SCHEMA_ID('dbo') AND TYPE='U'


use kms 

 select SUSER_NAME()
 select SUSER_SNAME()

 select USEr_id()

 select DATABASE_PRINCIPAL_ID()
 select * from sys.database_principals
 select * from sys.server_principals
 select SUSER_ID('public')

 use xstoredb

 select USER_ID(), SUSER_ID()

 select * from sys.database_principals

 select DATEADD(year, 45, '19740620')

declare @recid int = 100
select iif(@recid = (SELECT recid FROM dbo.moves WHERE recid=@recid),1,0)

declare @recid int
select @recid=recid from dbo.moves where recid=1
print @recid


use kms
alter table dbo.pers add column age as dateadd(year,1,dr)
create index ix_age on dbo.pers (age)

drop index ix_age on dbo.pers
alter table dbo.pers drop column age

alter table dbo.pers add age as datediff(year,dr,getdate())

create index ix_age on dbo.pers (age)

select cast(getdate() as datetime), cast(getdate() as datetime2), cast(getdate() as smalldatetime)


declare @dat1 datetime2
set @dat1 = dateadd(year, 1, '01.01.1000')
select @dat1

dbcc useroptions

use kms


select COUNT(*) as cnt, sum(code) as sum from 
(select code, name from nsi.kl union select code,name from nsi.viddocs) as p

select code, name from nsi.kl union select code,name from nsi.kl

select count(*) as cnt from nsi.kl union  all 
select count(*) as cnt from nsi.viddocs

go
create procedure qwert (@recid int, @pc char(3))
as
begin
 declare @maxrecid int
 select @maxrecid=max(recid) from dbo.moves
 return @maxrecid
end 

declare @result int
exec @result = qwert 1,''
print @result


alter table nsi.streets add input datetime
select * from nsi.streets

update nsi.streets set input=null



go

declare @mincode int = (select min(code) from nsi.streets)
declare @maxcode int = (select max(code) from nsi.streets)
declare @code int = @mincode
while @code<=@maxcode
 begin 
  if not exists (select code from nsi.streets where code=@code) 
	begin 
		set @code=@code+1
		continue
	 end
  update nsi.streets set input=DATEADD(MINUTE,48*60*RAND(),dateadd(day,-1,getdate()))
	where code = @code
  set @code=@code+1
  continue
 end

 set statistics io on
 
 select convert(date, GETDATE())

 select code from nsi.streets where input>=convert(date,getdate()) and input<DATEADD(day,1,convert(date,getdate()))

 create index idx_input on nsi.streets(input)

 Select convert(varchar(8),getdate(),112)

 select code from nsi.streets where CONVERT(varchar,input,112)=CONVERT(varchar,getdate(),112)

 alter table nsi.streets add custid int

go 
declare @mincode int = (select min(code) from nsi.streets)
declare @maxcode int = (select max(code) from nsi.streets)
declare @code int = @mincode
declare @rand float
while @code<=@maxcode
 begin 
  if not exists (select code from nsi.streets where code=@code) 
	begin 
		set @code=@code+1
		continue
	 end
  set @rand=RAND()
  update nsi.streets set custid = 1 + (case when @rand<0.3 then 1 when @rand >= 0.3 and @rand<0.6 then 2 else 3 end)
	where code = @code
  set @code=@code+1
  continue
 end

 select rand()

 select custid, count(*) from nsi.streets group by custid


select * from nsi.streets

select custid, input, lag(input,1) over (partition by custid order by input) as prev_inpur,
	 lead(input,1) over (partition by custid order by input) as next_input from nsi.streets

select code from nsi.kl

select code from nsi.streets where code > some (select code from nsi.kl)

select code from nsi.streets order by code asc 

select 4976-13

select code, count(*) from nsi.streets group by grouping sets ((code), (code, input))


go 
USE kms 
CREATE TABLE dbo.Sales (EmpId INT, Yr INT, Sales MONEY)
INSERT Sales VALUES(1, 2005, 12000)
INSERT Sales VALUES(1, 2006, 18000)
INSERT Sales VALUES(1, 2007, 25000)
INSERT Sales VALUES(2, 2005, 15000)
INSERT Sales VALUES(2, 2006, 6000)
INSERT Sales VALUES(3, 2006, 20000)
INSERT Sales VALUES(3, 2007, 24000)

SELECT EmpId, Yr, SUM(Sales) AS Sales
FROM Sales
GROUP BY EmpId, Yr

SELECT EmpId, Yr, SUM(Sales) AS Sales
FROM Sales
GROUP BY EmpId, Yr WITH ROLLUP

SELECT EmpId, Yr, SUM(Sales) AS Sales
FROM Sales
GROUP BY EmpId, Yr WITH CUBE

select Yr, Sum(Sales) as sales from sales group by yr with rollup

select Yr, Sum(sales) as sales from sales group by yr
union all
select null, Sum(sales) from sales 


declare @money1 money=1111111120.1
declare @money2 smallmoney=111120.1
select @money1
select @money2


update nsi.streets set name.write('Hello',0,0)

select * from nsi.streets

declare @qwert nvarchar(max)
set @qwert = N'qwert'
select @qwert.write()

use kms

alter table nsi.streets alter column [name] varchar(max)

select @@ERROR, @@ROWCOUNT

select XACT_STATE()


go
use kms 
create table nsi.test (id int, code char(2), name char(50))
insert into nsi.test values (1,'zz','TheFirstName'),(2,'qq','TheSecondName'),(3,'ww','TheThirdName')
declare @table table (id int, code char(2), name char(50))
--print 'Table nsi.test before deleted:'
--select * from nsi.test

delete from nsi.test output deleted.* into @table where id=1
print 'Table nsi.test after deleted:'
select * from nsi.test
select * from @table


