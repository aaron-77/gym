-- =============================================
-- TABLE: equipos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.equipos (
    equipo_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre_equipo varchar(100) NOT NULL,
    descripcion varchar(255) NULL,
    fk_icon integer NULL,
    CONSTRAINT pk_equipos PRIMARY KEY (equipo_id),
    CONSTRAINT fk_equipos_icons_for_parameters FOREIGN KEY (fk_icon) REFERENCES public.icons_for_parameters(icon_id)
);

ALTER TABLE public.equipos OWNER TO postgres;