-- =============================================
-- TABLE: horas_laborales
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.horas_laborales (
    id_hora integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    hora_inicio time NOT NULL,
    hora_fin time NOT NULL,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT pk_horas_laborales PRIMARY KEY (id_hora)
);

ALTER TABLE public.horas_laborales OWNER TO postgres;