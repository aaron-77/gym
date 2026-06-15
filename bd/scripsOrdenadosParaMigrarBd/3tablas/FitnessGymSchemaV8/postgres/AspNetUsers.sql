-- =============================================
-- [TABLA]: AspNetUsers
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetUsers (
    Id varchar(450) NOT NULL,
    NombreCompleto text NOT NULL,
    UserName varchar(256) NULL,
    NormalizedUserName varchar(256) NULL,
    Email varchar(256) NULL,
    NormalizedEmail varchar(256) NULL,
    EmailConfirmed boolean NOT NULL,
    PasswordHash text NULL,
    SecurityStamp text NULL,
    ConcurrencyStamp text NULL,
    PhoneNumber text NULL,
    PhoneNumberConfirmed boolean NOT NULL,
    TwoFactorEnabled boolean NOT NULL,
    LockoutEnd timestamptz NULL,
    LockoutEnabled boolean NOT NULL,
    AccessFailedCount integer NOT NULL,
    NumeroDeIdentificacion text DEFAULT '' NOT NULL,
    Direccion text DEFAULT '' NOT NULL,
    FechaDeNacimiento timestamp DEFAULT '0001-01-01 00:00:00'::timestamp NOT NULL,
    Apellido varchar(50) DEFAULT '' NOT NULL,
    Estado varchar(50) DEFAULT '' NOT NULL,
    FechaDeRegistro timestamp DEFAULT '0001-01-01 00:00:00'::timestamp NOT NULL,
    IdAntiguo integer NULL,
    IdSecundario integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    CONSTRAINT pk_aspnetusers PRIMARY KEY (Id)
);

CREATE INDEX idx_aspnetusers_normalizedemail ON public.AspNetUsers (NormalizedEmail);
CREATE UNIQUE INDEX idx_aspnetusers_normalizedusername ON public.AspNetUsers (NormalizedUserName) WHERE NormalizedUserName IS NOT NULL;