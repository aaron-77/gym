-- =============================================
-- TABLE: parametros_de_medicion
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.parametros_de_medicion (
    parametro_medicion_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(100) NULL,
    fecha_de_registro timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion_de_registro timestamp NULL,
    fk_icon integer NULL,
    CONSTRAINT pk_parametros_de_medicion PRIMARY KEY (parametro_medicion_id),
    CONSTRAINT fk_parametros_de_medicion_icons_for_parameters FOREIGN KEY (fk_icon) REFERENCES public.icons_for_parameters(icon_id)
);

ALTER TABLE public.parametros_de_medicion OWNER TO postgres;