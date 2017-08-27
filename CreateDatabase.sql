-- Ver. 02.0. Release Date: 25 June 2017
-- The first step of creating Database KMS
-- The next (the 2nd) step is to create Dictionaries 
-- alter database kms set online/offline/emergency/read_only
-- Предварительно создать net share командой net share MSSQLSERVER=D:\KMS\STREAM (пример)
-- MSSQLSERVER - наименование общей папки windows, задаваемое в закладке FILESTREAM свойств SQL Configuration Manager
-- D:\KMS\STREAM - физический путь к папке

USE master
GO
EXEC sp_configure filestream_access_level, 2 /*Разрешаем FileStream на уровне сервера*/
GO
RECONFIGURE
GO 

DECLARE @data_path varchar(256)
SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)  
                  FROM master.sys.master_files  
                  WHERE database_id = 1 AND file_id = 1);
--SELECT @data_path
USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name=N'kms')
 BEGIN 
  ALTER DATABASE kms SET single_user WITH rollback immediate
  DROP DATABASE kms
END 
GO

CREATE DATABASE kms COLLATE Cyrillic_General_CI_AI
 WITH FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = 'JPEG' ) 
GO

ALTER DATABASE kms ADD FILEGROUP EntitiesFG
ALTER DATABASE kms ADD FILEGROUP AuxuiliariesFG
ALTER DATABASE kms ADD FILEGROUP DefaultFG
ALTER DATABASE kms ADD FILEGROUP Media CONTAINS FILESTREAM 
ALTER DATABASE kms ADD FILE (NAME='jpg', FILENAME='D:\KMS\STREAM') TO FILEGROUP Media
GO 

DECLARE @Sql varchar(max)
DECLARE @file varchar(256)

SET @file = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)  
                  FROM master.sys.master_files  
                  WHERE database_id = 1 AND file_id = 1)+'Entities.ndf';
SET @Sql = 'ALTER DATABASE kms ADD FILE (NAME = "EntitiesFG", FILENAME = ' + QUOTENAME(@file, '''' ) + ')
	TO FILEGROUP EntitiesFG'
EXEC (@Sql)

SET @file = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)  
                  FROM master.sys.master_files  
                  WHERE database_id = 1 AND file_id = 1)+'Auxuiliaries.ndf';
SET @Sql = 'ALTER DATABASE kms ADD FILE (NAME = ''AuxuiliariesFG'', FILENAME = ' + QUOTENAME(@file, '''' ) + ')
	TO FILEGROUP AuxuiliariesFG'
EXEC (@Sql)

SET @file = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)  
                  FROM master.sys.master_files  
                  WHERE database_id = 1 AND file_id = 1)+'Default.ndf';
