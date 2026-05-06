-- =============================================
-- TABLE: intenciones
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.intenciones (
    intencion_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(100) NOT NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion_de_registro timestamp NULL,
    CONSTRAINT pk_intenciones PRIMARY KEY (intencion_id)
);

ALTER TABLE public.intenciones OWNER TO postgres;