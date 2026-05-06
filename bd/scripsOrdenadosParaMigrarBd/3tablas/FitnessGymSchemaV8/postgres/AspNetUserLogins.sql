-- =============================================
-- [TABLA]: AspNetUserLogins
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetUserLogins (
    LoginProvider varchar(450) NOT NULL,
    ProviderKey varchar(450) NOT NULL,
    ProviderDisplayName text NULL,
    UserId varchar(450) NOT NULL,
    CONSTRAINT pk_aspnetuserlogins PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT fk_aspnetuserlogins_aspnetusers_userid FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id) ON DELETE CASCADE
);

CREATE INDEX idx_aspnetuserlogins_userid ON public.AspNetUserLogins (UserId);