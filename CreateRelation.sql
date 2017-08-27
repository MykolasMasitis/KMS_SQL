-- Ver. 02.0. Release Date: 25 June 2017
-- The fourth step of creating Database KMS
-- The next (4th tep) is performing out of VFP module that populates the created here tables
-- All this code here is absolutely idempotent and can be executed repeatedly without ill effect

SET NOCOUNT ON
GO
USE kms
GO

-- Creating dbo.moves table 
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.moves')) DROP TABLE dbo.moves
CREATE TABLE dbo.moves (recid int IDENTITY(1,1), 
	parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
	istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
	status tinyint NOT NULL DEFAULT 1 REFERENCES nsi.status (code), 
	dp date null, d_gzk tinyint REFERENCES nsi.d_gzk (code),
	scn char(3) NOT NULL REFERENCES nsi.scenario (code),
	form tinyint NOT NULL DEFAULT 1 REFERENCES nsi.form (code),
	spos tinyint NOT NULL DEFAULT 1 REFERENCES nsi.spos (code),
	predst tinyint NOT NULL DEFAULT 0 REFERENCES nsi.predst (code),
	persid int NULL REFERENCES dbo.person(recid), 
	fioid int NULL REFERENCES dbo.fio(recid),
	vsid int NULL REFERENCES dbo.kms, 
	kmsid int NULL REFERENCES dbo.kms, 
	enpid int NULL REFERENCES dbo.enp(recid), 
	adr_id int NULL REFERENCES dbo.adr77(recid),
	adr50_id int NULL REFERENCES dbo.adr50(recid),
	docid int NULL REFERENCES dbo.docs(recid),
	ofioid int REFERENCES dbo.ofio(recid), odocid int NULL REFERENCES dbo.docs(recid), 
	okmsid int NULL REFERENCES dbo.kms,
	oenpid int NULL REFERENCES dbo.enp(recid), permid int NULL REFERENCES dbo.docs(recid),
	enp2id int NULL REFERENCES dbo.enp(recid),
	predstid int NULL REFERENCES dbo.predst (recid),
	auxid int REFERENCES dbo.details (recid), 
	errid int REFERENCES dbo.errors (recid), 
	[user] int DEFAULT SUSER_ID(), created datetime DEFAULT GETDATE()) -- ON pSchemeStatus(status)
GO
GO
CREATE CLUSTERED INDEX idx_moves_uniq ON dbo.moves (persid, parentid)
GO 
ALTER TABLE dbo.moves ADD CONSTRAINT PK_moves PRIMARY KEY (recid ASC)
GO

-- Creating dbo.moves table

