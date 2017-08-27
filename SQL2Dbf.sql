IF EXISTS(SELECT * FROM sys.servers WHERE name = N'FOX_ODBC')
EXEC master.sys.sp_dropserver 'FOX_ODBC','droplogins'  
GO
EXEC sp_addlinkedserver 
        @server = 'FOX_ODBC', 
        @provider = 'MSDASQL', 
        @srvproduct = '',
        @provstr = 'Driver={Microsoft Visual FoxPro Driver}; 
		UID=;SourceDB=D:\DBFSRV\;SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Russian;Null=No;Deleted=No'

IF EXISTS(SELECT * FROM sys.servers WHERE name = N'FOX_OLEDB')
EXEC master.sys.sp_dropserver 'FOX_OLEDB','droplogins'  
GO
EXEC  sp_addlinkedserver 
        @server = 'DBF', 
        @provider = 'VFPOLEDB',
        @srvproduct = '',
        @datasrc ='d:\dbfsrv\',
        @provstr = 'Collating Sequence=RUSSIAN'

EXEC master.dbo.sp_addlinkedserver 
	@server = N'DBF_TEST', 
	@srvproduct=N'Advantage', 
	@provider=N'Advantage OLE DB Provider', 
	@datasrc=N'c:\ads\dbftest', 
	@provstr=N'servertype=ads_remote_server;tabletype=ads_cdx;'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DBF_TEST',@useself=N'False',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
--- ѕримеры запросов
SELECT * FROM openquery(FOX_, 
    'SELECT * FROM d:\kms\base\user.dbf')

Select * from OPENQUERY('Select * from 'd:\kms\base\user.dbf'') 
/*
select * from FOX_OLEDB...[db\medbf] -- относительно datasrc 
select * from FOX_OLEDB...[\\srv\share\db\medbf]  -- UNC
select * from FOX_OLEDB...[c:\db\medbf]  -- local path
*/


/*
select *
from OPENQUERY(FOXODBC,
'select * from \\srv\buh\existdbf ;create dbf \\srv\buh\newdbf (id c(10),name c(50)) ' 
) a

-- файл \\srv\buh\existdbf - пустышка!!!! но он должен существовать
-- лично € использую специально созданный дл€ этого пустой dbf
-- собственно создание пррисзодит во второй команде
*/

/*Select * from OPENQUERY('Select * from {filename}')*/