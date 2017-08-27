-- Debugging AddMove procedure
--SELECT * FROM DBO.kmsview select * from dbo.moves
/*
SET NOCOUNT ON
USE kms
GO
DISABLE TRIGGER dbo.uModMoves ON dbo.moves
GO 
DISABLE TRIGGER dbo.uDelMoves ON dbo.moves
GO 
DISABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
DISABLE TRIGGER dbo.uDelFio ON dbo.fio
GO
DISABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
DISABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
DISABLE TRIGGER dbo.uDelKms ON dbo.kms
GO
DISABLE TRIGGER dbo.uDelErrors ON dbo.errors
GO
DISABLE TRIGGER dbo.uModEnp ON dbo.enp
GO

DELETE FROM dbo.moves
DELETE FROM dbo.person
DELETE FROM dbo.adr50
DELETE FROM dbo.adr77
DELETE FROM dbo.details
DELETE FROM dbo.docs
DELETE FROM dbo.enp
DELETE FROM dbo.fio
DELETE FROM dbo.kms
DELETE FROM dbo.ofio
DELETE FROM dbo.predst
DELETE FROM dbo.wrkpl
DELETE FROM dbo.errors

print 'Database kms is empty now!'
print '--------------------------------------'
*/
SET NOCOUNT ON
USE kms
GO
ENABLE TRIGGER dbo.uModMoves ON dbo.moves
GO 
ENABLE TRIGGER dbo.uDelMoves ON dbo.moves
GO 
ENABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
ENABLE TRIGGER dbo.uDelFio ON dbo.fio
GO 
ENABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
ENABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
ENABLE TRIGGER dbo.uDelKms ON dbo.kms
GO
ENABLE TRIGGER dbo.uDelErrors ON dbo.errors
GO
ENABLE TRIGGER dbo.uModEnp ON dbo.enp
GO
/*
print '�������������� �����������...'
declare @id int
exec dbo.AddPerson @scn='NB', @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'
else 
print '�������������� �� ��������...'

print '�������������� �����������...'
exec dbo.AddPerson @scn='NB', @fam='�����', @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'
else 
print '�������������� �� ��������...'

print '�������������� �����������...'
exec dbo.AddPerson @scn='NB', @fam='�����', @im='������', @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'
else 
print '�������������� �� ��������...'

print '�������������� �����������...'
exec dbo.AddPerson @scn='NB', @fam='�����', @im='������', @ot='�������������', @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'
else 
print '�������������� �� ��������...'

print '�������������� �����������...'
exec dbo.AddPerson @scn='NB', @fam='�����', @im='������', @ot='�������������', @dr='19740620', @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'
else 
print '�������������� �� ��������...'
*/
print '�������������� �����������...'
declare @id int
exec dbo.AddPerson @scn='NB', @fam='�����', @im='������', @ot='�������������', @dr='19740620', @w=1,  @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'+cast(@id as varchar(6))
else 
print '�������������� �� ��������...'+cast(@id as varchar(6))

print '�������� ������������ ���������� ���������������...'
declare @scn char(3), @fam varchar(40), @im varchar(40), @ot varchar(40), @w tinyint, @dr date, @mr varchar(max),
	@c_doc tinyint, @s_doc varchar(9), @n_doc varchar(8), @d_doc date, @e_doc date, @u_doc varchar(max), @x_doc tinyint
select @scn=scn, @fam=fam, @im=im, @ot=ot, @w=w, @dr=dr from dbo.kmsview where persid=@id
if (@scn='NB') AND (@fam='�����') AND (@im='������') AND (@ot='�������������') AND (@w=1) AND (@dr='19740620')
 print '�������������� �������� ���������...'+cast(@id as varchar(6))
else 
 print '�������������� �������� �� ���������!'+cast(@id as varchar(6))

print '--------------------------------------'

print '����������� �������� ��������...'
exec dbo.UpdatePerson @persid=@id, @scn='CD', @c_doc=14, @s_doc='4501', @n_doc='591777', @d_doc='20020129'
select @c_doc=c_doc, @s_doc=s_doc, @n_doc=n_doc, @d_doc=d_doc from dbo.kmsview where persid=@id
if @c_doc=14 and @s_doc='4501' and @n_doc='591777' and @d_doc='20020129'
 print '�������� �������� �������� ���������...'+cast(@id as varchar(6))
else 
 print '�������� �������� �������� �� ���������!'+cast(@id as varchar(6))

print '--------------------------------------'

