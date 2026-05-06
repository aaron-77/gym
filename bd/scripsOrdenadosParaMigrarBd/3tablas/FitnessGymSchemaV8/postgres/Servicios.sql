-- =============================================
-- TABLE: servicios
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.servicios (
    servicio_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_servicio varchar(100) NOT NULL,
    descripcion varchar(255) NULL,
    tipo_servicio varchar(50) NOT NULL,
    costo decimal(10,2) NOT NULL,
    CONSTRAINT pk_servicios PRIMARY KEY (servicio_id),
    CONSTRAINT ck_servicios_tipo_servicio CHECK (tipo_servicio IN ('Combinado', 'Rendimiento', 'Estetica', 'Salud'))
);

ALTER TABLE public.servicios OWNER TO postgres;