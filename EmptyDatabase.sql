USE kms
GO
DISABLE TRIGGER dbo.uModMoves ON dbo.moves
GO 
DISABLE TRIGGER dbo.uDelMoves ON dbo.moves
GO 

DELETE FROM dbo.moves
DELETE FROM dbo.pers
DELETE FROM dbo.adr50
DELETE FROM dbo.adr77
DELETE FROM dbo.auxinfo
DELETE FROM dbo.docs
DELETE FROM dbo.enp
DELETE FROM dbo.fio
DELETE FROM dbo.kms
DELETE FROM dbo.ofio
DELETE FROM dbo.predst
DELETE FROM dbo.wrkpl

print 'Database kms is empty now!'