print '����������� ������ ��������� ���������...'
exec dbo.UpdatePerson @persid=@id, @scn='CD', @e_doc='20190620', @u_doc='��� �-�� ������������', @x_doc=1
select @e_doc=e_doc, @u_doc=u_doc, @x_doc=x_doc from dbo.kmsview where persid=@id
if @e_doc='20190620' and @u_doc='��� �-�� ������������' and @x_doc=1
 print '������ ��������� ��������� �������� ���������...'+cast(@id as varchar(6))
else 
 print '������ ��������� ��������� �������� �� ���������...'+cast(@id as varchar(6))

print '����������� ������...'
declare @et char(1), @c_err varchar(8), @err_text varchar(250)
exec dbo.AddError @persid=@id, @et='1', @c_err='TRAERR', @err_text='������� ��������� �������������� �������� ��������'
select @et=et, @c_err=err_code, @err_text=err_text from dbo.kmsview where persid=@id
if @et='1' and @c_err='TRAERR' and @err_text='������� ��������� �������������� �������� ��������'
 print '������ ��������� ���������...'+cast(@id as varchar(6))
else 
 print '������ ��������� �� ���������...'+cast(@id as varchar(6))

print '����������� ����������� ��������� � ���'
print '--------------------------------------'
exec dbo.AddPerson @scn='NB', @kl=99, @gr='ISR', @snils='179-593-520 32', @fam='������', @im='���', @d_ot='0', @dr='19730220', @w=1,  @spos=2, @out_id=@id OUTPUT
if @id is not null
print '�������������� ��������...'+cast(@id as varchar(6))
else 
print '�������������� �� ��������...'+cast(@id as varchar(6))

print '����������� ������...'
exec dbo.AddError @persid=@id, @et='1', @c_err='DUDLS0', @err_text='���: ������ ��� ���������'
select @et=et, @c_err=err_code, @err_text=err_text from dbo.kmsview where persid=@id
if @et='1' and @c_err='DUDLS0' and @err_text='���: ������ ��� ���������'
 print '������ ��������� ���������...'+cast(@id as varchar(6))
else 
 print '������ ��������� �� ���������...'+cast(@id as varchar(6))

print '����������� �������� ��������...'
exec dbo.UpdatePerson @persid=@id, @c_doc=9, @n_doc='13821541', @d_doc='20090910', @e_doc='20190909'
select @c_doc=c_doc, @s_doc=s_doc, @n_doc=n_doc, @d_doc=d_doc, @e_doc=e_doc from dbo.kmsview where persid=@id
if @c_doc=9 and @s_doc=null and @n_doc='13821541' and @d_doc='20090910' and @e_doc='20190909'
 print '�������� �������� �������� ���������...'+cast(@id as varchar(6))
else 
 print '�������� �������� �������� �� ���������!'+cast(@id as varchar(6))

print '����������� ���...'
declare @c_perm tinyint, @s_perm varchar(12), @n_perm varchar(16), @d_perm date, @e_perm date
exec dbo.UpdatePerson @persid=@id, @c_perm=23, @n_perm='1319/15/130', @d_perm='20151230', @e_perm='20181229'
select @c_perm=c_perm, @s_perm=s_perm, @n_perm=n_perm, @d_perm=d_perm, @e_perm=e_perm from dbo.kmsview where persid=@id
if @c_perm=23 and @s_perm is null and @n_perm='1319/15/130' and @d_perm='20151230' and @e_perm='20181229'
 print '��� �������� ���������...'+cast(@id as varchar(6))
else 
 print '��� �������� �� ���������!'+cast(@id as varchar(6))

print '����������� ���������� ����...'
exec dbo.UpdatePerson @persid=@id, @predst=3, @pr_fam='�����', @pr_im='������', @pr_ot='�������������',
	@pr_c_doc=14, @pr_s_doc='4501', @pr_n_doc='591777', @pr_d_doc='20020129', @pr_u_doc='��� �-�� ������������',
	@pr_tel1='+74999950825', @pr_tel2='+79637820825', @pr_inf='������� � 09:00 �� 18:00' 
print '--------------------------------------'

print '����������� �����...'
exec dbo.UpdatePerson @persid=@id, @ul=24480, @dom='22', @kv='302', @d_reg77='20160101'
declare @ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5)
select @ul=ul, @dom=dom, @kor=kor, @str=str, @kv=kv
	from dbo.kmsview where recid=@id
if (@ul=24480) AND (@dom='22') AND (@kor is null) AND (@kv='302')
 print '���������� ����� �������� ���������...'
else 
 print '���������� ����� �������� �� ���������!'


