-- =============================================
-- TABLE: descuentos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.descuentos (
    descuento_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    porcentaje decimal(5,2) NOT NULL,
    descripcion varchar(255) NULL,
    fecha_inicio timestamp NOT NULL,
    fecha_fin timestamp NOT NULL,
    CONSTRAINT pk_descuentos PRIMARY KEY (descuento_id)
);

ALTER TABLE public.descuentos OWNER TO postgres;