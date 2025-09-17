-- DROP SCHEMA dbo;

CREATE SCHEMA dbo;
-- FitnessCenterDB.dbo.AspNetRoles definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetRoles;

CREATE TABLE FitnessCenterDB.dbo.AspNetRoles (
	Id nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Name nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	ConcurrencyStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetRoles PRIMARY KEY (Id)
);
 CREATE UNIQUE NONCLUSTERED INDEX RoleNameIndex ON FitnessCenterDB.dbo.AspNetRoles (  NormalizedName ASC  )  
	 WHERE  ([NormalizedName] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetUsers definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetUsers;

CREATE TABLE FitnessCenterDB.dbo.AspNetUsers (
	Id nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	NombreCompleto nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	UserName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedUserName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	Email nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedEmail nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	EmailConfirmed bit NOT NULL,
	PasswordHash nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	SecurityStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	ConcurrencyStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	PhoneNumber nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	PhoneNumberConfirmed bit NOT NULL,
	TwoFactorEnabled bit NOT NULL,
	LockoutEnd datetimeoffset NULL,
	LockoutEnabled bit NOT NULL,
	AccessFailedCount int NOT NULL,
	NumeroDeIdentificacion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	Direccion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	FechaDeNacimiento datetime2 DEFAULT '0001-01-01T00:00:00.0000000' NOT NULL,
	Apellido nvarchar(50) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	FechaDeRegistro datetime2 DEFAULT '0001-01-01T00:00:00.0000000' NOT NULL,
	IdAntiguo int NULL,
	CONSTRAINT PK_AspNetUsers PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX EmailIndex ON FitnessCenterDB.dbo.AspNetUsers (  NormalizedEmail ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE UNIQUE NONCLUSTERED INDEX UserNameIndex ON FitnessCenterDB.dbo.AspNetUsers (  NormalizedUserName ASC  )  
	 WHERE  ([NormalizedUserName] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.Descuentos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Descuentos;

CREATE TABLE FitnessCenterDB.dbo.Descuentos (
	DescuentoID int IDENTITY(1,1) NOT NULL,
	Porcentaje decimal(5,2) NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	FechaInicio datetime NOT NULL,
	FechaFin datetime NOT NULL,
	CONSTRAINT PK__Descuent__0C2C1138689BA8C4 PRIMARY KEY (DescuentoID)
);


-- FitnessCenterDB.dbo.LogErrores definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.LogErrores;

CREATE TABLE FitnessCenterDB.dbo.LogErrores (
	id int IDENTITY(1,1) NOT NULL,
	procedimiento nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	mensaje nvarchar(4000) COLLATE Modern_Spanish_CI_AS NOT NULL,
	severidad int NOT NULL,
	estado int NOT NULL,
	fecha datetime DEFAULT getdate() NULL,
	usuario nvarchar(100) COLLATE Modern_Spanish_CI_AS DEFAULT suser_name() NULL,
	host nvarchar(100) COLLATE Modern_Spanish_CI_AS DEFAULT host_name() NULL,
	aplicacion nvarchar(200) COLLATE Modern_Spanish_CI_AS DEFAULT app_name() NULL,
	CONSTRAINT PK__LogError__3213E83F2E02FD9A PRIMARY KEY (id)
);


-- FitnessCenterDB.dbo.Roles definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Roles;

CREATE TABLE FitnessCenterDB.dbo.Roles (
	RolID int IDENTITY(1,1) NOT NULL,
	NombreRol nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Roles__F92302D1C65ABB7F PRIMARY KEY (RolID)
);


-- FitnessCenterDB.dbo.Servicios definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Servicios;

CREATE TABLE FitnessCenterDB.dbo.Servicios (
	ServicioID int IDENTITY(1,1) NOT NULL,
	NombreServicio nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	TipoServicio nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Costo decimal(10,2) NOT NULL,
	CONSTRAINT PK__Servicio__D5AEEC221B5A2D82 PRIMARY KEY (ServicioID)
);
ALTER TABLE FitnessCenterDB.dbo.Servicios WITH NOCHECK ADD CONSTRAINT CK__Servicios__TipoS__412EB0B6 CHECK (([TipoServicio]='Combinado' OR [TipoServicio]='Rendimiento' OR [TipoServicio]='Estetica' OR [TipoServicio]='Salud'));


-- FitnessCenterDB.dbo.TipoRutina definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.TipoRutina;

CREATE TABLE FitnessCenterDB.dbo.TipoRutina (
	idTipoRutina int IDENTITY(1,1) NOT NULL,
	nombreTipoRutina nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__TipoRuti__55C9CD78F168D142 PRIMARY KEY (idTipoRutina)
);


-- FitnessCenterDB.dbo.[__EFMigrationsHistory] definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.[__EFMigrationsHistory];

CREATE TABLE FitnessCenterDB.dbo.[__EFMigrationsHistory] (
	MigrationId nvarchar(150) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProductVersion nvarchar(32) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK___EFMigrationsHistory PRIMARY KEY (MigrationId)
);


-- FitnessCenterDB.dbo.duracionCitas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.duracionCitas;

CREATE TABLE FitnessCenterDB.dbo.duracionCitas (
	DuracionID int IDENTITY(1,1) NOT NULL,
	Duracion int NOT NULL,
	FrecuenciaNotificaciones int NOT NULL,
	CONSTRAINT PK__duracion__3B2C07DA2413E2C8 PRIMARY KEY (DuracionID)
);


-- FitnessCenterDB.dbo.estadosClasesProgramadas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estadosClasesProgramadas;

CREATE TABLE FitnessCenterDB.dbo.estadosClasesProgramadas (
	idEstadoClaseProgramada int IDENTITY(1,1) NOT NULL,
	nombresEstado nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosC__C0C65CED53670AA4 PRIMARY KEY (idEstadoClaseProgramada)
);


-- FitnessCenterDB.dbo.estadosDeActividadLaboral definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estadosDeActividadLaboral;

CREATE TABLE FitnessCenterDB.dbo.estadosDeActividadLaboral (
	idEstadoActividadLaboral int IDENTITY(1,1) NOT NULL,
	nombreEstadoActividadLaboral nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fcehaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosD__F41B8ED8EC454C75 PRIMARY KEY (idEstadoActividadLaboral)
);


-- FitnessCenterDB.dbo.estadosDeClases definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estadosDeClases;

CREATE TABLE FitnessCenterDB.dbo.estadosDeClases (
	idEstadoClase int IDENTITY(1,1) NOT NULL,
	nombreEstado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcionEstado nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosD__A4F595D46615EEBC PRIMARY KEY (idEstadoClase)
);


-- FitnessCenterDB.dbo.estadosHorarioClaseProgramada definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estadosHorarioClaseProgramada;

CREATE TABLE FitnessCenterDB.dbo.estadosHorarioClaseProgramada (
	idEstadoHorarioClase int IDENTITY(1,1) NOT NULL,
	nombreEstadoHorario nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosH__FE1509CB80800E66 PRIMARY KEY (idEstadoHorarioClase)
);


-- FitnessCenterDB.dbo.estadosInscripciones definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estadosInscripciones;

CREATE TABLE FitnessCenterDB.dbo.estadosInscripciones (
	idEstadoInscripcion int IDENTITY(1,1) NOT NULL,
	nombreEstadoInscripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosI__5CD68FF4850AB16F PRIMARY KEY (idEstadoInscripcion)
);


-- FitnessCenterDB.dbo.horasLaborales definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.horasLaborales;

CREATE TABLE FitnessCenterDB.dbo.horasLaborales (
	idHora int IDENTITY(1,1) NOT NULL,
	horaInicio time NOT NULL,
	horaFin time NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__horasLab__770403DB6FE2950B PRIMARY KEY (idHora)
);


-- FitnessCenterDB.dbo.iconsForParameters definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.iconsForParameters;

CREATE TABLE FitnessCenterDB.dbo.iconsForParameters (
	iconId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPrivada nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPublica nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__iconsFor__5CE3968F35DA5BE8 PRIMARY KEY (iconId)
);


-- FitnessCenterDB.dbo.intenciones definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.intenciones;

CREATE TABLE FitnessCenterDB.dbo.intenciones (
	intencionId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	CONSTRAINT PK__intencio__41F5EC2340AE7FEA PRIMARY KEY (intencionId)
);


-- FitnessCenterDB.dbo.nivelesDeDificultadDeClase definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.nivelesDeDificultadDeClase;

CREATE TABLE FitnessCenterDB.dbo.nivelesDeDificultadDeClase (
	idNivelDeDificultadDeClase int IDENTITY(1,1) NOT NULL,
	nombreNivelDeDificultad nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime NULL,
	fechaDeModificacion datetime NULL,
	CONSTRAINT PK__nivelesD__86F5BA39539AB17D PRIMARY KEY (idNivelDeDificultadDeClase)
);


-- FitnessCenterDB.dbo.nivelesDeIntensidadDeClase definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.nivelesDeIntensidadDeClase;

CREATE TABLE FitnessCenterDB.dbo.nivelesDeIntensidadDeClase (
	idNivelDeIntensidad int IDENTITY(1,1) NOT NULL,
	nombreNivelDeIntensidad nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__nivelesD__6F6E9594C607DCB8 PRIMARY KEY (idNivelDeIntensidad)
);


-- FitnessCenterDB.dbo.nivelesDeLogro definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.nivelesDeLogro;

CREATE TABLE FitnessCenterDB.dbo.nivelesDeLogro (
	idNivelDeLogro int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__nivelesD__0A5FC0796013EA3F PRIMARY KEY (idNivelDeLogro)
);


-- FitnessCenterDB.dbo.sysdiagrams definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.sysdiagrams;

CREATE TABLE FitnessCenterDB.dbo.sysdiagrams (
	name sysname COLLATE Modern_Spanish_CI_AS NOT NULL,
	principal_id int NOT NULL,
	diagram_id int IDENTITY(1,1) NOT NULL,
	version int NULL,
	definition varbinary(MAX) NULL,
	CONSTRAINT PK__sysdiagr__C2B05B6153CBA9AD PRIMARY KEY (diagram_id),
	CONSTRAINT UK_principal_name UNIQUE (principal_id,name)
);


-- FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos;

CREATE TABLE FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos (
	idTipoDeRecurrenciaDeDiaFestivo int IDENTITY(1,1) NOT NULL,
	nombreTipoDeRecurrencia nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	CONSTRAINT PK__tiposDeR__3A34B1D521F4C5E6 PRIMARY KEY (idTipoDeRecurrenciaDeDiaFestivo)
);
 CREATE NONCLUSTERED INDEX IX_tiposDeRecurrenciaDeDiasFestivos_Nombre ON FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos (  nombreTipoDeRecurrencia ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.unidadesDeMedida definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.unidadesDeMedida;

CREATE TABLE FitnessCenterDB.dbo.unidadesDeMedida (
	unidadDeMedidaId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	CONSTRAINT PK__unidades__935D876DD487B38F PRIMARY KEY (unidadDeMedidaId)
);


-- FitnessCenterDB.dbo.AccessTokens definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AccessTokens;

CREATE TABLE FitnessCenterDB.dbo.AccessTokens (
	AccessTokenId uniqueidentifier DEFAULT newid() NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClientId nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TokenHash nvarchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	IssuedAt datetime2 DEFAULT sysutcdatetime() NOT NULL,
	ExpiresAt datetime2 NOT NULL,
	RevokedAt datetime2 NULL,
	IpAddress nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	UserAgent nvarchar(250) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AccessTokens PRIMARY KEY (AccessTokenId),
	CONSTRAINT FK_AccessTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AccessTokens_UserId ON FitnessCenterDB.dbo.AccessTokens (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetRoleClaims definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetRoleClaims;

CREATE TABLE FitnessCenterDB.dbo.AspNetRoleClaims (
	Id int IDENTITY(1,1) NOT NULL,
	RoleId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClaimType nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	ClaimValue nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetRoleClaims PRIMARY KEY (Id),
	CONSTRAINT FK_AspNetRoleClaims_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES FitnessCenterDB.dbo.AspNetRoles(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetRoleClaims_RoleId ON FitnessCenterDB.dbo.AspNetRoleClaims (  RoleId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetUserClaims definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetUserClaims;

CREATE TABLE FitnessCenterDB.dbo.AspNetUserClaims (
	Id int IDENTITY(1,1) NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClaimType nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	ClaimValue nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetUserClaims PRIMARY KEY (Id),
	CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetUserClaims_UserId ON FitnessCenterDB.dbo.AspNetUserClaims (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetUserLogins definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetUserLogins;

CREATE TABLE FitnessCenterDB.dbo.AspNetUserLogins (
	LoginProvider nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProviderKey nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProviderDisplayName nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK_AspNetUserLogins PRIMARY KEY (LoginProvider,ProviderKey),
	CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetUserLogins_UserId ON FitnessCenterDB.dbo.AspNetUserLogins (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetUserRoles definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetUserRoles;

CREATE TABLE FitnessCenterDB.dbo.AspNetUserRoles (
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	RoleId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK_AspNetUserRoles PRIMARY KEY (UserId,RoleId),
	CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES FitnessCenterDB.dbo.AspNetRoles(Id) ON DELETE CASCADE,
	CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetUserRoles_RoleId ON FitnessCenterDB.dbo.AspNetUserRoles (  RoleId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.AspNetUserTokens definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.AspNetUserTokens;

CREATE TABLE FitnessCenterDB.dbo.AspNetUserTokens (
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	LoginProvider nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Name nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Value nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetUserTokens PRIMARY KEY (UserId,LoginProvider,Name),
	CONSTRAINT FK_AspNetUserTokens_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);


-- FitnessCenterDB.dbo.Citas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Citas;

CREATE TABLE FitnessCenterDB.dbo.Citas (
	CitaID int IDENTITY(1,1) NOT NULL,
	FechaHora datetime NOT NULL,
	TipoCita nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	FechaHoraFin datetime NOT NULL,
	EntrenadorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Citas__F0E2D9F2556E9C13 PRIMARY KEY (CitaID),
	CONSTRAINT FK_Citas_AspNetUsers_NewEntrenadorId FOREIGN KEY (EntrenadorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Citas_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id)
);
ALTER TABLE FitnessCenterDB.dbo.Citas WITH NOCHECK ADD CONSTRAINT CK__Citas__TipoCita__45F365D3 CHECK (([TipoCita]='Entrenamiento Personal' OR [TipoCita]='Medicion'));
ALTER TABLE FitnessCenterDB.dbo.Citas WITH NOCHECK ADD CONSTRAINT CK__Citas__Estado__46E78A0C CHECK (([Estado]='Cancelada' OR [Estado]='Completada' OR [Estado]='Agendada'));


-- FitnessCenterDB.dbo.Clases definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Clases;

CREATE TABLE FitnessCenterDB.dbo.Clases (
	ClaseID int IDENTITY(1,1) NOT NULL,
	NombreClase nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Cupo int NOT NULL,
	Descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	duracionEnMinutos int NULL,
	fkIntensidad int NULL,
	fkDificultad int NULL,
	tiempoDeDescansoEnMinutos int DEFAULT 15 NOT NULL,
	duracionEnMinutosConDescansoIncluido int DEFAULT 60 NOT NULL,
	fkEstadoClase int NULL,
	InstructorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Clases__F54296B30E7E66FD PRIMARY KEY (ClaseID),
	CONSTRAINT FK_Clases_AspNetUsers_NewInstructorId FOREIGN KEY (InstructorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Clases_Dificultad FOREIGN KEY (fkDificultad) REFERENCES FitnessCenterDB.dbo.nivelesDeDificultadDeClase(idNivelDeDificultadDeClase),
	CONSTRAINT FK_Clases_Intensidad FOREIGN KEY (fkIntensidad) REFERENCES FitnessCenterDB.dbo.nivelesDeIntensidadDeClase(idNivelDeIntensidad),
	CONSTRAINT FK_Clases_estadosDeClases FOREIGN KEY (fkEstadoClase) REFERENCES FitnessCenterDB.dbo.estadosDeClases(idEstadoClase)
);


-- FitnessCenterDB.dbo.Cupones definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Cupones;

CREATE TABLE FitnessCenterDB.dbo.Cupones (
	CuponID int IDENTITY(1,1) NOT NULL,
	Codigo nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	DescuentoID int NULL,
	FechaExpiracion datetime NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Cupones__C43568B78A3A377F PRIMARY KEY (CuponID),
	CONSTRAINT FK__Cupones__Descuen__6B24EA82 FOREIGN KEY (DescuentoID) REFERENCES FitnessCenterDB.dbo.Descuentos(DescuentoID)
);
ALTER TABLE FitnessCenterDB.dbo.Cupones WITH NOCHECK ADD CONSTRAINT CK__Cupones__Estado__6C190EBB CHECK (([Estado]='Expirado' OR [Estado]='Usado' OR [Estado]='Activo'));


-- FitnessCenterDB.dbo.Ejercicios definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Ejercicios;

CREATE TABLE FitnessCenterDB.dbo.Ejercicios (
	EjercicioID int IDENTITY(1,1) NOT NULL,
	NombreEjercicio nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TipoEjercicio nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkIcon int NULL,
	CONSTRAINT PK__Ejercici__812226A1579B3B09 PRIMARY KEY (EjercicioID),
	CONSTRAINT fk_ejercicios_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDB.dbo.iconsForParameters(iconId)
);
ALTER TABLE FitnessCenterDB.dbo.Ejercicios WITH NOCHECK ADD CONSTRAINT CK__Ejercicio__TipoE__4E88ABD4 CHECK (([TipoEjercicio]='AMRAP' OR [TipoEjercicio]='Tiempo' OR [TipoEjercicio]='Peso'));


-- FitnessCenterDB.dbo.Equipos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Equipos;

CREATE TABLE FitnessCenterDB.dbo.Equipos (
	EquipoID int IDENTITY(1,1) NOT NULL,
	NombreEquipo nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkIcon int NULL,
	CONSTRAINT PK__Equipos__DE8A0BFFA22BEA11 PRIMARY KEY (EquipoID),
	CONSTRAINT FK_Equipos_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDB.dbo.iconsForParameters(iconId)
);


-- FitnessCenterDB.dbo.Pagos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Pagos;

CREATE TABLE FitnessCenterDB.dbo.Pagos (
	PagoID int IDENTITY(1,1) NOT NULL,
	Monto decimal(10,2) NOT NULL,
	FechaPago datetime DEFAULT getdate() NULL,
	MetodoPago nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Pagos__F00B6158C2211D16 PRIMARY KEY (PagoID),
	CONSTRAINT FK_Pagos_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id)
);
ALTER TABLE FitnessCenterDB.dbo.Pagos WITH NOCHECK ADD CONSTRAINT CK__Pagos__MetodoPag__656C112C CHECK (([MetodoPago]='PayPal' OR [MetodoPago]='Efectivo' OR [MetodoPago]='SINPE' OR [MetodoPago]='Transferencia'));
ALTER TABLE FitnessCenterDB.dbo.Pagos WITH NOCHECK ADD CONSTRAINT CK__Pagos__Estado__66603565 CHECK (([Estado]='Fallido' OR [Estado]='Completado' OR [Estado]='Pendiente'));


-- FitnessCenterDB.dbo.RefreshTokens definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.RefreshTokens;

CREATE TABLE FitnessCenterDB.dbo.RefreshTokens (
	RefreshTokenId uniqueidentifier DEFAULT newid() NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClientId nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TokenHash nvarchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	IssuedAt datetime2 DEFAULT sysutcdatetime() NOT NULL,
	ExpiresAt datetime2 NOT NULL,
	RevokedAt datetime2 NULL,
	ReplacedByTokenId uniqueidentifier NULL,
	IpAddress nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	UserAgent nvarchar(250) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_RefreshTokens PRIMARY KEY (RefreshTokenId),
	CONSTRAINT FK_RefreshTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_RefreshTokens_UserId ON FitnessCenterDB.dbo.RefreshTokens (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.Rutinas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Rutinas;

CREATE TABLE FitnessCenterDB.dbo.Rutinas (
	RutinaID int IDENTITY(1,1) NOT NULL,
	FechaCreacion datetime DEFAULT getdate() NULL,
	Observaciones nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkClase int NULL,
	fkTipoRutina int NULL,
	EntrenadorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Rutinas__E76E165A11753A49 PRIMARY KEY (RutinaID),
	CONSTRAINT FK_Rutinas_AspNetUsers_NewEntrenadorId FOREIGN KEY (EntrenadorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Rutinas_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Rutinas_Clases FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID),
	CONSTRAINT FK_Rutinas_TipoRutina FOREIGN KEY (fkTipoRutina) REFERENCES FitnessCenterDB.dbo.TipoRutina(idTipoRutina)
);


-- FitnessCenterDB.dbo.Usuarios definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.Usuarios;

CREATE TABLE FitnessCenterDB.dbo.Usuarios (
	UsuarioID int IDENTITY(1,1) NOT NULL,
	Nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Apellido nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Email nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Telefono nvarchar(15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	NombreUsuario nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Contrasena nvarchar(255) COLLATE Modern_Spanish_CI_AS NOT NULL,
	FechaNacimiento date NOT NULL,
	FechaRegistro datetime DEFAULT getdate() NULL,
	RolID int NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Usuarios__2B3DE7981B26D7DC PRIMARY KEY (UsuarioID),
	CONSTRAINT UQ__Usuarios__4EC5048011B00D5E UNIQUE (Telefono),
	CONSTRAINT UQ__Usuarios__6B0F5AE04376F638 UNIQUE (NombreUsuario),
	CONSTRAINT UQ__Usuarios__A9D1053404A4BEF2 UNIQUE (Email),
	CONSTRAINT FK__Usuarios__RolID__3D5E1FD2 FOREIGN KEY (RolID) REFERENCES FitnessCenterDB.dbo.Roles(RolID)
);
ALTER TABLE FitnessCenterDB.dbo.Usuarios WITH NOCHECK ADD CONSTRAINT CK__Usuarios__Estado__3E52440B CHECK (([Estado]='PendienteVerificacion' OR [Estado]='Inactivo' OR [Estado]='Activo'));


-- FitnessCenterDB.dbo.beneficiosDeClase definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.beneficiosDeClase;

CREATE TABLE FitnessCenterDB.dbo.beneficiosDeClase (
	idBeneficio int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	beneficio nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	fkIcon int NULL,
	descripcionBeneficio nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__benefici__00AAC26A2D2E6E7C PRIMARY KEY (idBeneficio),
	CONSTRAINT FK_Beneficio_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID),
	CONSTRAINT FK_iconsForParameters_beneficios_del_clase FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDB.dbo.iconsForParameters(iconId)
);


-- FitnessCenterDB.dbo.clasesProgramadas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.clasesProgramadas;

CREATE TABLE FitnessCenterDB.dbo.clasesProgramadas (
	idProgramacionClase int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	cupoMaximo int NOT NULL,
	fkEstadoClaseProgramada int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	fkEntrenador nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__clasesPr__712E87EE8D30E7B0 PRIMARY KEY (idProgramacionClase),
	CONSTRAINT FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador FOREIGN KEY (fkEntrenador) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_ClasesProgramadas_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID),
	CONSTRAINT FK_ClasesProgramadas_EstadoClaseProgramada FOREIGN KEY (fkEstadoClaseProgramada) REFERENCES FitnessCenterDB.dbo.estadosClasesProgramadas(idEstadoClaseProgramada)
);


-- FitnessCenterDB.dbo.consejosParaLasClases definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.consejosParaLasClases;

CREATE TABLE FitnessCenterDB.dbo.consejosParaLasClases (
	idConsejo int IDENTITY(1,1) NOT NULL,
	fkClase int NULL,
	fkEjercicio int NULL,
	introduccionDeConsejo nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	consejos nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__consejos__3DB777ADDB7A6091 PRIMARY KEY (idConsejo),
	CONSTRAINT FK_Consejos_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID) ON DELETE SET NULL,
	CONSTRAINT FK_Consejos_Ejercicio FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID) ON DELETE SET NULL
);


-- FitnessCenterDB.dbo.diasFestivosVariables definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.diasFestivosVariables;

CREATE TABLE FitnessCenterDB.dbo.diasFestivosVariables (
	idDiaFestivoVariable int IDENTITY(1,1) NOT NULL,
	nombreDiasFestivoVariable nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	deQueSemana int NULL,
	deQueMes int NULL,
	deQueDia int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	fkTipoDeRecurrenciaDelFestivo int NOT NULL,
	fkEstadoActividadLaboral int NOT NULL,
	CONSTRAINT PK__diasFest__499CE46553695ECB PRIMARY KEY (idDiaFestivoVariable),
	CONSTRAINT fk_estadosDeActividdadLaboral_diasFestivosVariables FOREIGN KEY (fkEstadoActividadLaboral) REFERENCES FitnessCenterDB.dbo.estadosDeActividadLaboral(idEstadoActividadLaboral),
	CONSTRAINT fk_tiposDeRecurrenciaDeDiasFestivos_diasFestivosVariables FOREIGN KEY (fkTipoDeRecurrenciaDelFestivo) REFERENCES FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos(idTipoDeRecurrenciaDeDiaFestivo)
);


-- FitnessCenterDB.dbo.diasFestivosYDescansos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.diasFestivosYDescansos;

CREATE TABLE FitnessCenterDB.dbo.diasFestivosYDescansos (
	idDiaFestivo int IDENTITY(1,1) NOT NULL,
	fechaFestivaODescanso date NOT NULL,
	descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fkEstadoActividadLaboral int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fcehaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__diasFest__A066CE26B7DC05E6 PRIMARY KEY (idDiaFestivo),
	CONSTRAINT fecha_unica UNIQUE (fechaFestivaODescanso),
	CONSTRAINT FK_diasFestivosYDescansos_EstadoActividadLaboral FOREIGN KEY (fkEstadoActividadLaboral) REFERENCES FitnessCenterDB.dbo.estadosDeActividadLaboral(idEstadoActividadLaboral)
);
 CREATE NONCLUSTERED INDEX IX_diasFestivosYDescansos_Fecha ON FitnessCenterDB.dbo.diasFestivosYDescansos (  fechaFestivaODescanso ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.estructuraDeClase definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.estructuraDeClase;

CREATE TABLE FitnessCenterDB.dbo.estructuraDeClase (
	idBloque int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	numeroConsecutivoDelBloque int NOT NULL,
	duracionMenorEnMinutos int NOT NULL,
	duracionMayorEnMinutos int NOT NULL,
	tituloBloque nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcionBloque nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estructu__EF4379A8928D581A PRIMARY KEY (idBloque),
	CONSTRAINT FK_Estructura_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID)
);


-- FitnessCenterDB.dbo.horariosDeClasesProgramadas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas;

CREATE TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas (
	idHorarioDeClaseProgramada int IDENTITY(1,1) NOT NULL,
	fkClaseProgramada int NOT NULL,
	fkHorarioLaboral int NOT NULL,
	fkEstadoHorarioClase int DEFAULT 1 NOT NULL,
	fechaDeLaClase date NULL,
	fkEntrenador nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__horarios__873B1A4EFA42A731 PRIMARY KEY (idHorarioDeClaseProgramada),
	CONSTRAINT FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador FOREIGN KEY (fkEntrenador) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_horariosDeClasesProgramadas_clasesProgramadas FOREIGN KEY (fkClaseProgramada) REFERENCES FitnessCenterDB.dbo.clasesProgramadas(idProgramacionClase),
	CONSTRAINT FK_horasLborales_horariosClasesProgramadas FOREIGN KEY (fkHorarioLaboral) REFERENCES FitnessCenterDB.dbo.horasLaborales(idHora),
	CONSTRAINT fk_estadosClasesProgramadas_horariosDeClasesProgramadas FOREIGN KEY (fkEstadoHorarioClase) REFERENCES FitnessCenterDB.dbo.estadosHorarioClaseProgramada(idEstadoHorarioClase)
);


-- FitnessCenterDB.dbo.imagesForClases definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.imagesForClases;

CREATE TABLE FitnessCenterDB.dbo.imagesForClases (
	idClassImage int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	urlParaBanner nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	urlParaParaDescripcionDeClase nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	urlParaBloqueConsejos nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	FechaDeCreacion datetime DEFAULT getdate() NOT NULL,
	FechaDeModificacion datetime DEFAULT getdate() NOT NULL,
	CONSTRAINT PK__imagesFo__F0634AEDFB54D109 PRIMARY KEY (idClassImage),
	CONSTRAINT FK_imagesForClases_Clases FOREIGN KEY (fkClase) REFERENCES FitnessCenterDB.dbo.Clases(ClaseID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- FitnessCenterDB.dbo.imagesForExercises definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.imagesForExercises;

CREATE TABLE FitnessCenterDB.dbo.imagesForExercises (
	idImage int IDENTITY(1,1) NOT NULL,
	fkEjercicio int NOT NULL,
	nombreParaElFront nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPrivada nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPublica nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__imagesFo__84D649AFC118D1B7 PRIMARY KEY (idImage),
	CONSTRAINT FK_ImagesForExercises_Ejercicio FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID)
);


-- FitnessCenterDB.dbo.inscripcionesDeClases definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.inscripcionesDeClases;

CREATE TABLE FitnessCenterDB.dbo.inscripcionesDeClases (
	idInscripcion int IDENTITY(1,1) NOT NULL,
	fkProgramacionClase int NOT NULL,
	fechaDeInscripcion datetime DEFAULT getdate() NULL,
	fkEstadoInscripcion int NOT NULL,
	fkCliente nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__inscripc__3D58AB69B61D8617 PRIMARY KEY (idInscripcion),
	CONSTRAINT FK_InscripcionesDeClases_AspNetUsers_NewFkCliente FOREIGN KEY (fkCliente) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_InscripcionesDeClases_EstadoInscripcion FOREIGN KEY (fkEstadoInscripcion) REFERENCES FitnessCenterDB.dbo.estadosInscripciones(idEstadoInscripcion),
	CONSTRAINT FK_InscripcionesDeClases_ProgramacionClase FOREIGN KEY (fkProgramacionClase) REFERENCES FitnessCenterDB.dbo.clasesProgramadas(idProgramacionClase)
);


-- FitnessCenterDB.dbo.parametrosDeMedicion definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.parametrosDeMedicion;

CREATE TABLE FitnessCenterDB.dbo.parametrosDeMedicion (
	parametroMedicionId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	fkIcon int NULL,
	CONSTRAINT PK__parametr__FE4B91C8ECDB659E PRIMARY KEY (parametroMedicionId),
	CONSTRAINT fk_parametrosDeMedicion_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDB.dbo.iconsForParameters(iconId)
);


-- FitnessCenterDB.dbo.parametros_unidadesDeMedida definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.parametros_unidadesDeMedida;

CREATE TABLE FitnessCenterDB.dbo.parametros_unidadesDeMedida (
	fkParametroDeMedicion int NOT NULL,
	fkUnidadDeMedida int NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	CONSTRAINT PK__Parametr__44945C4A9DEF7EB4 PRIMARY KEY (fkParametroDeMedicion,fkUnidadDeMedida),
	CONSTRAINT FK__Parametro__fkPar__4924D839 FOREIGN KEY (fkParametroDeMedicion) REFERENCES FitnessCenterDB.dbo.parametrosDeMedicion(parametroMedicionId),
	CONSTRAINT FK__Parametro__fkUni__4A18FC72 FOREIGN KEY (fkUnidadDeMedida) REFERENCES FitnessCenterDB.dbo.unidadesDeMedida(unidadDeMedidaId)
);


-- FitnessCenterDB.dbo.preReservasDeHorario definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.preReservasDeHorario;

CREATE TABLE FitnessCenterDB.dbo.preReservasDeHorario (
	idPreReserva int IDENTITY(1,1) NOT NULL,
	fechaInicioDeLaReserva datetime NOT NULL,
	fechaDeExpiracionDeLaReserva datetime NOT NULL,
	fkHoraLaboral int NOT NULL,
	idUsuarioQueReserva int NOT NULL,
	fechaReservada date NOT NULL,
	CONSTRAINT PK__preReser__0FAC6FC5DD04E13F PRIMARY KEY (idPreReserva),
	CONSTRAINT FK_preReservasDeHorario_horariosClasesProgramadas FOREIGN KEY (fkHoraLaboral) REFERENCES FitnessCenterDB.dbo.horasLaborales(idHora)
);


-- FitnessCenterDB.dbo.EjercicioEquipos definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.EjercicioEquipos;

CREATE TABLE FitnessCenterDB.dbo.EjercicioEquipos (
	EjercicioEquipoID int IDENTITY(1,1) NOT NULL,
	EjercicioID int NULL,
	EquipoID int NULL,
	CONSTRAINT PK__Ejercici__A8CC48FDB85B7151 PRIMARY KEY (EjercicioEquipoID),
	CONSTRAINT FK__Ejercicio__Ejerc__571DF1D5 FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__Ejercicio__Equip__5812160E FOREIGN KEY (EquipoID) REFERENCES FitnessCenterDB.dbo.Equipos(EquipoID)
);


-- FitnessCenterDB.dbo.RegistrosEntrenamiento definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento;

CREATE TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento (
	RegistroID int IDENTITY(1,1) NOT NULL,
	RutinaID int NULL,
	FechaRegistro datetime DEFAULT getdate() NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Registro__B897313EAB9C2539 PRIMARY KEY (RegistroID),
	CONSTRAINT FK_RegistrosEntrenamiento_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK__Registros__Rutin__6FE99F9F FOREIGN KEY (RutinaID) REFERENCES FitnessCenterDB.dbo.Rutinas(RutinaID)
);


-- FitnessCenterDB.dbo.RutinaEjercicios definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.RutinaEjercicios;

CREATE TABLE FitnessCenterDB.dbo.RutinaEjercicios (
	RutinaEjercicioID int IDENTITY(1,1) NOT NULL,
	RutinaID int NULL,
	EjercicioID int NULL,
	[Sets] int NULL,
	Repeticiones int NULL,
	Peso decimal(5,2) NULL,
	Tiempo int NULL,
	MetaRepeticiones int NULL,
	CONSTRAINT PK__RutinaEj__56420023FA3B532E PRIMARY KEY (RutinaEjercicioID),
	CONSTRAINT FK__RutinaEje__Ejerc__52593CB8 FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__RutinaEje__Rutin__5165187F FOREIGN KEY (RutinaID) REFERENCES FitnessCenterDB.dbo.Rutinas(RutinaID)
);


-- FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion;

CREATE TABLE FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion (
	id int IDENTITY(1,1) NOT NULL,
	fkEjercicio int NOT NULL,
	fkParametro int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	CONSTRAINT PK__ejercici__3213E83FF0FCCAAC PRIMARY KEY (id),
	CONSTRAINT FK_ejercicios_parametrosDeMedicion_Ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDB.dbo.parametrosDeMedicion(parametroMedicionId)
);
 CREATE NONCLUSTERED INDEX idx_ejercicios_parametrosDeMedicion_ejercicio ON FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion (  fkEjercicio ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_ejercicios_parametrosDeMedicion_parametro ON FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion (  fkParametro ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- FitnessCenterDB.dbo.medidas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.medidas;

CREATE TABLE FitnessCenterDB.dbo.medidas (
	medidaId int IDENTITY(1,1) NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fkParametro int NULL,
	valor decimal(10,2) NULL,
	fkEjercicio int NULL,
	fkUsuario nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__medidas__1C299EFA6221D68B PRIMARY KEY (medidaId),
	CONSTRAINT FK_Medidas_AspNetUsers_NewFkUsuario FOREIGN KEY (fkUsuario) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT fk_medidas_ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT fk_medidas_parametros FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDB.dbo.parametrosDeMedicion(parametroMedicionId)
);


-- FitnessCenterDB.dbo.metas definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.metas;

CREATE TABLE FitnessCenterDB.dbo.metas (
	metaId int IDENTITY(1,1) NOT NULL,
	fkIntencion int NOT NULL,
	fkParametro int NOT NULL,
	fkEjercicio int NULL,
	valorObjetivo decimal(10,2) NOT NULL,
	fechaDeInicioDeLaMeta datetime NOT NULL,
	fechaLimite datetime NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaDeModificacionDeRegistro datetime DEFAULT getdate() NULL,
	fkNivelDeLogro int DEFAULT 1 NOT NULL,
	fkUsuario nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__metas__8189FF8C363B9BB4 PRIMARY KEY (metaId),
	CONSTRAINT FK_Metas_AspNetUsers_NewFkUsuario FOREIGN KEY (fkUsuario) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Metas_Ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK_Metas_Intenciones FOREIGN KEY (fkIntencion) REFERENCES FitnessCenterDB.dbo.intenciones(intencionId),
	CONSTRAINT FK_Metas_Parametros FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDB.dbo.parametrosDeMedicion(parametroMedicionId),
	CONSTRAINT fk_metas_nivelesDeLogro FOREIGN KEY (fkNivelDeLogro) REFERENCES FitnessCenterDB.dbo.nivelesDeLogro(idNivelDeLogro)
);


-- FitnessCenterDB.dbo.DetalleEntrenamiento definition

-- Drop table

-- DROP TABLE FitnessCenterDB.dbo.DetalleEntrenamiento;

CREATE TABLE FitnessCenterDB.dbo.DetalleEntrenamiento (
	DetalleID int IDENTITY(1,1) NOT NULL,
	RegistroID int NULL,
	EjercicioID int NULL,
	[Sets] int NULL,
	Repeticiones int NULL,
	Peso decimal(5,2) NULL,
	Tiempo int NULL,
	CONSTRAINT PK__DetalleE__6E19D6FA406B23BB PRIMARY KEY (DetalleID),
	CONSTRAINT FK__DetalleEn__Ejerc__74AE54BC FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDB.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__DetalleEn__Regis__73BA3083 FOREIGN KEY (RegistroID) REFERENCES FitnessCenterDB.dbo.RegistrosEntrenamiento(RegistroID)
);


-- dbo.v_estadoActivoClases source

-- dbo.v_estadoActivoClases source

-- dbo.v_estadoActivoClases source

CREATE OR ALTER VIEW dbo.v_estadoActivoClases AS
SELECT idEstadoClase from estadosDeClases edc where Lower(nombreEstado) = 'activa';


-- dbo.v_idEstadoCanceladoClasesProgramadas source

CREATE OR ALTER VIEW v_idEstadoCanceladoClasesProgramadas AS
SELECT idEstadoClaseProgramada
FROM  estadosClasesProgramadas
WHERE nombresEstado = 'cancelada';


-- dbo.v_idEstadoCanceladoInscripcionAClase source

CREATE OR ALTER VIEW v_idEstadoCanceladoInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'cancelada';


-- dbo.v_idEstadoDisponibleClasesProgramadas source

CREATE OR ALTER VIEW v_idEstadoDisponibleClasesProgramadas AS
SELECT idEstadoClaseProgramada
FROM  estadosClasesProgramadas
WHERE nombresEstado = 'disponible';


-- dbo.v_idEstadoVigenteInscripcionAClase source

CREATE OR ALTER VIEW v_idEstadoVigenteInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'vigente';


-- dbo.v_nivelesDeDificultad source

CREATE OR ALTER VIEW v_nivelesDeDificultad
AS
SELECT 
    idNivelDeDificultadDeClase,
    nombreNivelDeDificultad
FROM 
    FitnessCenterDB.dbo.nivelesDeDificultadDeClase;


-- dbo.v_nivelesDeIntensidad source

CREATE OR ALTER VIEW v_nivelesDeIntensidad
AS
SELECT 
    idNivelDeIntensidad,
    nombreNivelDeIntensidad
FROM 
    FitnessCenterDB.dbo.nivelesDeIntensidadDeClase;