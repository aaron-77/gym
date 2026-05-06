-- =============================================
-- TABLE: metas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.metas (
    meta_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_intencion integer NOT NULL,
    fk_parametro integer NOT NULL,
    fk_ejercicio integer NULL,
    valor_objetivo decimal(10,2) NOT NULL,
    fecha_de_inicio_de_la_meta timestamp NOT NULL,
    fecha_limite timestamp NOT NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_de_modificacion_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fk_nivel_de_logro integer DEFAULT 1 NOT NULL,
    fk_usuario varchar(450) NULL,
    CONSTRAINT pk_metas PRIMARY KEY (meta_id),
    CONSTRAINT fk_metas_aspnet_users FOREIGN KEY (fk_usuario) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_metas_ejercicios FOREIGN KEY (fk_ejercicio) REFERENCES public.ejercicios(ejercicio_id),
    CONSTRAINT fk_metas_intenciones FOREIGN KEY (fk_intencion) REFERENCES public.intenciones(intencion_id),
    CONSTRAINT fk_metas_parametros FOREIGN KEY (fk_parametro) REFERENCES public.parametros_de_medicion(parametro_medicion_id),
    CONSTRAINT fk_metas_niveles_de_logro FOREIGN KEY (fk_nivel_de_logro) REFERENCES public.niveles_de_logro(id_nivel_de_logro)
);

ALTER TABLE public.metas OWNER TO postgres;