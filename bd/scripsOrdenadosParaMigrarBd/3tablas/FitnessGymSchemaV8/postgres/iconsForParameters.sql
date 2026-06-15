-- =============================================
-- TABLE: icons_for_parameters
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.icons_for_parameters (
    icon_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre text NOT NULL,
    url_privada text NOT NULL,
    url_publica text NOT NULL,
    CONSTRAINT pk_icons_for_parameters PRIMARY KEY (icon_id)
);

ALTER TABLE public.icons_for_parameters OWNER TO postgres;