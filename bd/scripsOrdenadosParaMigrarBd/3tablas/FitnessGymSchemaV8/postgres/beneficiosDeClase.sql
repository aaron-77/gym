-- =============================================
-- TABLE: beneficios_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.beneficios_de_clase (
    id_beneficio integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase integer NOT NULL,
    beneficio varchar(200) NOT NULL,
    fecha_de_creacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fecha_de_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    fk_icon integer NULL,
    descripcion_beneficio text NULL,
    CONSTRAINT pk_beneficios_de_clase PRIMARY KEY (id_beneficio),
    CONSTRAINT fk_beneficio_clase FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id),
    CONSTRAINT fk_icons_for_parameters_beneficios_del_clase FOREIGN KEY (fk_icon) REFERENCES public.icons_for_parameters(icon_id)
);

ALTER TABLE public.beneficios_de_clase OWNER TO postgres;