-- Ver. 02.0. Release Date: 25 June 2017
-- Creating a view with procs
--
USE kms
GO
IF OBJECT_ID('dbo.ViewMoves','V') IS NOT NULL DROP VIEW dbo.ViewMoves
GO

CREATE VIEW dbo.viewmoves WITH SCHEMABINDING AS SELECT 
	a.recid,a.status,a.scn,a.form,a.spos,a.predst,a.dp,
	b.snils,b.dr,b.true_dr,b.w,b.photo,b.sign,
	c.c_okato,c.ra_name,c.np_c,c.np_name,c.ul_c,c.ul_name,c.dom as dom50,c.kor as kor50,c.str as str50,c.kv as kv50,c.d_reg as d_reg50,
	d.ul,c.dom,d.kor,d.str,d.kv,d.d_reg,
	e.pv,e.nz,e.kl,e.cont,e.gr,e.mr,e.comment,e.ktg,e.lpuid,
	f.c_doc,f.s_doc,f.n_doc,f.d_doc,f.e_doc,f.u_doc,f.x_doc,
	g.c_doc as c_perm,g.s_doc as s_perm,g.n_doc as n_perm,g.d_doc as d_perm,g.e_doc as e_perm,
	h.c_doc as oc_doc,h.s_doc as os_doc,h.n_doc as on_doc,h.d_doc as od_doc,h.e_doc as oe_doc,h.u_doc as ou_doc,
	i.enp,i.blanc,i.ogrn as enpogrn,i.okato as enpokato,i.dp as enpdp,i.dt as enpdt,i.dr as enpdr,
	j.enp as enp2,j.ogrn as enp2ogrn,j.okato as enp2okato,j.dp as enp2dp,j.dt as enp2dt,
	k.fam,k.d_fam,k.im,k.d_im,k.ot,k.d_ot,
	l.s_card as s_vs,l.n_card as n_vs,l.ogrn as vsogrn,l.okato as vsokato,l.dp as vsdp,l.dt as vsdt,
	m.s_card as s_kms,m.n_card as n_kms,m.ogrn as kmsogrn,m.okato as kmsokato,m.dp as kmsdp,m.dt as kmsdt,
	n.s_card as s_okms,n.n_card as n_okms,n.ogrn as okmsogrn,n.okato as okmsokato,n.dp as okmsdp,n.dt as okmsdt,
	o.fam as ofam, o.im as oim, o.ot as oot,
	p.et as et, p.code as err_code, p.name as err_text, p.c_t as err_c_t, p.ogrn as err_okato
	
	FROM dbo.moves a

	LEFT OUTER JOIN dbo.person     b ON a.persid=b.recid
	LEFT OUTER JOIN dbo.adr50    c ON a.adr50_id=c.recid
	LEFT OUTER JOIN dbo.adr77    d ON a.adr_id=d.recid
	LEFT OUTER JOIN dbo.details  e ON a.auxid=e.recid
	LEFT OUTER JOIN dbo.docs     f ON a.docid=f.recid
	LEFT OUTER JOIN dbo.docs     g ON a.permid=g.recid
	LEFT OUTER JOIN dbo.docs     h ON a.odocid=h.recid
	LEFT OUTER JOIN dbo.enp      i ON a.enpid=i.recid
	LEFT OUTER JOIN dbo.enp      j ON a.enp2id=j.recid
	LEFT OUTER JOIN dbo.fio      k ON a.fioid=k.recid
	LEFT OUTER JOIN dbo.kms      l ON a.vsid=l.recid
	LEFT OUTER JOIN dbo.kms      m ON a.kmsid=m.recid
	LEFT OUTER JOIN dbo.kms      n ON a.okmsid=n.recid
	LEFT OUTER JOIN dbo.ofio     o ON a.ofioid=o.recid
	LEFT OUTER JOIN dbo.errors   p ON a.errid=p.recid

	WHERE a.isdeleted=0
GO
--CREATE UNIQUE CLUSTERED INDEX CLU_recid ON dbo.kmsview(recid)
--GO 

IF OBJECT_ID('dbo.GetPersons','P') IS NOT NULL DROP PROCEDURE dbo.GetPersons
GO
CREATE PROCEDURE dbo.GetPersons
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM kmsview;
END
GO

IF OBJECT_ID('dbo.preview','V') IS NOT NULL DROP VIEW dbo.preview
GO
CREATE VIEW dbo.preview AS SELECT a.recid, g.snils, g.w, g.dr, h.enp, j.fam, j.im, j.ot, k.s_card as s_vs, k.n_card as n_vs
FROM dbo.moves a
LEFT OUTER JOIN dbo.person g ON a.persid=g.recid
LEFT OUTER JOIN dbo.enp h ON a.enpid=h.recid
LEFT OUTER JOIN dbo.fio j ON a.fioid=j.recid
LEFT OUTER JOIN dbo.kms k ON a.vsid=k.recid
WHERE a.isdeleted=0
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.oneview')) DROP FUNCTION dbo.oneview
GO
CREATE FUNCTION dbo.oneview (@recid int) RETURNS TABLE
AS RETURN (SELECT * FROM dbo.preview WHERE recid=@recid)
GO 

IF OBJECT_ID('dbo.kmsview','V') IS NOT NULL DROP VIEW dbo.kmsview
GO
CREATE VIEW dbo.kmsview WITH SCHEMABINDING AS SELECT 
	a.recid, o.recid as persid, d.pv, a.status,a.scn,a.form,a.spos,a.predst,a.dp, 
	j.fam as fam,j.d_fam,j.im as im,j.d_im,j.ot as ot,j.d_ot,
	o.snils,o.dr as dr,o.true_dr,o.w,o.photo,o.sign,
	c.ul,r.name, c.dom,c.kor,c.str,c.kv,c.d_reg,
	d.nz,d.kl,d.cont,d.gr,d.mr,d.comment,d.ktg,d.lpuid,
	e.c_doc,e.s_doc,e.n_doc,e.d_doc,e.e_doc,e.u_doc,e.x_doc,
	f.c_doc as c_perm,f.s_doc as s_perm,f.n_doc as n_perm,f.d_doc as d_perm,f.e_doc as e_perm,
	g.c_doc as oc_doc,g.s_doc as os_doc,g.n_doc as on_doc,g.d_doc as od_doc,g.e_doc as oe_doc, g.u_doc as ou_doc,
	h.enp,h.blanc,h.ogrn as enpogrn,h.okato as enpokato,h.dp as enpdp,h.dt as enpdt,h.dr as enpdr,
	i.enp as enp2,i.ogrn as enp2ogrn,i.okato as enp2okato,i.dp as enp2dp,i.dt as enp2dt,
	k.s_card as s_vs,k.n_card as n_vs,k.ogrn as vsogrn,k.okato as vsokato,k.dp as vsdp,k.dt as vsdt,
	l.s_card as s_kms,l.n_card as n_kms,l.ogrn as kmsogrn,l.okato as kmsokato,l.dp as kmsdp,l.dt as kmsdt,l.dr as kmsdr,
	m.s_card as s_okms,m.n_card as n_okms,m.ogrn as okmsogrn,m.okato as okmsokato,m.dp as okmsdp,m.dt as okmsdt,
	n.fam as ofam,n.im as oim,n.ot as oot,
	b.c_okato,b.ra_name,b.np_c,b.np_name,b.ul_c,b.ul_name,b.dom as dom50,b.kor as kor50,b.str as str50,b.kv as kv50, b.d_reg as d_reg50,
	p.et as et, p.code as err_code, p.name as err_text, p.c_t as err_c_t, p.ogrn as err_okato,
	q.fam as pr_fam, q.im as pr_im, q.ot as pr_ot, q.c_doc as pr_c_doc, q.s_doc as pr_s_doc, q.n_doc as pr_n_doc,
	q.d_doc as pr_d_doc, q.u_doc as pr_u_doc, q.tel1 as pr_tel1, q.tel2 as pr_tel2, q.inf as pr_inf, a.created as created

	FROM dbo.moves a
	LEFT OUTER JOIN dbo.adr50 b ON a.adr50_id=b.recid
	LEFT OUTER JOIN dbo.adr77 c ON a.adr_id=c.recid
	LEFT OUTER JOIN dbo.details d ON a.auxid=d.recid
	LEFT OUTER JOIN dbo.docs e ON a.docid=e.recid
	LEFT OUTER JOIN dbo.docs f ON a.permid=f.recid
	LEFT OUTER JOIN dbo.docs g ON a.odocid=g.recid
	LEFT OUTER JOIN dbo.enp h ON a.enpid=h.recid
	LEFT OUTER JOIN dbo.enp i ON a.enp2id=i.recid
	LEFT OUTER JOIN dbo.fio j ON a.fioid=j.recid
	LEFT OUTER JOIN dbo.kms k ON a.vsid=k.recid
	LEFT OUTER JOIN dbo.kms l ON a.kmsid=l.recid
	LEFT OUTER JOIN dbo.kms m ON a.okmsid=m.recid
	LEFT OUTER JOIN dbo.ofio n ON a.ofioid=n.recid
	LEFT OUTER JOIN dbo.person o ON a.persid=o.recid
	LEFT OUTER JOIN dbo.errors p ON a.errid=p.recid
	LEFT OUTER JOIN dbo.predst q ON a.predstid=q.recid
	LEFT OUTER JOIN nsi.streets r ON c.ul=r.code
	WHERE a.istop=1
GO
--CREATE UNIQUE CLUSTERED INDEX CLU_recid ON dbo.kmsview(recid)
--GO 

IF OBJECT_ID('dbo.GetPersons','P') IS NOT NULL DROP PROCEDURE dbo.GetPersons
GO
CREATE PROCEDURE dbo.GetPersons
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM kmsview;
END
GO


