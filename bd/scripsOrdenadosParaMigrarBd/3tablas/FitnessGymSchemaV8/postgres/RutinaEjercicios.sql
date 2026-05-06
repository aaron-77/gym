-- =============================================
-- TABLE: rutina_ejercicios
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.rutina_ejercicios (
    rutina_ejercicio_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    rutina_id integer NULL,
    ejercicio_id integer NULL,
    sets integer NULL,
    repeticiones integer NULL,
    peso decimal(5,2) NULL,
    tiempo integer NULL,
    meta_repeticiones integer NULL,
    CONSTRAINT pk_rutina_ejercicios PRIMARY KEY (rutina_ejercicio_id),
    CONSTRAINT fk_rutina_ejercicios_ejercicio FOREIGN KEY (ejercicio_id) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_rutina_ejercicios_rutina FOREIGN KEY (rutina_id) REFERENCES public.rutinas(rutina_id)
);

ALTER TABLE public.rutina_ejercicios OWNER TO postgres;