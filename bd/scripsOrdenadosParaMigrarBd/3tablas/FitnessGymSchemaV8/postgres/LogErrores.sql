-- =============================================
-- TABLE: log_errores
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.log_errores (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    procedimiento varchar(200) NOT NULL,
    mensaje varchar(4000) NOT NULL,
    severidad integer NOT NULL,
    estado integer NOT NULL,
    fecha timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    usuario varchar(100) DEFAULT current_user NULL,
    host varchar(100) DEFAULT inet_server_addr() NULL,
    aplicacion varchar(200) DEFAULT current_setting('application_name', true) NULL,
    CONSTRAINT pk_log_errores PRIMARY KEY (id)
);

ALTER TABLE public.log_errores OWNER TO postgres;