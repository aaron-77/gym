-- =============================================
-- TABLE: estados_de_actividad_laboral
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estados_de_actividad_laboral (
    id_estado_actividad_laboral integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_estado_actividad_laboral varchar(100) NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estados_de_actividad_laboral PRIMARY KEY (id_estado_actividad_laboral)
);

ALTER TABLE public.estados_de_actividad_laboral OWNER TO postgres;