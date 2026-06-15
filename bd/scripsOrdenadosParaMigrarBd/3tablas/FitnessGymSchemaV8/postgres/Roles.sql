-- =============================================
-- [TABLA]: Roles
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.Roles (
    RolID integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    NombreRol varchar(50) NOT NULL,
    CONSTRAINT pk_roles PRIMARY KEY (RolID)
);