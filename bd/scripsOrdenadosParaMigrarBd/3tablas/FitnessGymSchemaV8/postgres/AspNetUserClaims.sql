-- =============================================
-- [TABLA]: AspNetUserClaims
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetUserClaims (
    Id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    UserId varchar(450) NOT NULL,
    ClaimType text NULL,
    ClaimValue text NULL,
    CONSTRAINT pk_aspnetuserclaims PRIMARY KEY (Id),
    CONSTRAINT fk_aspnetuserclaims_aspnetusers_userid FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id) ON DELETE CASCADE
);

CREATE INDEX idx_aspnetuserclaims_userid ON public.AspNetUserClaims (UserId);