-- SELECT * FROM DBO.KMSVIEW
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

print 'Застрахованный добавляется...'
declare @id int
declare @scn char(3), @fam varchar(40), @im varchar(40), @ot varchar(40), @w tinyint, @dr date, @mr varchar(max),
		@c_doc tinyint, @s_doc varchar(9), @n_doc varchar(8), @d_doc date, @e_doc date, @u_doc varchar(max), @x_doc tinyint
declare @ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5), @d_reg77 date
declare @c_perm tinyint, @s_perm varchar(12), @n_perm varchar(16), @d_perm date, @e_perm date

exec dbo.AddPerson @scn='NB',
 /* dbo.fio */ @fam='Рябов', @im='Михаил', @ot='Станиславович', 
 /* dbo.person */ @snils='001-438-525 01', @dr='19740620', @w=1,
 /* основной документ, dbo.docs (tip=1) */ @c_doc=14, @s_doc='4501', @n_doc='591777', @d_doc='20020129', @e_doc='20190620', @u_doc='ОВД Р-НА ТЕКСТИЛЬЩИКИ', @x_doc=1, 
 /* московский адрес, dbo.adr77 */ @ul=745, @dom='20', @kor='2', @kv='40', @d_reg77='19900919',
 /* dbo.details */ @pv='060', @kl=0, @cont='+79637820825, 9950825@mail.ru', @mr='СССР, гор. Москва', 
 /* dbo.moves */ @predst=3,
 /* dbo.predst */ @pr_fam='Рябова', @pr_im='Ольга', @pr_ot='Михайловна',
 /* dbo.predst */ @pr_c_doc=14, @pr_s_doc='4510', @pr_n_doc='127187', @pr_d_doc='20090317', @pr_u_doc='ОТД. ПО Р-НУ МАРЬИНО ОУФМС РОССИИ ПО ГОР. МОСКВЕ В ЮВАО',
 /* dbo.predst */ @pr_tel1='+79637102730', @pr_inf='Звонить с 09:00 до 18:00',
  @out_id=@id OUTPUT

if @id is not null
 print 'Застрахованный добавлен...'
else 
 print 'Застрахованный не добавлен...'

exec dbo.AddPerson @scn='NB',
 /* dbo.fio */ @fam='Рябова', @im='Ольга', @ot='Михайловна', 
 /* dbo.person */ @snils='001-438-525 02', @dr='19800820', @w=2,
 /* основной документ, dbo.docs (tip=1) */ @c_doc=14, @s_doc='4510', @n_doc='127187', @d_doc='20090317', @e_doc='20250820', @u_doc='ОТД. ПО Р-НУ МАРЬИНО ОУФМС РОССИИ ПО ГОР. МОСКВЕ В ЮВАО', @x_doc=1, 
 /* московский адрес, dbo.adr77 */ @ul=18920, @dom='3', @kor='1', @kv='75', @d_reg77='20160119',
 /* dbo.details */ @pv='060', @kl=0, @cont='+79637102730', @mr='СССР, гор. Москва', 
 /* dbo.moves */ @predst=3,
 /* dbo.predst */ @pr_fam='Рябов', @pr_im='Михаил', @pr_ot='Станиславович',
 /* dbo.predst */ @pr_c_doc=14, @pr_s_doc='4501', @pr_n_doc='591777', @pr_d_doc='20020129', @pr_u_doc='ОВД Р-НА ТЕКСТИЛЬЩИКИ',
 /* dbo.predst */ @pr_tel1='+79637820825', @pr_inf='Звонить с 09:00 до 18:00',
  @out_id=@id OUTPUT

if @id is not null
 print 'Застрахованный добавлен...'
else 
 print 'Застрахованный не добавлен...'

exec dbo.AddPerson @scn='NB',
 /* dbo.fio */ @fam='Рябова', @im='Анна', @ot='Михайловна', 
 /* dbo.person */ @snils='186-316-748-98', @dr='20051024', @w=2,
 /* основной документ, dbo.docs (tip=1) */ @c_doc=3, @s_doc='II-МЮ', @n_doc='813134', @d_doc='20050212', @e_doc='20190131', @u_doc='ЛЮБЛИНСКИЙ ОТД. ЗАГС УПРАВЛЕНИЯ ЗАГС ГОР. МОСКВЫ', @x_doc=1, 
 /* московский адрес, dbo.adr77 */ @ul=745, @dom='20', @kor='2', @kv='40', @d_reg77='20051013',
 /* dbo.details */ @pv='060', @kl=0, @mr='РФ, гор. Москва', 
 /* dbo.moves */ @predst=3,
 /* dbo.predst */ @pr_fam='Рябов', @pr_im='Михаил', @pr_ot='Станиславович',
 /* dbo.predst */ @pr_c_doc=14, @pr_s_doc='4501', @pr_n_doc='591777', @pr_d_doc='20020129', @pr_u_doc='ОВД Р-НА ТЕКСТИЛЬЩИКИ',
 /* dbo.predst */ @pr_tel1='+79637820825', @pr_inf='Звонить с 09:00 до 18:00',
  @out_id=@id OUTPUT