/*
IF OBJECT_ID('uModMoves','TR') IS NOT NULL DROP TRIGGER uModMoves
GO
CREATE TRIGGER dbo.uModMoves ON dbo.moves
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModMoves trigger fired!'
	
	IF  NOT EXISTS (SELECT * FROM inserted EXCEPT SELECT * FROM deleted)
	 BEGIN 
	  PRINT 'Nothing has been changed (uModMoves)!'
	  RETURN
	 END 
	
	--DECLARE @testvalue int = power(2,(8-1))
	--IF (COLUMNS_UPDATED() & @testvalue) = 0
	DECLARE @nval tinyint = (select status from inserted)
	DECLARE @oval tinyint = (select status from deleted)

	--SET @nval = IIF(@nval IS NULL, @oval, @nval)

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @parentid int, @version_start datetime, @version_stop datetime, @isdeleted bit

	DECLARE @status tinyint, @dp date, @d_gzk tinyint, @scn char(3), @form tinyint, @spos tinyint, @predst tinyint,
		@persid int, @fioid int, @vsid int, @kmsid int, @enpid int, @adr_id int, @adr50_id int, @docid int,
		@ofioid int, @odocid int, @okmsid int, @oenpid int, @permid int, @enp2id int, @predstid int, @auxid int, @errid int
	DECLARE @o_status tinyint, @o_dp date, @o_d_gzk tinyint, @o_scn char(3), @o_form tinyint, @o_spos tinyint, 
		@o_predst tinyint, @o_persid int, @o_fioid int, @o_vsid int, @o_kmsid int, @o_enpid int, @o_adr_id int,
		@o_adr50_id int, @o_docid int, @o_ofioid int, @o_odocid int, @o_okmsid int, @o_oenpid int, @o_permid int,
		@o_enp2id int, @o_predstid int, @o_auxid int, @o_errid int
	
	SET @o_status   = (select status from deleted)
	SET @o_dp       = (select dp from deleted)
	SET @o_d_gzk    = (select d_gzk from deleted)
	SET @o_scn      = (select scn from deleted)
	SET @o_form     = (select form from deleted)
	SET @o_spos     = (select spos from deleted)
	SET @o_predst   = (select predst from deleted)
	SET @o_persid   = (select persid from deleted)
	SET @o_fioid    = (select fioid from deleted)
	SET @o_vsid     = (select vsid from deleted)
	SET @o_kmsid    = (select kmsid from deleted)
	SET @o_enpid    = (select enpid from deleted)
	SET @o_adr_id   = (select adr_id from deleted)
	SET	@o_adr50_id = (select adr50_id from deleted)
	SET @o_docid    = (select docid from deleted)
	SET @o_ofioid   = (select ofioid from deleted)
	SET @o_odocid   = (select odocid from deleted)
	SET @o_okmsid   = (select okmsid from deleted)
	SET @o_oenpid   = (select oenpid from deleted)
	SET @o_permid   = (select permid from deleted)
	SET	@o_enp2id   = (select enp2id from deleted)
	SET @o_predstid = (select predstid from deleted)
	SET @o_auxid    = (select auxid from deleted)
	SET @o_errid    = (select errid from deleted)

	DECLARE newcur CURSOR FOR SELECT
		recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		status, dp, d_gzk, scn, form, spos, predst, persid, fioid, vsid, kmsid, enpid, adr_id, adr50_id, docid,
		ofioid, odocid, okmsid, oenpid, permid, enp2id, predstid, auxid, errid
		FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @parentid, @version_start, @version_stop, @istop, @isdeleted,
		@status, @dp, @d_gzk, @scn, @form, @spos, @predst, @persid, @fioid, @vsid, @kmsid, @enpid, @adr_id,
		@adr50_id, @docid, @ofioid, @odocid, @okmsid, @oenpid, @permid, @enp2id, @predstid, @auxid, @errid

	CLOSE newcur
	DEALLOCATE newcur

    DECLARE @recid int = (select recid from deleted)
	
--	IF @nval != @oval
--	BEGIN

--	 print 'Поле status изменено!'+cast(@oval as char)+' '+cast(@nval as char)

--	 IF @status!=@o_status or coalesce(@dp,'')!=coalesce(@o_dp,'') or 
--	   coalesce(@d_gzk,0)!=coalesce(@o_d_gzk,0) or @scn!=@o_scn or 
--	   @form!=@o_form or @spos!=@o_spos or 
--	   @predst!=@o_predst or coalesce(@persid,0)!=coalesce(@o_persid,0) or 
--	   coalesce(@fioid,0)!=coalesce(@o_fioid,0) or coalesce(@vsid,0)!=coalesce(@o_vsid,0) or 
--	   coalesce(@kmsid,0)!=coalesce(@o_kmsid,0) or coalesce(@enpid,0)!=coalesce(@o_enpid,0) or
--	   coalesce(@adr_id,0)!=coalesce(@o_adr_id,0) or coalesce(@adr50_id,0)!=coalesce(@o_adr50_id,0) or 
--	   coalesce(@docid,0)!=coalesce(@o_docid,0) or coalesce(@ofioid,0)!=coalesce(@o_ofioid,0) or 
--	   coalesce(@odocid,0)!=coalesce(@o_odocid,0) or coalesce(@okmsid,0)!=coalesce(@o_okmsid,0) or 
--	   coalesce(@oenpid,0)!=coalesce(@o_oenpid,0) or coalesce(@permid,0)!=coalesce(@o_permid,0) or 
--	   coalesce(@enp2id,0)!=coalesce(@o_enp2id,0) or coalesce(@predstid,0)!=coalesce(@o_predstid,0) or 
--	   coalesce(@auxid,0)!=coalesce(@o_auxid,0) or coalesce(@errid,0)!=coalesce(@o_errid,0)
--	  BEGIN 

	   UPDATE dbo.moves SET istop=0, version_stop=sysdatetime() WHERE moves.recid=@recid

	   INSERT INTO dbo.moves
		(parentid, version_start, version_stop, istop, isdeleted,
		[status], dp, d_gzk, scn, form, spos, predst, persid, fioid, vsid, kmsid, enpid, adr_id, adr50_id, docid,
		ofioid, odocid, okmsid, oenpid, permid, enp2id, predstid, auxid, errid)
	   SELECT deleted.recid as parentid, sysdatetime() as version_start, null as version_stop, 'true' as istop, 'false' as isdeleted,
		[status], dp, d_gzk, scn, form, spos, predst, persid, fioid, vsid, kmsid, enpid, adr_id, adr50_id, docid,
		ofioid, odocid, okmsid, oenpid, permid, enp2id, predstid, auxid, errid
		FROM inserted LEFT JOIN deleted ON inserted.recid=deleted.recid

	   INSERT INTO dbo.moves
		(parentid, version_start, version_stop, istop, isdeleted,
		[status], dp, d_gzk, scn, form, spos, predst, persid, fioid, vsid, kmsid, enpid, adr_id, adr50_id, docid,
		ofioid, odocid, okmsid, oenpid, permid, enp2id, predstid, auxid, errid)
			VALUES
		(@parentid, @version_start, @version_stop, @istop, @isdeleted,
		coalesce(@status, @o_status), coalesce(@dp, @o_dp), coalesce(@d_gzk, @o_d_gzk), coalesce(@scn, @o_scn),
		coalesce(@form, @o_form), coalesce(@spos, @o_spos), coalesce(@predst, @o_predst), coalesce(@persid, @o_persid),
		coalesce(@fioid, @o_fioid), coalesce(@vsid, @o_vsid), coalesce(@kmsid, @o_kmsid), coalesce(@enpid, @o_enpid),
		coalesce(@adr_id, @o_adr_id), coalesce(@adr50_id,@o_adr50_id), coalesce(@docid,@o_docid),coalesce(@ofioid, @o_ofioid),
		coalesce(@odocid, @o_odocid), coalesce(@okmsid, @o_okmsid), coalesce(@oenpid, @o_oenpid), coalesce(@permid, @o_permid),
		coalesce(@enp2id, @o_enp2id), coalesce(@predstid, @o_predstid), coalesce(@auxid, @o_auxid), coalesce(@errid, @o_errid))

	   UPDATE dbo.moves SET childid=SCOPE_IDENTITY() WHERE moves.recid=@recid
--	  END 
--	 else 
--	  begin
--	   print 'qwert'
--	  end 
--	 END

--	ELSE
--	BEGIN
--	 UPDATE dbo.moves SET [status]=@status, dp=@dp, d_gzk=@d_gzk, scn=@scn, form=@form, spos=@spos, predst=@predst, 
--		persid=@persid, fioid=iif(@fioid=0,null,@fioid), vsid=@vsid, kmsid=@kmsid, enpid=@enpid, adr_id=iif(@adr_id=0,null,@adr_id), adr50_id=@adr50_id, 
--		docid=@docid, ofioid=iif(@ofioid=0, null, @ofioid), odocid=@odocid, okmsid=@okmsid, oenpid=@o_enpid, permid=@permid, enp2id=@enp2id,
--		predstid=@predstid, auxid=@auxid, errid=@errid WHERE moves.recid=@recid
--	END 

END
GO
DISABLE TRIGGER dbo.uModMoves ON dbo.moves
GO
*/

