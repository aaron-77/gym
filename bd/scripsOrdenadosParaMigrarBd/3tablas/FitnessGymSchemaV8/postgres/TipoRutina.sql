-- =============================================
-- TABLE: tipo_rutina
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.tipo_rutina (
    id_tipo_rutina integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_tipo_rutina varchar(100) NOT NULL,
    fecha_de_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_de_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_tipo_rutina PRIMARY KEY (id_tipo_rutina)
);

ALTER TABLE public.tipo_rutina OWNER TO postgres;