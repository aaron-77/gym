-- =============================================
-- TABLE: parametros_unidades_de_medida
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.parametros_unidades_de_medida (
    fk_parametro_de_medicion integer NOT NULL,
    fk_unidad_de_medida integer NOT NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_parametros_unidades_de_medida PRIMARY KEY (fk_parametro_de_medicion, fk_unidad_de_medida),
    CONSTRAINT fk_parametros_unidades_de_medida_parametro FOREIGN KEY (fk_parametro_de_medicion) REFERENCES public.parametros_de_medicion(parametro_medicion_id),
    CONSTRAINT fk_parametros_unidades_de_medida_unidad FOREIGN KEY (fk_unidad_de_medida) REFERENCES public.unidades_de_medida(unidad_de_medida_id)
);

ALTER TABLE public.parametros_unidades_de_medida OWNER TO postgres;