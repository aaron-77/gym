-- =============================================
-- Tabla: __EFMigrationsHistory
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

-- Drop table if exists
DROP TABLE IF EXISTS public.__EFMigrationsHistory;

CREATE TABLE public.__EFMigrationsHistory (
    MigrationId varchar(150) NOT NULL,
    ProductVersion varchar(32) NOT NULL,
    CONSTRAINT PK___EFMigrationsHistory PRIMARY KEY (MigrationId)
);