-- Proc dbo.AddPerson
IF OBJECT_ID('dbo.AddPerson','P') IS NOT NULL DROP PROCEDURE dbo.AddPerson
GO
CREATE PROCEDURE dbo.AddPerson (@recid int=null, @status tinyint=1, @scn char(3), @dp date=null, @d_gzk tinyint=null, @form tinyint=1, @spos tinyint=1, @predst tinyint=0,
	@snils varchar(14)=null, @dr date=null, @true_dr tinyint=1, @w tinyint=null,
	@pv char(3)=null, @nz varchar(5)=null, @kl tinyint=null, @cont varchar(40)=null, @gr char(3)=null, @mr varchar(max)=null, @comment varchar(max)=null, @ktg varchar(1)=null, @lpuid dec(4)=null,
	@fam varchar(50)=null, @d_fam char(1)=null, @im varchar(50)=null, @d_im char(1)=null, @ot varchar(50)=null, @d_ot char(1)=null, 
	@ofam varchar(50)=null, @oim varchar(50)=null, @oot varchar(50)=null,
	@photo varbinary(max)=null, @sign varbinary(max)=null, /*@oper tinyint=0, @operpv tinyint=0,*/
	@s_vs varchar(12)=null, @n_vs varchar(32)=null, @vs_dp date=null, @vs_dt date=null, 
	@s_kms varchar(12)=null, @n_kms varchar(32)=null, @kmsogrn varchar(13)='1025004642519', @kmsokato varchar(5)='45000', @kms_dp date=null, @kms_dt date=null, @kms_dr date=null,
	@s_okms varchar(12)=null, @n_okms varchar(32)=null, @okmsogrn varchar(13)='1025004642519', @okmsokato varchar(5)='45000', @okms_dp date=null, @okms_dt date=null, @okms_dr date=null,
	@enp varchar(16)=null, @blanc varchar(11)=null, @enpogrn varchar(13)=null, @enpokato varchar(5)=null, @enp_dp date=null, @enp_dt date=null, @enp_dr date=null,
	@oenp varchar(16)=null, @oenpogrn varchar(13)=null, @oenpokato varchar(5)=null, @oenp_dp date=null,
	@enp2 varchar(16)=null, @blanc2 varchar(11)=null, @enp2ogrn varchar(13)=null, @enp2okato varchar(5)=null, @enp2_dp date=null, @enp2_dt date=null, @enp2_dr date=null,
	@c_doc tinyint=null, @s_doc varchar(12)=null, @n_doc varchar(16)=null, @d_doc date=null, @e_doc date=null, @u_doc varchar(max)=null, @x_doc tinyint=0,
	@c_perm tinyint=null, @s_perm varchar(12)=null, @n_perm varchar(16)=null, @d_perm date=null, @e_perm date=null,
	@oc_doc tinyint=null, @os_doc varchar(12)=null, @on_doc varchar(16)=null, @od_doc date=null, @oe_doc date=null, @ou_doc varchar(max)=null, @ox_doc tinyint=0,
	@ul int=null, @dom varchar(7)=null, @kor varchar(5)=null, @str varchar(5)=null, @kv varchar(5)=null, @d_reg77 date=null,
	@c_okato varchar(5)=null, @ra_name varchar(60)=null, @np_c tinyint=null, @np_name varchar(60)=null, @ul_c tinyint=null, @ul_name varchar(60)=null,
	@dom50 varchar(7)=null, @kor50 varchar(5)=null, @str50 varchar(5)=null, @kv50 varchar(5)=null, @d_reg50 date=null,
	@pr_fam varchar(50)=null, @pr_im varchar(50)=null, @pr_ot varchar(50)=null, @pr_c_doc tinyint=null, @pr_s_doc varchar(9)=null, @pr_n_doc varchar(8)=null, @pr_d_doc date=null, @pr_u_doc varchar(max)=null,
	@pr_tel1 varchar(10)=null, @pr_tel2 varchar(10)=null, @pr_inf varchar(100)=null, 
	@out_id int OUTPUT)
