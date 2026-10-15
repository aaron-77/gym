
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'fitnessCenterDb')
BEGIN
    RESTORE DATABASE [fitnessCenterDb]
    FROM DISK = N'/var/opt/mssql/backups/FitnessGymDB.bak'
    WITH MOVE 'FitnessCenterDB' TO '/var/opt/mssql/data/FitnessCenterDB.mdf',
         MOVE 'FitnessCenterDB_log' TO '/var/opt/mssql/data/FitnessCenterDB_log.ldf',
         NOUNLOAD, REPLACE, STATS = 10;
END