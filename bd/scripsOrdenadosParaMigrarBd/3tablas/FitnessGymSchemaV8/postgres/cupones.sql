-- =============================================
-- TABLE: cupones
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.cupones (
    cupon_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codigo varchar(50) NOT NULL,
    descuento_id integer NULL,
    fecha_expiracion timestamp NOT NULL,
    estado varchar(50) NOT NULL,
    CONSTRAINT pk_cupones PRIMARY KEY (cupon_id),
    CONSTRAINT fk_cupones_descuentos FOREIGN KEY (descuento_id) REFERENCES public.descuentos(descuento_id),
    CONSTRAINT ck_cupones_estado CHECK (estado IN ('Expirado', 'Usado', 'Activo'))
);

ALTER TABLE public.cupones OWNER TO postgres;