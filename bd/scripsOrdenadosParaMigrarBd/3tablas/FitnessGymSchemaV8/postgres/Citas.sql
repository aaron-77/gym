-- =============================================
-- [TABLA]: Citas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.Citas (
    CitaID integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    FechaHora timestamp NOT NULL,
    TipoCita varchar(50) NOT NULL,
    Estado varchar(50) NOT NULL,
    FechaHoraFin timestamp NOT NULL,
    EntrenadorId varchar(450) NULL,
    UserId varchar(450) NULL,
    CONSTRAINT pk_citas PRIMARY KEY (CitaID),
    CONSTRAINT fk_citas_aspnetusers_entrenadorid FOREIGN KEY (EntrenadorId) REFERENCES public.AspNetUsers(Id),
    CONSTRAINT fk_citas_aspnetusers_userid FOREIGN KEY (UserId) REFERENCES public.AspNetUsers(Id)
);

ALTER TABLE public.Citas ADD CONSTRAINT ck_citas_tipocita CHECK (TipoCita IN ('Entrenamiento Personal', 'Medicion'));
ALTER TABLE public.Citas ADD CONSTRAINT ck_citas_estado CHECK (Estado IN ('Cancelada', 'Completada', 'Agendada'));