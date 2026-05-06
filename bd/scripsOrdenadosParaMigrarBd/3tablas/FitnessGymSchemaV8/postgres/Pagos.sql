-- =============================================
-- TABLE: pagos
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.pagos (
    pago_id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    monto decimal(10,2) NOT NULL,
    fecha_pago timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    metodo_pago varchar(50) NOT NULL,
    estado varchar(50) NOT NULL,
    user_id varchar(450) NULL,
    CONSTRAINT pk_pagos PRIMARY KEY (pago_id),
    CONSTRAINT fk_pagos_aspnet_users FOREIGN KEY (user_id) REFERENCES public.asp_net_users(id),
    CONSTRAINT ck_pagos_metodo_pago CHECK (metodo_pago IN ('PayPal', 'Efectivo', 'SINPE', 'Transferencia')),
    CONSTRAINT ck_pagos_estado CHECK (estado IN ('Fallido', 'Completado', 'Pendiente'))
);

ALTER TABLE public.pagos OWNER TO postgres;