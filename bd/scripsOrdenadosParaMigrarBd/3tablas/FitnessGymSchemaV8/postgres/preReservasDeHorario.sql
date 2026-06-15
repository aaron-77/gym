-- =============================================
-- TABLE: pre_reservas_de_horario
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.pre_reservas_de_horario (
    id_pre_reserva integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fecha_inicio_de_la_reserva timestamp NOT NULL,
    fecha_de_expiracion_de_la_reserva timestamp NOT NULL,
    fk_hora_laboral integer NOT NULL,
    id_usuario_que_reserva varchar(450) NULL,
    fecha_reservada date NOT NULL,
    id_clase integer NULL,
    fecha_de_la_clase date NULL,
    id_entrenador varchar(450) NULL,
    CONSTRAINT pk_pre_reservas_de_horario PRIMARY KEY (id_pre_reserva),
    CONSTRAINT fk_pre_reservas_de_horario_horarios_clases_programadas FOREIGN KEY (fk_hora_laboral) REFERENCES public.horas_laborales(id_hora)
);

CREATE INDEX ix_pre_reservas_de_horario_fecha_clase ON public.pre_reservas_de_horario (fecha_de_la_clase, id_clase) INCLUDE (fk_hora_laboral, id_entrenador);
CREATE UNIQUE INDEX ux_pre_reservas_de_horario_unique ON public.pre_reservas_de_horario (id_clase, fecha_de_la_clase, fk_hora_laboral, id_entrenador) WHERE id_clase IS NOT NULL AND fecha_de_la_clase IS NOT NULL AND id_entrenador IS NOT NULL;

ALTER TABLE public.pre_reservas_de_horario OWNER TO postgres;