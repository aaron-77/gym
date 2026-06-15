-- =============================================
-- TABLE: medidas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.medidas (
    medida_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fecha_de_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fk_parametro integer NULL,
    valor decimal(10,2) NULL,
    fk_ejercicio integer NULL,
    fk_usuario varchar(450) NULL,
    CONSTRAINT pk_medidas PRIMARY KEY (medida_id),
    CONSTRAINT fk_medidas_aspnet_users FOREIGN KEY (fk_usuario) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_medidas_ejercicios FOREIGN KEY (fk_ejercicio) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_medidas_parametros FOREIGN KEY (fk_parametro) REFERENCES public.parametros_de_medicion(parametro_medicion_id)
);

ALTER TABLE public.medidas OWNER TO postgres;