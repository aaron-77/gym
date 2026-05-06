-- =============================================
-- [TABLA]: Usuarios
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.Usuarios (
    UsuarioID integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    Nombre varchar(100) NOT NULL,
    Apellido varchar(100) NOT NULL,
    Email varchar(100) NOT NULL,
    Telefono varchar(15) NOT NULL,
    NombreUsuario varchar(50) NOT NULL,
    Contrasena varchar(255) NOT NULL,
    FechaNacimiento date NOT NULL,
    FechaRegistro timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    RolID integer NULL,
    Estado varchar(50) NOT NULL,
    CONSTRAINT pk_usuarios PRIMARY KEY (UsuarioID),
    CONSTRAINT uq_usuarios_telefono UNIQUE (Telefono),
    CONSTRAINT uq_usuarios_nombreusuario UNIQUE (NombreUsuario),
    CONSTRAINT uq_usuarios_email UNIQUE (Email),
    CONSTRAINT fk_usuarios_rolid FOREIGN KEY (RolID) REFERENCES public.Roles(RolID)
);

ALTER TABLE public.Usuarios ADD CONSTRAINT ck_usuarios_estado CHECK (Estado IN ('PendienteVerificacion', 'Inactivo', 'Activo'));