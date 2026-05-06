-- =============================================
-- [TABLA]: Clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.Clases (
    ClaseID integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    NombreClase varchar(100) NOT NULL,
    Cupo integer NOT NULL,
    Descripcion text NULL,
    duracionEnMinutos integer NULL,
    fkIntensidad integer NULL,
    fkDificultad integer NULL,
    tiempoDeDescansoEnMinutos integer DEFAULT 15 NOT NULL,
    duracionEnMinutosConDescansoIncluido integer DEFAULT 60 NOT NULL,
    fkEstadoClase integer NULL,
    InstructorId varchar(450) NULL,
    CONSTRAINT pk_clases PRIMARY KEY (ClaseID),
    CONSTRAINT fk_clases_aspnetusers_instructorid FOREIGN KEY (InstructorId) REFERENCES public.AspNetUsers(Id),
    CONSTRAINT fk_clases_dificultad FOREIGN KEY (fkDificultad) REFERENCES public.nivelesDeDificultadDeClase(idNivelDeDificultadDeClase),
    CONSTRAINT fk_clases_intensidad FOREIGN KEY (fkIntensidad) REFERENCES public.nivelesDeIntensidadDeClase(idNivelDeIntensidad),
    CONSTRAINT fk_clases_estadosdeclases FOREIGN KEY (fkEstadoClase) REFERENCES public.estadosDeClases(idEstadoClase)
);