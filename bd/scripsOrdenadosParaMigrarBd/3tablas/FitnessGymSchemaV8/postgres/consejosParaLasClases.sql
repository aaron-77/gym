-- =============================================
-- TABLE: consejos_para_las_clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.consejos_para_las_clases (
    id_consejo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase integer NULL,
    fk_ejercicio integer NULL,
    introduccion_de_consejo text NOT NULL,
    consejos text NOT NULL,
    CONSTRAINT pk_consejos_para_las_clases PRIMARY KEY (id_consejo),
    CONSTRAINT fk_consejos_clase FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id),
    CONSTRAINT fk_consejos_ejercicio FOREIGN KEY (fk_ejercicio) REFERENCES public.ejercicios(ejercicio_id)
);

ALTER TABLE public.consejos_para_las_clases OWNER TO postgres;