-- =============================================
-- [TABLA]: AspNetUserTokens
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AspNetUserTokens (
    UserId varchar(450) NOT NULL,
    LoginProvider varchar(450) NOT NULL,
    Name varchar(450) NOT NULL,
    Value text NULL,
    CONSTRAINT pk_aspnetusertokens PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT fk_aspnetusertokens_aspnetusers_userid FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id) ON DELETE CASCADE
);