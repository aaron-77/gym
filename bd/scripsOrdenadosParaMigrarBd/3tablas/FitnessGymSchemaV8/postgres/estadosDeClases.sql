-- =============================================
-- TABLE: estados_de_clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estados_de_clases (
    id_estado_clase integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_estado varchar(50) NOT NULL,
    descripcion_estado text NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estados_de_clases PRIMARY KEY (id_estado_clase)
);

ALTER TABLE public.estados_de_clases OWNER TO postgres;