AS
BEGIN TRY
	BEGIN TRANSACTION
	print 'dbo.AddPerson'

    DECLARE @persid int, @vsid int, @kmsid int, @okmsid int, @enpid int, @oenpid int, @enp2id int, @docid int,
		@odocid int, @permid int, @fioid int, @ofioid int, @adr_id int, @adr50_id int, @auxid int, @predstid int 

	--IF dbo.IsNewPerson(@scn)=0 BEGIN RAISERROR(60001, 16, 1) RETURN END 
	 
	IF (@fam IS NULL OR @fam='') BEGIN RAISERROR(60002, 16, 1) RETURN END
	IF (@im IS NULL OR @im='') BEGIN RAISERROR(60003, 16, 1) RETURN END
	IF ((@ot IS NULL OR @ot='') AND COALESCE(@d_ot,' ')!='0') BEGIN RAISERROR(60004, 16, 1) RETURN END
	IF (@dr IS NULL OR @dr='') BEGIN RAISERROR(60005, 16, 1) RETURN END
	IF (@w IS NULL OR @w NOT IN (1,2)) BEGIN RAISERROR(60006, 16, 1) RETURN END

	--IF (@gr NOT IN (SELECT code FROM nsi.countries)) BEGIN RAISERROR(90103, 16, 1) RETURN END
	--IF (@mr IS NULL OR @mr='') BEGIN RAISERROR(90104, 16, 1) RETURN END
	--IF (@c_doc IS NULL) BEGIN RAISERROR(90108, 16, 1) RETURN END
	--IF (@s_doc IS NULL OR @s_doc='') BEGIN RAISERROR(90109, 16, 1) RETURN END
	--IF (@n_doc IS NULL OR @n_doc='') BEGIN RAISERROR(90110, 16, 1) RETURN END
	--IF (@d_doc IS NULL OR @d_doc='') BEGIN RAISERROR(90111, 16, 1) RETURN END

	INSERT INTO dbo.person (snils, dr, true_dr, w) VALUES (@snils, @dr, COALESCE(@true_dr, 1), @w)
	SET @persid = @@IDENTITY

    INSERT INTO dbo.fio (fam, d_fam, im, d_im, ot, d_ot) VALUES (@fam, coalesce(@d_fam,' '), @im, coalesce(@d_im,' '), @ot, coalesce(@d_ot,' '))
	SET @fioid = SCOPE_IDENTITY()

	--Старые ФИО
	IF (@ofam IS NOT NULL AND @ofam!='') or (@oim IS NOT NULL AND @oim!='') or (@oot IS NOT NULL AND @oot!='')
	 BEGIN
	  INSERT INTO dbo.ofio (fam, im, ot) VALUES (@ofam, @oim, @oot)
	  SET @ofioid = SCOPE_IDENTITY()
	 END 
	--Старые ФИО
	--ВС
	IF (@n_vs IS NOT NULL)
	 BEGIN
	  INSERT INTO dbo.kms (tip, s_card, n_card, dp, dt) VALUES (1, @s_vs, @n_vs, @vs_dp, @vs_dt)
	  SET @vsid = SCOPE_IDENTITY()
	 END 
	--ВС
	--КМС
	IF (@n_kms IS NOT NULL)
	 BEGIN
	 INSERT INTO dbo.kms (tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES (2, @s_kms, @n_kms, @kmsogrn, @kmsokato, @kms_dp, @kms_dt, @kms_dr)
	  SET @kmsid = SCOPE_IDENTITY()
	 END 
	--КМС
	--Старый КМС
	IF (@n_okms IS NOT NULL)
	 BEGIN
	  INSERT INTO dbo.kms (tip, s_card, n_card, dp, dt, dr) VALUES (3, @s_okms, @n_okms, @okms_dp, @okms_dt, @okms_dr)
	  SET @okmsid = SCOPE_IDENTITY()
	 END 
	--Старый КМС

	--Основной документ
	IF (@n_doc IS NOT NULL)
	 BEGIN
	  INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(1, @c_doc, @s_doc, @n_doc, @d_doc, @e_doc, @u_doc, @x_doc)
	  SET @docid = SCOPE_IDENTITY()
	 END 
	--Основной документ
	--Разрешение на проживание
	IF (@n_perm IS NOT NULL)
	 BEGIN
	  INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc) VALUES 
		(2, @c_perm, @s_perm, @n_perm, @d_perm, @e_perm)
	  SET @permid = SCOPE_IDENTITY()
	 END 
	--Разрешение на проживание
	--Старый документ
	IF (@on_doc IS NOT NULL)
	 BEGIN
	  INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(3, @oc_doc, @os_doc, @on_doc, @od_doc, @oe_doc, @ou_doc, @ox_doc)
	  SET @odocid = SCOPE_IDENTITY()
	 END 
	--Старый документ
	--ЕНП
	IF (@enp IS NOT NULL)
	 BEGIN
	  IF @enpogrn IS NULL and @enpokato IS NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, dp, dt) VALUES (1, @enp, @blanc, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn IS NULL and @enpokato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, okato, dp, dt) VALUES (1, @enp, @blanc, @enpokato, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn IS NOT NULL and @enpokato IS NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, ogrn, dp, dt) VALUES (1, @enp, @blanc, @enpogrn, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn IS NOT NULL and @enpokato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, okato, ogrn, dp, dt) VALUES (1, @enp, @blanc, @enpokato, @enpogrn, @enp_dp, @enp_dt)

	  SET @enpid = SCOPE_IDENTITY()
	 END 
	--ЕНП
	--Старый ЕНП
	IF (@oenp IS NOT NULL)
	 BEGIN
	  IF @enpogrn IS NULL and @enpokato IS NULL
	   INSERT INTO dbo.enp (tip, enp, dp) VALUES (2, @oenp, @oenp_dp)
	  ELSE IF @enpogrn IS NULL and @enpokato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, okato, dp) VALUES (2, @oenp, @oenpokato, @oenp_dp)
	  ELSE IF @enpogrn IS NOT NULL and @enpokato IS NULL
	   INSERT INTO dbo.enp (tip, enp, ogrn, dp) VALUES (2, @oenp, @oenpogrn, @oenp_dp)
	  ELSE IF @enpogrn IS NOT NULL and @enpokato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, okato, ogrn, dp) VALUES (2, @oenp, @oenpokato, @oenpogrn, @oenp_dp)

	  SET @oenpid = SCOPE_IDENTITY()
	 END 
	--Старый ЕНП
	--Второй ЕНП
	IF (@enp2 IS NOT NULL)
	 BEGIN
	  IF @enp2ogrn IS NULL and @enp2okato IS NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, dp, dt) VALUES (2, @enp2, @blanc2, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn IS NULL and @enp2okato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, okato, dp, dt) VALUES (2, @enp2, @blanc2,@enp2okato, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn IS NOT NULL and @enp2okato IS NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, ogrn, dp, dt) VALUES (2, @enp2, @blanc2, @enp2ogrn, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn IS NOT NULL and @enp2okato IS NOT NULL
	   INSERT INTO dbo.enp (tip, enp, blanc, okato, ogrn, dp, dt) VALUES (2, @enp2, @blanc2, @enp2okato, @enp2ogrn, @enp2_dp, @enp2_dt)

	  SET @enp2id = SCOPE_IDENTITY()
	 END 
	--Второй ЕНП
	--Московский адрес
	IF (@ul IS NOT NULL)
	 BEGIN
	  SET @adr_id = dbo.seekadr77 (@ul, @dom, @kor, @str, @kv)
	  IF @adr_id = 0
	   BEGIN
		INSERT INTO dbo.adr77 (ul, dom, kor, [str], kv, d_reg) VALUES (@ul, @dom, @kor, @str, @kv, @d_reg77)
		SET @adr_id = SCOPE_IDENTITY()
	   END 
	 END 
	--Московский адрес
	--Иногородний адрес
	IF (@c_okato!='' AND @c_okato IS NOT NULL)
	 BEGIN
	  SET @adr50_id = dbo.seekadr50(@c_okato, @ra_name, @np_name, @ul_name, @dom, @kor, @str, @kv)
	  IF @adr50_id = 0
	  BEGIN 
	   INSERT INTO dbo.adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES 
		(@c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50)
	   SET @adr50_id = SCOPE_IDENTITY()
	  END
	 --UPDATE dbo.moves SET adr50_id=@adr50_id WHERE recid=@recid
	 END 
	--Иногородний адрес
	-- details
	IF ((@pv!='' and @pv IS NOT NULL) or (@nz!='' and @nz IS NOT NULL) or (@kl IS NOT NULL) or
		(@cont!='' and @cont IS NOT NULL) or (@gr!='' and @gr IS NOT NULL) or (@mr!='' and @mr IS NOT NULL) or 
		(@comment!='' and @comment IS NOT NULL) or (@ktg!='' and @ktg IS NOT NULL) or (@lpuid IS NOT NULL))
	 BEGIN
	  INSERT INTO dbo.details(pv, nz, kl, cont, gr, mr, comment, ktg, lpuid) VALUES 
		(@pv, @nz, coalesce(@kl,0), @cont, @gr, @mr, @comment, @ktg, @lpuid)
	  SET @auxid = SCOPE_IDENTITY()
	 END 
	-- details
	--Представитель
	IF (@pr_fam IS NOT NULL AND @pr_fam!='') or (@pr_im IS NOT NULL AND @pr_im!='') or (@pr_ot IS NOT NULL AND @pr_ot!='')
	 BEGIN
	  SET @predstid = dbo.seekprfio(@pr_fam, @pr_im, @pr_ot)
	  IF @predstid = 0 
	   BEGIN
	   INSERT INTO dbo.predst (fam, im, ot, c_doc, s_doc, n_doc, d_doc, u_doc, tel1, tel2, inf) VALUES 
		(@pr_fam, @pr_im, @pr_ot,@pr_c_doc,@pr_s_doc,@pr_n_doc,@pr_d_doc,@pr_u_doc,@pr_tel1,@pr_tel2,@pr_inf)
	   SET @predstid = SCOPE_IDENTITY()
	  END 
	 END 
	--Представитель

	INSERT INTO dbo.moves (persid, status, scn, dp, d_gzk, form, spos, predst, predstid, vsid, kmsid, enpid, fioid, adr_id, adr50_id,
	docid, ofioid, odocid, okmsid, oenpid, permid, enp2id, auxid) VALUES 
	(@persid, @status, @scn, COALESCE(@dp, CAST(GETDATE() as date)), @d_gzk, @form, @spos, @predst, @predstid, @vsid, @kmsid, @enpid, @fioid, @adr_id, 
	 @adr50_id, @docid, @ofioid, @odocid, @okmsid, @oenpid, @permid, @enp2id, @auxid)
		
--	SET @out_id = SCOPE_IDENTITY()
	SET @out_id = @persid

	COMMIT TRANSACTION
--	RETURN @out_id
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.AddPerson

-- Proc dbo.UpdatePerson
IF OBJECT_ID('dbo.UpdatePerson','P') IS NOT NULL DROP PROCEDURE dbo.UpdatePerson
GO
CREATE PROCEDURE dbo.UpdatePerson (@persid int, @status tinyint=null, @scn char(3)=null, @dp date=null, @d_gzk tinyint=null, @form tinyint=null, @spos tinyint=null, @predst tinyint=null,
	@snils varchar(14)=null, @dr date=null, @true_dr tinyint=null, @w tinyint=null,
	@pv char(3)=null, @nz varchar(5)=null, @kl tinyint=null, @cont varchar(40)=null, @gr char(3)=null, @mr varchar(max)=null, @comment varchar(max)=null, @ktg varchar(1)=null, @lpuid dec(4)=null,
	-- Параметры ФИО
	@fam varchar(50)=null, @d_fam char(1)=null, @im varchar(50)=null, @d_im char(1)=null, @ot varchar(50)=null, @d_ot char(1)=null, 
	-- Параметры ФИО
	@ofam varchar(50)=null, @oim varchar(50)=null, @oot varchar(50)=null,
	@photo varbinary(max)=null, @sign varbinary(max)=null, /*@oper tinyint=0, @operpv tinyint=0,*/
	-- Параметры времянки
	@s_vs varchar(12)=null, @n_vs varchar(32)=null, @vs_dp date=null, @vs_dt date=null, 
	-- Параметры времянки
	-- Параметры КМС
	@s_kms varchar(12)=null, @n_kms varchar(32)=null, @kmsogrn varchar(13)=null /*'1025004642519'*/, @kmsokato varchar(5)=null /*'45000'*/, @kms_dp date=null, @kms_dt date=null, @kms_dr date=null,
	-- Параметры КМС
	-- Параметры старого КМС
	@s_okms varchar(12)=null, @n_okms varchar(32)=null, @okmsogrn varchar(13)=null/*'1025004642519'*/, @okmsokato varchar(5)=null/*'45000'*/, @okms_dp date=null, @okms_dt date=null, @okms_dr date=null,
	-- Параметры старого КМС
	-- Параметры ЕНП
	@enp varchar(16)=null, @blanc varchar(11)=null, @enpogrn varchar(13)=null, @enpokato varchar(5)=null, @enp_dp date=null, @enp_dt date=null, @enp_dr date=null,
	-- Параметры ЕНП
	-- Параметры второго ЕНП
	@enp2 varchar(16)=null, @blanc2 varchar(11)=null, @enp2ogrn varchar(13)=null, @enp2okato varchar(5)=null, @enp2_dp date=null, @enp2_dt date=null, @enp2_dr date=null,
	-- Параметры второго ЕНП
	-- Параметры основного документа
	@c_doc tinyint=null, @s_doc varchar(12)=null, @n_doc varchar(16)=null, @d_doc date=null, @e_doc date=null, @u_doc varchar(max)=null, @x_doc tinyint=null,
	-- Параметры основного документа
	-- Параметры разрешения на проживание
	@c_perm tinyint=null, @s_perm varchar(12)=null, @n_perm varchar(16)=null, @d_perm date=null, @e_perm date=null,
	-- Параметры разрешения на проживание
	@oc_doc tinyint=null, @os_doc varchar(12)=null, @on_doc varchar(16)=null, @od_doc date=null, @oe_doc date=null, @ou_doc varchar(max)=null, @ox_doc tinyint=null,
	-- Параметры московского адреса
	@ul int=null, @dom varchar(7)=null, @kor varchar(5)=null, @str varchar(5)=null, @kv varchar(5)=null, @d_reg77 date=null,
	-- Параметры московского адреса
	-- Параметры немосковского адреса
	@c_okato varchar(5)=null, @ra_name varchar(60)=null, @np_c tinyint=null, @np_name varchar(60)=null, @ul_c tinyint=null, @ul_name varchar(60)=null,
	@dom50 varchar(7)=null, @kor50 varchar(5)=null, @str50 varchar(5)=null, @kv50 varchar(5)=null, @d_reg50 date=null,
	-- Параметры немосковского адреса
	-- Параметры представителя
	@pr_fam varchar(50)=null, @pr_im varchar(50)=null, @pr_ot varchar(50)=null, @pr_c_doc tinyint=null, @pr_s_doc varchar(9)=null, @pr_n_doc varchar(8)=null, @pr_d_doc date=null, @pr_u_doc varchar(max)=null,
	@pr_tel1 varchar(10)=null, @pr_tel2 varchar(10)=null, @pr_inf varchar(100)=null, 
	-- Параметры представителя
	@out_id int=null OUTPUT)
AS
BEGIN TRY
	BEGIN TRANSACTION
	print 'dbo.UpdatePerson'

	--IF (@recid IS NULL OR @recid=0) BEGIN RAISERROR(60010, 16, 1) RETURN END /*Пустой recid*/
	--IF (@recid IS NULL OR @recid=0) BEGIN ;THROW 90301, 'Отказ процедуры UpdatePerson: пустой recid!', 1; RETURN END /*Пустой recid*/
	IF (@persid != COALESCE((SELECT recid FROM dbo.person WHERE /*IsTop='true' AND*/ recid=@persid), 0)) BEGIN RAISERROR(60011, 16, 1) RETURN END /*Несуществующий recid*/
	--IF dbo.IsNewPerson(@scn)=1 BEGIN RAISERROR(60012, 16, 1) RETURN END /*Если сценарий подразумевает добавление, а не редактирование*/
    -- Все Id считываем их dbo.moves!
    DECLARE @recid int, @vsid int, @kmsid int, @okmsid int, @enpid int, @oenpid int, @enp2id int, @docid int,
		@odocid int, @permid int, @fioid int, @ofioid int, @adr_id int, @adr50_id int, @auxid int, @predstid int
	SELECT @recid=recid, @vsid=vsid, @kmsid=kmsid, @okmsid=okmsid, @enpid=enpid, @oenpid=oenpid, @enp2id=enp2id,
		@docid=docid, @odocid=odocid, @permid=permid, @fioid=fioid, @ofioid=ofioid, @adr_id=adr_id, @adr50_id=adr50_id,
		@auxid=auxid, @predstid=predstid FROM dbo.moves WHERE persid=@persid AND IsTop=1
	
	DECLARE @ostatus tinyint, @odp date, @od_gzk tinyint, @oscn char(3), @oform tinyint, @ospos tinyint, @opredst tinyint
	SELECT @ostatus=status, @odp=dp, @od_gzk=d_gzk ,@oscn=scn, @ospos=spos, @opredst=predst 
		FROM dbo.moves WHERE persid=@persid AND IsTop=1

	--Московский адрес, возмжно одно значение у нескольких застрахованных.
	-- Проверяем, передан ли (IS NOT NULL) хотя бы один параметр из адресного перечня в процедуру
	-- и, если нет, в блок обновления московского адреса не входим
	IF @ul IS NOT NULL OR @dom IS NOT NULL OR @kor IS NOT NULL OR @str IS NOT NULL OR @kv IS NOT NULL
	BEGIN
	 -- Проверяем, был ли московский адрес раньше, если не был (@adr_id IS NULL), то пробуем добавить
	 IF @adr_id IS NULL
	  BEGIN
	   -- Проверяем, не добавлялся ли такой адрес в dbo.adr77 ранее?
	   -- Если добавлялся, то получаем его recid
	   SET @adr_id = dbo.seekadr77 (@ul, @dom, @kor, @str, @kv)
	   IF @adr_id = 0
	   -- Если не добавлялся ранее, то добавляем сейчас
	   BEGIN
        INSERT INTO dbo.adr77 (ul, dom, kor, [str], kv, d_reg) VALUES (@ul, @dom, @kor, @str, @kv, @d_reg77)
        SET @adr_id = SCOPE_IDENTITY()
	   END 
	  END 

	 -- Для удаления московского адреса, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	 -- В случае адреса, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	 -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	 ELSE IF (@adr_id>0) AND (@ul=0 AND @dom='' AND @kor='' AND @str='' AND @kv='' AND @d_reg77='')
      BEGIN
	   DELETE FROM dbo.adr77 WHERE recid=@adr_id
       SET @adr_id = 0
	  END 

	 -- Если два верхних условия не выполнены, то предполагаем редактирование
	 ELSE 
	  BEGIN
	   -- В процедуру может быть передан один и более параметр адресного перечня, которые необходимо обновить. 
	   -- Если переданы не все параметры, то остальные останутся равными NULL и их надо
	   -- заполнить существующими значениями, что и выполняется следующим селектом:
	   SELECT @ul = COALESCE(@ul, ul), @dom = COALESCE(@dom, dom), @kor = COALESCE(@kor, kor),
		@str = COALESCE(@str, str), @kv = COALESCE(@kv, kv), @d_reg77 = COALESCE(@d_reg77, d_reg)
		FROM dbo.adr77 WHERE recid=@adr_id

	   -- Проверяем, привели ли изменения к изменению индексного ключа: ul,dom,kor,str,kv
	   IF @adr_id = dbo.seekadr77 (@ul, @dom, @kor, @str, @kv)
	    -- Если поменялось что-то не из индексных параметров, то есть d_reg
	    UPDATE dbo.adr77 SET d_reg=COALESCE(@d_reg77, d_reg) WHERE recid=@adr_id

	    ELSE
		 -- Если же поменялся один или более индексных параметров: ul,dom,kor,str,kv
	     BEGIN
		  -- Проверяем, не добавлен ли такой адрес в справочник адресов (dbo.adr77) и, если добавлен, то получаем его id (@adr_id)
	      DECLARE @oadr_id int = @adr_id
          SET @adr_id = dbo.seekadr77 (@ul, @dom, @kor, @str, @kv)
          
		  IF @adr_id = 0 
	       BEGIN
		    -- если нет, то проверяем, только ли редактируемый застрахованный именует исходный (до редактирования) адрес
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr_id=@oadr_id) = 1
			-- и, если у одного, то меняем его
		     BEGIN
	          UPDATE dbo.adr77 SET ul = COALESCE(@ul, ul), dom = COALESCE(@dom, dom), kor = COALESCE(@kor, kor), 
				str = COALESCE(@str, str), kv = COALESCE(@kv, kv), d_reg = COALESCE(@d_reg77, d_reg)
				WHERE recid=@oadr_id
		      SET @adr_id=@oadr_id
		     END
	        ELSE
		     -- если нет, то добавляем. в противном случае адрес поменяется и других застрахованных, имеющих тот же адрес
	   	     BEGIN
              INSERT INTO dbo.adr77 (ul, dom, kor, [str], kv, d_reg) VALUES (@ul, @dom, @kor, @str, @kv, @d_reg77)
              SET @adr_id = SCOPE_IDENTITY()
	          IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr_id=@oadr_id)=1 
		       DELETE FROM dbo.adr77 WHERE recid=@oadr_id
		     END 
	       END
	      ELSE
		   -- IF @adr_id > 0
	       BEGIN
		    -- Новый адрес обнаружен в справочнике сущностей и его id присвоен переменной @adr_id
			-- Проверяем, прописан ли кто-то еще по старому адресу и, если нет, то удаляем его из справочника dbo.adr77
			-- (при удалении срабатывае триггер uDelAdr7!)
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr_id=@oadr_id)=1 
		 	 DELETE FROM dbo.adr77 WHERE recid=@oadr_id
	       END 
	    END 
	  END
	 END
	--Московский адрес
	
	--Иногородний адрес
	-- Проверяем, передан ли (IS NOT NULL) хотя бы один параметр из адресного (немосковского ) перечня
	--  в процедуру и, если нет, в блок обновления немосковского адреса не входим
	IF @c_okato IS NOT NULL OR @ra_name IS NOT NULL OR @np_c IS NOT NULL OR @np_name IS NOT NULL OR @ul_c IS NOT NULL OR 
	   @ul_name IS NOT NULL OR @dom50 IS NOT NULL OR @kor50 IS NOT NULL OR @str50 IS NOT NULL OR @kv50 IS NOT NULL OR
	   @d_reg50 IS NOT NULL
     BEGIN
	  -- Проверяем, имел ли застрахованный немосковский адрес раньше, если не имел ( @adr50_id IS NULL),
	  --  то добавляем
	  IF @adr50_id IS NULL
	   BEGIN
		-- Проверяем, не добавлен ли такой адрес в справочник адресов (dbo.adr50) и, если добавлен, то получаем его id (@adr50_id)
		-- есл нет, то добавляем
	    SET @adr50_id = dbo.seekadr50(@c_okato, @ra_name, @np_name, @ul_name, @dom, @kor, @str, @kv)
	    IF @adr50_id = 0
	    BEGIN
         INSERT INTO dbo.adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES 
		  (@c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50)
         SET @adr50_id = SCOPE_IDENTITY()
	    END
	   END 
	  
	  -- Для удаления немосковского адреса, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае адреса, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @adr50_id>0 AND (@c_okato='' AND @ra_name='' AND  @np_name='' AND @ul_name='' AND @dom50='' AND
		@kor50='' AND @str50='' AND @kv50='')
       BEGIN
	    DELETE FROM dbo.adr50 WHERE recid=@adr50_id
        SET @adr50_id = 0
	   END 
	  
	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответсвующий одной компоненте адресного пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @c_okato = COALESCE(@c_okato, c_okato), @ra_name = COALESCE(@ra_name, ra_name), @np_c = COALESCE(@np_c, np_c),
		 @np_name = COALESCE(@np_name, np_name), @ul_c = COALESCE(@ul_c, ul_c), @ul_name = COALESCE(@ul_name, ul_name),
		 @dom = COALESCE(@dom, dom), @kor = COALESCE(@kor, kor), @str = COALESCE(@str, str), @kv = COALESCE(kv, @kv),
		 @d_reg50 = COALESCE(@d_reg50, d_reg) FROM dbo.adr50 WHERE recid=@adr50_id
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: c_okato, ra_name, np_name, ul_name, dom, kor, str, kv
		IF @adr50_id=dbo.seekadr50(@c_okato, @ra_name, @np_name, @ul_name, @dom50, @kor50, @str50, @kv50) 
		 -- Поменялось что-то не из индексных параметров: np_c, ul_c или d_reg50 => update!
	     UPDATE dbo.adr50 SET np_c=COALESCE(@np_c,np_c), ul_c=COALESCE(@ul_c,ul_c), d_reg=COALESCE(@d_reg50,d_reg) WHERE recid=@adr50_id

	    ELSE
		 -- Поменялось один или более индексных параметров: c_okato, ra_name, np_name, ul_name, dom, kor, str, kv
	     BEGIN
		  -- Проверяем, не добавлен ли такой адрес в справочник адресов (dbo.adr50) и, если добавлен, то получаем его id (@adr50_id)
	      DECLARE @oadr50_id int = @adr50_id
          SET @adr50_id = dbo.seekadr50(@c_okato, @ra_name, @np_name, @ul_name, @dom50, @kor50, @str50, @kv50)

          IF @adr50_id = 0 
	       BEGIN
		    -- если да, то проверяем, у одного ли застрахованного такой адрес
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr50_id=@oadr50_id) = 1
			-- и, если у одного, то меняем его
		     BEGIN
	          UPDATE dbo.adr50 SET c_okato=COALESCE(@c_okato,c_okato), ra_name=COALESCE(@ra_name,ra_name), np_c=COALESCE(@np_c,np_c),
	           np_name=COALESCE(@np_name,np_name), ul_c=COALESCE(@ul_c,ul_c), ul_name=COALESCE(@ul_name,ul_name), dom=COALESCE(@dom50,dom),
	           kor=COALESCE(@kor50,kor), str=COALESCE(@str50,str), kv=COALESCE(@kv50,kv), d_reg=COALESCE(@d_reg50,d_reg)
	           WHERE recid=@oadr50_id
		      SET @adr50_id=@oadr50_id
		     END
	        ELSE
		     -- если нет, то добавляем
	   	     BEGIN
              INSERT INTO dbo.adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES 
		       (@c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50)
              SET @adr50_id = SCOPE_IDENTITY()
	          IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr50_id=@oadr50_id)=1 
		       DELETE FROM dbo.adr50 WHERE recid=@oadr50_id
		     END 
	       END
	      ELSE
		   -- IF @adr50_id > 0
	       BEGIN
		    -- Новый адрес обнаружен в справочнике сущностей и его id присвоен переменной @adr50_id
			-- Проверяем, прописан ли кто-то еще по старому адресу и, если нет, то удаляем его из справочника dbo.adr50
			-- (при удалении срабатывае триггер uDelAdr50!)
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND adr50_id=@oadr50_id)=1 
		 	 DELETE FROM dbo.adr50 WHERE recid=@oadr50_id
	       END 
	    END 
	  END
	 END 
	--Иногородний адрес

	--ФИО
	-- Проверяем, передан ли (IS NOT NULL) хотя бы один параметр из относящихся к ФИО в процедуру
	--  и, если нет, в блок обновления немосковского адреса не входим
	IF @fam IS NOT NULL OR @d_fam IS NOT NULL OR @im IS NOT NULL OR @d_im IS NOT NULL OR 
	   @ot IS NOT NULL OR @d_ot IS NOT NULL

     BEGIN
	  -- Проверяем, было ли ФИО раньше, если не было (@fioid IS NULL), то добавляем
	  IF @fioid IS NULL
	   BEGIN
		-- Проверяем, не добавлено ли такое ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
		-- есл нет, то добавляем
	    SET @fioid = dbo.seekfio (@fam, @im, @ot)
	    IF @fioid = 0
	     BEGIN
          INSERT INTO dbo.fio (fam,d_fam,im,d_im,ot,d_ot) VALUES (@fam,coalesce(@d_fam,' '),@im,coalesce(@d_im,' '),@ot,coalesce(@d_ot,' '))
          SET @fioid = SCOPE_IDENTITY()
	     END
	   END 

	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @fioid>0 AND (@fam='' AND @im='' AND  @ot='')
       BEGIN
	    DELETE FROM dbo.fio WHERE recid=@fioid
        SET @fioid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @fam = COALESCE(@fam, fam), @d_fam = COALESCE(@d_fam, d_fam), @im = COALESCE(@im, im),
		 @d_im = COALESCE(@d_im, d_im), @ot = COALESCE(@ot, ot), @d_ot = COALESCE(@d_ot, d_ot)
		 FROM dbo.fio WHERE recid=@fioid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @fioid = dbo.seekfio (@fam, @im, @ot)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.fio SET d_fam=COALESCE(@d_fam,d_fam), d_im=COALESCE(@d_im,d_im), d_ot=COALESCE(@d_ot,d_ot) WHERE recid=@fioid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      DECLARE @o_fioid int = @fioid
          SET @fioid = dbo.seekfio (@fam, @im, @ot)

          IF @fioid = 0 
	       BEGIN
		    -- если да, то проверяем, у одного ли застрахованного такие ФИО
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND fioid=@o_fioid) = 1
			-- и, если у одного, то меняем его
		     BEGIN
		      SET @fioid=@o_fioid
	          UPDATE dbo.fio SET fam=COALESCE(@fam,fam), d_fam=COALESCE(@d_fam,d_fam), im=COALESCE(@im,im),
	           d_im=COALESCE(@d_im,d_im), ot=COALESCE(@ot,ot), d_ot=COALESCE(@d_ot,d_ot)
	           WHERE recid=@fioid
		     END
	        ELSE
		     -- если нет, то добавляем
	   	     BEGIN
			  INSERT INTO dbo.fio (fam, d_fam, im, d_im, ot, d_ot) VALUES 
				(@fam, coalesce(@d_fam,' '), @im, coalesce(@d_im,' '), @ot, coalesce(@d_ot,' '))
              SET @fioid = SCOPE_IDENTITY()
	          IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND fioid=@o_fioid)=1 
		       DELETE FROM dbo.fio WHERE recid=@o_fioid
		     END 
	       END
	      ELSE
		   -- IF @fioid > 0
	       BEGIN
		    -- Новый ФИО обнаружен в справочнике сущностей и его id присвоен переменной @fioid
			-- Проверяем, имеет ли кто-то еще такие ФИО и, если нет, то удаляем его из справочника dbo.fio
			-- (при удалении срабатывае триггер uDelFio50!)
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND fioid=@o_fioid)=1 
		 	 DELETE FROM dbo.fio WHERE recid=@o_fioid
	       END 
	    END 
	  END
	 END
	--ФИО

	--Старые ФИО
	-- Проверяем, передан ли (IS NOT NULL) хотя бы один параметр из пула ФИО в процедуру и, если нет,
	-- в блок обновления немосковского адреса не входим
	IF @ofam IS NOT NULL OR @oim IS NOT NULL OR @oot IS NOT NULL

     BEGIN
	  -- Проверяем, было ли ФИО раньше, если не было (@ofioid IS NULL), то добавляем
	  IF @ofioid IS NULL
	   BEGIN
		-- Проверяем, не добавлено ли такое ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
		-- есл нет, то добавляем
	    SET @ofioid = dbo.seekofio (@ofam, @oim, @oot)
	    IF @ofioid = 0
	     BEGIN
          INSERT INTO dbo.ofio (fam, im, ot) VALUES (@ofam, @oim, @oot)
          SET @ofioid = SCOPE_IDENTITY()
	     END
	   END 

	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @ofioid>0 AND (@ofam='' AND @oim='' AND  @oot='')
       BEGIN
	    DELETE FROM dbo.ofio WHERE recid=@ofioid
        SET @ofioid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @ofam = COALESCE(@ofam, fam), @oim = COALESCE(@oim, im), @oot = COALESCE(@oot, ot)
		 FROM dbo.ofio WHERE recid=@ofioid
		
	    -- Поменялось один или более индексных параметров: fio, im, ot
		-- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	    DECLARE @o_ofioid int = @ofioid
        SET @ofioid = dbo.seekofio (@ofam, @oim, @oot)

        IF @ofioid = 0 
	     BEGIN
		  -- если да, то проверяем, у одного ли застрахованного такие ФИО
	      IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND fioid=@o_ofioid) = 1
		   -- и, если у одного, то меняем его
		   BEGIN
		    SET @ofioid=@o_ofioid
	        UPDATE dbo.ofio SET fam=COALESCE(@ofam,fam), im=COALESCE(@oim,im), ot=COALESCE(@oot,ot)
	         WHERE recid=@ofioid
		   END
	      ELSE
		   -- если нет, то добавляем
	   	   BEGIN
			INSERT INTO dbo.ofio (fam, im, ot) VALUES 
			 (@ofam, @oim, @oot)
            SET @ofioid = SCOPE_IDENTITY()
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND ofioid=@o_ofioid)=1 
		     DELETE FROM dbo.ofio WHERE recid=@o_ofioid
		   END 
	      END
	     ELSE
		  -- IF @fioid > 0
	      BEGIN
		   -- Новый ФИО обнаружен в справочнике сущностей и его id присвоен переменной @fioid
		   -- Проверяем, имеет ли кто-то еще такие ФИО и, если нет, то удаляем его из справочника dbo.fio
		   -- (при удалении срабатывае триггер uDelFio50!)
	       IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND ofioid=@o_ofioid)=1 
		    DELETE FROM dbo.ofio WHERE recid=@o_ofioid
	      END 
	  END
	 END
	--Старые ФИО

	--Основной документ
	IF @c_doc IS NOT NULL OR @s_doc IS NOT NULL OR @n_doc IS NOT NULL OR @d_doc IS NOT NULL OR @e_doc IS NOT NULL
		OR @u_doc IS NOT NULL OR @x_doc IS NOT NULL
	 BEGIN 

	  -- Проверяем, был ли документ раньше, если не было (@docid IS NULL), то добавляем
	  IF @docid IS NULL
	   BEGIN
		-- Проверяем, не принадлежит ли вводимый документ другому застрахованному.
		-- Если не принадлежит, то добавляем
	    SET @docid = dbo.seekdocs(@s_doc, @n_doc)
	    IF @docid = 0
	     BEGIN
          INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		   (1, @c_doc, @s_doc, @n_doc, @d_doc, @e_doc, @u_doc, COALESCE(@x_doc,0))
          SET @docid = SCOPE_IDENTITY()
	     END
		ELSE
		 BEGIN
		  RAISERROR(60020, 16, 1) -- повтор основного документа!
		  RETURN
		 END 
	   END 

	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @docid>0 AND (@c_doc=0 AND @s_doc='' AND  @n_doc='')
       BEGIN
	    DELETE FROM dbo.docs WHERE recid=@docid
        SET @docid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @c_doc = COALESCE(@c_doc, c_doc), @s_doc = COALESCE(@s_doc, s_doc), @n_doc = COALESCE(@n_doc, n_doc),
		 @d_doc = COALESCE(@d_doc, d_doc), @e_doc = COALESCE(@e_doc, e_doc), @u_doc = COALESCE(@u_doc, u_doc),
		 @x_doc = COALESCE(@x_doc, x_doc) FROM dbo.docs WHERE recid=@docid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @docid = dbo.seekdocs (@s_doc, @n_doc)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.docs SET c_doc=COALESCE(@c_doc,c_doc), d_doc=COALESCE(@d_doc,d_doc), e_doc=COALESCE(@e_doc,e_doc),
			u_doc = COALESCE(@u_doc, u_doc), x_doc = COALESCE(@x_doc, x_doc) WHERE recid=@docid
	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)

          IF dbo.seekdocs(@s_doc, @n_doc) = 0 
	       BEGIN
	        UPDATE dbo.docs SET c_doc=COALESCE(@c_doc, c_doc),s_doc=COALESCE(@s_doc, s_doc), n_doc=COALESCE(@n_doc, n_doc), d_doc=COALESCE(@d_doc, d_doc),
	 	     e_doc=COALESCE(@e_doc, e_doc), u_doc=COALESCE(@u_doc, u_doc), x_doc=COALESCE(@x_doc, x_doc) 
			 WHERE recid=@docid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60020, 16, 1) -- повтор основного документа!
		    RETURN
		   END 
	    END 
	  END
	 END
	--Основной документ
	
	--Старый документ
	IF @oc_doc IS NOT NULL OR @os_doc IS NOT NULL OR @on_doc IS NOT NULL OR @od_doc IS NOT NULL OR @oe_doc IS NOT NULL
		OR @ou_doc IS NOT NULL OR @ox_doc IS NOT NULL
	 BEGIN 

	  -- Проверяем, был ли документ раньше, если не было (@odocid IS NULL), то добавляем
	  IF @odocid IS NULL
	   BEGIN
		-- Проверяем, не добавлено ли такое ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
		-- есл нет, то добавляем
	    SET @odocid = dbo.seekdocs(@os_doc, @on_doc)
	    IF @odocid = 0
	     BEGIN
          INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		   (3, @oc_doc, @os_doc, @on_doc, @od_doc, @oe_doc, @ou_doc, @ox_doc)
          SET @odocid = SCOPE_IDENTITY()
	     END
		ELSE
		 BEGIN
		  RAISERROR(60021, 16, 1) -- повтор старого документа!
		  RETURN
		 END 
	   END 

	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @odocid>0 AND (@oc_doc=0 AND @os_doc='' AND  @on_doc='')
       BEGIN
	    DELETE FROM dbo.docs WHERE recid=@odocid
        SET @odocid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @oc_doc = COALESCE(@oc_doc, c_doc), @os_doc = COALESCE(@os_doc, s_doc), @on_doc = COALESCE(@on_doc, n_doc),
		 @od_doc = COALESCE(@od_doc, d_doc), @oe_doc = COALESCE(@oe_doc, e_doc), @ou_doc = COALESCE(@ou_doc, u_doc),
		 @ox_doc = COALESCE(@ox_doc, x_doc) FROM dbo.docs WHERE recid=@odocid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @odocid = dbo.seekdocs (@os_doc, @on_doc)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.docs SET c_doc=COALESCE(@oc_doc,c_doc), d_doc=COALESCE(@od_doc,d_doc), e_doc=COALESCE(@oe_doc,e_doc),
			u_doc = COALESCE(@ou_doc, u_doc), x_doc = COALESCE(@ox_doc, x_doc) WHERE recid=@odocid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      --DECLARE @o_fioid int = @fioid
          --SET @fioid = dbo.seekfio (@fam, @im, @ot)

          IF dbo.seekdocs(@os_doc, @on_doc) = 0 
	       BEGIN
	        UPDATE dbo.docs SET c_doc=COALESCE(@oc_doc, c_doc),s_doc=COALESCE(@os_doc, s_doc), n_doc=COALESCE(@on_doc, n_doc), d_doc=COALESCE(@d_doc, d_doc),
	 	     e_doc=COALESCE(@oe_doc, e_doc), u_doc=COALESCE(@ou_doc, u_doc), x_doc=COALESCE(@ox_doc, x_doc) 
			 WHERE recid=@odocid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60021, 16, 1) -- повтор основного документа!
		    RETURN
		   END 
	    END 
	  END
	 END
	--Старый документ
	
	--Разрешение на проживание
	IF @c_perm IS NOT NULL OR @s_perm IS NOT NULL OR @n_perm IS NOT NULL OR @d_perm IS NOT NULL OR @e_perm IS NOT NULL
	 BEGIN
	  -- Проверяем, был ли документ раньше, если не было (@odocid IS NULL), то добавляем
	  IF @permid IS NULL
	   BEGIN
		-- Проверяем, не добавлено ли такое ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
		-- есл нет, то добавляем
	    SET @permid = dbo.seekdocs(@s_perm, @n_perm)
	    IF @permid = 0
	     BEGIN
		  INSERT INTO dbo.docs (tip, c_doc, s_doc, n_doc, d_doc, e_doc) VALUES 
		   (2, @c_perm, @s_perm, @n_perm, @d_perm, @e_perm)
          SET @permid = SCOPE_IDENTITY()
	     END
		ELSE
		 BEGIN
		  RAISERROR(60022, 16, 1) -- повтор разрешения на проживание!
		  RETURN
		 END 
	   END 
	  
	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @permid>0 AND (@c_perm=0 AND @s_perm='' AND @n_perm='')
       BEGIN
	    DELETE FROM dbo.docs WHERE recid=@permid
        SET @permid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE
	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @c_perm = COALESCE(@c_perm, c_doc), @s_perm = COALESCE(@s_perm, s_doc), @n_perm = COALESCE(@n_perm, n_doc),
		 @d_perm = COALESCE(@d_perm, d_doc), @e_perm = COALESCE(@e_perm, e_doc) FROM dbo.docs WHERE recid=@permid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @permid = dbo.seekdocs (@s_perm, @n_perm)
		 -- Поменялось что-то не из индексных параметров: c_perm, d_perm => update!
	     UPDATE dbo.docs SET c_doc=COALESCE(@c_perm,c_doc), d_doc=COALESCE(@d_perm,d_doc), e_doc=COALESCE(@e_perm,e_doc)
			WHERE recid=@permid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      --DECLARE @o_fioid int = @fioid
          --SET @fioid = dbo.seekfio (@fam, @im, @ot)

          IF dbo.seekdocs(@s_perm, @n_perm) = 0 
	       BEGIN
	        UPDATE dbo.docs SET c_doc=COALESCE(@c_perm, c_doc),s_doc=COALESCE(@s_perm, s_doc), n_doc=COALESCE(@n_perm, n_doc),
			 d_doc=COALESCE(@d_perm, d_doc), e_doc=COALESCE(@e_perm, e_doc) WHERE recid=@permid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60022, 16, 1) -- повтор разрешения на проживание!
		    RETURN
		   END 
	    END 
	   END 
	END
	--Разрешение на проживание

	--ВС
	IF @s_vs IS NOT NULL OR @n_vs IS NOT NULL OR @vs_dp IS NOT NULL OR @vs_dt IS NOT NULL
	BEGIN

	  -- Проверяем, было ли ВС ранее, если не было (@vsid IS NULL), то добавляем
	  IF @vsid IS NULL
	   BEGIN
		-- Проверяем, не существует ли уже такое ВС в справочнике (dbo.kms) 
	    IF dbo.seekkms(@s_vs, @n_vs) = 0
	     BEGIN
          INSERT INTO dbo.kms (tip, s_card, n_card, dp, dt) VALUES (1, @s_vs, @n_vs, @vs_dp, @vs_dt)
          SET @vsid = SCOPE_IDENTITY()
	     END
		ELSE
		-- и, если добавлен, то ошибка!
		 BEGIN
		  RAISERROR(60023, 16, 1) 
		  RETURN 
		 END
	   END 

	  -- Для удаления ВС, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  ELSE IF @vsid>0 AND (@s_vs='' AND  @n_vs='')
       BEGIN
	    DELETE FROM dbo.kms WHERE recid=@vsid
        SET @vsid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @s_vs = COALESCE(@s_vs, s_card), @n_vs = COALESCE(@n_vs, n_card), @vs_dp = COALESCE(@vs_dp, dp),
		 @vs_dt = COALESCE(@vs_dt, dt) FROM dbo.kms WHERE recid=@vsid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @vsid = dbo.seekkms(@s_vs, @n_vs)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.kms SET dp=COALESCE(@vs_dp,dp), dt=COALESCE(@vs_dt,dt) WHERE recid=@vsid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
          IF dbo.seekkms(@s_vs, @n_vs) = 0 
	       BEGIN
	        UPDATE dbo.kms SET s_card=COALESCE(@s_vs, s_card), n_card=COALESCE(@n_vs, n_card), dp=COALESCE(@vs_dp,dp), dt=COALESCE(@vs_dt,dt) 
			 WHERE recid=@vsid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60023, 16, 1) 
		    RETURN 
		   END
	    END 
	  END
	END
	--ВС

	--КМС
	IF @s_kms IS NOT NULL OR @n_kms IS NOT NULL OR @kmsogrn IS NOT NULL OR @kmsokato IS NOT NULL OR @kms_dp IS NOT NULL OR 
	   @kms_dt IS NOT NULL OR @kms_dr IS NOT NULL
	BEGIN

	  -- Проверяем, было ли ВС ранее, если не было (@vsid IS NULL), то добавляем
	  IF @kmsid IS NULL
	   BEGIN
		-- Проверяем, не существует ли уже такое ВС в справочнике (dbo.kms) 
	    IF dbo.seekkms(@s_kms, @n_kms) = 0
	     BEGIN
		  INSERT INTO dbo.kms (tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES (2, @s_kms, @n_kms, COALESCE(@kmsogrn,'1025004642519'), COALESCE(@kmsokato,'45000'), @kms_dp, @kms_dt, @kms_dr)
		  SET @kmsid = SCOPE_IDENTITY()
	     END
		ELSE
		-- и, если добавлен, то ошибка!
		 BEGIN
		  RAISERROR(60024, 16, 1) 
		  RETURN 
		 END
	   END 

	  -- Для удаления ВС, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  ELSE IF @kmsid>0 AND (@s_kms='' AND  @n_kms='' AND @kmsogrn='' AND @kmsokato='' AND @kms_dp='' AND @kms_dt='' AND @kms_dr='')
       BEGIN
	    DELETE FROM dbo.kms WHERE recid=@kmsid
        SET @kmsid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @s_kms = COALESCE(@s_kms, s_card), @n_kms = COALESCE(@n_kms, n_card), @kmsokato = COALESCE(@kmsokato, okato),
		 @kmsogrn = COALESCE(@kmsogrn, ogrn), @kms_dp = COALESCE(@kms_dp, dp), @kms_dt = COALESCE(@kms_dt, dt),
		 @kms_dr = COALESCE(@kms_dr, dr) FROM dbo.kms WHERE recid=@kmsid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @kmsid = dbo.seekkms(@s_kms, @n_kms)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.kms SET okato=COALESCE(@kmsokato, okato), ogrn=COALESCE(@kmsogrn,ogrn), dp=COALESCE(@kms_dp,dp),
			dt=COALESCE(@kms_dt,dt), dr=COALESCE(@kms_dr,dr) WHERE recid=@kmsid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      --DECLARE @o_fioid int = @fioid
          --SET @fioid = dbo.seekfio (@fam, @im, @ot)

          IF dbo.seekkms(@s_kms, @n_kms) = 0 
	       BEGIN
	        UPDATE dbo.kms SET s_card=COALESCE(@s_kms, s_card), n_card=COALESCE(@n_kms, n_card),
				okato=COALESCE(@kmsokato, okato), ogrn=COALESCE(@kmsogrn,ogrn),
				dp=COALESCE(@kms_dp,dp), dt=COALESCE(@kms_dt,dt), dr=COALESCE(@kms_dr,dr) WHERE recid=@kmsid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60024, 16, 1) 
		    RETURN 
		   END
	    END 
	  END
	END
	--КМС

	--Старый КМС
	IF @s_okms IS NOT NULL OR @n_okms IS NOT NULL OR @okmsogrn IS NOT NULL OR @okmsokato IS NOT NULL OR @okms_dp IS NOT NULL OR 
	   @okms_dt IS NOT NULL OR @okms_dr IS NOT NULL
	BEGIN
	  -- Проверяем, имел ли застрахованный старый КМС ранее (@okmsid?=0)
	  IF @okmsid IS NULL
	   BEGIN
	    -- Не имел. 
		-- Тогда проверяем, не имеет ли такой старый КМС другой застрахованный?
	    IF dbo.seekkms(@s_okms, @n_okms) = 0
	     -- Такого КМС (старого или нового!) в справочнике сущностей (dbo.kms) нет => можно смело добавлять!
	     BEGIN
          INSERT INTO dbo.kms (tip, s_card, n_card, dp, dt, dr) VALUES (3, @s_okms, @n_okms, @okms_dp, @okms_dt, @okms_dr)
          SET @okmsid = SCOPE_IDENTITY()
	     END
		ELSE
		-- Такой КМС уже существует и принадлежит другому засрахованному => ошибка (повтор старого КМС)!
		 BEGIN
		  RAISERROR(60025, 16, 1) 
		  RETURN 
		 END
	   END 

	  -- Для удаления старого КМС необходимо обнуление ВСЕХ его компонентов.
	  -- В приложении сделать кнопку, обнуляющую все компоненты выбранной сущности!
	  ELSE IF @okmsid>0 AND (@s_okms='' AND  @n_okms='' AND @okmsogrn='' AND @okmsokato='' AND @okms_dp='' AND @okms_dt='' AND @okms_dr='')
       BEGIN
	    DELETE FROM dbo.kms WHERE recid=@okmsid
        SET @okmsid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан один и более параметров, относящихся к одной сущности,
	    -- Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @s_okms = COALESCE(@s_okms, s_card), @n_okms = COALESCE(@n_okms, n_card), @okmsokato = COALESCE(@okmsokato, okato),
		 @okmsogrn = COALESCE(@okmsogrn, ogrn), @okms_dp = COALESCE(@okms_dp, dp), @okms_dt = COALESCE(@okms_dt, dt),
		 @okms_dr = COALESCE(@okms_dr, dr) FROM dbo.kms WHERE recid=@okmsid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: серия и номер старого КМС?
		IF @okmsid = dbo.seekkms(@s_okms, @n_okms)
		 -- Поменялось что-то не из индексных параметров
	     UPDATE dbo.kms SET okato=COALESCE(@okmsokato, okato), ogrn=COALESCE(@okmsogrn,ogrn), dp=COALESCE(@okms_dp,dp),
			dt=COALESCE(@okms_dt,dt), dr=COALESCE(@okms_dr,dr) WHERE recid=@okmsid

	    ELSE
		 -- Поменялось один или более индексных параметров: серия и номер документа!
	     BEGIN
		  -- Проверим, не имеет ли такой КМС другой застрахованный?
          IF dbo.seekkms(@s_okms, @n_okms) = 0
	       BEGIN
	        UPDATE dbo.kms SET s_card=COALESCE(@s_okms, s_card), n_card=COALESCE(@n_okms, n_card),
				okato=COALESCE(@okmsokato, okato), ogrn=COALESCE(@okmsogrn,ogrn),
				dp=COALESCE(@okms_dp,dp), dt=COALESCE(@okms_dt,dt), dr=COALESCE(@okms_dr,dr) WHERE recid=@okmsid
	       END
	      ELSE
	 	   -- Такой КМС уже существует и принадлежит другому засрахованному => ошибка (повтор старого КМС)!
		   BEGIN
		    RAISERROR(60025, 16, 1) 
		    RETURN 
		   END
	    END 
	  END
	END
	--Старый КМС

	--ЕНП
	IF @enp IS NOT NULL OR @blanc IS NOT NULL OR @enpogrn IS NOT NULL OR @enpokato IS NOT NULL OR
	 @enp_dp IS NOT NULL OR @enp_dt IS NOT NULL OR @enp_dr IS NOT NULL
	BEGIN

	  -- Проверяем, было ли ВС ранее, если не было (@vsid IS NULL), то добавляем
	  IF @enpid IS NULL
	   BEGIN
		-- Проверяем, не существует ли уже такое ВС в справочнике (dbo.kms) 
	    IF dbo.seekenp(@enp) = 0
	     BEGIN
          INSERT INTO dbo.enp (tip, enp, blanc, okato, ogrn, dp, dt, dr) VALUES 
			(1, @enp, @blanc, COALESCE(@enpokato,'45000'), COALESCE(@enpogrn,'1025004642519'), @enp_dp, @enp_dt, @enp_dr)
          SET @enpid = SCOPE_IDENTITY()
	     END
		ELSE
		-- и, если добавлен, то ошибка!
		 BEGIN
		  RAISERROR(60026, 16, 1) 
		  RETURN 
		 END
	   END 

	  -- Для удаления ВС, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  ELSE IF @enpid>0 AND (@enp=''AND @enpogrn='' AND @enpokato='' AND @enp_dp='' AND @enp_dt='' AND @enp_dr='')
       BEGIN
	    DELETE FROM dbo.enp WHERE recid=@enpid
        SET @enpid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @enp = COALESCE(@enp, enp), @enpokato = COALESCE(@enpokato, okato), @enpogrn = COALESCE(@enpogrn, ogrn),
		 @enp_dp = COALESCE(@enp_dp, dp), @enp_dt = COALESCE(@enp_dt, dt), @enp_dr = COALESCE(@enp_dr, dr)
		 FROM dbo.enp WHERE recid=@enpid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @enpid = dbo.seekenp(@enp)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.enp SET okato=COALESCE(@enpokato, okato), ogrn=COALESCE(@enpogrn,ogrn), dp=COALESCE(@enp_dp,dp),
			dt=COALESCE(@enp_dt,dt), dr=COALESCE(@enp_dr,dr) WHERE recid=@enpid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      --DECLARE @o_fioid int = @fioid
          --SET @fioid = dbo.seekfio (@fam, @im, @ot)

          IF dbo.seekenp(@enp) = 0 
	       BEGIN
	        UPDATE dbo.enp SET enp=COALESCE(@enp, enp), 
				okato=COALESCE(@enpokato, okato), ogrn=COALESCE(@enpogrn,ogrn),
				dp=COALESCE(@enp_dp,dp), dt=COALESCE(@enp_dt,dt), dr=COALESCE(@enp_dr,dr) WHERE recid=@enpid
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60026, 16, 1) 
		    RETURN 
		   END
	    END 
	  END
	END
	--ЕНП

	--Второй ЕНП
	IF @enp2 IS NOT NULL OR @blanc2 IS NOT NULL OR @enp2ogrn IS NOT NULL OR @enp2okato IS NOT NULL OR
	   @enp2_dp IS NOT NULL OR @enp2_dt IS NOT NULL OR @enp2_dr IS NOT NULL
	BEGIN

	  -- Проверяем, было ли ВС ранее, если не было (@vsid IS NULL), то добавляем
	  IF @enp2id IS NULL
	   BEGIN
		-- Проверяем, не существует ли уже такое ВС в справочнике (dbo.kms) 
	    IF dbo.seekenp(@enp2) = 0
	     BEGIN
          INSERT INTO dbo.enp (tip, enp, blanc, okato, ogrn, dp, dt, dr) VALUES 
			(2, @enp2, @blanc2, COALESCE(@enp2okato,'45000'), COALESCE(@enp2ogrn,'1025004642519'), @enp2_dp, @enp2_dt, @enp2_dr)
          SET @enp2id = SCOPE_IDENTITY()
	     END
		ELSE
		-- и, если добавлен, то ошибка!
		 BEGIN
		  RAISERROR(60027, 16, 1) 
		  RETURN 
		 END
	   END 

	  -- Для удаления ВС, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  ELSE IF @enp2id>0 AND (@enp2=''AND @enp2ogrn='' AND @enp2okato='' AND @enp2_dp='' AND @enp2_dt='' AND @enp2_dr='')
       BEGIN
	    DELETE FROM dbo.enp WHERE recid=@enp2id
        SET @enp2id = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @enp2 = COALESCE(@enp2, enp), @enp2okato = COALESCE(@enp2okato, okato), @enp2ogrn = COALESCE(@enp2ogrn, ogrn),
		 @enp2_dp = COALESCE(@enp2_dp, dp), @enp2_dt = COALESCE(@enp2_dt, dt), @enp2_dr = COALESCE(@enp2_dr, dr)
		 FROM dbo.enp WHERE recid=@enp2id
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @enp2id = dbo.seekenp(@enp2)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.enp SET okato=COALESCE(@enp2okato, okato), ogrn=COALESCE(@enp2ogrn,ogrn), dp=COALESCE(@enp2_dp,dp),
			dt=COALESCE(@enp2_dt,dt), dr=COALESCE(@enp2_dr,dr) WHERE recid=@enp2id

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
          IF dbo.seekenp(@enp2) = 0 
	       BEGIN
	        UPDATE dbo.enp SET enp=COALESCE(@enp2, enp), 
				okato=COALESCE(@enp2okato, okato), ogrn=COALESCE(@enp2ogrn,ogrn),
				dp=COALESCE(@enp2_dp,dp), dt=COALESCE(@enp2_dt,dt), dr=COALESCE(@enp2_dr,dr) WHERE recid=@enp2id
	       END
	      ELSE
		   BEGIN
		    RAISERROR(60027, 16, 1) 
		    RETURN 
		   END
	    END 
	  END
	END
	--Второй ЕНП

	-- details
	IF (@auxid IS NULL OR @auxid=0) AND ((@pv!='' and @pv IS NOT NULL) or (@nz!='' and @nz IS NOT NULL) or (@kl IS NOT NULL) or
		(@cont!='' and @cont IS NOT NULL) or (@gr!='' and @gr IS NOT NULL) or (@mr!='' and @mr IS NOT NULL) or 
		(@comment!='' and @comment IS NOT NULL) or (@ktg!='' and @ktg IS NOT NULL) or (@lpuid IS NOT NULL))
	 BEGIN
      INSERT INTO dbo.details(pv, nz, kl, cont, gr, mr, comment, ktg, lpuid) VALUES 
		(@pv, @nz, coalesce(@kl,0), @cont, @gr, @mr, @comment, @ktg, @lpuid)
      SET @auxid = SCOPE_IDENTITY()
	 END 

	ELSE IF (@auxid IS NOT NULL and @auxid>0) AND ((@pv!='' and @pv IS NOT NULL) or (@nz!='' and @nz IS NOT NULL) or (@kl IS NOT NULL) or
		(@cont!='' and @cont IS NOT NULL) or (@gr!='' and @gr IS NOT NULL) or (@mr!='' and @mr IS NOT NULL) or (@comment!='' and @comment IS NOT NULL) or
		(@ktg!='' and @ktg IS NOT NULL) or (@lpuid IS NOT NULL))
     BEGIN
	 UPDATE dbo.details SET pv=COALESCE(@pv,pv), nz=COALESCE(@nz,nz), kl=COALESCE(@kl,kl),
	  cont=COALESCE(@cont,cont), gr=COALESCE(@gr,gr), mr=COALESCE(@mr,mr), comment=COALESCE(@comment,comment),
	  ktg=COALESCE(@ktg,ktg), lpuid=COALESCE(@lpuid,lpuid) WHERE recid=@auxid
      SET @auxid = @@IDENTITY
	 END 
   -- details

	--Представитель
	-- Проверяем, передан ли (IS NOT NULL) хотя бы один параметр из относящихся к ФИО в процедуру
	--  и, если нет, в блок обновления немосковского адреса не входим
	IF @pr_fam IS NOT NULL OR @pr_im IS NOT NULL OR @pr_ot IS NOT NULL OR
	   @pr_c_doc IS NOT NULL OR @pr_s_doc IS NOT NULL OR @pr_n_doc IS NOT NULL OR @pr_d_doc IS NOT NULL OR @pr_u_doc IS NOT NULL OR 
	   @pr_tel1 IS NOT NULL OR @pr_tel2 IS NOT NULL OR @pr_inf IS NOT NULL

     BEGIN
	  -- Проверяем, было ли ФИО раньше, если не было (@fioid IS NULL), то добавляем
	  IF @predstid IS NULL
	   BEGIN
		-- Проверяем, не добавлено ли такое ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
		-- есл нет, то добавляем
	    SET @predstid = dbo.seekprfio (@pr_fam, @pr_im, @pr_ot)
	    IF @predstid = 0
	     BEGIN
          INSERT INTO dbo.predst (fam,im,ot,c_doc,s_doc,n_doc,d_doc,u_doc,tel1,tel2,inf) VALUES 
			(@pr_fam,@pr_im,@pr_ot,@pr_c_doc,@pr_s_doc,@pr_n_doc,@pr_d_doc,@pr_u_doc,@pr_tel1,@pr_tel2,@pr_inf)
          SET @predstid = SCOPE_IDENTITY()
	     END
	   END 

	  -- Для удаления ФИО, как и любой другой сущности необходимо обнуление ВСЕХ её компонентов.
	  -- В случае ФИО, где все значимые (участвующие в формировании уникального индекса) компоненты имеют тип char
	  -- обнуление означает присваивание значения '', что и проверяется в условии ниже
	  ELSE IF @predstid>0 AND (@pr_fam='' AND @pr_im='' AND  @pr_ot='')
       BEGIN
	    DELETE FROM dbo.predst WHERE recid=@predstid
        SET @predstid = 0
	   END 

	  -- Если два верхних условия не выполнены, то предполагаем редактирование
	  ELSE

	   BEGIN
	    -- В процедуру может быть передан только один параметр, соответствующий одной компоненте ФИО пула,
	    -- который необходимо обновить. Посколько остальные параметры при этом останутся равными NULL, их надо
		-- заполнить существующими значениями, что и выполняется следующим селектом:
	    SELECT @pr_fam = COALESCE(@pr_fam, fam), @pr_im = COALESCE(@pr_im, im), @pr_ot = COALESCE(@pr_ot, ot),
		 @pr_c_doc = COALESCE(@pr_c_doc, c_doc), @pr_s_doc = COALESCE(@pr_s_doc, s_doc), @pr_n_doc = COALESCE(@pr_n_doc, n_doc),
		 @pr_d_doc = COALESCE(@pr_d_doc, d_doc), @pr_u_doc = COALESCE(@pr_u_doc, u_doc),
		 @pr_tel1 = COALESCE(@pr_tel1, tel1), @pr_tel2 = COALESCE(@pr_tel2, tel2), @pr_inf = COALESCE(@pr_inf, inf)
		 FROM dbo.predst WHERE recid=@predstid
		
	    -- Проверяем, привели ли изменения к изменению индексного ключа: fam, im, ot
		IF @predstid = dbo.seekprfio (@pr_fam, @pr_im, @pr_ot)
		 -- Поменялось что-то не из индексных параметров: d_fam, d_im, d_ot => update!
	     UPDATE dbo.predst SET c_doc=COALESCE(@pr_c_doc,c_doc), s_doc=COALESCE(@pr_s_doc,s_doc), n_doc=COALESCE(@n_doc,n_doc), 
			d_doc=COALESCE(@d_doc,d_doc), u_doc=COALESCE(@u_doc, u_doc), tel1=COALESCE(@pr_tel1,tel1), tel2=COALESCE(@pr_tel2,tel2),
			inf=COALESCE(@pr_inf,inf) WHERE recid=@predstid

	    ELSE
		 -- Поменялось один или более индексных параметров: fio, im, ot
	     BEGIN
		  -- Проверяем, не добавлен ли такой ФИО в справочник ФИО (dbo.fio) и, если добавлен, то получаем его id (@fioid)
	      DECLARE @o_predstid int = @predstid
          SET @predstid = dbo.seekprfio (@pr_fam, @pr_im, @pr_ot)

          IF @predstid = 0 
	       BEGIN
		    -- если да, то проверяем, у одного ли застрахованного такие ФИО
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND predstid=@o_predstid) = 1
			-- и, если у одного, то меняем его
		     BEGIN
		      SET @predstid=@o_predstid
	          UPDATE dbo.predst SET fam=COALESCE(@pr_fam,fam), im=COALESCE(@pr_im,im), ot=COALESCE(@pr_ot,ot)
				WHERE recid=@predstid
		     END
	        ELSE
		     -- если нет, то добавляем
	   	     BEGIN
			  INSERT INTO dbo.predst (fam,im,ot,c_doc,s_doc,n_doc,d_doc,u_doc,tel1,tel2,inf) VALUES 
			   (@pr_fam,@pr_im,@pr_ot,@pr_c_doc,@pr_s_doc,@pr_n_doc,@pr_d_doc,@pr_u_doc,@pr_tel1,@pr_tel2,@pr_inf)
              SET @predstid = SCOPE_IDENTITY()
	          IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND predstid=@o_predstid)=1 
		       DELETE FROM dbo.predst WHERE recid=@o_predstid
		     END 
	       END
	      ELSE
		   -- IF @fioid > 0
	       BEGIN
		    -- Новый ФИО обнаружен в справочнике сущностей и его id присвоен переменной @fioid
			-- Проверяем, имеет ли кто-то еще такие ФИО и, если нет, то удаляем его из справочника dbo.fio
			-- (при удалении срабатывае триггер uDelFio50!)
	        IF (SELECT COUNT(*) FROM dbo.moves WHERE isdeleted='FALSE' AND predstid=@o_predstid)=1 
		 	 DELETE FROM dbo.predst WHERE recid=@o_predstid
	       END 
	    END 
	  END
	 END
	--Представитель

   UPDATE dbo.person SET snils=COALESCE(@snils,snils), dr=COALESCE(@dr,dr), true_dr=COALESCE(@true_dr, true_dr), 
		w=COALESCE(@w,w) WHERE recid=@persid
   
