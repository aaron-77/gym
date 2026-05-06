-- =============================================
-- TABLE: unidades_de_medida
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.unidades_de_medida (
    unidad_de_medida_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(100) NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion_de_registro timestamp NULL,
    CONSTRAINT pk_unidades_de_medida PRIMARY KEY (unidad_de_medida_id)
);

ALTER TABLE public.unidades_de_medida OWNER TO postgres;