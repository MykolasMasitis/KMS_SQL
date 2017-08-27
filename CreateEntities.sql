-- Ver. 02.0. Release Date: 25 June 2017
-- The third step of creating Database KMS
-- All this code here is absolutely idempotent and can be executed repeatedly without ill effect

SET NOCOUNT ON
GO
USE kms
GO

-- Creating dbo.adr50 ok!
-- Creating dbo.adr77 ok!
-- Creating dbo.details
-- Creating dbo.docs ok!
-- Creating dbo.enp
-- Creating dbo.fio ok!
-- Creating dbo.kms
-- Creating dbo.ofio ok!
-- Creating dbo.predst
-- Creating dbo.wrkpl
-- Creating dbo.person

-- Creating FileTable
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.Photos')) DROP TABLE dbo.Photos
CREATE TABLE Photos AS FILETABLE WITH (FILETABLE_DIRECTORY='PHOTOS')

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.Signs')) DROP TABLE dbo.Signs
CREATE TABLE Signs AS FILETABLE WITH (FILETABLE_DIRECTORY='SIGNS')
-- Creating FileTable

-- Creating dbo.adr50
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekadr50')) DROP FUNCTION dbo.seekadr50
GO
--IF OBJECT_ID('dbo.adr50') IS NOT NULL 
IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME = 'adr50') DROP TABLE adr50
/*IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.adr50')) DROP TABLE dbo.adr50*/
CREATE TABLE dbo.adr50 (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
Parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
c_okato varchar(5), ra_name varchar(60), np_c tinyint NULL REFERENCES nsi.np_c(code),
np_name varchar(60), ul_c tinyint NULL REFERENCES nsi.ul_c(code), ul_name varchar(60), dom varchar(7), kor varchar(5),
[str] varchar(5), kv varchar(5), d_reg date, [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_adr50_unik ON dbo.adr50 (c_okato, ra_name, np_name, ul_name, dom, kor, [str], kv) INCLUDE (recid)
GO

IF OBJECT_ID('pseekadr50','P') IS NOT NULL DROP PROCEDURE pseekadr50
GO
CREATE PROCEDURE dbo.pseekadr50(@c_okato varchar(5)='', @ra_name varchar(60)='', @np_name varchar(60)='',
	 @ul_name varchar(60)='',@dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='',
	 @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM dbo.adr50 WHERE c_okato=@c_okato AND ra_name=@ra_name AND np_name=@np_name AND ul_name=@ul_name
	AND dom=@dom AND kor=@kor AND [str]=@str AND kv=@kv;
END
GO

CREATE FUNCTION dbo.seekadr50(@c_okato varchar(5), @ra_name varchar(60), @np_name varchar(60),
	 @ul_name varchar(60),@dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5)) RETURNS int WITH SCHEMABINDING
BEGIN
DECLARE @recid int
SELECT @recid=recid FROM dbo.adr50 WHERE c_okato=@c_okato AND ra_name=@ra_name AND np_name=@np_name AND ul_name=@ul_name
	AND dom=@dom AND kor=@kor AND [str]=@str AND kv=@kv
SET @recid=CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
RETURN @recid
END
GO

IF OBJECT_ID('uModAdr50','TR') IS NOT NULL DROP TRIGGER uModAdr50
GO
CREATE TRIGGER dbo.uModAdr50 ON dbo.adr50
INSTEAD OF UPDATE
AS
--IF UPDATE()
BEGIN
	SET NOCOUNT ON
	print 'uModAdr50 trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModAdr50 ON dbo.adr50
GO

IF OBJECT_ID('uDelAdr50','TR') IS NOT NULL DROP TRIGGER uDelAdr50
GO
CREATE TRIGGER dbo.uDelAdr50 ON dbo.adr50
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelAdr50 trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.adr50 SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
-- Creating dbo.adr50

-- Creating dbo.adr77
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekadr77')) DROP FUNCTION dbo.seekadr77
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.adr77')) DROP TABLE dbo.adr77
CREATE TABLE dbo.adr77 (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
arentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
ul int NOT NULL, dom varchar(7) NOT NULL, kor varchar(5), [str] varchar(5), kv varchar(5) NOT NULL, d_reg date,
[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_adr77_unik ON dbo.adr77 (ul,dom,kor,[str],kv) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

CREATE FUNCTION dbo.seekadr77 (@ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.adr77 WHERE ul=@ul AND dom=@dom AND (kor=@kor OR @kor is null) AND
	(str=@str OR @str is null) AND kv=@kv AND IsTop=1
 SET @recid=CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
 RETURN @recid
END
GO 

--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekadr77')) DROP PROCEDURE dbo.pseekadr77
GO
CREATE PROCEDURE dbo.pseekadr77(@ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5), @recid int=NULL out)
AS
BEGIN
 SET NOCOUNT ON;
 SELECT recid FROM dbo.adr77 WHERE ul=@ul AND dom=@dom AND kor=@kor AND str=@str AND kv=@kv AND IsTop=1
END
GO
--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModAdr77','TR') IS NOT NULL DROP TRIGGER uModAdr77
GO
CREATE TRIGGER dbo.uModAdr77 ON dbo.adr77
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModAdr77 trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModAdr77 ON dbo.adr77
GO

IF OBJECT_ID('uDelAdr77','TR') IS NOT NULL DROP TRIGGER uDelAdr77
GO
CREATE TRIGGER dbo.uDelAdr77 ON dbo.adr77
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelAdr77 trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.adr77 SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
-- Creating dbo.adr77

-- Creating dbo.details table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.details')) DROP TABLE dbo.details
CREATE TABLE dbo.details (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
pv char(3), nz varchar(5), kl tinyint NOT NULL DEFAULT 0, cont varchar(40),
gr char(3) default 'RUS' check(gr = upper(gr))  references nsi.countries(code),
mr varchar(max), comment varchar(max), ktg varchar(1), lpuid dec(4), 
[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO

IF OBJECT_ID('uModAux','TR') IS NOT NULL DROP TRIGGER uModAux
GO
CREATE TRIGGER dbo.uModAux ON dbo.details
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModAux trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModAux ON dbo.details
GO

IF OBJECT_ID('uDelAux','TR') IS NOT NULL DROP TRIGGER uDelAux
GO
CREATE TRIGGER dbo.uDelAux ON dbo.details
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelAux trigger fired!'

END
GO
DISABLE TRIGGER dbo.uDelAux ON dbo.details
GO
-- Creating dbo.details table

-- Creating dbo.docs table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekdocs')) DROP FUNCTION dbo.seekdocs
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.docs')) DROP TABLE dbo.docs
CREATE TABLE dbo.docs (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
tip tinyint/*1-осн. документ, 2-доп. документ, 3-старый документ*/, 
c_doc tinyint NOT NULL REFERENCES nsi.viddocs (code), s_doc varchar(12) NULL, n_doc varchar(16) NOT NULL, d_doc date NOT NULL, e_doc date,
u_doc varchar(max), x_doc tinyint NOT NULL DEFAULT 0, [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_docs_unik ON dbo.docs (s_doc, n_doc) INCLUDE (recid)
GO

CREATE FUNCTION dbo.seekdocs (@s_doc varchar(12), @n_doc varchar(16)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.docs WHERE s_doc=@s_doc AND n_doc=@n_doc
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekdocs')) DROP PROCEDURE dbo.pseekdocs
GO
CREATE PROCEDURE dbo.pseekdocs(@s_doc varchar(12)='', @n_doc varchar(16)='', @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM docs WHERE s_doc=@s_doc AND n_doc=@n_doc
END
GO
--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModDocs','TR') IS NOT NULL DROP TRIGGER uModDos
GO
CREATE TRIGGER dbo.uModDocs ON dbo.docs
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModDocs trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModDocs ON dbo.docs
GO

IF OBJECT_ID('uDelDocs','TR') IS NOT NULL DROP TRIGGER uDelDocs
GO
CREATE TRIGGER dbo.uDelDocs ON dbo.docs
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelDocs trigger fired!'
	SET NOCOUNT ON

END
GO
DISABLE TRIGGER dbo.uDelDocs ON dbo.docs
GO
-- Creating dbo.docs table

-- Creating dbo.enp table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekenp')) DROP FUNCTION dbo.seekenp
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.enp')) DROP TABLE dbo.enp
CREATE TABLE dbo.enp (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
tip tinyint, enp char(16) not null, blanc varchar(11) null, ogrn varchar(13) NOT NULL DEFAULT '1025004642519', 
okato varchar(5) NOT NULL DEFAULT '45000', dp date null, dt date null, dr date null,
[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_enp_unik ON dbo.enp (enp) INCLUDE (recid)
GO

CREATE FUNCTION dbo.seekenp (@enp char(16)/*, @ogrn varchar(13)='1025004642519', @okato varchar(5)='45000'*/) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.enp WHERE enp=@enp AND IsTop='true' /*AND ogrn=@ogrn AND okato=@okato*/
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekenp')) DROP PROCEDURE dbo.pseekenp
GO
CREATE PROCEDURE dbo.pseekenp(@enp char(16), @ogrn varchar(13)='1025004642519', @okato varchar(5)='45000', @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM dbo.enp WHERE enp=@enp AND ogrn=@ogrn AND okato=@okato
END
GO
--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModEnp','TR') IS NOT NULL DROP TRIGGER uModEnp
GO
CREATE TRIGGER dbo.uModEnp ON dbo.enp
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModEnp trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.kms SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uModEnp ON dbo.enp
GO

IF OBJECT_ID('uDelEnp','TR') IS NOT NULL DROP TRIGGER uDelEnp
GO
CREATE TRIGGER dbo.uDelEnp ON dbo.enp
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON

END
GO
DISABLE TRIGGER dbo.uDelEnp ON dbo.enp
GO
-- Creating dbo.enp table

-- Creating dbo.fio table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekfio')) DROP FUNCTION dbo.seekfio
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.fio')) DROP TABLE dbo.fio
CREATE TABLE dbo.fio (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(50) NOT NULL, d_fam char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code),
im varchar(50) NOT NULL, d_im char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code),
ot varchar(50), d_ot char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code), 
[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_fio_unik ON dbo.fio (fam,im,ot) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

CREATE FUNCTION dbo.seekfio (@fam varchar(50), @im varchar(50), @ot varchar(50)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.fio WHERE fam=@fam AND im=@im AND (ot=@ot or @ot is null) AND IsDeleted='false'
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

IF OBJECT_ID('uModFio','TR') IS NOT NULL DROP TRIGGER uModFio
GO
CREATE TRIGGER dbo.uModFio ON dbo.fio
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uModFio trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModFio ON dbo.fio
GO

IF OBJECT_ID('uDelFio','TR') IS NOT NULL DROP TRIGGER uDelFio
GO
CREATE TRIGGER dbo.uDelFio ON dbo.fio
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelFio trigger fired!'

	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.fio SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uDelFio ON dbo.fio
GO
-- Creating dbo.fio table

-- Creating dbo.kms table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekkms')) DROP FUNCTION dbo.seekkms
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.kms')) DROP TABLE dbo.kms
CREATE TABLE dbo.kms (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
tip tinyint /*1-ВС,2-КМС,3-старый КМС*/, s_card varchar(12) null, n_card varchar(32) not null, ogrn varchar(13) NOT NULL DEFAULT '1025004642519', okato varchar(5) NOT NULL DEFAULT '45000',
dp date null, dt date null, dr date null, [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_kms_unik ON dbo.kms (s_card,n_card) INCLUDE (recid)
GO

CREATE FUNCTION dbo.seekkms (@s_card varchar(12), @n_card varchar(32)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.kms WHERE s_card=@s_card AND n_card=@n_card AND IsTop='true'
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekkms')) DROP PROCEDURE dbo.pseekkms
GO
CREATE PROCEDURE dbo.pseekkms(@s_card varchar(12)=null, @n_card varchar(32)=null, @recid int=NULL out)
AS
BEGIN
 SET NOCOUNT ON;
 SELECT recid FROM dbo.kms WHERE s_card=@s_card AND n_card=@n_card
END
GO
--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModkms','TR') IS NOT NULL DROP TRIGGER uModkms
GO
CREATE TRIGGER dbo.uModkms ON dbo.kms
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModkms trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModkms ON dbo.kms
GO

IF OBJECT_ID('uDelKms','TR') IS NOT NULL DROP TRIGGER uDelKms
GO
CREATE TRIGGER dbo.uDelKms ON dbo.kms
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelKms trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.kms SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
	END
GO
DISABLE TRIGGER dbo.uDelKms ON dbo.kms
GO

-- Creating dbo.kms table

-- Creating dbo.ofio table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekofio')) DROP FUNCTION dbo.seekofio
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.ofio')) DROP TABLE dbo.ofio
CREATE TABLE dbo.ofio (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(50), im varchar(50), ot varchar(50), [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_ofio_unik ON dbo.ofio (fam,im,ot) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

CREATE FUNCTION dbo.seekofio (@fam varchar(50), @im varchar(50), @ot varchar(50)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.ofio WHERE fam=@fam AND im=@im AND (ot=@ot or @ot is null) AND IsDeleted='false'
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 


IF OBJECT_ID('uModOFio','TR') IS NOT NULL DROP TRIGGER uModOFio
GO
CREATE TRIGGER dbo.uModOFio ON dbo.ofio
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uModOFio trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModOFio ON dbo.ofio
GO

IF OBJECT_ID('uDelOFio','TR') IS NOT NULL DROP TRIGGER uDelOFio
GO
CREATE TRIGGER dbo.uDelOFio ON dbo.ofio
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelOFio trigger fired!'

	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.ofio SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
-- Creating dbo.ofio table

-- Creating dbo.person
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekpers')) DROP FUNCTION dbo.seekpers
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.person')) DROP TABLE dbo.person
CREATE TABLE dbo.person (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	snils varchar(14), dr date NOT NULL, true_dr tinyint NOT NULL DEFAULT 1 REFERENCES nsi.true_dr (code),
	w tinyint NOT NULL REFERENCES nsi.sex (code),
	photo varbinary(max), [sign] varbinary(max), [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_pers_snils ON dbo.person (snils) WHERE snils IS NOT NULL
GO

CREATE FUNCTION dbo.seekpers (@snils varchar(14)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.person WHERE snils=@snils
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

IF OBJECT_ID('uModPers','TR') IS NOT NULL DROP TRIGGER uModPers
GO
CREATE TRIGGER dbo.uModPers ON dbo.person
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uModPers trigger fired!'

END
GO
DISABLE TRIGGER dbo.uModPers ON dbo.person
GO

IF OBJECT_ID('uDelPers','TR') IS NOT NULL DROP TRIGGER uDelPers
GO
CREATE TRIGGER dbo.uDelPers ON dbo.person
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelPers trigger fired!'

END
GO
DISABLE TRIGGER dbo.uDelPers ON dbo.person
GO
-- Creating dbo.person

-- Creating dbo.predst table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekprfio')) DROP FUNCTION dbo.seekprfio
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.predst')) DROP TABLE dbo.predst
CREATE TABLE dbo.predst (recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(50), im varchar(50), ot varchar(50), c_doc tinyint, s_doc varchar(12), n_doc varchar(16), d_doc date,
u_doc varchar(max), tel1 varchar(10), tel2 varchar(10), inf varchar(100), [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) ON EntitiesFG
GO
CREATE UNIQUE INDEX idx_predst_unik ON dbo.predst (fam,im,ot) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO
CREATE FUNCTION dbo.seekprfio (@fam varchar(50), @im varchar(50), @ot varchar(50)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.predst WHERE fam=@fam AND im=@im AND (ot=@ot or @ot is null) AND IsDeleted='false'
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

-- Creating dbo.predst table

-- Creating dbo.wrkpl table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.wrkpl')) DROP TABLE dbo.wrkpl
CREATE TABLE [dbo].[wrkpl](
[recid] int IDENTITY(1,1),
[code] varchar(3), [name] varchar(100),
[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE(),
CONSTRAINT [PK_wrkpl] PRIMARY KEY CLUSTERED ([recid] ASC)) ON EntitiesFG
GO
--INSERT INTO wrkpl (code,name) values ('','')
--GO
CREATE INDEX name ON wrkpl (name)
GO
-- Creating dbo.wrkpl table

--Creating dbo.errors table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.errors')) DROP TABLE dbo.errors
CREATE TABLE dbo.errors (recid int IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
	istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
	et char(1) NOT NULL, code varchar(8) NOT NULL, [name] varchar(250), c_t char(5) NULL /*REFERENCES nsi.okato(okato)*/,
	ogrn char(13) NULL, [user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE())
GO 
CREATE UNIQUE INDEX idx_errors_unik ON dbo.errors (et, code) INCLUDE (recid)
GO
CREATE FUNCTION dbo.seekerror (@et char(1), @c_err varchar(5)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.errors WHERE et=@et AND code=@c_err
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 
IF OBJECT_ID('uDelErrors','TR') IS NOT NULL DROP TRIGGER uDelErrors
GO
CREATE TRIGGER dbo.uDelErrors ON dbo.errors
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelErrors trigger fired!'

	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.errors SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid
END
GO
DISABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
--Creating dbo.errors table


-- Example of handling jpg files
--UPDATE dbo.person SET photo = 
--	(SELECT BulkColumn FROM OpenRowSet (BULK 'd:\kms\base\060\jpeg\f004283.jpg', SINGLE_BLOB) AS TempJpg)
--	 WHERE recid=1
-- Example of handling jpg files

print 'The third step of creating kms database has been performed successfully!'
print 'Run CreateRelation.sql now!'
/*
IF EXISTS (SELECT * FROM sys.server_triggers WHERE name = 'logon_trigger')
DROP TRIGGER logon_trigger ON ALL SERVER
GO
*/