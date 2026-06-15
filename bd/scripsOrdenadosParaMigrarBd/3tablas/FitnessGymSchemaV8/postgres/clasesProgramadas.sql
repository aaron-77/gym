-- =============================================
-- TABLE: clases_programadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.clases_programadas (
    id_programacion_clase integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase integer NOT NULL,
    cupo_maximo integer NOT NULL,
    fk_estado_clase_programada integer NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fk_entrenador varchar(450) NULL,
    fecha_de_la_clase date DEFAULT CURRENT_DATE NULL,
    CONSTRAINT pk_clases_programadas PRIMARY KEY (id_programacion_clase),
    CONSTRAINT fk_clases_programadas_aspnet_users FOREIGN KEY (fk_entrenador) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_clases_programadas_clase FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id),
    CONSTRAINT fk_clases_programadas_estado_clase_programada FOREIGN KEY (fk_estado_clase_programada) REFERENCES public.estados_clases_programadas(id_estado_clase_programada)
);

ALTER TABLE public.clases_programadas OWNER TO postgres;