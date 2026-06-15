-- =============================================
-- TABLE: horarios_de_clases_programadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.horarios_de_clases_programadas (
    id_horario_de_clase_programada integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase_programada integer NOT NULL,
    fk_horario_laboral integer NOT NULL,
    fk_estado_horario_clase integer DEFAULT 1 NOT NULL,
    CONSTRAINT pk_horarios_de_clases_programadas PRIMARY KEY (id_horario_de_clase_programada),
    CONSTRAINT fk_horarios_de_clases_programadas_clases_programadas FOREIGN KEY (fk_clase_programada) REFERENCES public.clases_programadas(id_programacion_clase),
    CONSTRAINT fk_horas_laborales_horarios_clases_programadas FOREIGN KEY (fk_horario_laboral) REFERENCES public.horas_laborales(id_hora),
    CONSTRAINT fk_estados_clases_programadas_horarios_de_clases_programadas FOREIGN KEY (fk_estado_horario_clase) REFERENCES public.estados_horario_clase_programada(id_estado_horario_clase)
);

ALTER TABLE public.horarios_de_clases_programadas OWNER TO postgres;