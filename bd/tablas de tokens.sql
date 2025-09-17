-- ============================================
-- Tabla de Refresh Tokens
-- ============================================
CREATE TABLE [dbo].[RefreshTokens] (
    RefreshTokenId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId NVARCHAR(450) NOT NULL,
    ClientId NVARCHAR(100) NOT NULL,
    TokenHash NVARCHAR(256) NOT NULL, -- SHA256 o equivalente
    IssuedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ExpiresAt DATETIME2 NOT NULL,
    RevokedAt DATETIME2 NULL,
    ReplacedByTokenId UNIQUEIDENTIFIER NULL,
    IpAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(250) NULL,
    CONSTRAINT FK_RefreshTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id)
);

-- Índice para búsqueda rápida de token por hash
CREATE UNIQUE INDEX IX_RefreshTokens_TokenHash ON [dbo].[RefreshTokens](TokenHash);

-- ============================================
-- Tabla opcional de Access Tokens (solo auditoría o revocación)
-- ============================================
CREATE TABLE [dbo].[AccessTokens] (
    AccessTokenId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId NVARCHAR(450) NOT NULL,
    ClientId NVARCHAR(100) NOT NULL,
    TokenHash NVARCHAR(256) NOT NULL, -- hash del JWT si decides almacenar
    IssuedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ExpiresAt DATETIME2 NOT NULL,
    RevokedAt DATETIME2 NULL,
    IpAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(250) NULL,
    CONSTRAINT FK_AccessTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id)
);

-- Índice para búsqueda rápida
CREATE UNIQUE INDEX IX_AccessTokens_TokenHash ON [dbo].[AccessTokens](TokenHash);
