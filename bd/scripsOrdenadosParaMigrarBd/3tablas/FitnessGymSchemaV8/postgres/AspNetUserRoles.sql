-- =============================================
-- [TABLA]: AspNetUserRoles
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

-- Drop table

-- DROP TABLE public.AspNetUserRoles;

CREATE TABLE public.AspNetUserRoles (
	UserId varchar(450) NOT NULL,
	RoleId varchar(450) NOT NULL,
	CONSTRAINT PK_AspNetUserRoles PRIMARY KEY (UserId,RoleId),
	CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES public.AspNetRoles(Id) ON DELETE CASCADE,
	CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id) ON DELETE CASCADE
);

CREATE INDEX "IX_AspNetUserRoles_RoleId" ON public.AspNetUserRoles (RoleId ASC);