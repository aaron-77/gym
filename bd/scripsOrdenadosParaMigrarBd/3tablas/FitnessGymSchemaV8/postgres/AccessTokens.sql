-- =============================================
-- [TABLA]: AccessTokens
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.AccessTokens (
    AccessTokenId uuid DEFAULT gen_random_uuid() NOT NULL,
    UserId varchar(450) NOT NULL,
    ClientId varchar(100) NOT NULL,
    TokenHash varchar(256) NOT NULL,
    IssuedAt timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ExpiresAt timestamp NOT NULL,
    RevokedAt timestamp NULL,
    IpAddress varchar(50) NULL,
    UserAgent varchar(250) NULL,
    CONSTRAINT pk_accesstokens PRIMARY KEY (AccessTokenId),
    CONSTRAINT fk_accesstokens_aspnetusers FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id) ON DELETE CASCADE
);

CREATE INDEX idx_accesstokens_userid ON public.AccessTokens (UserId);