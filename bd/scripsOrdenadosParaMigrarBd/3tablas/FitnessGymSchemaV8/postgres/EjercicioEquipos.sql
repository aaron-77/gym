-- =============================================
-- TABLE: ejercicio_equipos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.ejercicio_equipos (
    ejercicio_equipo_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    ejercicio_id integer NULL,
    equipo_id integer NULL,
    CONSTRAINT pk_ejercicio_equipos PRIMARY KEY (ejercicio_equipo_id),
    CONSTRAINT fk_ejercicio_equipos_ejercicio FOREIGN KEY (ejercicio_id) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_ejercicio_equipos_equipo FOREIGN KEY (equipo_id) REFERENCES public.equipos(equipo_id)
);

ALTER TABLE public.ejercicio_equipos OWNER TO postgres;