-- =============================================
-- [TABLA]: AspNetRoleClaims
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetRoleClaims (
    Id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    RoleId varchar(450) NOT NULL,
    ClaimType text NULL,
    ClaimValue text NULL,
    CONSTRAINT pk_aspnetroleclaims PRIMARY KEY (Id),
    CONSTRAINT fk_aspnetroleclaims_aspnetroles_roleid FOREIGN KEY (RoleId) REFERENCES public.AspNetRoles(Id) ON DELETE CASCADE
);

CREATE INDEX idx_aspnetroleclaims_roleid ON public.AspNetRoleClaims (RoleId);