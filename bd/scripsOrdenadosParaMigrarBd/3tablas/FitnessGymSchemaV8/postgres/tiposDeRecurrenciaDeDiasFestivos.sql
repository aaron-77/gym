-- =============================================
-- TABLE: tipos_de_recurrencia_de_dias_festivos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.tipos_de_recurrencia_de_dias_festivos (
    id_tipo_de_recurrencia_de_dia_festivo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_tipo_de_recurrencia varchar(100) NOT NULL,
    descripcion text NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp NULL,
    CONSTRAINT pk_tipos_de_recurrencia_de_dias_festivos PRIMARY KEY (id_tipo_de_recurrencia_de_dia_festivo)
);

CREATE INDEX ix_tipos_de_recurrencia_de_dias_festivos_nombre ON public.tipos_de_recurrencia_de_dias_festivos (nombre_tipo_de_recurrencia);

ALTER TABLE public.tipos_de_recurrencia_de_dias_festivos OWNER TO postgres;