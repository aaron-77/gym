-- =============================================
-- TABLE: images_for_clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.images_for_clases (
    id_class_image integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_clase integer NOT NULL,
    url_para_banner text NULL,
    url_para_descripcion_de_clase text NULL,
    url_para_bloque_consejos text NULL,
    fecha_de_creacion timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_de_modificacion timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_images_for_clases PRIMARY KEY (id_class_image),
    CONSTRAINT fk_images_for_clases_clases FOREIGN KEY (fk_clase) REFERENCES public.clases(clase_id) ON DELETE CASCADE
);

ALTER TABLE public.images_for_clases OWNER TO postgres;