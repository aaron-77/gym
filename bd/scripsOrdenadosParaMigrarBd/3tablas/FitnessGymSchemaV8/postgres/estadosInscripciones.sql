-- =============================================
-- TABLE: estados_inscripciones
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estados_inscripciones (
    id_estado_inscripcion integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_estado_inscripcion text NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estados_inscripciones PRIMARY KEY (id_estado_inscripcion)
);

ALTER TABLE public.estados_inscripciones OWNER TO postgres;