--   IF @ostatus>1 and @scn != (SELECT scn FROM dbo.moves WHERE recid=@recid AND IsTop=1)
--   BEGIN
--     INSERT INTO dbo.moves (persid, status, scn, dp, d_gzk, form, spos, predst, predstid, vsid, kmsid, enpid, fioid, adr_id, adr50_id,
--	  docid, ofioid, odocid, okmsid, oenpid, permid, enp2id, auxid) VALUES 
--	  (@persid, COALESCE(@status,@ostatus), COALESCE(@scn,@oscn), COALESCE(@dp,@odp), COALESCE(@d_gzk,@od_gzk),
--	   COALESCE(@form,@oform), COALESCE(@spos,@ospos), COALESCE(@predst,@opredst), @predstid, @vsid, @kmsid, @enpid, @fioid, @adr_id, 
--	   @adr50_id, @docid, @ofioid, @odocid, @okmsid, @oenpid, @permid, @enp2id, @auxid)
--	 END
--	ELSE
--	 BEGIN
	  UPDATE dbo.moves SET status=COALESCE(@status, status), dp=COALESCE(@dp,dp), d_gzk=COALESCE(@d_gzk,d_gzk),
	   form=COALESCE(@form,form), spos=COALESCE(@spos,spos), predst=COALESCE(@predst,predst),
	   persid=COALESCE(@persid,persid),fioid=COALESCE(@fioid,fioid),vsid=COALESCE(@vsid,vsid),kmsid=COALESCE(@kmsid,kmsid),
	   enpid=COALESCE(@enpid,enpid),adr_id=COALESCE(@adr_id,adr_id),adr50_id=COALESCE(@adr50_id,adr50_id),
	   docid=COALESCE(@docid,docid),ofioid=COALESCE(@ofioid,ofioid),odocid=COALESCE(@odocid,odocid),
	   okmsid=COALESCE(@okmsid,okmsid),oenpid=COALESCE(@oenpid,oenpid),permid=COALESCE(@permid,permid),
	   enp2id=COALESCE(@enp2id,enp2id),predstid=COALESCE(@predstid,predstid),auxid=COALESCE(@auxid,auxid)
	   WHERE recid=@recid
