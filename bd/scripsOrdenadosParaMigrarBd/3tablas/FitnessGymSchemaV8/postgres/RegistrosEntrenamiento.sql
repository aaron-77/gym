-- =============================================
-- TABLE: registros_entrenamiento
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.registros_entrenamiento (
    registro_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    rutina_id integer NULL,
    fecha_registro timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    user_id varchar(450) NULL,
    CONSTRAINT pk_registros_entrenamiento PRIMARY KEY (registro_id),
    CONSTRAINT fk_registros_entrenamiento_aspnet_users FOREIGN KEY (user_id) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_registros_entrenamiento_rutina FOREIGN KEY (rutina_id) REFERENCES public.rutinas(rutina_id)
);

ALTER TABLE public.registros_entrenamiento OWNER TO postgres;