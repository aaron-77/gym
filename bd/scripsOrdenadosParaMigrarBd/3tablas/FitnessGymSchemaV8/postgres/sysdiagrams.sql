-- =============================================
-- TABLE: sysdiagrams
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- Notas: Esta tabla es de soporte de diagrama de base de datos, usualmente no necesaria en PostgreSQL
-- =============================================

CREATE TABLE public.sysdiagrams (
    name varchar(256) NOT NULL,
    principal_id integer NOT NULL,
    diagram_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    version integer NULL,
    definition bytea NULL,
    CONSTRAINT pk_sysdiagrams PRIMARY KEY (diagram_id),
    CONSTRAINT uk_principal_name UNIQUE (principal_id, name)
);

COMMENT ON TABLE public.sysdiagrams IS 'Support table for database diagrams';
COMMENT ON COLUMN public.sysdiagrams.name IS 'Diagram name';
COMMENT ON COLUMN public.sysdiagrams.principal_id IS 'Principal ID who owns the diagram';
COMMENT ON COLUMN public.sysdiagrams.diagram_id IS 'Primary key';
COMMENT ON COLUMN public.sysdiagrams.version IS 'Diagram version number';
COMMENT ON COLUMN public.sysdiagrams.definition IS 'Diagram definition (bytea)';

ALTER TABLE public.sysdiagrams OWNER TO postgres;