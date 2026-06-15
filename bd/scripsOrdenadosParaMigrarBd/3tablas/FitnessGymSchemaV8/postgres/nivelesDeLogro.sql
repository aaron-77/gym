-- =============================================
-- TABLE: niveles_de_logro
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.niveles_de_logro (
    id_nivel_de_logro integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(100) NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_niveles_de_logro PRIMARY KEY (id_nivel_de_logro)
);

ALTER TABLE public.niveles_de_logro OWNER TO postgres;