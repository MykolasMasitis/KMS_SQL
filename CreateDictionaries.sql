-- Ver. 02.0. Release Date: 25 June 2017
-- Ver. 02.0. Release Date: 25 June 2017
-- The second step of creating Database KMS
-- The next (the 3rd) step is perfoming out of VFP module and populate the created here tables

SET NOCOUNT ON
GO
USE [kms]
GO

DECLARE @table sysname;
SET @table = 'nsi.status';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.status
CREATE TABLE nsi.status(code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25), used bit) ON AuxuiliariesFG
INSERT INTO nsi.status VALUES /*(0,'Не определен',0), */(1,'Ожидание подачи',0),(2,'Ожидание ответа',1),
	(3,'Обработана (ошибка)',1),(4,'Полис на изготовлении',1),(5,'Полис получен',1),(6,'Полис выдан',1)
GO

DECLARE @table sysname;
SET @table = 'nsi.codfio';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.codfio
CREATE TABLE nsi.codfio(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name char(45)) ON AuxuiliariesFG
INSERT INTO nsi.codfio VALUES (SPACE(1), 'Стандартная запись'),('0', 'Нет отчества/имени'),('1', 'Одна буква в фамилии/имени/отчестве'),
	('2', 'Пробел в фамилии/имени/отчестве'),('3', 'Одна буква+пробел в фамилии/имени/отчестве'),
	('9', 'Повтор реквизитов у разных физических лиц*')
GO

DECLARE @table sysname;
SET @table = 'nsi.predst';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.predst
CREATE TABLE nsi.predst(code tinyint PRIMARY KEY CLUSTERED, name char(30)) ON AuxuiliariesFG
INSERT INTO nsi.predst (code,name) VALUES (0, 'Лично'), (1, 'Мать ребёнка'), (2, 'Отец ребёнка'),
	(3,'Иное доверенное лицо'), (4,'Ходатайствующая организация')
GO

DECLARE @table sysname;
SET @table = 'nsi.spos';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.spos
CREATE TABLE nsi.spos (code tinyint PRIMARY KEY CLUSTERED, name char(30)) ON AuxuiliariesFG
INSERT INTO nsi.spos (code,name) VALUES (1, 'Лично'), (2, 'Через представителя'), (3, 'Через сайт МГФОМС'),
	(4,'Через Единый портал госуслуг')
GO

DECLARE @table sysname;
SET @table = 'nsi.form';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.form
CREATE TABLE nsi.form (code tinyint PRIMARY KEY CLUSTERED, name char(40)) ON AuxuiliariesFG
INSERT INTO nsi.form (code,name) VALUES (1, 'бумажный носитель'), (2, 'электронный полис'), (3, 'УЭК (универсальная электронная карта)')
GO

DECLARE @table sysname;
SET @table = 'nsi.scenario';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.scenario
CREATE TABLE nsi.scenario (code char(3) PRIMARY KEY CLUSTERED, name char(150),
	ismsk bit NULL, isown bit NULL, isenp bit NULL, izgt bit NULL) ON AuxuiliariesFG
INSERT INTO nsi.scenario VALUES 
('NB','Постановка на учет','true','true',null,'true'),
('CI','Перерегистрация нового московского полиса без изменения персональных данных','true','false','true',null),
('RI','Перерегистрация нового московского полиса с изменениями персональных данных','true','false','true','true'),
('PI','Перерегистрация старого московского полиса без изменения персональных данных','true','false','false','true'),
('PRI','Перерегистрация старого московского полиса с изменениями персональных данных','true','false','false','true'),
('CT','Перерегистрация нового территориального полиса без изменения персональных данных','false','false','true',null),
('RT','Перерегистрация нового территориального полиса с изменением персональных данных','false','false','true','true'),
('PT','Перерегистрация старого территориального полиса на новый без изменения персональных данных','false','false','false','true'),
('PRT','Перерегистрация старого территориального полиса на новый с изменением персональных данных','false','false','false','true'),
('DP','Изготовление полиса нового образца (по причине порчи/утери или после перерасчета  ЕНП)','true','true','true','true'),
('CR','Замена реквизитов, не влекущих замену ЕНП, в новом полисе застахованного лица','true','true','true','true'),
('CP','Замена своего старого полиса на новый без изменения персональных данных','true','true','false','true'),
('PR','Замена своего старого полиса на новый с изменением персональных данных','true','true','false','true'),
('MP','Разрешение дубликатов (объединение двух страховок)',null,null,null,'false'),
('RD','Разъединение дубликатов застрахованных лиц',null,null,null,'false'),
('CD','Изменение данных без замены полиса (УДЛ - при получении нового взамен старого или добавление СНИЛС)','true','true','true','false'),
('CLR','Снятие с учёта от СМО','true','true',null,'false'),
('POK','Выдача на руки от СМО','true','true','true','false'),
('CPV','Замена половозрастных реквизитов','true',null,null,'false'),
('AD','Актуализация данных о страховке в РС','true','true','true','false'),
('XD','Исправление ошибки, не связанной с изменением состояния на учёте','true','true','true','false')
GO

DECLARE @table sysname;
SET @table = 'nsi.d_gzk';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.d_gzk
CREATE TABLE nsi.d_gzk (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(75)) ON AuxuiliariesFG
INSERT INTO nsi.d_gzk (code,name) VALUES (0, 'в ГОЗНАК на печать не посылать'),
	(1, 'указанный ЕНП должен быть отправлен в ГОЗНАК с признаком печати “впервые”'),
	(2, 'указанный ЕНП должен быть отправлен в ГОЗНАК с признаком печати “повторно”'),
	(3, 'изготовить электронный полис с признаком печати «впервые»'),
	(4, 'изготовить электронный полис с признаком печати «повторно»')
