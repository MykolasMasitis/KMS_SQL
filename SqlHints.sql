-- Показать план исполнения

-- Очистка кеша
DBCC DROPCLEANBUFFERS 

--- Посмотреть настройка set
DBCC USEROPTIONS

-- Посмотреть, какие блокировки наложены
sp_Lock 65,66 (номер подключений - пример!)

SET DEADLOCK PRIORITY!!!

SELECT * FROM Sys.SQL_Modules

SELECT * FROM Sys.Views

execute sp_HelpText 'nameofsomething'

