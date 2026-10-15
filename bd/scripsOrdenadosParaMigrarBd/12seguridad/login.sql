/* ============================================================
   LOGIN - aaronlogin (ÁMBITO: SERVIDOR / master)
   ------------------------------------------------------------
   Orden de ejecución:
     1. restore.sql          (crea la BD y los users del .bak)
     2. ESTE SCRIPT          (login.sql - crea el login)
     3. usuarios.sql         (dropea user, lo recrea, da permisos)

   Si corrés este script ANTES del restore, no pasa nada malo:
   el login vive en master, no depende de la BD.
   ============================================================ */

USE [master];
GO

/* ------------------------------------------------------------
   1. LIMPIEZA - eliminar login previo
   ------------------------------------------------------------
   DROP LOGIN resetea el SID y borra todas las membresías
   heredadas. Esto es lo que saca a aaronlogin de [sysadmin],
   que es como estaba en el script viejo de dbatools.

   Efecto secundario: el USER que apunte a este login queda
   huérfano hasta que corras usuarios.sql. Es intencional.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'aaronlogin' AND type = N'S')
BEGIN
    DROP LOGIN [aaronlogin];
END
GO

/* ------------------------------------------------------------
   2. CREAR LOGIN
   ------------------------------------------------------------
   CHECK_POLICY = OFF es OBLIGATORIO si la password no cumple
   la política de Windows (8+ car., mayúscula, minúscula,
   número, símbolo). Con la política ON, CREATE LOGIN falla
   con error de complejidad.

   No se agrega a NINGÚN server role. El login nace mínimo.
   ------------------------------------------------------------ */
CREATE LOGIN [aaronlogin]
WITH
    PASSWORD           = N'fitnessgymuser',
    DEFAULT_DATABASE   = [FitnessCenterDB],
    DEFAULT_LANGUAGE   = [Español],
    CHECK_POLICY       = OFF,
    CHECK_EXPIRATION   = OFF;
GO

/* ------------------------------------------------------------
   3. VERIFICACIÓN (no es error, es reporte)
   ------------------------------------------------------------
   Esperado: is_disabled = 0, tipo = SQL_LOGIN.
   Si querés confirmar que NO quedó en sysadmin, corré:
     SELECT * FROM sys.server_role_members m
     JOIN sys.server_principals p ON m.member_principal_id = p.principal_id
     WHERE p.name = 'aaronlogin';
   (no debe devolver filas)
   ------------------------------------------------------------ */
SELECT
    name            = sp.name,
    type            = sp.type_desc,
    is_disabled     = sp.is_disabled,
    default_db      = SUSER_SNAME(sp.default_database_name)
FROM sys.server_principals sp
WHERE sp.name = N'aaronlogin';
GO
