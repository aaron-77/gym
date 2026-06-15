-- =============================================
-- TABLE: images_for_exercises
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.images_for_exercises (
    id_image integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_ejercicio integer NOT NULL,
    nombre_para_el_front varchar(200) NOT NULL,
    url_privada text NOT NULL,
    url_publica text NOT NULL,
    CONSTRAINT pk_images_for_exercises PRIMARY KEY (id_image),
    CONSTRAINT fk_images_for_exercises_ejercicio FOREIGN KEY (fk_ejercicio) REFERENCES public.ejercicios(ejercicio_id)
);

ALTER TABLE public.images_for_exercises OWNER TO postgres;