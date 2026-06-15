-- =============================================
-- TABLE: inscripciones_de_clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.inscripciones_de_clases (
    id_inscripcion integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_programacion_clase integer NOT NULL,
    fecha_de_inscripcion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fk_estado_inscripcion integer NOT NULL,
    fk_cliente varchar(450) NULL,
    CONSTRAINT pk_inscripciones_de_clases PRIMARY KEY (id_inscripcion),
    CONSTRAINT fk_inscripciones_de_clases_aspnet_users FOREIGN KEY (fk_cliente) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_inscripciones_de_clases_estado_inscripcion FOREIGN KEY (fk_estado_inscripcion) REFERENCES public.estados_inscripciones(id_estado_inscripcion),
    CONSTRAINT fk_inscripciones_de_clases_programacion_clase FOREIGN KEY (fk_programacion_clase) REFERENCES public.clases_programadas(id_programacion_clase)
);

ALTER TABLE public.inscripciones_de_clases OWNER TO postgres;