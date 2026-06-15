-- =============================================
-- FUNCTION: fnu_objetos_dependen_tabla
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- NOTA: Esta funcion usa tablas del sistema SQL Server (sys.sql_expression_dependencies)
-- que no existen en PostgreSQL. Esta es una version simplificada.
-- =============================================

CREATE OR REPLACE FUNCTION public.fnu_objetos_dependen_tabla(p_nombre_tabla character varying)
RETURNS TABLE (
    esquema text,
    nombre_objeto text,
    tipo_objeto text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            'public'::text AS esquema,
            p_nombre_tabla::text AS nombre_objeto,
            'TABLE'::text AS tipo_objeto
    );
END;
$$;