--	 END 
--	SET @out_id = SCOPE_IDENTITY()
--	SET @out_id = @@IDENTITY
--	SET @out_id = IDENT_CURRENT('dbo.moves')
	SET @out_id = @persid

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.UpdatePerson

-- Proc dbo.AddError
IF OBJECT_ID('dbo.AddError','P') IS NOT NULL DROP PROCEDURE dbo.AddError
GO
CREATE PROCEDURE dbo.AddError
	(@persid int, @et char(1), @c_err varchar(8), @err_text varchar(250)=null, @out_id int=null output)
AS
BEGIN TRY
	BEGIN TRANSACTION
	print 'dbo.AddError'

	DECLARE @recid int = null
    SELECT @recid=recid FROM dbo.kmsview WHERE persid=@persid
	 IF @recid = null BEGIN RAISERROR(60030,16,1) RETURN END

    DECLARE @errid int 
	SELECT @errid=errid FROM dbo.moves WHERE recid=@recid AND IsTop=1
	
	IF @et IS NOT NULL OR @c_err IS NOT NULL OR @err_text IS NOT NULL
	 BEGIN
	  -- Проверяем, была ли ошибка ранее, если не было (@errid IS NULL), то добавляем
	  IF @errid IS NULL
	   BEGIN
		-- Проверяем, не существует ли уже такая ошибка в справочнике (dbo.errors) 
		SET @errid = dbo.seekerror(@et, @c_err)
	    IF  @errid = 0
	     BEGIN
          INSERT INTO dbo.errors (et,code,[name]) VALUES 
			(@et, @c_err, @err_text)
          SET @errid = SCOPE_IDENTITY()
	     END
	   END 
	  ELSE /*IF @errid IS NULL*/
	   BEGIN
	    IF dbo.seekerror(@et, @c_err) = @errid /*повтор! ничего не делаем!*/ RETURN
		ELSE
	     BEGIN
          INSERT INTO dbo.errors (et,code,[name]) VALUES 
			(@et, @c_err, @err_text)
          SET @errid = SCOPE_IDENTITY()
	     END
	   END
	 END

    UPDATE dbo.moves SET errid=COALESCE(@errid, errid), status = 3 WHERE recid=@recid AND IsTop='true'
	
	SET @out_id = SCOPE_IDENTITY()

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.AddError