if @id is not null
 print 'Застрахованный добавлен...'
else 
 print 'Застрахованный не добавлен...'

exec dbo.AddPerson @scn='NB',
 /* dbo.fio */ @fam='Рябова', @im='Варвара', @ot='Михайловна', 
 /* dbo.person */ @snils='186-316-748-99', @dr='20061024', @w=2,
-- /* основной документ, dbo.docs (tip=1) */ @c_doc=3, @s_doc='III-МЮ', @n_doc='687044', @d_doc='20080504', @e_doc='20201024', @u_doc='ЛЮБЛИНСКИЙ ОТД. ЗАГС УПРАВЛЕНИЯ ЗАГС ГОР. МОСКВЫ', @x_doc=1, 
 /* московский адрес, dbo.adr77 */ @ul=745, @dom='20', @kor='2', @kv='40', @d_reg77='20051013',
 /* dbo.details */ @pv='060', @kl=0, @mr='РФ, гор. Москва', 
 /* dbo.moves */ @predst=3,
 /* dbo.predst */ @pr_fam='Рябова', @pr_im='Ольга', @pr_ot='Михайловна',
 /* dbo.predst */ @pr_c_doc=14, @pr_s_doc='4510', @pr_n_doc='127187', @pr_d_doc='20090317', @pr_u_doc='ОТД. ПО Р-НУ МАРЬИНО ОУФМС РОССИИ ПО ГОР. МОСКВЕ В ЮВАО',
 /* dbo.predst */ @pr_tel1='+79637102730', @pr_inf='Звонить с 09:00 до 18:00',
  @out_id=@id OUTPUT

if @id is not null
 print 'Застрахованный добавлен...'
else 
 print 'Застрахованный не добавлен...'

print 'Добавляется иностранный гражданин с РВП'
exec dbo.AddPerson @scn='NB', 
 /* dbo.fio */ @fam='Канизо', @im='Шай', @d_ot='0', @w=1,
 /* dbo.person */ @snils='179-593-520 32',  @dr='19730220', 
 /* основной документ, dbo.docs (tip=1) */ @c_doc=9, @n_doc='13821541', @d_doc='20090910', @e_doc='20190909',
 --/* РВП dbo.docs (tip=1) */ @c_perm=23, @n_perm='1319/15/130', @d_perm='20151230', @e_perm='20181229',
 /* московский адрес, dbo.adr77 */  @ul=18920, @dom='3', @kor='1', @kv='75', @d_reg77='20161231',
 /* dbo.details */ @pv='060', @kl=99, @mr='РФ, гор. Москва', @gr='ISR',
 /* dbo.moves */ @predst=3, @spos=2,
 /* dbo.predst */ @pr_fam='Рябов', @pr_im='Михаил', @pr_ot='Станиславович',
 /* dbo.predst */ @pr_c_doc=14, @pr_s_doc='4501', @pr_n_doc='591777', @pr_d_doc='20020129', @pr_u_doc='ОВД Р-НА ТЕКСТИЛЬЩИКИ',
 /* dbo.predst */ @pr_tel1='+79637820825', @pr_inf='Звонить с 09:00 до 18:00',
 @out_id=@id OUTPUT
if @id is not null
print 'Застрахованный добавлен...'+cast(@id as varchar(6))
else 
print 'Застрахованный не добавлен...'+cast(@id as varchar(6))

--SELECT * FROM DBO.KMSVIEW

exec dbo.submit /*формирование заявки!*/


--update dbo.moves set status=status+1 where recid in (select recid from [reps].[def_20170825_20170825] qwert)
--update moves set status =2 from dbo.moves inner join [reps].[rep_20170825_20170825] reps on moves.recid=reps.recid 
--use kms 
--select a.recid,a.parentid, a.childid, b.recid, b.parentid, b.childid FROM dbo.moves a inner JOIN dbo.moves b ON a.recid=b.parentid





