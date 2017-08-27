-- Ver. 02.0. Release Date: 25 June 2017
-- Unit tests for testing kms database, ver.01

-- Turning all the triggers on
USE kms
GO
ENABLE TRIGGER dbo.uModFio ON dbo.fio
GO 
ENABLE TRIGGER dbo.uDelFio ON dbo.fio
GO
ENABLE TRIGGER dbo.uModOFio ON dbo.ofio
GO 
ENABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
ENABLE TRIGGER dbo.uModAux ON dbo.auxinfo
GO
ENABLE TRIGGER dbo.uDelAux ON dbo.auxinfo
GO
ENABLE TRIGGER dbo.uModkms ON dbo.kms
GO
ENABLE TRIGGER dbo.uDelKms ON dbo.kms
GO
ENABLE TRIGGER dbo.uModDocs ON dbo.docs
GO
ENABLE TRIGGER dbo.uDelDocs ON dbo.docs
GO
ENABLE TRIGGER dbo.uModEnp ON dbo.enp
GO
ENABLE TRIGGER dbo.uDelEnp ON dbo.enp
GO
ENABLE TRIGGER dbo.uModAdr77 ON dbo.adr77
GO
ENABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
ENABLE TRIGGER dbo.uModAdr50 ON dbo.adr50
GO
ENABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
-- Turning all the triggers on

print 'All the triggers enabled!'
