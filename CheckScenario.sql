--
-- Набор функций предназначен для проверки полноты и корректности заполнения записи
-- в зависимости от сценария
--
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
