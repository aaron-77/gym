-- =============================================
-- TABLE: detalle_entrenamiento
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.detalle_entrenamiento (
    detalle_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    registro_id integer NULL,
    ejercicio_id integer NULL,
    sets integer NULL,
    repeticiones integer NULL,
    peso decimal(5,2) NULL,
    tiempo integer NULL,
    CONSTRAINT pk_detalle_entrenamiento PRIMARY KEY (detalle_id),
    CONSTRAINT fk_detalle_entrenamiento_ejercicio FOREIGN KEY (ejercicio_id) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_detalle_entrenamiento_registro FOREIGN KEY (registro_id) REFERENCES public.registros_entrenamiento(registro_id)
);

ALTER TABLE public.detalle_entrenamiento OWNER TO postgres;