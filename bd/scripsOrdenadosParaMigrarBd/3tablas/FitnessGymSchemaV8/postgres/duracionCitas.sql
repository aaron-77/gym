-- =============================================
-- TABLE: duracion_citas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.duracion_citas (
    duracion_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    duracion integer NOT NULL,
    frecuencia_notificaciones integer NOT NULL,
    CONSTRAINT pk_duracion_citas PRIMARY KEY (duracion_id)
);

ALTER TABLE public.duracion_citas OWNER TO postgres;