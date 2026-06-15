-- =============================================
-- TABLE: estados_horario_clase_programada
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estados_horario_clase_programada (
    id_estado_horario_clase integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_estado_horario varchar(50) NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estados_horario_clase_programada PRIMARY KEY (id_estado_horario_clase)
);

ALTER TABLE public.estados_horario_clase_programada OWNER TO postgres;