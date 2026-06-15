-- =============================================
-- TABLE: niveles_de_dificultad_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.niveles_de_dificultad_de_clase (
    id_nivel_de_dificultad_de_clase integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_nivel_de_dificultad text NOT NULL,
    fecha_de_creacion timestamp NULL,
    fecha_de_modificacion timestamp NULL,
    CONSTRAINT pk_niveles_de_dificultad_de_clase PRIMARY KEY (id_nivel_de_dificultad_de_clase)
);

ALTER TABLE public.niveles_de_dificultad_de_clase OWNER TO postgres;