/*
print '�������������� �����������...'
declare @id int
exec dbo.AddPerson @scn='NB', @fam='�����', @im='������', @ot='�������������', @w=1, @dr='19740620',
@mr='������', @c_doc=14, @s_doc='4501', @n_doc='591777', @d_doc='20020129', @out_id=@id OUTPUT
print '�������������� ��������...'

print '�������� ������������ ���������� ���������������...'
declare @scn char(3), @fam varchar(40), @im varchar(40), @ot varchar(40), @w tinyint, @dr date, @mr varchar(max),
	@c_doc tinyint, @s_doc varchar(9), @n_doc varchar(8), @d_doc date, @e_doc date, @u_doc varchar(max), @x_doc tinyint
select @scn=scn, @fam=fam, @im=im, @ot=ot, @w=w, @dr=dr, @mr=mr, @c_doc=c_doc, @s_doc=s_doc, @n_doc=n_doc, @d_doc=d_doc 
	from dbo.kmsview where recid=@id
if (@scn='NB') AND (@fam='�����') AND (@im='������') AND (@ot='�������������') AND (@w=1) AND (@dr='19740620') AND
	(@mr='������') AND (@c_doc=14) AND (@s_doc='4501') AND (@n_doc='591777') AND (@d_doc='20020129')
 print '�������������� �������� ���������...'
else 
 print '�������������� �������� �� ���������!'

print '����������� ��...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @s_vs='P2104', @n_vs='001002003', @vs_dp='20020101', @vs_dt='20020201'
declare @s_vs varchar(12), @n_vs varchar(32), @vs_dp date, @vs_dt date
select @s_vs=s_vs, @n_vs=n_vs, @vs_dp=vsdp, @vs_dt=vsdt
	from dbo.kmsview where recid=@id
if (@s_vs='P2104') AND (@n_vs='001002003') AND (@vs_dp='20020101') AND (@vs_dt='20020201')
 print '�� �������� ���������...'
else 
 print '�� �������� �� ���������!'

print '�������� ��...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @s_vs='P2104', @n_vs='001002003', @vs_dp='20020101', @vs_dt='20020201'
select @s_vs=s_vs, @n_vs=n_vs, @vs_dp=vsdp, @vs_dt=vsdt
	from dbo.kmsview where recid=@id
if (@s_vs='P2104') AND (@n_vs='001002003') AND (@vs_dp='20020101') AND (@vs_dt='20020201')
 print '�� ������� ���������...'
else 
 print '�� ������� �� ���������!'

print '�������� ��...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @n_vs='002003004', @vs_dt='20020301'
select @s_vs=s_vs, @n_vs=n_vs, @vs_dp=vsdp, @vs_dt=vsdt
	from dbo.kmsview where recid=@id
if (@s_vs='P2104') AND (@n_vs='002003004') AND (@vs_dp='20020101') AND (@vs_dt='20020301')
 print '�� ������� ���������...'
else 
 print '�� ������� �� ���������!'

print '����������� ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @s_kms='770000', @n_kms='4049700674'
declare @s_kms varchar(12), @n_kms varchar(32)
select @s_kms=s_kms, @n_kms=n_kms from dbo.kmsview where recid=@id
if (@s_kms='770000') AND (@n_kms='4049700674')
 print '��� �������� ���������...'
else 
 print '��� �������� �� ���������!'

print '������������� ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @kms_dp='20000901', @kms_dt='20990901', @kms_dr='20000902'
declare @kms_dp date, @kms_dt date, @kms_dr date
select @kms_dp=kmsdp, @kms_dt=kmsdt, @kms_dr=kmsdr from dbo.kmsview where recid=@id
if (@kms_dp='20000901') AND (@kms_dt='20990901') AND (@kms_dr='20000902')
 print '��� �������������� ���������...'
else 
 print '��� �������������� �� ���������!'

print '����������� ������ ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @s_okms='770001', @n_okms='4049700674'
declare @s_okms varchar(12), @n_okms varchar(32)
select @s_okms=s_okms, @n_okms=n_okms from dbo.kmsview where recid=@id
if (@s_okms='770001') AND (@n_okms='4049700674')
 print '������ ��� �������� ���������...'
else 
 print '������ ��� �������� �� ���������!'

print '������������� ������ ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @okms_dp='20000901', @okms_dt='20990901', @okms_dr='20000902'
declare @okms_dp date, @okms_dt date, @okms_dr date
select @okms_dp=okmsdp, @okms_dt=kmsdt, @okms_dr=kmsdr from dbo.kmsview where recid=@id
if (@okms_dp='20000901') AND (@okms_dt='20990901') AND (@okms_dr='20000902')
 print '������ ��� �������������� ���������...'
else 
 print '������ ��� �������������� �� ���������!'

print '����������� ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @enp='775352082900219'
declare @enp varchar(16)
select @enp=enp from dbo.kmsview where recid=@id
if @enp='775352082900219'
 print '��� �������� ���������...'
else 
 print '��� �������� �� ���������!'

print '�������� �������� ��������...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @c_doc=15
select @c_doc=c_doc from dbo.kmsview where recid=@id
if @c_doc=15
 print '�������� �������� ������� ���������...'
else 
 print '�������� �������� ������� �� ���������!'

print '�������� �������� ��������...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @e_doc='20991231'
select @e_doc=e_doc from dbo.kmsview where recid=@id
if @e_doc='20991231'
 print '�������� �������� ������� ���������...'
else 
 print '�������� �������� ������� �� ���������!'

print '�������� �������� ��������...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @n_doc='591778'
select @n_doc=n_doc from dbo.kmsview where recid=@id
if @n_doc='591778'
 print '�������� �������� ������� ���������...'
else 
 print '�������� �������� ������� �� ���������!'

print '����������� ���������� �� ����������...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @c_perm=23, @s_perm='��', @n_perm='001002', @d_perm='20110101', @e_perm='20140101'
declare @c_perm tinyint, @s_perm varchar(9), @n_perm varchar(8), @d_perm date, @e_perm date
select @c_perm=c_perm, @s_perm=s_perm, @n_perm=n_perm, @d_perm=d_perm, @e_perm=e_perm
	from dbo.kmsview where recid=@id
if @c_perm=23 AND @s_perm='��' AND @n_perm='001002' AND @d_perm='20110101' AND @e_perm='20140101'
 print '���������� �� ���������� ��������� ���������...'
else 
 print '���������� �� ���������� ��������� �� ���������...'

print '����������� �����...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ul=745, @dom='20', @kor='2', @kv='40'
declare @ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5)
select @ul=ul, @dom=dom, @kor=kor, @str=str, @kv=kv
	from dbo.kmsview where recid=@id
if (@ul=745) AND (@dom='20') AND (@kor='2') AND (@kv='40')
 print '���������� ����� �������� ���������...'
else 
 print '���������� ����� �������� �� ���������!'

print '����������� ����������� �����...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @c_okato='46000', @ra_name='��������-��������� �����',
	@np_c=1, @np_name='��������', @ul_c=17, @ul_name='������������', @dom50='15', @d_reg50='19740622'
declare @c_okato varchar(5), @ra_name varchar(60), @np_c tinyint, @np_name varchar(60), @ul_c tinyint, 
	@ul_name varchar(60), @dom50 varchar(7), @d_reg50 date
select @c_okato=c_okato , @ra_name=ra_name , @np_c=np_c , @np_name=np_name , @ul_c=ul_c , @ul_name=ul_name,
	@dom50=dom50, @d_reg50=d_reg50
	from dbo.kmsview where recid=@id
if (@c_okato='46000') AND (@ra_name='��������-��������� �����') AND (@np_c=1) AND (@np_name='��������') AND
	(@ul_c=17) AND (@ul_name='������������') AND (@dom50='15') AND (@d_reg50='19740622')
 print '����������� ����� �������� ���������...'
else 
 print '����������� ����� �������� �� ���������!'

exec dbo.UpdatePerson @recid=@id, @scn='CD', @np_c=2
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ul_c=18

exec dbo.UpdatePerson @recid=@id, @scn='CD', @kv50='3'

exec dbo.UpdatePerson @recid=@id, @scn='CD', @kor50='1'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @str50='2'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @kv50='3'

print '--------------------------------------'
	

print '�������������� �����������...'
exec dbo.AddPerson @scn='NB', @fam='�������', @im='���������', @ot='���������', @w=1, @dr='19430821',
@mr='�������', @c_doc=14, @s_doc='4502', @n_doc='591778', @d_doc='20020129', @out_id=@id OUTPUT
print '�������������� ��������...'

print '�������� ������������ ���������� ���������������...'
select @scn=scn, @fam=fam, @im=im, @ot=ot, @w=w, @dr=dr, @mr=mr, @c_doc=c_doc, @s_doc=s_doc, @n_doc=n_doc, @d_doc=d_doc 
	from dbo.kmsview where recid=@id
if (@scn='NB') AND (@fam='�������') AND (@im='���������') AND (@ot='���������') AND (@w=1) AND (@dr='19430821') AND
	(@mr='�������') AND (@c_doc=14) AND (@s_doc='4502') AND (@n_doc='591778') AND (@d_doc='20020129')
 print '�������������� �������� ���������...'
else 
 print '�������������� �������� �� ���������!'

print '����������� �����...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ul=745, @dom='20', @kor='2', @kv='40'
select @ul=ul, @dom=dom, @kor=kor, @str=str, @kv=kv
	from dbo.kmsview where recid=@id
if (@ul=745) AND (@dom='20') AND (@kor='2') AND (@kv='40')
 print '���������� ����� �������� ���������...'
else 
 print '���������� ����� �������� �� ���������!'

print '�������� �����...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ul=745, @dom='20', @kor='', @kv='40'
select @ul=ul, @dom=dom, @kor=kor, @str=str, @kv=kv
	from dbo.kmsview where recid=@id
if (@ul=745) AND (@dom='20') AND (@kor='') AND (@kv='40')
 print '���������� ����� ������� ���������...'
else 
 print '���������� ����� �������� �� ���������!'

print '--------------------------------------'

print '�������� ���...'
declare @recsinfio int = (select count(*) from dbo.fio where isdeleted='false')
print '� dbo.fio '+cast(@recsinfio as char(1))+' ������(��)...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @fam='�����', @im='������', @ot='�������������'
select @fam=fam, @im=im, @ot=ot
	from dbo.kmsview where recid=@id
if (@fam='�����') AND (@im='������') AND (@ot='�������������')
 print '��� ������� ���������...'
else 
 print '��� �������� �� ���������!'

set @recsinfio = (select count(*) from dbo.fio where isdeleted='false')
print '� dbo.fio '+cast(@recsinfio as char(1))+' ������(��)...'

print '�������� ���...'
set @recsinfio = (select count(*) from dbo.fio where istop='true')
print '� dbo.fio '+cast(@recsinfio as char(1))+' ������(��)...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @fam='�������', @im='���������', @ot='���������'
select @fam=fam, @im=im, @ot=ot
	from dbo.kmsview where recid=@id
if (@fam='�������') AND (@im='���������') AND (@ot='���������')
 print '��� ������� ���������...'
else 
 print '��� ������� �� ���������!'

set @recsinfio = (select count(*) from dbo.fio where istop='true')
print '� dbo.fio '+cast(@recsinfio as char(1))+' ������(��)...'

print '--------------------------------------'

print '����������� ������ ���...'
declare @ofam varchar(40), @oim varchar(40), @oot varchar(40)
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ofam='��������', @oim='�����', @oot='���������'
select @ofam=ofam, @oim=oim, @oot=oot
	from dbo.kmsview where recid=@id
if (@ofam='��������') AND (@oim='�����') AND (@oot='���������')
 print '������ ��� ��������� ���������...'
else 
 print '������ ��� ��������� �� ���������...'

print '��������� ������ ���...'
exec dbo.UpdatePerson @recid=@id, @scn='CD', @ofam='', @oim='', @oot=''
select @ofam=ofam, @oim=oim, @oot=oot
	from dbo.kmsview where recid=@id
if (@ofam is null) AND (@oim is null) AND (@oot is null)
 print '������ ��� ������� ���������...'
else 
 print '������ ��� ������� �� ���������...'
*/
/*
IF OBJECT_ID('dbo.test','P') IS NOT NULL DROP PROCEDURE dbo.test
create procedure dbo.test (@w tinyint=0, @age int=0, @result int output)
as 
begin
 select * from dbo.kmsview where w=iif(@w=0, w, @w) and DATEDIFF(year,dr,getdate())>@age
 set @result = @@ROWCOUNT
end
*/

--- SQL Hints �������� ��� ������� ���� heap
/*
use kms 
SELECT stb.name, idx.type_desc FROM sys.tables stb
	INNER JOIN sys.indexes idx ON stb.object_id=idx.object_id AND idx.type=0
	ORDER BY stb.name
*/
--- SQL Hints

--SELECT * FROM DBO.kmsview
/*
go 
declare @c_okato varchar(5)='46000', @ra_name varchar(60)=null, @adr50_id int=7
SELECT @c_okato=COALESCE(@c_okato,c_okato), @ra_name=COALESCE(@ra_name,ra_name)
	FROM dbo.adr50 WHERE recid=@adr50_id
if @@ROWCOUNT>0
 print @@rowcount


*/
--select DATEADD(year,14,'20050131')

--select * from dbo.photos

--select dr, dbo.Age(dr, getdate()) from dbo.kmsview 

--select scn, count(*) as cnt from dbo.kmsview group by scn order by cnt desc 