GO

DECLARE @table sysname;
SET @table = 'nsi.true_dr';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.true_dr
CREATE TABLE nsi.true_dr(code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25)) ON AuxuiliariesFG
INSERT INTO nsi.true_dr VALUES (1,'Дата достоверна'),(2,'Достоверны месяц и год'),(3,'Достоверен год')
GO

DECLARE @table sysname;
SET @table = 'nsi.streets';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.streets
CREATE TABLE nsi.streets(code int, name char(60),
CONSTRAINT [PK_streets] PRIMARY KEY CLUSTERED ([code] ASC)) ON AuxuiliariesFG
-- Заполняется в kmssql!
GO

DECLARE @table sysname;
SET @table = 'nsi.countries';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.countries
CREATE TABLE nsi.countries(code char(3), name char(50),
CONSTRAINT [PK_countries] PRIMARY KEY CLUSTERED ([code] ASC)) ON AuxuiliariesFG
-- Заполняется в kmssql!
GO

DECLARE @table sysname;
SET @table = 'nsi.kl';
IF OBJECT_ID(@table, 'U') IS NOT NULL DROP TABLE nsi.kl
CREATE TABLE nsi.kl (code tinyint PRIMARY KEY CLUSTERED, name char(40), [tip] tinyint) ON AuxuiliariesFG
INSERT INTO nsi.kl VALUES 
	(0,'Гр. РФ, постоянная регистрация в Москве',1),
	(45,'Иностранцы, имеющие вид на жительстов',1),
	(73,'Беженцы и переселенцы',1),
	(77,'Гр. РФ, зарег. в иных субъектах РФ, БОМЖ',1),
	(99,'Иностранцы, временно проживающие в РФ',1)
GO

DECLARE @table sysname;
SET @table = 'nsi.sex';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [nsi].[sex]
CREATE TABLE [nsi].[sex]([code] tinyint, [name] char(12),
CONSTRAINT [PK_sex] PRIMARY KEY CLUSTERED ([code] ASC)) ON AuxuiliariesFG
/*INSERT INTO [nsi].[sex] (code,name) VALUES (0, 'не определен')*/
INSERT INTO [nsi].[sex] (code,name) VALUES (1, 'мужской')
INSERT INTO [nsi].[sex] (code,name) VALUES (2, 'женский')
GO

DECLARE @table sysname;
SET @table = 'nsi.viddocs';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.viddocs
CREATE TABLE nsi.viddocs (code tinyint PRIMARY KEY CLUSTERED, name char(50)) ON AuxuiliariesFG
INSERT INTO nsi.viddocs (code,name) VALUES (0,  'Не определен')
GO

DECLARE @table sysname;
SET @table = 'nsi.pvp2';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.pvp2
CREATE TABLE nsi.pvp2 (code char(3) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON AuxuiliariesFG
INSERT INTO nsi.pvp2 (code,name) VALUES ('000', 'Unknown punkt')
GO

DECLARE @table sysname;
SET @table = 'nsi.nompmmyy';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.nompmmyy;
CREATE TABLE nsi.nompmmyy (s_card char(6), n_card numeric(10), q char(2), enp char(16), vsn char(9), 
	lpu_id numeric(6), date_in date, spos numeric(1)) ON AuxuiliariesFG
GO

DECLARE @table sysname;
SET @table = 'nsi.sprlpu';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.sprlpu;
CREATE TABLE nsi.sprlpu (fil_id dec(4) NOT NULL PRIMARY KEY CLUSTERED,
	lpu_id dec(4), mcod char(7), name char(40), fullname char(120)) ON AuxuiliariesFG
GO

DECLARE @table sysname;
SET @table = 'nsi.p_doc';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.p_doc;
CREATE TABLE nsi.p_doc (code tinyint NOT NULL PRIMARY KEY CLUSTERED,
	name varchar(10), vid_docu char(1)) ON AuxuiliariesFG
GO
INSERT INTO nsi.p_doc VALUES (1,'КМС','С'),(2,'ВС','В'),(3,'ЕНП','П'),(4,'УЭК','К'),(5,'ЭлПолис','Э')
GO

DECLARE @table sysname;
SET @table = 'nsi.okato'
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.okato
CREATE TABLE nsi.okato (c_t tinyint NOT NULL PRIMARY KEY CLUSTERED, okato char(5) NOT NULL, name varchar(40)) ON AuxuiliariesFG
GO

DECLARE @table sysname;
SET @table = 'nsi.tersmo'
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.tersmo
CREATE TABLE nsi.tersmo (okato char(5) NOT NULL, ogrn char(15) NOT NULL, c_t tinyint NOT NULL, t_name varchar(40), 
	q_name varchar(150)) ON AuxuiliariesFG
GO
ALTER TABLE nsi.tersmo ADD CONSTRAINT PK_tersmo PRIMARY KEY CLUSTERED (okato,ogrn)
GO

--Заполняется модулем импорта kmssql --
DECLARE @table sysname;
SET @table = 'nsi.np_c';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.np_c
CREATE TABLE nsi.np_c (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(6), fname varchar(45)) ON AuxuiliariesFG
GO

--Заполняется модулем импорта kmssql --
DECLARE @table sysname;
SET @table = 'nsi.ul_c';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.ul_c
CREATE TABLE nsi.ul_c (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(6), fname varchar(45)) ON AuxuiliariesFG
GO

print 'The second step of creating kms database has been performed successfully!'
print 'You may fill the dictionaries now using VFP app ksql.exe or run CreateEntities.sql!'