IF OBJECT_ID('uModMoves','TR') IS NOT NULL DROP TRIGGER uModMoves
GO
CREATE TRIGGER dbo.uModMoves ON dbo.moves
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModMoves trigger fired!'
	
	IF  NOT EXISTS (SELECT * FROM inserted EXCEPT SELECT * FROM deleted)
	 BEGIN 
	  PRINT 'Nothing has been changed (uModMoves)!'
	  RETURN
	 END 

    INSERT INTO dbo.moves
	 (parentid, version_start, version_stop, istop, isdeleted,
	 [status], dp, d_gzk, scn, form, spos, predst, persid, fioid, vsid, kmsid, enpid, adr_id, adr50_id, docid,
	 ofioid, odocid, okmsid, oenpid, permid, enp2id, predstid, auxid, errid)
    SELECT deleted.recid as parentid, sysdatetime() as version_start, null as version_stop, 'true' as istop, 'false' as isdeleted,
	 inserted.status, inserted.dp, inserted.d_gzk, inserted.scn, inserted.form, inserted.spos, inserted.predst, inserted.persid,
	 inserted.fioid, inserted.vsid, inserted.kmsid, inserted.enpid, inserted.adr_id, inserted.adr50_id, inserted.docid,
	 inserted.ofioid, inserted.odocid, inserted.okmsid, inserted.oenpid, inserted.permid, inserted.enp2id, inserted.predstid,
	 inserted.auxid, inserted.errid
	 FROM inserted INNER JOIN deleted ON inserted.recid=deleted.recid

    UPDATE dbo.moves SET istop='false', version_stop=sysdatetime() WHERE recid IN (SELECT recid FROM deleted)

	UPDATE a SET a.childid=b.recid FROM dbo.moves a JOIN dbo.moves b ON a.recid=b.parentid

END
GO
DISABLE TRIGGER dbo.uModMoves ON dbo.moves
GO

IF OBJECT_ID('uDelMoves','TR') IS NOT NULL DROP TRIGGER uDelMoves
GO
CREATE TRIGGER dbo.uDelMoves ON dbo.moves
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelMoves trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.moves SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

END
GO
DISABLE TRIGGER dbo.uDelMoves ON dbo.moves
GO

print 'The fourth step of creating kms database has been performed successfully!'
print 'Run CreateInterface.sql now!'
