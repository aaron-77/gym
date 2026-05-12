-- =============================================
-- TABLE: estados_clases_programadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estados_clases_programadas (
    id_estado_clase_programada integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_estado text NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estados_clases_programadas PRIMARY KEY (id_estado_clase_programada)
);

ALTER TABLE public.estados_clases_programadas OWNER TO postgres;