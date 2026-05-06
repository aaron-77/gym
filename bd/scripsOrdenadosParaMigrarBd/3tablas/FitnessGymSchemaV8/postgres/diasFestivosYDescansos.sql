-- =============================================
-- TABLE: dias_festivos_y_descansos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.dias_festivos_y_descansos (
    id_dia_festivo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fecha_festiva_o_descanso date NOT NULL,
    descripcion text NULL,
    fk_estado_actividad_laboral integer NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_dias_festivos_y_descansos PRIMARY KEY (id_dia_festivo),
    CONSTRAINT uk_dias_festivos_y_descansos_fecha UNIQUE (fecha_festiva_o_descanso),
    CONSTRAINT fk_dias_festivos_y_descansos_estado_actividad_laboral FOREIGN KEY (fk_estado_actividad_laboral) REFERENCES public.estados_de_actividad_laboral(id_estado_actividad_laboral)
);

CREATE INDEX ix_dias_festivos_y_descansos_fecha ON public.dias_festivos_y_descansos (fecha_festiva_o_descanso);

ALTER TABLE public.dias_festivos_y_descansos OWNER TO postgres;