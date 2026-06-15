-- =============================================
-- TABLE: dias_festivos_variables
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.dias_festivos_variables (
    id_dia_festivo_variable integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_dia_festivo_variable varchar(100) NOT NULL,
    de_que_semana integer NULL,
    de_que_mes integer NULL,
    de_que_dia integer NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp NULL,
    fk_tipo_de_recurrencia_del_festivo integer NOT NULL,
    fk_estado_actividad_laboral integer NOT NULL,
    CONSTRAINT pk_dias_festivos_variables PRIMARY KEY (id_dia_festivo_variable),
    CONSTRAINT fk_estados_de_actividad_laboral_dias_festivos_variables FOREIGN KEY (fk_estado_actividad_laboral) REFERENCES public.estados_de_actividad_laboral(id_estado_actividad_laboral),
    CONSTRAINT fk_tipos_de_recurrencia_de_dias_festivos_dias_festivos_variables FOREIGN KEY (fk_tipo_de_recurrencia_del_festivo) REFERENCES public.tipos_de_recurrencia_de_dias_festivos(id_tipo_de_recurrencia_de_dia_festivo)
);

ALTER TABLE public.dias_festivos_variables OWNER TO postgres;