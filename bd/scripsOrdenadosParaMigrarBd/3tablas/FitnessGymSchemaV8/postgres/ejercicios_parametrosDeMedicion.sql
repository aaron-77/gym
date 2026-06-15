-- =============================================
-- TABLE: ejercicios_parametros_de_medicion
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.ejercicios_parametros_de_medicion (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_ejercicio integer NOT NULL,
    fk_parametro integer NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp NULL,
    CONSTRAINT pk_ejercicios_parametros_de_medicion PRIMARY KEY (id),
    CONSTRAINT fk_ejercicios_parametros_de_medicion_ejercicios FOREIGN KEY (fk_ejercicio) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_ejercicios_parametros_de_medicion_parametros_de_medicion FOREIGN KEY (fk_parametro) REFERENCES public.parametros_de_medicion(parametro_medicion_id)
);

CREATE INDEX idx_ejercicios_parametros_de_medicion_ejercicio ON public.ejercicios_parametros_de_medicion (fk_ejercicio);
CREATE INDEX idx_ejercicios_parametros_de_medicion_parametro ON public.ejercicios_parametros_de_medicion (fk_parametro);

ALTER TABLE public.ejercicios_parametros_de_medicion OWNER TO postgres;