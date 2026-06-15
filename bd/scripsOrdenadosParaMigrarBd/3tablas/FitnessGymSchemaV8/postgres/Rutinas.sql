-- =============================================
-- TABLE: rutinas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.rutinas (
    rutina_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    observaciones varchar(255) NULL,
    fk_clase integer NULL,
    fk_tipo_rutina integer NULL,
    entrenador_id varchar(450) NULL,
    user_id varchar(450) NULL,
    CONSTRAINT pk_rutinas PRIMARY KEY (rutina_id),
    CONSTRAINT fk_rutinas_aspnet_users_entrenador FOREIGN KEY (entrenador_id) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_rutinas_aspnet_users FOREIGN KEY (user_id) REFERENCES public.asp_net_users(id),
    CONSTRAINT fk_rutinas_clases FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id),
    CONSTRAINT fk_rutinas_tipo_rutina FOREIGN KEY (fk_tipo_rutina) REFERENCES public.tipo_rutina(id_tipo_rutina)
);

ALTER TABLE public.rutinas OWNER TO postgres;