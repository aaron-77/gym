-- =============================================
-- TABLE: estructura_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.estructura_de_clase (
    id_bloque integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase integer NOT NULL,
    numero_consecutivo_del_bloque integer NOT NULL,
    duracion_menor_en_minutos integer NOT NULL,
    duracion_mayor_en_minutos integer NOT NULL,
    titulo_bloque varchar(200) NOT NULL,
    descripcion_bloque text NOT NULL,
    fecha_de_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_de_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_estructura_de_clase PRIMARY KEY (id_bloque),
    CONSTRAINT fk_estructura_clase FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id)
);

ALTER TABLE public.estructura_de_clase OWNER TO postgres;