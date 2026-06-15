-- =============================================
-- TABLE: ejercicios
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.ejercicios (
    ejercicio_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_ejercicio varchar(100) NOT NULL,
    tipo_ejercicio varchar(50) NOT NULL,
    descripcion varchar(255) NULL,
    fk_icon integer NULL,
    CONSTRAINT pk_ejercicios PRIMARY KEY (ejercicio_id),
    CONSTRAINT fk_ejercicios_icons_for_parameters FOREIGN KEY (fk_icon) REFERENCES public.icons_for_parameters(icon_id),
    CONSTRAINT ck_ejercicios_tipo_ejercicio CHECK (tipo_ejercicio IN ('AMRAP', 'Tiempo', 'Peso'))
);

ALTER TABLE public.ejercicios OWNER TO postgres;