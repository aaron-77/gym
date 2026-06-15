-- =============================================
-- TABLE: refresh_tokens
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE TABLE public.refresh_tokens (
    refresh_token_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id varchar(450) NOT NULL,
    client_id varchar(100) NOT NULL,
    token_hash varchar(256) NOT NULL,
    issued_at timestamp with time zone DEFAULT current_timestamp NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone NULL,
    replaced_by_token_id uuid NULL,
    ip_address varchar(50) NULL,
    user_agent varchar(250) NULL,
    CONSTRAINT pk_refresh_tokens PRIMARY KEY (refresh_token_id),
    CONSTRAINT fk_refresh_tokens_aspnet_users FOREIGN KEY (user_id) REFERENCES public.asp_net_users(id) ON DELETE CASCADE
);

CREATE INDEX ix_refresh_tokens_user_id ON public.refresh_tokens (user_id);

ALTER TABLE public.refresh_tokens OWNER TO postgres;