-- Proc dbo.submit
IF OBJECT_ID('dbo.submit','P') IS NOT NULL DROP PROCEDURE dbo.submit
GO
CREATE PROCEDURE dbo.submit
AS
BEGIN TRY
 BEGIN TRANSACTION
  SET NOCOUNT ON

  DECLARE @min_date date, @max_date date
  SELECT @min_date=CAST(MIN(created) AS date), @max_date=CAST(MAX(created) AS date) FROM dbo.kmsview WHERE status=1

  IF @min_date IS NULL OR @max_date IS NULL BEGIN PRINT 'Ожидающих подачи записей не обнаружено...'; RETURN END 

  DECLARE @file varchar(100) = 'reps.rep_'+REPLACE(CAST(@min_date AS char(10)),'-','')+'_'+REPLACE(CAST(@max_date AS char(10)),'-','')
  DECLARE @def varchar(100) = 'reps.def_'+REPLACE(CAST(@min_date AS char(10)),'-','')+'_'+REPLACE(CAST(@max_date AS char(10)),'-','')

  DECLARE @Sql varchar(250) = 'IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID(' + QUOTENAME(@file,'''') + 
	')) DROP TABLE ' + @file
  EXEC (@Sql)
  SET @Sql = 'IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID(' + QUOTENAME(@def,'''') + 
	')) DROP TABLE ' + @def
  EXEC (@Sql)

  SET @Sql = 'CREATE TABLE '+@file+' (recid int, scn char(3), fam varchar(50), im varchar(50), ot varchar(50))'
  EXEC (@Sql)
  SET @Sql = 'CREATE TABLE '+@def+' (recid int, scn char(3), fam varchar(50), im varchar(50), ot varchar(50))'
  EXEC (@Sql)

  SET @Sql = 'INSERT INTO ' + @file + ' (recid, scn, fam, im, ot) SELECT recid, scn, fam, im, ot FROM dbo.kmsview WHERE status=1 AND dbo.isvalid(recid, scn)=1'
  EXEC (@Sql)

  SET @Sql = 'INSERT INTO ' + @def + ' (recid, scn, fam, im, ot) SELECT recid, scn, fam, im, ot FROM dbo.kmsview WHERE status=1 AND dbo.isvalid(recid, scn)<>1'
  EXEC (@Sql)

  UPDATE dbo.moves SET status = 2 WHERE status=1 AND IsTop='true' AND dbo.isvalid(recid, scn)='true'

 COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.submit

print 'The fifth step of creating kms database has been performed successfully!'
print 'Dont forget to run UnitTests!'