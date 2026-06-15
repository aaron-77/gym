-- =============================================
-- [TABLA]: AspNetRoles
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetRoles (
    Id varchar(450) NOT NULL,
    Name varchar(256) NULL,
    NormalizedName varchar(256) NULL,
    ConcurrencyStamp text NULL,
    CONSTRAINT pk_aspnetroles PRIMARY KEY (Id)
);

CREATE UNIQUE INDEX idx_aspnetroles_normalizedname ON public.AspNetRoles (NormalizedName) WHERE NormalizedName IS NOT NULL;