SET @Sql = 'ALTER DATABASE kms ADD FILE (NAME = ''DefaultFG'', FILENAME = ' + QUOTENAME(@file, '''' ) + ')
	TO FILEGROUP DefaultFG'
EXEC (@Sql)
GO 

ALTER DATABASE kms MODIFY FILEGROUP DefaultFG DEFAULT
GO 

USE kms
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name='nsi') DROP SCHEMA nsi
GO
CREATE SCHEMA nsi
GO

-- Схема для формирования отчетов
IF EXISTS (SELECT * FROM sys.schemas WHERE name='reps') DROP SCHEMA reps
GO
CREATE SCHEMA reps
GO

CREATE PARTITION FUNCTION pFuncStatus(tinyint)
	AS RANGE LEFT FOR VALUES (0,5)
CREATE PARTITION SCHEME pSchemeStatus
	AS PARTITION pFuncStatus TO 
	(EntitiesFG,EntitiesFG,DefaultFG)

-- Здесь было определение ошибок! Вынесено в отдельный модуль!

--- Procedures' definitions
IF OBJECT_ID('dbo.IsENP','FN') IS NOT NULL DROP FUNCTION dbo.IsENP
GO
-- Luhn algorithm
CREATE FUNCTION dbo.IsENP(@enp varchar(16)) RETURNS bit 
BEGIN
 SET @enp = RTRIM(LTRIM(@enp))
 SET @enp = STUFF(REPLICATE('0',16), 16-LEN(@enp)+1, LEN(@enp), @enp)
 IF LEN(@enp)<>16 RETURN 0

 DECLARE @CheckDigit char(1) = CAST(RIGHT(@enp,1) AS int)

 DECLARE @npos tinyint

 -- Нечётная часть числа
 DECLARE @OddPart varchar(16) = ''
 SET @npos = 15
 WHILE (@npos>0)
 BEGIN
  SET @OddPart = @OddPart + SUBSTRING(@enp, @npos, 1)
  IF @npos>2 SET @npos = @npos -2
  ELSE BREAK
 END

 -- Чётная часть числа
 DECLARE @EvenPart varchar(16) = ''
 SET @npos = 14
 WHILE (@npos>=1)
 BEGIN
  SET @EvenPart = @EvenPart + SUBSTRING(@enp, @npos, 1)
  IF @npos>2 SET @npos = @npos -2
  ELSE BREAK
 END

 -- Конкатенируем две части, предварительно умножив нечётную часть на два
 DECLARE @VAB char(40) = @EvenPart + RTRIM(CAST(CAST(@OddPart AS int)*2 AS char(16)))

 SET @npos = 0
 DECLARE @sum int = 0 
 WHILE (@npos <= LEN(@VAB))
 BEGIN
  SET @sum = @sum + cast(substring(@vab, @npos,1) as int)
  SET @npos = @npos + 1
 END
 
 DECLARE @vd int
 SET @vd = ceiling(cast(@sum as real)/10)*10 - @sum

 RETURN iif(@vd != @CheckDigit, 0, 1)
END
GO 

IF OBJECT_ID('dbo.KmsConv','FN') IS NOT NULL DROP FUNCTION dbo.KmsConv
GO
CREATE FUNCTION dbo.KmsConv(@sn_pol varchar(30)) RETURNS char(17)
BEGIN
 SET @sn_pol = RTRIM(LTRIM(@sn_pol))
 DECLARE @ser char(6)  = SUBSTRING(@sn_pol,1,6)
 DECLARE @num varchar(20) = SUBSTRING(@sn_pol,7,20)

 SET @num = LTRIM(RTRIM(@num))
 SET @num = STUFF(REPLICATE('0',10),10-LEN(@num)+1,LEN(@num),@num)

 RETURN @ser+' '+@num
END
GO 

IF OBJECT_ID('dbo.IsKms','FN') IS NOT NULL DROP FUNCTION dbo.IsKms
GO
CREATE FUNCTION dbo.IsKms(@sn_pol varchar(17)) RETURNS bit 
BEGIN
 SET @sn_pol = RTRIM(LTRIM(@sn_pol))
 DECLARE @ser char(6)  = SUBSTRING(@sn_pol,1,6)
 DECLARE @num char(10) = SUBSTRING(@sn_pol,8,10)

 -- Проверяем серию КМС на корректность
 IF SUBSTRING(@ser,1,2)!='77' RETURN 0
 IF ISNUMERIC(SUBSTRING(@ser,3,2))=0 RETURN 0
 IF CAST(SUBSTRING(@ser,3,2) AS tinyint) NOT BETWEEN 0 AND 99 RETURN 0
 IF ISNUMERIC(SUBSTRING(@ser,5,2))=0 RETURN 0
 IF (CAST(SUBSTRING(@ser,5,2) AS tinyint) NOT BETWEEN 0 AND 27) AND 
	(CAST(SUBSTRING(@ser,5,2) AS tinyint) NOT IN (45,50,51,52,73,77,99)) RETURN 0

SET @num = LTRIM(@num)
SET @num = STUFF(REPLICATE('0',10),10-LEN(@num)+1,LEN(@num),@num)

 -- Проверяем номер КМС на корректность
 DECLARE @n01 tinyint = CAST(SUBSTRING(@num,01,1) AS tinyint)
 DECLARE @n02 tinyint = CAST(SUBSTRING(@num,02,1) AS tinyint)
 DECLARE @n03 tinyint = CAST(SUBSTRING(@num,03,1) AS tinyint)
 DECLARE @n04 tinyint = CAST(SUBSTRING(@num,04,1) AS tinyint)
 DECLARE @n05 tinyint = CAST(SUBSTRING(@num,05,1) AS tinyint)
 DECLARE @n06 tinyint = CAST(SUBSTRING(@num,06,1) AS tinyint)
 DECLARE @n07 tinyint = CAST(SUBSTRING(@num,07,1) AS tinyint)
 DECLARE @n08 tinyint = CAST(SUBSTRING(@num,08,1) AS tinyint)
 DECLARE @n09 tinyint = CAST(SUBSTRING(@num,09,1) AS tinyint)
 DECLARE @n10 tinyint = CAST(SUBSTRING(@num,10,1) AS tinyint)

 DECLARE @r1 tinyint = (@n02*2 + @n03*8 + @n04*6 + @n05*3 + @n06*5 + @n07*4 + @n08*2 + @n09*1 + @n10*7) % 10
 IF @n01 != @r1 RETURN 0
 
 RETURN 1
END
GO 

IF OBJECT_ID('dbo.IsNewPerson','FN') IS NOT NULL DROP FUNCTION dbo.IsNewPerson
GO
CREATE FUNCTION dbo.IsNewPerson(@scn char(3)) RETURNS bit 
 BEGIN 
--  IF @scn IN ('CR','CP','PR','CD','CLR','POK','AD','XD') RETURN 'false'
  IF @scn IN ('CI','CPV','','','','','','') RETURN 'true'
--  RETURN 'true'
  RETURN 'false'
 END 
GO 

IF OBJECT_ID('dbo.Age','FN') IS NOT NULL DROP FUNCTION dbo.Age
GO
CREATE FUNCTION dbo.Age(@dr date, @curdate date) RETURNS tinyint
 BEGIN 
  DECLARE @Age tinyint
  SET @Age = DATEDIFF(year, @dr, @curdate)
  RETURN @Age
 END 
GO 
--- Procedures' definitions
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.isvalid')) DROP FUNCTION dbo.isvalid
GO
CREATE FUNCTION dbo.isvalid(@recid int /*сюда передается recid dbo.moves!*/, @scn char(3)) RETURNS bit
 BEGIN
  DECLARE @persid int, @status tinyint, @form tinyint, @spos tinyint, @predst tinyint, @dp date, @snils varchar(14),
   @dr date, @true_dr tinyint, @w tinyint, @c_okato varchar(5), @ra_name varchar(60), @np_c tinyint, @np_name varchar(60),
   @ul_c tinyint, @ul_name varchar(60), @dom50 varchar(7), @kor50 varchar(5), @str50 varchar(5), @kv50 varchar(5),
   @d_reg50 date, @ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5), @d_reg date,
   @pv char(3), @kl tinyint, @gr char(3), @mr varchar(max), 
   @ktg varchar(1), @lpuid decimal(4,0), @c_doc tinyint, @s_doc varchar(9), @n_doc varchar(8), @d_doc date, @e_doc date,
   @u_doc varchar(max), @x_doc tinyint, @c_perm tinyint, @s_perm varchar(9), @n_perm varchar(8), @d_perm date, @e_perm date,
   @oc_doc tinyint, @os_doc varchar(9), @on_doc varchar(8), @od_doc date, @oe_doc date, @ou_doc varchar(max),
   @enp char(16), @enpogrn varchar(13), @enpokato varchar(5), @enpdp date, @enpdt date, @enpdr date,
   @enp2 char(16), @enp2ogrn varchar(13), @enp2okato varchar(5), @enp2dp date, @enp2dt date,
   @fam varchar(40), @d_fam char(1), @im varchar(40), @d_im char(1), @ot varchar(40), @d_ot char(1),
   @s_vs varchar(12), @n_vs varchar(32), @vsogrn varchar(13), @vsokato varchar(5), @vsdp date, @vsdt date,
   @s_kms varchar(12), @n_kms varchar(32), @kmsogrn varchar(13), @kmsokato varchar(5), @kmsdp date, @kmsdt date,
   @kmsdr date, @s_okms varchar(12), @n_okms varchar(32), @okmsogrn varchar(13), @okmsokato varchar(5), @okmsdp date,
   @okmsdt date, @ofam varchar(40), @oim varchar(40), @oot varchar(40)
  
  SELECT @persid=persid, @status=status, @form=form, @spos=spos, @predst=predst, @dp=dp, @snils=snils,
   @dr=dr, @true_dr=true_dr, @w=w, @c_okato=c_okato, @ra_name=ra_name, @np_c=np_c, @np_name=np_name,
   @ul_c=ul_c, @ul_name=ul_name, @dom50=dom50, @kor50=kor50, @str50=str50, @kv50=kv50,
   @d_reg50=d_reg50, @ul=ul, @dom=dom, @kor=kor, @str=str, @kv=kv, @d_reg=d_reg,
   @pv=pv, @kl=kl, @gr=gr, @mr=mr, 
   @ktg=ktg, @lpuid=lpuid, @c_doc=c_doc, @s_doc=s_doc, @n_doc=n_doc, @d_doc=d_doc, @e_doc=e_doc,
   @u_doc=u_doc, @x_doc=x_doc, @c_perm=c_perm, @s_perm=s_perm, @n_perm=n_perm, @d_perm=d_perm, @e_perm=e_perm,
   @oc_doc=oc_doc, @os_doc=os_doc, @on_doc=on_doc, @od_doc=od_doc, @oe_doc=oe_doc, @ou_doc=ou_doc,
   @enp=enp, @enpogrn=enpogrn, @enpokato=enpokato, @enpdp=enpdp, @enpdt=enpdt, @enpdr=enpdr,
   @enp2=enp2, @enp2ogrn=enp2ogrn, @enp2okato=enp2okato, @enp2dp=enp2dp, @enp2dt=enp2dt,
   @fam=fam, @d_fam=d_fam, @im=im, @d_im=d_im, @ot=ot, @d_ot=d_ot,
   @s_vs=s_vs, @n_vs=n_vs, @vsogrn=vsogrn, @vsokato=vsokato, @vsdp=vsdp, @vsdt=vsdt,
   @s_kms=s_kms, @n_kms=n_kms, @kmsogrn=kmsogrn, @kmsokato=kmsokato, @kmsdp=kmsdp, @kmsdt=kmsdt,
   @kmsdr=kmsdr, @s_okms=s_okms, @n_okms=n_okms, @okmsogrn=okmsogrn, @okmsokato=okmsokato, @okmsdp=okmsdp,
   @okmsdt=okmsdt, @ofam=ofam, @oim=oim, @oot=oot FROM dbo.kmsview WHERE recid=@recid

  DECLARE @fioid int, @vsid int, @kmsid int, @enpid int, @adr_id int, @adr50_id int, @docid int,
   @ofioid int, @odocid int, @okmsid int, @oenpid int, @permid int, @enp2id int, @predstid int, @auxid int, @errid int
  SELECT @fioid=fioid, @vsid=vsid, @kmsid=kmsid, @enpid=enpid, @adr_id=adr_id, @adr50_id=adr50_id,
   @docid=docid, @ofioid=ofioid, @odocid=odocid, @okmsid=okmsid, @oenpid=oenpid, @permid=permid, @enp2id=enp2id,
   @predstid=predstid, @auxid=auxid, @errid=errid FROM dbo.moves WHERE recid=@recid

   IF (@adr_id IS NULL OR @fioid IS NULL OR @docid IS NULL) RETURN 'false'
   IF (@kl=99 AND @permid IS NULL) RETURN 'false'

  /*IF (@kl IS NULL OR @fam IS NULL OR @im IS NULL OR @ot IS NULL OR @dr IS NULL OR @w IS NULL OR @gr IS NULL OR
	@mr IS NULL OR @form IS NULL OR @predst IS NULL OR @spos IS NULL) RETURN 0*/
  
  RETURN 'true'
 END
GO

print 'The first step of creating kms database has been performed successfully!'
print 'Run UserDefinedErrors.sql'

